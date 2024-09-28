#!/bin/bash

HUBADDR= # the IP address of your harmony hub
HUBID= # the hub ID

# This is for the action IDs of various actions you've created on your hub
ACT_NONE=-1
ACT_KODI=
ACT_PLEX=
ACT_USER=
ACT_CHRM=

OPTIONS="-U -n --ping-interval 1 --ping-timeout 10"


ws_url="ws://${HUBADDR}:8088/?domain=svcs.myharmony.com&hubId=${HUBID}"
/usr/local/bin/websocat ${OPTIONS} ${ws_url} | while read line 
do
	if [ $(echo ${line} | jq -r .type) = "harmony.engine?startActivityFinished" ]
	then
		cp /etc/gdm3/custom.conf /tmp/custom.conf
		current_activity=$(echo ${line} | jq -r .data.activityId)
		echo "Current activity: ${current_activity}"
		gdmuser=""
		case ${current_activity} in
			${ACT_KODI})
				gdmuser="kodi"
				;;
			${ACT_PLEX})
				gdmuser="plexhtpc"
				;;
			${ACT_USER})
				gdmuser="user"
				;;
			${ACT_NONE})
				gdmuser=""
				;;
			${ACT_CHRM})
				gdmuser=""
				;;
			*)
				continue
				;;
		esac
		echo "Restarting GDM with user: ${gdmuser}"
		/usr/bin/sed "s/.*AutomaticLogin=.*/AutomaticLogin=${gdmuser}/" /tmp/custom.conf > /etc/gdm3/custom.conf
		/usr/bin/systemctl restart gdm3.service
	fi
done

