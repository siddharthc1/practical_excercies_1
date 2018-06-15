#!/bin/sh


n=1
#loop running for 3 times


nohup sqoop metastore &


while  [ $n -le 3 ]

do
	hive -e "create database if not exists practical_exercise_1;"

	sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --create practical_exercise_1.user -- import --connect jdbc:mysql://localhost/practical_exercise_1 --username root --password-file /user/cloudera/root_pwd.txt --table user -m 4 --hive-import --hive-database practical_exercise_1 --hive-table user --incremental append --check-column id --last-value 0
	
	if [ $? -ne 0 ];then
		echo Failed at creating user table at hive 
		exit 1
		continue
	fi


	sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --exec practical_exercise_1.user

	if [ $? -ne 0 ];then
		echo Failed at creating user table at hive 
		exit 1
		continue
	fi


	sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --create practical_exercise_1.activitylog -- import --connect jdbc:mysql://localhost/practical_exercise_1 --username root --password-file /user/cloudera/root_pwd.txt --table activitylog -m 4 --hive-import --hive-database practical_exercise_1 --hive-table activitylog --incremental append --check-column id --last-value 0
	
	if [ $? -ne 0 ];then
		echo Failed at creating activitylog table at hive
		exit 1
		continue
	fi

	sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --exec practical_exercise_1.activitylog

	if [ $? -ne 0 ];then
		echo Failed at creating activitylog table at hive 
		exit 1
		continue
	else
		break
	fi

	n=$(( n+1 ))


done

if [$n == 4]
then 
	echo Job failed
	exit 1
fi
