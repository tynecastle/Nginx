#!/bin/bash

# Monitor nginx requests and send email once no less than 50 requests
# return the specified code within a minute.
# This script should be put into crontab and execute once a minute.
#
# Author : Liu Sibo
# Email  : liusibojs@dangdang.com
# Date   : 2019-01-03

log_file="/data/joblog/httpd/access_log"
send_mail="send_mail.py"
addressee="liusibojs@dangdang.com"

function usage() {
    echo "Usage:"
    echo -e "\tsh $0 <state_code>"
    echo -e "\te.g. sh $0 404"
}

if [ -z $1 ]
then
    usage
    exit 1
fi

state_code=$1
t=$(date -d "-1 min" +"%H:%M:[0-5][0-9]")
n=$(grep $t $log_file | grep -c "$state_code")

if [ $n -ge 50 ]
then
    subject="$state_code DETECTED"
    content="$n requests returned $state_code during last minute."
    python $send_mail $addressee "$subject" "$content"
fi
