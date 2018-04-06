#!/bin/bash

dist=`grep PRETTY_NAME /etc/*-release | awk -F '="' '{print $2}'`
OS=$(echo $dist | awk '{print $1;}')
OS1=`cut -d' ' -f1 /etc/redhat-release`
SERVICE=/etc/systemd/system/rioos-gulp.service
CONTEXT_DIR=/var/lib/rioos/context
KR_BIN=$CONTEXT_DIR/krd

case "$OS" in
  "Fedora")
     ip route add default via 192.168.1.1
esac

if [ "$OS" = "Red Hat" ]  || [ "$OS" = "Ubuntu" ] || [ "$OS" = "Debian" ] || [ "$OS" = "CentOS" ] || [ "$OS1" = "CentOS" ] || [ "$OS" = "Fedora" ]
then
CONF='//var/lib/rioos/gulp/gulpd.conf'
else
  CONF='//var/lib/rioos/rioosgulp/conf/gulpd.conf'
fi
cat >$CONF  <<'EOF'
apiVersion: v1
kind: Config
preferences: {}
assemblyId: "811934182660907008"
users:
  slack-notifier:
    token: "xoxp-15643264595-292147004003-835083f841ed3a0207a6ad46d19b7959"
    username: "ahoy"
    enabled: true
EOF

sed -i "s/^[ \t]*assemblyId.*/assemblyId: \"$ASSEMBLY_ID\"/" $CONF

# cat >$SERVICE  <<'EOF'
cat >/etc/systemd/system/rioos-gulp.service <<'EOF'
[Unit]
Description=rioos-gulp Agent
After=network.target

[Service]
ExecStart=/usr/share/rioos/gulp/bin/gulpd -v=4 --api-server=https://localhost:7443 --rioconfig=/var/lib/rioos/gulp/gulpd.conf
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

if
[[ -f "$KR_BIN" ]]
then
  sudo cp $CONTEXT_DIR/kr $CONTEXT_DIR/krd $CONTEXT_DIR/krssh /usr/bin/
  sudo cp $CONTEXT_DIR/kr-pkcs11.so /usr/lib/
fi

case "$OS1" in
   "CentOS")
        sudo service rioos-gulp start
          ;;
esac


case "$OS" in
   "Ubuntu")
dist=`grep VERSION_ID /etc/*-release | awk -F '="' '{print $2}'`
v=$(echo $dist | awk -F '"' '{print $1;}')
  case "$v" in
         "14.04")
         stop rioosgulp
         start rioosgulp
          ;;
         "16.04")
          service rioos-gulp stop
          service rioos-gulp start
         ;;
  esac
HOSTNAME=`hostname`
echo $HOSTNAME

sudo cat >> //etc/hosts <<EOF
127.0.0.1  `hostname` localhost
EOF

   ;;
   "Debian")
	systemctl stop rioos-gulp.service
	systemctl start rioos-gulp.service
   ;;
   "Fedora")
	sudo systemctl stop rioos-gulp.service
	sudo systemctl start rioos-gulp.service
  ;;
   "CentOS")
	systemctl stop rioos-gulp.service
	systemctl start rioos-gulp.service

   ;;
   "CoreOS")
if [ -f /mnt/context.sh ]; then
  . /mnt/context.sh
fi

sudo cat >> //home/core/.ssh/authorized_keys <<EOF
$SSH_PUBLIC_KEY
EOF

sudo -s

sudo cat > //etc/hostname <<EOF
$HOSTNAME
EOF

sudo cat > //etc/hosts <<EOF
127.0.0.1 $HOSTNAME localhost
EOF

sudo cat > //etc/systemd/network/static.network <<EOF
[Match]
Name=ens3

[Network]
Address=$ETH0_IP/27
Gateway=$ETH0_GATEWAY
DNS=8.8.8.8
DNS=8.8.4.4

EOF

	sudo systemctl restart systemd-networkd

	systemctl stop rioos-gulp.service
	systemctl start rioos-gulp.service
	ip route add default via 192.168.1.1		# Replace with Subnet Gateway IPs
;;
esac
