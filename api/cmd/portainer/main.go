package main // import "github.com/portainer/portainer"

import (
	"github.com/portainer/portainer"
	"github.com/portainer/portainer/bolt"
	"github.com/portainer/portainer/cli"
	"github.com/portainer/portainer/cron"
	"github.com/portainer/portainer/crypto"
	"github.com/portainer/portainer/exec"
	"github.com/portainer/portainer/file"
	"github.com/portainer/portainer/git"
	"github.com/portainer/portainer/http"
	"github.com/portainer/portainer/jwt"
	"github.com/portainer/portainer/ldap"

	"log"
)

func initCLI() *portainer.CLIFlags {
	var cli portainer.CLIService = &cli.Service{}
	flags, err := cli.ParseFlags(portainer.APIVersion)
	if err != nil {
		log.Fatal("F1 %s",err)
	}

	err = cli.ValidateFlags(flags)
	if err != nil {
		log.Fatal("F2 %s",err)
	}
	return flags
}

func initFileService(dataStorePath string) portainer.FileService {
	fileService, err := file.NewService(dataStorePath, "")
	if err != nil {
		log.Fatal("F3 %s",err)
	}
	return fileService
}

func initStore(dataStorePath string) *bolt.Store {
	store, err := bolt.NewStore(dataStorePath)
	if err != nil {
		log.Fatal("F4 %s",err, dataStorePath)
	}

	err = store.Open()
	if err != nil {
		log.Fatal("F5 %s",err, dataStorePath)
	}

	err = store.MigrateData()
	if err != nil {
		log.Fatal("F6 %s",err)
	}
	return store
}

func initStackManager(assetsPath string) portainer.StackManager {
	return exec.NewStackManager(assetsPath)
}

func initJWTService(authenticationEnabled bool) portainer.JWTService {
	if authenticationEnabled {
		jwtService, err := jwt.NewService()
		if err != nil {
			log.Fatal("F7 %s",err)
		}
		return jwtService
	}
	return nil
}

func initCryptoService() portainer.CryptoService {
	return &crypto.Service{}
}

func initLDAPService() portainer.LDAPService {
	return &ldap.Service{}
}

func initGitService() portainer.GitService {
	return &git.Service{}
}

func initEndpointWatcher(endpointService portainer.EndpointService, externalEnpointFile string, syncInterval string) bool {
	authorizeEndpointMgmt := true
	if externalEnpointFile != "" {
		authorizeEndpointMgmt = false
		log.Println("Using external endpoint definition. Endpoint management via the API will be disabled.")
		endpointWatcher := cron.NewWatcher(endpointService, syncInterval)
		err := endpointWatcher.WatchEndpointFile(externalEnpointFile)
		if err != nil {
			log.Fatal("F8 %s",err)
		}
	}
	return authorizeEndpointMgmt
}

func initStatus(authorizeEndpointMgmt bool, flags *portainer.CLIFlags) *portainer.Status {
	return &portainer.Status{
		Analytics:          !*flags.NoAnalytics,
		Authentication:     !*flags.NoAuth,
		EndpointManagement: authorizeEndpointMgmt,
		Version:            portainer.APIVersion,
	}
}

func initDockerHub(dockerHubService portainer.DockerHubService) error {
	_, err := dockerHubService.DockerHub()
	if err == portainer.ErrDockerHubNotFound {
		dockerhub := &portainer.DockerHub{
			Authentication: false,
			Username:       "",
			Password:       "",
		}
		return dockerHubService.StoreDockerHub(dockerhub)
	} else if err != nil {
		return err
	}

	return nil
}

func initSettings(settingsService portainer.SettingsService, flags *portainer.CLIFlags) error {
	_, err := settingsService.Settings()
	if err == portainer.ErrSettingsNotFound {
		settings := &portainer.Settings{
			LogoURL:                     *flags.Logo,
			DisplayDonationHeader:       true,
			DisplayExternalContributors: false,
			AuthenticationMethod:        portainer.AuthenticationInternal,
			LDAPSettings: portainer.LDAPSettings{
				TLSConfig: portainer.TLSConfiguration{},
				SearchSettings: []portainer.LDAPSearchSettings{
					portainer.LDAPSearchSettings{},
				},
			},
			AllowBindMountsForRegularUsers:     true,
			AllowPrivilegedModeForRegularUsers: true,
		}

		if *flags.Templates != "" {
			settings.TemplatesURL = *flags.Templates
		} else {
			settings.TemplatesURL = portainer.DefaultTemplatesURL
		}

		if *flags.Labels != nil {
			settings.BlackListedLabels = *flags.Labels
		} else {
			settings.BlackListedLabels = make([]portainer.Pair, 0)
		}

		return settingsService.StoreSettings(settings)
	} else if err != nil {
		return err
	}

	return nil
}

func retrieveFirstEndpointFromDatabase(endpointService portainer.EndpointService) *portainer.Endpoint {
	endpoints, err := endpointService.Endpoints()
	if err != nil {
		log.Fatal("F99 %s",err)
	}
	return &endpoints[0]
}

func main() {
	flags := initCLI()

	fileService := initFileService(*flags.Data)

	store := initStore(*flags.Data)
	defer store.Close()

	stackManager := initStackManager(*flags.Assets)

	jwtService := initJWTService(!*flags.NoAuth)

	cryptoService := initCryptoService()

	ldapService := initLDAPService()

	gitService := initGitService()

	authorizeEndpointMgmt := initEndpointWatcher(store.EndpointService, *flags.ExternalEndpoints, *flags.SyncInterval)

	err := initSettings(store.SettingsService, flags)
	if err != nil {
		log.Fatal("F10 %s",err)
	}

	err = initDockerHub(store.DockerHubService)
	if err != nil {
		log.Fatal("F11 %s",err)
	}

	applicationStatus := initStatus(authorizeEndpointMgmt, flags)
	
	log.Printf("Starting Portainer1");

	if *flags.Endpoint != "" {
		endpoints, err := store.EndpointService.Endpoints()
		if err != nil {
			log.Fatal("F12 %s",err)
		}
		if len(endpoints) == 0 {
			endpoint := &portainer.Endpoint{
				Name: "primary",
				URL:  *flags.Endpoint,
				TLSConfig: portainer.TLSConfiguration{
					TLS:           *flags.TLSVerify,
					TLSSkipVerify: false,
					TLSCACertPath: *flags.TLSCacert,
					TLSCertPath:   *flags.TLSCert,
					TLSKeyPath:    *flags.TLSKey,
				},
				AuthorizedUsers: []portainer.UserID{},
				AuthorizedTeams: []portainer.TeamID{},
			}
			err = store.EndpointService.CreateEndpoint(endpoint)
			if err != nil {
				log.Fatal("F13 %s",err)
			}
		} else {
			log.Println("Instance already has defined endpoints. Skipping the endpoint defined via CLI.")
		}
	}

	adminPasswordHash := ""
	if *flags.AdminPasswordFile != "" {
		content, err := fileService.GetFileContent(*flags.AdminPasswordFile)
		if err != nil {
			log.Fatal("F15 %s",err)
		}
		adminPasswordHash, err = cryptoService.Hash(content)
		if err != nil {
			log.Fatal("F16 %s",err)
		}
	} else if *flags.AdminPassword != "" {
		adminPasswordHash = *flags.AdminPassword
	}

	if adminPasswordHash != "" {
		users, err := store.UserService.UsersByRole(portainer.AdministratorRole)
		if err != nil {
			log.Fatal("F17 %s",err)
		}

		if len(users) == 0 {
			log.Printf("Creating admin user with password hash %s", adminPasswordHash)
			user := &portainer.User{
				Username: "admin",
				Role:     portainer.AdministratorRole,
				Password: adminPasswordHash,
			}
			err := store.UserService.CreateUser(user)
			if err != nil {
				log.Fatal("F18 %s",err)
			}
		} else {
			log.Println("Instance already has an administrator user defined. Skipping admin password related flags.")
		}
	}

	var server portainer.Server = &http.Server{
		Status:                 applicationStatus,
		BindAddress:            *flags.Addr,
		AssetsPath:             *flags.Assets,
		AuthDisabled:           *flags.NoAuth,
		EndpointManagement:     authorizeEndpointMgmt,
		UserService:            store.UserService,
		TeamService:            store.TeamService,
		TeamMembershipService:  store.TeamMembershipService,
		EndpointService:        store.EndpointService,
		ResourceControlService: store.ResourceControlService,
		SettingsService:        store.SettingsService,
		RegistryService:        store.RegistryService,
		DockerHubService:       store.DockerHubService,
		StackService:           store.StackService,
		StackManager:           stackManager,
		CryptoService:          cryptoService,
		JWTService:             jwtService,
		FileService:            fileService,
		LDAPService:            ldapService,
		GitService:             gitService,
		SSL:                    *flags.SSL,
		SSLCert:                *flags.SSLCert,
		SSLKey:                 *flags.SSLKey,
	}

	log.Printf("Starting Portainer %s on %s", portainer.APIVersion, *flags.Addr)
	err = server.Start()
	if err != nil {
		log.Fatal("F19 %s",err)
	}
}
