#!/bin/sh

set -e

start() {
	exec_cmd=$1
	if [ -f "$RIOCONF/$CONF_FILE" ]
	then
		$2
	else
		echo " ```"$RIOCONF/$CONF_FILE" not found... skipped ``` "
		$exec_cmd start
	fi
}
case $1 in
	controller)
		daemon_name="rioos-controller-manager"
		RUN_CMD="$SOURCE_DIR/$daemon_name --v=4 --api-server=$API_SERVER --watch-server=$WATCH_SERVER \
			--rioos-api-content-type=application/json --service-account-private-key-file=$RIOCONF/service-account.key \
			--root-ca-file=$RIOCONF/server-ca.cert.pem --use-service-account-credentials --rioconfig=$RIOCONF/controller.rioconfig \
			--concurrent-serviceaccount-token-syncs=2 --dns-endpoint=$DNS_ENDPOINT --dns-apikey=$DNS_APIKEY \
			--dns-provider=$DNS_PROVIDER"
		start "$daemon_name" "$RUN_CMD"
	break
	;;

	apiserver)
		daemon_name="rioos-apiserver"
		RUN_CMD="$SOURCE_DIR/$daemon_name start --config $RIOCONF/$CONF_FILE"
		start "$daemon_name" "$RUN_CMD"
	break
	;;

	blockchain)
		daemon_name="rioos-blockchain-server"
		RUN_CMD="$SOURCE_DIR/$daemon_name start --config $RIOCONF/$CONF_FILE"
		start "$daemon_name" "$RUN_CMD"
	break
	;;

	scheduler)
		daemon_name="rioos-scheduler"
		RUN_CMD="$SOURCE_DIR/$daemon_name --v=4 --leader-elect=false --api-server=$API_SERVER \
		  --watch-server=$WATCH_SERVER --service-account-private-key-file=$RIOCONF/service-account.key \
			--use-service-account-credentials --rioconfig=$RIOCONF/scheduler.rioconfig"
		start "$daemon_name" "$RUN_CMD"
	break
	;;
	marketplace)
		daemon_name="rioos-marketplaces"
		RUN_CMD="$SOURCE_DIR/$daemon_name start --config $RIOCONF/$CONF_FILE"
		start "$daemon_name" "$RUN_CMD"
	break
	;;

	ui)
	if [ -f "$RIOCONF/$CONF_FILE" ]
	then
		cd $SOURCE_DIR && yarn install && yarn start
	else
		$SOURCE_DIR/yarn start --port 8000 --live-reload-port 49153
	fi
	break
	;;

	*)
		echo >&2 "error: $1 not match"
	;;
esac

exec "$@"
