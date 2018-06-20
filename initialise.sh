#initialisation script

#clearing the directories 
hadoop fs -rm -r /user/cloudera/user
hadoop fs -rm -r /user/cloudera/activitylog

#deleting the sqoop job 
sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --delete practical_exercise_1.activitylog

#deleting and creating a new folder on HDFS to store the csv files
hadoop fs -rm -r /user/cloudera/workshop/
hadoop fs -mkdir /user/cloudera/workshop/

#deleting any previous database with name practical_exercise_1
hive -e "drop database practical_exercise_1 cascade;"
#creating database with name practical_exercise_1
hive -e "create database practical_exercise_1;"

#creating sqoop meta job for deltas for task_1
sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --create practical_exercise_1.activitylog -- import --connect jdbc:mysql://localhost/practical_exercise_1 --username root --password-file /user/cloudera/root_pwd.txt --table activitylog -m 4 --hive-import --hive-database practical_exercise_1 --hive-table activitylog --incremental append --check-column id --last-value 0

sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --exec practical_exercise_1.activitylog

#creating folders process and archieve inside workshop directory to store the csv file
#external table points to process folder
#archieve folder will store the backup for process fail
hadoop fs -mkdir /user/cloudera/workshop/process/ 						 
hadoop fs -mkdir /user/cloudera/workshop/archieve/  

#external table to load the csv files from the process folder to hive database for task_2
hive -e "CREATE EXTERNAL TABLE practical_exercise_1.user_upload_dump ( user_id int, file_name STRING, timestamp int) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/user/cloudera/workshop/process/' tblproperties ('skip.header.line.count'='1');"

#creating table user_total for the task_3
hive -e "create table if not exists practical_exercise_1.user_total(time_ran int, total_users int, users_added int);"

         
