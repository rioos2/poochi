#!/bin/sh

set -e

start() {
	exec_cmd=$2
	if [ -f "$RIOCONF/$CONF_FILE" ]
	then
		$SOURCE_DIR/$1 --config=$RIOCONF/$CONF_FILE
	else
		$exec_cmd $3
	fi
}
case $1 in
	controller)
		daemon_name="rioos-controller-manager"
		RUN_CMD="$SOURCE_DIR/$daemon_name --v=4 --api-server=$API_SERVER \
			--dns-endpoint=$DNS_ENDPOINT --dns-apikey=$DNS_APIKEY \
			--dns-provider=$DNS_PROVIDER"
		start $daemon_name $RUN_CMD
	break
	;;

	apiserver)
		daemon_name="rioos-apiserver"
		RUN_CMD="$SOURCE_DIR/$daemon_name start"
		start $daemon_name $RUN_CMD
	break
	;;

	blockchain)
		daemon_name="rioos-blockchain-server"
		RUN_CMD="$SOURCE_DIR/$daemon_name start"
		start $daemon_name $RUN_CMD
	break
	;;

	scheduler)
		daemon_name="rioos-scheduler"
		RUN_CMD="$SOURCE_DIR/$daemon_name --v=4 --leader-elect=false \
		  --api-server=$API_SERVER"
		start $daemon_name $RUN_CMD
	break
	;;
	marketplace)
		daemon_name="rioos-marketplaces"
		RUN_CMD="$SOURCE_DIR/$daemon_name start"
		start $daemon_name $RUN_CMD
	break
	;;

	ui)
	if [ -f "$RIOCONF/$CONF_FILE" ]
	then
		$SOURCE_DIR/$1 --config=$RIOCONF/$CONF_FILE
	else
		$SOURCE_DIR/ember server --port 4200 --live-reload-port 49153
	fi
	break
	;;

	*)
		echo >&2 "error: $1 not match"
	;;
esac

exec "$@"
