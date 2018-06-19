hadoop fs -rm -r /user/cloudera/user
hadoop fs -rm -r /user/cloudera/activitylog

sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --delete practical_exercise_1.activitylog

hadoop fs -rm -r /user/cloudera/workshop/
hadoop fs -mkdir /user/cloudera/workshop/

hive -e "drop database practical_exercise_1 cascade;"


hive -e "create database if not exists practical_exercise_1;"

sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --create practical_exercise_1.activitylog -- import --connect jdbc:mysql://localhost/practical_exercise_1 --username root --password-file /user/cloudera/root_pwd.txt --table activitylog -m 4 --hive-import --hive-database practical_exercise_1 --hive-table activitylog --incremental append --check-column id --last-value 0

sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --exec practical_exercise_1.activitylog

hadoop fs -mkdir /user/cloudera/workshop/process/ 						 
hadoop fs -mkdir /user/cloudera/workshop/archieve/  



hive -e "CREATE EXTERNAL TABLE practical_exercise_1.user_upload_dump ( user_id int, file_name STRING, timestamp int) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/user/cloudera/workshop/process/' tblproperties ('skip.header.line.count'='1');"
                                          
hive -e "drop table practical_exercise_1.user_total;"

hive -e "create table if not exists practical_exercise_1.user_total(time_ran int, total_users int, users_added int);"



         
