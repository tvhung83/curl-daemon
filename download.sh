#!/bin/bash
export USERNAME="fshare.group%40gmail.com"
export PASSWORD="101202303"
export EXT_PARAMS="url_refe=http%3A%2F%2Fwww.fshare.vn%2F&auto_login=1"
export LOGIN_DATA="login_useremail=$USERNAME&login_password=$PASSWORD&$EXT_PARAMS"
export LOGIN_URL="https://www.fshare.vn/login.php"
export COOKIE_PATH="/tmp/cookies.txt"
export OUTPUT_PATH="/tmp/output"
export DOWNLOAD_PATH="/media/Seagate/Movies"

while read file
do
	echo "Downloading file: $file"
	cd $DOWNLOAD_PATH
	curl -c $COOKIE_PATH -k -H "referer: $LOGIN_URL" --data $LOGIN_DATA $LOGIN_URL
    	curl -b $COOKIE_PATH $file -w "%{redirect_url}" \
    		| xargs curl -LOC - 2>&1 \
    		| tr '\r' '\n' \
    		| awk '{ print "{\"file\": \"'$file'\",\"total_percent\": \""$1"\",\"total\": \""$2"\",\"current_percent\": \""$3"\",\"received\": \""$4"\",\"average_download\": \""$7"\",\"time_total\": \""$9"\",\"time_spent\": \""$10"\",\"time_left\": \""$11"\",\"current_speed\": \""$12"\"}" > "'$OUTPUT_PATH'" }'
done < download.list