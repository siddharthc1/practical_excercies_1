#!/bin/sh


n=1
#loop running for 3 times

while  [ $n -le 2 ]

do
	echo 'TASK-2'

	
	name=$(basename user_upload_dum*.csv)
	
	hadoop fs -put $name /user/cloudera/workshop/process/
	
	if [ $? -ne 0 ];then
		echo Failed at uploading files
		exit 1
		
	fi	
	
	hadoop fs -cp  /user/cloudera/workshop/process/* /user/cloudera/workshop/archieve/
	
	if [ $? -ne 0 ];then
		echo File exist
		exit 1
		
	else
		break
	
	fi

	n=$(( n+1 ))


done



