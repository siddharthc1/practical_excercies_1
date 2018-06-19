#!/bin/sh


n=1
#loop running for 3 times


nohup sqoop metastore &


while  [ $n -le 3 ]

do
	
	sqoop import --connect jdbc:mysql://localhost/practical_exercise_1 --username root --password-file /user/cloudera/root_pwd.txt --table user -m 4 --hive-import --hive-database practical_exercise_1 --hive-table user 
	
	if [ $? -ne 0 ];then
		echo Failed at creating user table at hive 
		exit 1
		continue
	fi

	sqoop import --connect jdbc:mysql://localhost/practical_exercise_1 --username root --password-file /user/cloudera/root_pwd.txt --table activitylog -m 4 --hive-import --hive-database practical_exercise_1 --hive-table activitylog 
	
	if [ $? -ne 0 ];then
		echo Failed at creating activitylog table at hive
		exit 1
		continue
	else
		break
	fi

	n=$(( n+1 ))


done

