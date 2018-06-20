#!/bin/sh
#TASK-2: Upload the CSV file on HDFS to a directory which is pointed by the external table and the move the files to archieve folder to make it a backup

#get the name of the file created by the practical_exercise_data_generator.py	
name=$(basename user_upload_dum*.csv)

#upload the files to HDFS	
hadoop fs -put $name /user/cloudera/workshop/process/
	
if [ $? -ne 0 ];then
	echo Failed at uploading files
	exit 1	
fi	

#move the files to the archieve folder	
hadoop fs -cp  /user/cloudera/workshop/process/* /user/cloudera/workshop/archieve/
	
if [ $? -ne 0 ];then
	echo File exist
	exit 1
fi
