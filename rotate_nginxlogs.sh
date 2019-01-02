#!/bin/bash
# Rotate the nginx logs to prevent a single
# logfile from consuming too much disk space.

LOGS_PATH=/var/log/httpd
FIVEDAYSAGO=$(date -d "-5 day" +%Y%m%d)
YESTERDAY=$(date -d "yesterday" +%Y%m%d)
PID_PATH=/var/run/nginx.pid

cd $LOGS_PATH
currentlogs=$(ls | egrep '_log$|\.log$')
for curr in $currentlogs
do
    # Logs are rotated only when both of the following two criteria are met:
    # 1. updated within last 5 days
    # 2. not an empty log
    if [[ $(date -r $curr +%Y%m%d) -gt $FIVEDAYSAGO ]] && [[ $(du $curr | cut -f1) -gt 0 ]]
    then
        /bin/mv $curr ${curr}.${YESTERDAY}
    fi
done

# Send USR1 signal to master process of nginx so that new log files will be created
kill -USR1 $(cat $PID_PATH)
