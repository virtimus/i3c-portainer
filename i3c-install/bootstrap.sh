#!/bin/sh

ln -s /i3c/i3c.sh /i

/i rebuild i3cd

/i rerun i3cd
#cd $(dirname $0)

exec_in() { docker exec $@; }
exec_in i3cd "/run-i3c.sh"
