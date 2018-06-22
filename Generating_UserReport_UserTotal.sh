#!/bin/sh
#Generating Reporting tables

NOW=$(date +%s)

#Drop table already existing user_report table
hive -e "drop table if exists practical_exercise_1.user_report;"

hive -e "create table practical_exercise_1.user_report(user_id int, total_updates int, total_inserts int, total_deletes int, last_activity_type string, is_active boolean, upload_count int);"

hive -e "insert into practical_exercise_1.user_report 
select a.user_id, 
COALESCE(b.co,0) as U, 
COALESCE(c.co,0) as I, 
COALESCE(d.co,0) as D, 
COALESCE(e.co,NULL) as type, 
COALESCE(f.co,FALSE) as bool, 
COALESCE(g.co,0) as upload 
from (select id as user_id from practical_exercise_1.user group by id) as a 
left join (select user_id, count(user_id) as co from practical_exercise_1.activitylog where type='UPDATE' group by user_id) as b on a.user_id=b.user_id  
left join (select user_id, count(user_id) as co from practical_exercise_1.activitylog where type='INSERT' group by user_id) as c on a.user_id=c.user_id 
left join(select user_id, count(user_id) as co from practical_exercise_1.activitylog where type='DELETE' group by user_id) as d on a.user_id=d.user_id 
left join (SELECT a.user_id, a.type as co FROM practical_exercise_1.activitylog a INNER JOIN (SELECT user_id, MAX(ti) as ti FROM practical_exercise_1.activitylog GROUP BY user_id ) AS b ON a.user_id = b.user_id AND a.ti = b.ti) as e on a.user_id=e.user_id 
left join (select user_id, if(count(*) = 0, FALSE, TRUE) as co from practical_exercise_1.activitylog where ti between $NOW AND $NOW-172800 group by user_id) as f on a.user_id=f.user_id 
left join (select user_id, count(user_id) as co from practical_exercise_1.user_upload_dump group by user_id) as g on a.user_id=g.user_id;"

if [ $? -ne 0 ];then
	echo Failed at creating user_report
	exit 1
fi

#Inser into user_total table 
hive -e "insert into practical_exercise_1.user_total select current_timestamp(), sub1.t , case when sub2.t1 is NULL then sub1.t when sub2.t1 is not NULL then sub1.t-sub2.t1 end from (select count(distinct id) as t from practical_exercise_1.user)sub1, (select max(total_users) t1 from practical_exercise_1.user_total) sub2;"

if [ $? -ne 0 ];then
	echo Failed at inserting into user_total
	exit 1
fi


