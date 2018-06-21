#!/bin/sh
#TASK-2: Upload the CSV file on HDFS to a directory which is pointed by the External table and the move the files to archieve folder to make it a backup


#Upload the files to HDFS	
hadoop fs -put *.csv /user/cloudera/workshop/process/
	
if [ $? -ne 0 ];then
	echo Failed at uploading files
	exit 1	
fi	

#Move the files to the archieve folder	
hadoop fs -cp  /user/cloudera/workshop/process/* /user/cloudera/workshop/archieve/
	
if [ $? -ne 0 ];then
	echo File exist
	exit 1
fi



