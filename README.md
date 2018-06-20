**DESCRIPTION**

In this project, data is imported from MySQL database and one type of CSV file and uploaded into Hive.
Then using Hive query it creates reporting tables namely user_report and user_total.


**SETTING THE ENVIRONMENT AND USAGE**

1. Clone the "practical_exercise_1" project from the git repo https://github.com/siddharthc1
2. We will create a new directory and run the process in the folder.
    
    
    mkdir practical_exercise_1
    cd mkdir


3. Create a MySQL database with name practical_exercise_1


    mysql -u root -p
    mysql> create database practical_exercise_1; 
    
    
4. Run the python file practical_exercise_data_generator.py to get MySQL database and CSV file with current timestamp.

    python practical_exercise_data_generator.py --load_data
    
    python practical_exercise_data_generator.py --create_csv
  

5.
