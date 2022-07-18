# MySQL Backup Script (for Windows)
This is a Windows `batch` script, which is used to backup any MySQL database. 
Originally, this script supports XAMPP by default, but it can be used for any MySQL Installation.

This utility uses `mysqldump.exe`, which is a backup utility provided by MySQL.

Read More about `mysqldump`: https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html

### How to Use the Batch Script?
  - Download `backup.bat` Batch Script
  - Double Click to Execute the Script
    - By Default, it Looks for XAMPP Installation in C, D and E drives and try to locate `mysqldump.exe` file
    - If it does not find XAMPP, script will prompt to specify the path to `mysqldump.exe`
  - Script asks the Database Name to take backup
  - Script autogenerates the Backup SQL File Name in the format `<dbname>_<currentdate>.sql`. If user wants to Enter Custom Backup File Name, it can be entered with or without `.sql` extension (Batch Script handles the missing `.sql` extension by itself)
  - On Successful backup, it generates the `.sql` script file in the same directory where script is placed

### How to Restore the Database from Backup SQL File?
1. Create the Database in MySQL
2. Import the Database
3. Select the `.sql` file and restore the database