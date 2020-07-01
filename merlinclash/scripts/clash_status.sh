#!/bin/sh

source /jffs/softcenter/scripts/base.sh
eval $(dbus export merlinclash_)
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'

pid_clash=$(pidof clash)
pid_watchdog=$(ps | grep clash_watchdog.sh | grep -v grep | awk '{print $1}')
date=$(echo_date)
yamlname=$merlinclash_yamlsel
yamlpath=/jffs/softcenter/merlinclash/$yamlname.yaml

if [ ! -f $yamlpath ]; then
    host=''
    port=''
    secret=''
else
    host=$(yq r $yamlpath external-controller | awk -F":" '{print $1}')
    port=$(yq r $yamlpath external-controller | awk -F":" '{print $2}')
    secret=$(yq r $yamlpath secret)
fi

if [ -n "$pid_clash" ]; then
    text1="<span style='color: green'>$date Clash 进程运行正常！(PID: $pid_clash)</span>"
else
    text1="<span style='color: red'>$date Clash 进程未在运行！</span>"
fi

if [ -n "$pid_watchdog" ]; then
    text2="<span style='color: green'>$date Clash 看门狗运行正常！(PID: $pid_watchdog)</span>"
else
    text2="<span style='color: orange'>$date Clash 看门狗未在运行！</span>"
fi

echo "$text1@$text2@$host@$port@$secret" > /tmp/merlinclash.log

