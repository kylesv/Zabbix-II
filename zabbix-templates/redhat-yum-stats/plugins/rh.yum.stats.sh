#!/bin/bash

file=/tmp/zabbix_rh.yum.stats.log

#flock=/tmp/zabbix_rh.yum.stats.log.lock

function parse_results(){

    result=$(cat $file | awk '/'''$input''':[0-9]+/{ print $0 }' |awk -F':' '{print $2}')

    if [ "$result" = "" ]; then
	sleep 60
    else
	echo $result
    fi

}

function check_values(){
    /etc/zabbix/plugins/rh.yum.stats.exec.sh &
    sleep 1
}

input=$1

if [ "$input" = "" ]; then
  echo "ZBX_NOTSUPPORTED"
  exit 22
fi

if [ ! -f $file ]; then
  touch $file
fi

#if test `find "$file" -mmin +15 > /dev/null 2>&1`; then
if test `find "$file" -mmin +180 2> /dev/null`; then
    check_values
elif [ ! -s $file ]; then
    check_values
fi

#return results
parse_results

exit 0

