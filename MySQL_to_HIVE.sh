#!/bin/sh
#TASK-1: Load the files from the mysql database to hive using sqoop 

#sqoop import table user from mysql to hive database
sqoop import --connect jdbc:mysql://localhost/practical_exercise_1 --username root --password-file /user/cloudera/root_pwd.txt --table user -m 4 --hive-import --hive-database practical_exercise_1 --hive-table user 
	
if [ $? -ne 0 ];then
	echo Failed at creating user table at hive 
	exit 1
fi

#sqoop import table activitylog from mysql to hive database 
sqoop import --connect jdbc:mysql://localhost/practical_exercise_1 --username root --password-file /user/cloudera/root_pwd.txt --table activitylog -m 4 --hive-import --hive-database practical_exercise_1 --hive-table activitylog 
	
if [ $? -ne 0 ];then
	echo Failed at creating activitylog table at hive
	exit 1
fi

