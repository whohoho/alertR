#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

mkdir -p /opt/alarm
mkdir -p /opt/alarm/logs

mods="alertClientExecuter alertClientMail alertClientPushNotification alertClientRaspberryPi alertClientTemplate managerClientConsole managerClientKeypad sensorClientDevelopment sensorClientExecuter sensorClientFIFO sensorClientPing sensorClientRaspberryPi sensorClientWeatherService"

for mod in $mods
do
  echo $mod
  mkdir -p /opt/alarm/$mod
  mkdir -p /opt/alarm/$mod/config

  echo "python $DIR/alertRinstaller.py -i $mod -t /opt/alarm/$mod"

  cat << EOF > /etc/systemd/system/$mod.service
[Unit]
Description=alertr_$mod

[Service]
ExecStart=/opt/alarm/$mod/alertRclient.py

[Install]
WantedBy=multi-user.target

EOF

systemctl daemon-reload

systemctl start $mod.service
done

#python alertRinstaller.py -i <chosen alertR instance> -t <target directory>"

