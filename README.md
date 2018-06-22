**DESCRIPTION**

In this project, data is imported from MySQL database and one type of CSV file is uploaded into HDFS.
Then using Hive query it creates reporting tables namely user_report and user_total.


**SETTING THE ENVIRONMENT AND USAGE**

1. Clone the "practical_exercise_1" project from the git repo https://github.com/siddharthc1

2. Create a MySQL database with name practical_exercise_1

    ```
    mysql -u root -p
    mysql> create database practical_exercise_1; 
    ```
    
3. Install dependant python packages using PIP:
    
    ```
    pip install peewee==2.8.8
    pip install PyMySQL==0.7.10
    ```
        
4. Start the initialise script
    
    ```
    ./initialise.sh
    ```

5. Now start the process in following order

    ```
    ./MySQL_to_HIVE.sh
    ./Uploading_CSV_to_HDFS.sh
    ./Generating_UserReport_UserTotal.sh
    ```
    
