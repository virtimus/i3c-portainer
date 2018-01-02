#!/bin/bash

#SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )";
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  SCRIPTPATH="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPTPATH="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

echo 'SCRIPTPATH:'$SCRIPTPATH;	
i3cLocalRootDir=$(dirname "$SCRIPTPATH");
if [ $i3cLocalRootDir == '/' ]; then
	i3cLocalRootDir='';
fi	

		
if [ "x$I3C_HOME" = "x" ]; then	
	I3C_HOME=$i3cLocalRootDir'/i3c';	
fi
if [ "x$I3C_DATA_DIR" = "x" ]; then
	I3C_DATA_DIR=$i3cLocalRootDir'/data';
fi
if [ "x$I3C_LOG_DIR" = "x" ]; then
	I3C_LOG_DIR=$i3cLocalRootDir'/log';
fi
echo '------------------------------------------------------------------------';
echo '-- i3c.env.sh variables:';
echo '------------------------------------------------------------------------';
echo 'i3cLocalRootDir:'$i3cLocalRootDir;
echo 'I3C_HOME:'$I3C_HOME;
echo 'I3C_DATA_DIR:'$I3C_DATA_DIR;
echo 'I3C_LOG_DIR:'$I3C_LOG_DIR;
