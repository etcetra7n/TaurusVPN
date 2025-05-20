#!/bin/bash

if ! sudo wg show | grep -q "latest handshake"; then # Latest handshake is not found
	uptime_min=$(awk '{print int($1 / 60)}' /proc/uptime)
	uptime_sec=$(awk '{print int($1 % 60)}' /proc/uptime)
	if [ "$uptime_min" -ge 4 ]; then
		(
			cat <<-EOF
			Subject: TaurusVPN: Shutting down because no connection was recieved
			To: {TO EMAIL}@gmail.com
			From: comm-system-noreply@taurusvpn.com
			The server is shutting down because no client was connected within 4 minutes of running. This is an automatic email from the TaurusVPN E2.micro comm system

			EOF
			echo Uptime: $uptime_min min $uptime_sec sec
			echo Timestamp: $(TZ="Asia/Kolkata" date +"%Y-%M-%d %H:%M:%S") IST
		) | msmtp {TO EMAIL}@gmail.com
		sudo /sbin/shutdown now
	fi
	exit 0
fi

last_hs_min=$(sudo wg show | grep -oP 'latest handshake: \K[0-9]+(?= minutes?)')
if	[ "$last_hs_min" -ge 4 ]; then
	uptime_min=$(awk '{print int($1 / 60)}' /proc/uptime)
	uptime_sec=$(awk '{print int($1 % 60)}' /proc/uptime)
	(
		cat <<-EOF
		Subject: TaurusVPN: Shutting down because no active clients are remaining
		To: {TO EMAIL}@gmail.com
		From: comm-system-noreply@taurusvpn.com
		Your server is shutting down because 4 minutes have passed since last handshake with a client. This is an automatic email from the TaurusVPN E2.micro comm system

		EOF
		echo Uptime: $uptime_min min $uptime_sec sec
		echo Sent: $(sudo wg show | grep 'transfer' | awk -F'[ ]+' '{print $3} {print $4}')
		echo Recieved: $(sudo wg show | grep 'transfer' | awk -F'[ ]+' '{print $6} {print$7}')
		echo
		echo Server IP: $(curl -s ifconfig.me)
		echo Cleint IP: $(sudo wg show | grep 'endpoint' | awk -F'[:]+' '{print $2}')
		echo Last handshake: $(sudo wg show | grep 'latest handshake' | awk -F'[:]+' '{print $2}')
	) | msmtp {TO EMAIL}@gmail.com
	sudo /sbin/shutdown now
fi
