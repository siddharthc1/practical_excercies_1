#!/bin/sh
echo 'TASK-2'

hadoop fs -mkdir /user/cloudera/workshop/hive1/ 
hadoop fs -mkdir /user/cloudera/workshop/hive1/logs/
hadoop fs -mkdir /user/cloudera/workshop/hive1/logs/input/

hadoop fs -put user_upload_dump.csv /user/cloudera/workshop/hive1/logs/input/

hive -e "CREATE EXTERNAL TABLE user_upload_dump1 ( user_id int, file_name STRING, timestamp int) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/user/cloudera/workshop/hive1/logs/input' tblproperties ('skip.header.line.count'='1');"




