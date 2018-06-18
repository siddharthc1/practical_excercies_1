#!/bin/sh

n=1
#loop running for 3 times

while  [ $n -le 3 ]

do

	NOW=$(date +%s)
 
	echo 'TASK_3' 

	hive -e "show databases;"
	hive -e "drop table practical_exercise_1.user_report;"
	hive -e "drop table practical_exercise_1.user_total;"

	
	hive -e "show tables in practical_excercise_1 ;"

	hive -e "create table practical_exercise_1.user_report as select a.user_id, COALESCE(b.co,0) as update, COALESCE(c.co,0) as insert, COALESCE(d.co,0) as delete, COALESCE(e.co,NULL) as type, COALESCE(f.co,FALSE) as bool, COALESCE(g.co,0) as upload from (select user_id from practical_exercise_1.activitylog group by user_id) as a left join (select user_id, count(user_id) as co from practical_exercise_1.activitylog where type='UPDATE' group by user_id) as b on a.user_id=b.user_id  left join (select user_id, count(user_id) as co from practical_exercise_1.activitylog where type='INSERT' group by user_id) as c on a.user_id=c.user_id left join(select user_id, count(user_id) as co from practical_exercise_1.activitylog where type='DELETE' group by user_id) as d on a.user_id=d.user_id left join (SELECT a.user_id, a.type as co FROM practical_exercise_1.activitylog a INNER JOIN (SELECT user_id, MIN(timestamp) as timestamp FROM practical_exercise_1.activitylog GROUP BY user_id ) AS b ON a.user_id = b.user_id AND a.timestamp = b.timestamp) as e on a.user_id=e.user_id left join (select user_id, if(count(*) = 0, FALSE, TRUE) as co from practical_exercise_1.activitylog where timestamp between $NOW AND $NOW-172800 group by user_id) as f on a.user_id=f.user_id left join (select user_id, count(user_id) as co from practical_exercise_1.user_upload_dump group by user_id) as g on a.user_id=g.user_id;"

	if [ $? -ne 0 ];then
		echo Failed at creating user_report
		exit 1
		continue
	fi

	hive -e "create table if not exists practical_exercise_1.user_total(time_ran int, total_users int, users_added int);"

	if [ $? -ne 0 ];then
		echo Failed at creating user_total
		exit 1
		continue
	fi

	hive -e "insert into practical_exercise_1.user_total select $NOW, sub1.t , case when sub2.t1 is NULL then sub1.t when sub2.t1 is not NULL then sub1.t-sub2.t1 end from (select count(distinct id) as t from practical_exercise_1.user)sub1, (select max(total_users) t1 from practical_exercise_1.user_total) sub2;"

	if [ $? -ne 0 ];then
		echo Failed at inserting into user_total
		exit 1
		continue
	else
		break
	fi

	n=$((n+1))


done






