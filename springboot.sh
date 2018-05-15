#!/bin/bash
# chkconfig 2345 20 80
# written by Gavin Kim on 2018.05.18
readonly PROC_NAME="springboot"
readonly DAEMON="/springboot-0.0.1-SNAPSHOT.jar"
readonly PID_PATH="/springboot"
readonly PROC_PID="${PID_PATH}${PROC_NAME}.pid"

start()
{
 	echo "Starting  ${PROC_NAME}..."
	local PID=$(get_status)
	if [ -n "${PID}" ]; then
		echo "${PROC_NAME} is already running"
		exit 0
	fi
	nohup java -jar -XX:MaxPermSize=128m -Xms512m -Xmx1024m "${DAEMON}" > /dev/null 2>&1 &
	local PID=${!}

	if [ -n ${PID} ]; then
		echo " - Starting..."
		echo " - Created Process ID in ${PROC_PID}"
		echo ${PID} > ${PROC_PID}
	else
		echo " - failed to start."
	fi
}
stop()
{
	echo "Stopping ${PROC_NAME}..."
	local DAEMON_PID=`cat "${PROC_PID}"`

	if [ "$DAEMON_PID" -lt 3 ]; then
		echo "${PROC_NAME} was not  running."
	else
		kill $DAEMON_PID
		rm -f $PROC_PID
		echo " - Shutdown ...."
	fi
}
status()
{
	local PID=$(get_status)
	if [ -n "${PID}" ]; then
		echo "${PROC_NAME} is running"
	else
		echo "${PROC_NAME} is stopped"
		# start daemon
		#nohup java -jar "${DAEMON}" > /dev/null 2>&1 &
	fi
}

get_status()
{
	ps ux | grep ${PROC_NAME} | grep -v grep | awk '{print $2}'
}

case "$1" in
    start)
        start
        sleep 7
        ;;
    stop)
        stop
        sleep 5
        ;;
    status)
    status "${PROC_NAME}"
	;;
	*)
	echo "Usage: $0 {start | stop | status }"
esac
exit 0