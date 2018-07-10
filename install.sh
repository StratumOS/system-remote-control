#!/bin/bash

PAUSE=1

# checking and installing dependencies

# install screen strace
apt -y install screen strace

# create screen service

cat > /etc/systemd/system/autostart.service << EOF
[Unit]
Description = Autostart Captain
After = NetworkManager-wait-online.service network.target network-online.target dbus.service
Wants = NetworkManager-wait-online.service network-online.target
Requires = dbus.service
Documentation=https://github.com/system66

[Service]
Type = forking
PIDFile = /var/run/screen-captain.pid
ExecStart = /usr/bin/screen -dmS xmr-stak xmr-stak --config /opt/stratumos/xmr-stak/config.txt --poolconf /opt/stratumos/xmr-stak/pools.txt
WorkingDirectory=/opt/stratumos/xmr-stak
Restart = on-abort

[Install]
WantedBy = multi-user.target

EOF

# to ensure the system boots to the console (TTY) rather than to a display manager
systemctl set-default multi-user.target

systemctl enable autostart.service
systemctl daemon-reload

# start autosatart.service
systemctl start autostart.service


chkconfig --list apex
chkconfig --add apex
