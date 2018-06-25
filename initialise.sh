#!/usr/bin/env bash
# Initialization script

# Clearing the Directories
hadoop fs -rm -r /user/cloudera/user
hadoop fs -rm -r /user/cloudera/activitylog

# Starting Sqoop Metastore
nohup sqoop metastore &

# Deleting the Sqoop job that already exist
sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --delete practical_exercise_1.activitylog

# Deleting and creating a new Directory on HDFS to store the csv files
hadoop fs -rm -r /user/cloudera/workshop/
hadoop fs -mkdir /user/cloudera/workshop/

# Deleting any previous database with name practical_exercise_1
hive -e "drop database practical_exercise_1 cascade;"

# Creating database with name practical_exercise_1
hive -e "create database practical_exercise_1;"

# Creating sqoop meta job for activitylog table
sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --create practical_exercise_1.activitylog -- import --connect jdbc:mysql://localhost/practical_exercise_1 --username root --password-file /user/cloudera/root_pwd.txt --table activitylog -m 4 --hive-import --hive-database practical_exercise_1 --hive-table activitylog --incremental append --check-column id --last-value 0

# Creating Directories process and archive inside workshop directory to store the csv file
hadoop fs -mkdir /user/cloudera/workshop/process/
hadoop fs -mkdir /user/cloudera/workshop/archive/

# Creating External table
hive -e "CREATE EXTERNAL TABLE practical_exercise_1.user_upload_dump ( user_id int, file_name STRING, timestamp int) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/user/cloudera/workshop/process/' tblproperties ('skip.header.line.count'='1');"

# Creating user_total table
hive -e "create table if not exists practical_exercise_1.user_total(time_ran int, total_users int, users_added int);"

         
