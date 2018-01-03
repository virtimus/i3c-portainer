#!/bin/bash

set -x
	args=("$@")
	echo "args: ${args[@]:2}"
	

i3cDataDir='/i3c/data'
i3cHome='/i3c/i3c'; #'/i3c'
i3cLogDir='/i3c/log'
i3cVersion=v0

build(){
case "$1" in	
	i3cd)
		docker build -t i3c/i3cd:$i3cVersion $i3cHome/dockerfiles/i3cd/.
		;;
	*)
			echo "Usage: $0 build ic3d|...";
esac

}

run(){
case "$1" in
	i3cd)
		docker run -d --name i3cd \
		-v $i3cDataDir/i3cd:/data \
		-v $i3cHome:$i3cHome \
		-v $i3cLogDir:/log \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e I3C_HOME=$i3cHome \
		-e I3C_DATA_DIR=/data \
		-e I3C_LOG_DIR=/log \
		i3c/i3cd:$i3cVersion 
		;;			
	*)
			echo "Usage: $0 run i3cd|...";
esac
}


rm(){
case "$1" in
	i3cd)
		docker rm i3cd
		;;			
	*)
			echo "Usage: $0 rm i3cd|...";
esac
}

psa(){
	docker ps -a
}

rmidangling(){
   docker rmi $(docker images -a -q --filter "dangling=true")
}

start(){
case "$1" in
	i3cd)
		docker start i3cd
		;;		
	*)
		echo "Usage: $0 start i3cd|...";
esac
}

stop(){
case "$1" in
	i3cd)
		docker stop i3cd
		;;		
	*)
		echo "Usage: $0 stop i3cd|...";
esac
}

pid(){
	exec docker inspect --format '{{ .State.Pid }}' "$@"
}

ip(){
	exec docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"
}

logs(){
	exec docker logs "$@"
}

exec(){
case "$1" in
	i3cd)
		docker exec -it i3cd $2
		;;		
	*)
		echo "Usage: $0 exec i3cd|...";
esac
}


case "$1" in
	build)
 		build $2;
        ;;	
	run)
 		run $2;
        ;;	
	runb)
 		runb $2;
        ;;	
	start)
 		start $2;
        ;;
	stop)
 		stop $2;
        ;;		
	rm)
 		rm $2;
        ;;	
	psa)
 		psa $2;
        ;;	        
    rmi)
    	rmidangling $2;
    	;;    
    rebuild)
    	rm $2;
    	build $2;    
        ;;
    rerun)
		stop $2;
    	rm $2;
    	run $2;    
        ;;		
	pid)
		pid $2;
		;;
	ip)
		ip $2;
		;;
	exec)
		exec $2 $3 $4 $5 $6 $7 $8 $9;
		;;			
	logs)
		logs $2;
		;;
	
	*)
			echo "Usage: $0 build|run|runb|start|stop|rm|psa|rmi|rebuild|rerun|pid|ip|exec|logs...";
esac
 	

#tu skrypty




