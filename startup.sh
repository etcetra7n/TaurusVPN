#!/bin/bash

myip=$(curl -s ifconfig.me)
res=$(curl -s -o /dev/null -w "%{http_code}" -X GET "https://api.dynu.com/nic/update?myip=$myip" -H "Authorization: Basic { BASE64_ENCODED_USERNAME:PASSWORD }")

if [ "$res" = "200" ]; then
	(
		echo Subject: TaurusVPN: Started at $(TZ="Asia/Kolkata" date +"%H:%M")
		cat <<-EOF
		To: { TO_EMAIL }@gmail.com
		From: comm-system-noreply@taurusvpn.com
		This is an automatic email from the E2.micro comm system, triggered when the server starts up. I'm here to tell you that TaurusVPN is up and ready for connection

		EOF
		echo Server IP: $myip
		echo Timestamp: $(TZ="Asia/Kolkata" date +"%Y-%M-%d %H:%M:%S") IST
	) | msmtp { TO_EMAIL }@gmail.com
else
	(
		echo Subject: TaurusVPN: Unable to update dynamic IP address
		cat <<-EOF
		To: { TO_EMAIL }@gmail.com
		From: comm-system-noreply@taurusvpn.com
		The desec.io api did not return a positive response to a update ip request. Your server will continue to listen for connection for 4 minutes but you might have to manually update the server IP on the client side. This is an automatic email from the TaurusVPN E2.micro comm system, triggered when the server starts up

		EOF
		echo Desec.io response: $(res)
		echo Server IP: $(curl -s ifconfig.me)
		echo Timestamp: $(TZ="Asia/Kolkata" date +"%Y-%M-%d %H:%M:%S") IST
	) | msmtp { TO_EMAIL }@gmail.com
fi