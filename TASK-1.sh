

#!/bin/sh

​hive -e 'CREATE DATABASE practical_excercise_1;'
sqoop import --connect jdbc:mysql://localhost/practical_exercise_1 --username root --password cloudera --table user -m 1 --hive-import --hive-database practical_excercise_1 --hive-table user 



sqoop import --connect jdbc:mysql://localhost/practical_exercise_1 --username root --password cloudera --table activitylog -m 1 --hive-import --hive-database practical_excercise_1 --hive-table activitylog
