#!/bin/bash

trap 'kill 0 ' EXIT

if [ "$#" != "2" ];then
        echo "Example: sh temp_record.sh 50(cpu limit) 2(cpu numbers)"
	exit -1
fi

record_dir=cpu_$1
cpu_num=$2
temp_record_file="./${record_dir}/record_temp.txt"
cpu_record_file="./${record_dir}/record_cpu.txt"

function check_process()
{
        if [ "$1" = "" ];
        then
		return 1
        fi
        process_num=$(ps -ef|grep "$1" |grep -v "grep" |wc -l)
        if [ "${process_num}" = "1" ];
        then
		exit 0
        fi
}

function cpu_usage()
{
	sysbench --num-threads=${cpu_num} --max-time=300 --test=cpu run &
        limit=$(((($1*${cpu_num}))-3))
	echo "limit $limit"
	cpulimit -e "sysbench" -l ${limit} &
	top -d 1 -b -n 210 |grep Cpu > ${cpu_record_file} &
}

function cpu_temp()
{
	while true
	do
		time=$(date)
		temp=$(cat /sys/class/thermal/thermal_zone0/temp)
		echo "${time}: ${temp}" >>${temp_record_file}
		#sync
		sleep 1
		check_process "sysbench"
	done
}

function main()
{
	rm ${record_dir} -rf
	mkdir ${record_dir}
	cpu_usage $1
	cpu_temp
}
main $1
