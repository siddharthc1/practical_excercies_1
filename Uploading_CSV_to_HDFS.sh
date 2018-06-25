#!/bin/sh
# TASK-2: Upload the CSV file on HDFS to a directory which is pointed by the External table and the move the files to archive directory to make it a backup


# Upload the files to HDFS
hadoop fs -put *.csv /user/cloudera/workshop/process/
	
if [ $? -ne 0 ];then
	echo Failed at uploading CSV files
	exit 1	
fi	

# Move the files to the Archive directory
hadoop fs -cp  /user/cloudera/workshop/process/* /user/cloudera/workshop/archive/
	
if [ $? -ne 0 ];then
	echo Failed at moving files to archive directory
	exit 1
fi



