#!/bin/bash

# Monitor nginx requests that return 404.
# Author : Liu Sibo
# Email  : liusibojs@dangdang.com
# Date   : 2019-01-03

log_file="/data/joblog/httpd/access_log"
send_mail="send_mail.py"
addressee="liusibojs@dangdang.com"

t=$(date -d "-1 min" +"%H:%M:[0-5][0-9]")
n=$(grep $t $log_file | grep -c "404")

if [ $n -ge 50 ]
then
    python $send_mail $addressee "404 REQUESTS DETECTED" "$n requests returned 404 during last minute."
fi
