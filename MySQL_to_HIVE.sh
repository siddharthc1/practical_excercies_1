#!/bin/sh
#TASK-1: Load the files from the mysql database to hive using sqoop 

#generating the data from generator file 
python practical_exercise_data_generator.py --load_data
python practical_exercise_data_generator.py --create_csv

#sqoop import table user from mysql to hive 
sqoop import --connect jdbc:mysql://localhost/practical_exercise_1 --username root --password-file /user/cloudera/root_pwd.txt --table user -m 4 --hive-import --hive-overwrite --hive-database practical_exercise_1 --hive-table user
	
if [ $? -ne 0 ];then
	echo Failed at creating user table at hive 
	exit 1
fi

#sqoop import table activitylog from mysql to hive  
sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --exec practical_exercise_1.activitylog
	
if [ $? -ne 0 ];then
	echo Failed at creating activitylog table at hive
	exit 1
fi

