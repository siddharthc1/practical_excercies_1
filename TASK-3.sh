#!/bin/sh

NOW=$(date +%s)
 
echo 'TASK_3' 
#echo $NOW


hive -e "select a.user_id, COALESCE(b.co,0) as update, COALESCE(c.co,0) as insert, COALESCE(d.co,0) as delete, COALESCE(e.co,NULL) as type, COALESCE(f.co,FALSE) as bool, COALESCE(g.co,0) as upload from (select user_id from activitylog group by user_id) as a left join (select user_id, count(user_id) as co from activitylog where type='UPDATE' group by user_id) as b on a.user_id=b.user_id  left join (select user_id, count(user_id) as co from activitylog where type='INSERT' group by user_id) as c on a.user_id=c.user_id left join(select user_id, count(user_id) as co from activitylog where type='DELETE' group by user_id) as d on a.user_id=d.user_id left join (SELECT a.user_id, a.type as co FROM activitylog a INNER JOIN (SELECT user_id, MIN(timestamp) as timestamp FROM activitylog GROUP BY user_id ) AS b ON a.user_id = b.user_id AND a.timestamp = b.timestamp) as e on a.user_id=e.user_id left join (select user_id, if(count(*) = 0, FALSE, TRUE) as co from activitylog where timestamp between 1528136917 AND 1528136919 group by user_id) as f on a.user_id=f.user_id left join (select user_id, count(user_id) as co from user_upload_dump group by user_id) as g on a.user_id=g.user_id;"


hive -e "INSERT into user_total  (time_ran, total_users , users_added ) values('1528136917', (select count(1) from activitylog where timestamp between 0 and 1528136917), (Select d1 - d2 from
(select count(1) as d1 from activitylog where timestamp between 0 and 1528136917) as a,
(select c.total_users as d2 from (select * from user_total order by time_ran desc limit 1) as c) as b;));"



