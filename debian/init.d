#! /bin/sh
### BEGIN INIT INFO
# Provides:          pimd
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: PIM-SM/SSM multicast routing daemon
# Description:       Lightweight, stand-alone PIM-SM/SSM multicast routing daemon
### END INIT INFO

PATH=/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/sbin/pimd
NAME=pimd
DESC="PIM-SM/SSM multicast routing daemon"
PIDFILE="/run/${NAME}.pid"

. /lib/lsb/init-functions

test -x $DAEMON || exit 0

set -e

case "$1" in
  start)
	log_daemon_msg "Starting $DESC" "$NAME"
	start-stop-daemon --start --quiet --pidfile /var/run/$NAME.pid \
		--exec $DAEMON
	log_end_msg $?
	;;
  stop)
	log_daemon_msg "Stopping $DESC" "$NAME"
	start-stop-daemon --stop --quiet --oknodo --pidfile /var/run/$NAME.pid \
		--exec $DAEMON --retry 5
	log_end_msg $?
	;;
  restart)
	log_action_begin_msg "Restarting $DESC" "$NAME"
	start-stop-daemon --stop --quiet --pidfile \
		/var/run/$NAME.pid --exec $DAEMON --retry 5
	start-stop-daemon --start --quiet --pidfile \
		/var/run/$NAME.pid --exec $DAEMON
	log_end_msg $?
	;;
  reload|force-reload)
	log_action_begin_msg "Reloading $DESC configuration files" "$NAME"
	start-stop-daemon --oknodo --stop --signal HUP --quiet \
		--pidfile "$PIDFILE" --exec "$DAEMON"
	log_end_msg $?
	;;
  status)
	status_of_proc -p "$PIDFILE" "$DAEMON" "$NAME"
	exit $?
	;;
  *)
	N=/etc/init.d/$NAME
	echo "Usage: $N {start|stop|restart|force-reload}" >&2
	exit 1
	;;
esac

exit 0
