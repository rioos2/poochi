#!/bin/bash

dist=`grep PRETTY_NAME /etc/*-release | awk -F '="' '{print $2}'`
OS=$(echo $dist | awk '{print $1;}')
OS1=`cut -d' ' -f1 /etc/redhat-release`
OS2=$(echo "$(uname -mrs)" | cut -d' ' -f1)
SERVICE=/etc/systemd/system/rioos-gulp.service
MOUNT_DIR=/mnt
MAIL_DIR=/var/lib/rioos/gulp/mailer
CONF_DIR=/var/lib/rioos/config
KR_BIN=$MOUNT_DIR/krd

mkdir -p $MAIL_DIR $CONF_DIR
cp /mnt/gulp.rioconfig $CONF_DIR
cp /mnt/*.html $MAIL_DIR

case "$OS" in
  "Fedora")
     ip route add default via 107.152.143.241
esac

if [ "$OS" = "Red Hat" ]  || [ "$OS" = "Ubuntu" ] || [ "$OS" = "Debian" ] || [ "$OS" = "CentOS" ] || [ "$OS1" = "CentOS" ] || [ "$OS" = "Fedora" ] || [ "$OS2" = "FreeBSD" ]
then
CONF='//var/lib/rioos/config/gulp.rioconfig'
else
  CONF='//var/lib/rioos/gulp/config/gulp.config'
fi

cat <<'EOF' >>$CONF
notifiers:
 slack:
   token: "xoxp-215534234516-302596694497-303133137460-0c441857c06675d4b7fd1bf404ad8a0"
   username: "sandbox"
   enabled: true
 smtp:
   enabled: true
   username: "postmaster@ojamail.megambox.com"
   password: "b311ed99d8d544b10ca001bd5fdbcbe1"
   sender: "dev@rio.company"
   domain: "smtp.mailgun.org"
assemblyId: "916515026334924800"
EOF

ex -sc '10i|    email: "info@rio.company"' -cx $CONF
ex -sc '11i|    password: "7145424030804834316"' -cx $CONF

sed -i "s/^[ \t]*assemblyId.*/assemblyId: \"$RIOOS_SH_ASSEMBLY_ID\"/" $CONF
sed -i "s/^[ \t]*email.*/   email: \"$RIOOS_SH_EMAIL\"/" $CONF
sed -i "s/^[ \t]*7145424030804834316:.*/   7145424030804834316: \"$RIOOS_SH_PASSWORD\"/" $CONF
sed -i "s/^[ \t]*secret_name:.*/   secret_name: \"$RIOOS_SH_AGENT_SECRET\"/" $CONF

if [ "$OS2" = "FreeBSD" ]
then
	sed -i '' "s/^[ \t]*assemblyId.*/assemblyId: \"$RIOOS_SH_ASSEMBLY_ID\"/" $CONF
	sed -i '' "s/^[ \t]*username.*/   username: \"$RIOOS_SH_EMAIL\"/" $CONF
	sed -i '' "s/^[ \t]*7145424030804834316:.*/   7145424030804834316: \"$RIOOS_SH_PASSWORD\"/" $CONF
	sed -i '' "s/^[ \t]*secret_name:.*/   secret_name: \"$AGENT_SECRET\"/" $CONF
fi

cat >/etc/systemd/system/rioos-gulp.service <<'EOF'
[Unit]
Description=rioos-gulp Agent
After=network.target

[Service]
ExecStart=/usr/share/rioos/gulp/bin/gulpd --api-server=https://console.rioos.xyz:7443 --watch-server=https://console.rioos.xyz:8443 --rioos-api-content-type=application/json --rioconfig=/var/lib/rioos/config/gulp.rioconfig -v=4
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

if
[[ -f "$KR_BIN" ]]
then
  sudo cp $MOUNT_DIR/krd $MOUNT_DIR/krssh /usr/bin/
  sudo cp $MOUNT_DIR/kr-pkcs11.so /usr/lib/
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
	  systemctl enable rioos-gulp
          systemctl start rioos-gulp.service
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
	ip route add default via 107.152.143.241		# Replace with Subnet Gateway IPs
;;
esac