#!/bin/sh


n=1
#loop running for 3 times

while  [ $n -le 2 ]

do
	echo 'TASK-2'

	hadoop fs -mkdir /user/cloudera/workshop/process/ 						 #initialisation script
	hadoop fs -mkdir /user/cloudera/workshop/archieve/                                              #initialisation script
 
	name=$(basename user_upload_dum*.csv)
	echo $name
	#mv $name user_upload_dump.csv
	hadoop fs -put $name /user/cloudera/workshop/process/
	
	if [ $? -ne 0 ];then
		echo Failed at uploading files
		exit 1
		continue
	fi	

	hive -e "CREATE EXTERNAL TABLE practical_exercise_1.user_upload_dump ( user_id int, file_name STRING, timestamp int) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/user/cloudera/workshop/process/' tblproperties ('skip.header.line.count'='1');"
        
	if [ $? -ne 0 ];then
		echo Failed at external table
		exit 1
		continue
	fi	
	
	hadoop fs -mv  /user/cloudera/workshop/process/* /user/cloudera/workshop/archieve/
	
	if [ $? -ne 0 ];then
		echo Failed  
		exit 1
		continue
	fi

	hadoop fs -rm -r  /user/cloudera/workshop/process/

	if [ $? -ne 0 ];then
		echo Failed at creating user table at hive 
		exit 1
		continue
	else
		break
	
	fi

	n=$(( n+1 ))


done





