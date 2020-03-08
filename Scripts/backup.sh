#!/bin/bash

#DECLARE VARIABLES
backup_dir="/data"
server_backup_dir="user@yourserver.com:/path/to/storebackup"
log_dir="backuperrors.txt"
email="you@youremail.com"
trap 'kill -HUP 0' EXIT

function backup () {

if rsync -avz --delete $backup_dir $server_backup_dir  2>&1 >>$log_dir
then
du -sh $backup_dir| mail -s "backup succeeded $backup_dir" $email
else
mail -s "rysnc failed on $backup_dir" $email < $log_dir
return 1
fi
}


type -P inotifywait &>/dev/null || { echo "inotifywait command not found."; exit 1; }

while true
do

backup  || exit 0

inotifywait -r -e modify,attrib,close_write,move,create,delete  --format '%T %:e %f' --timefmt '%c' $backup_dir  2>&1 >>$log_dir && backup

done