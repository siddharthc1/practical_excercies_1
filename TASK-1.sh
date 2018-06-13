

#!/bin/sh


n=1
#loop running for 3 times


#printf "cloudera" > root_pwd.txt
#hadoop fs -put root_pwd.txt /user/cloudera/
#hadoop fs -chmod 400 /user/cloudera/root_pwd.txt
#nohup sqoop metastore &


while  [ $n -le 3 ]

do
	hive -e "create database if not exists practical_excercise_1;"
	sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --create practical_excercise_1.user -- import --connect jdbc:mysql://localhost/practical_exercise_1 --username root --password-file /user/cloudera/root_pwd.txt --table user -m 1 --hive-import --hive-database practical_excercise_1 --hive-table user --incremental append --check-column id --last-value 0


	sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --exec practical_excercise_1.user


	sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --create practical_excercise_1.activitylog -- import --connect jdbc:mysql://localhost/practical_exercise_1 --username root --password-file /user/cloudera/root_pwd.txt --table activitylog -m 1 --hive-import --hive-database practical_excercise_1 --hive-table activitylog --incremental append --check-column id --last-value 0

	sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --exec practical_excercise_1.activitylog

	if [ $? -eq 0 ]
	then
		echo Successful
		exit 0
		break
	else
		echo Process Failed
	fi

	n=$(( n+1 ))


done

if [$n == 4]
then 
	echo Job failed
	exit 1
fi
