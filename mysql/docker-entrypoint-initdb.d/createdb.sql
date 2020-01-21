#
# Copy createdb.sql.example to createdb.sql
# then uncomment then set database name and username to create you need databases
#
# example: .env MYSQL_USER=appuser and need db name is myshop_db
#
#    CREATE DATABASE IF NOT EXISTS `myshop_db` ;
#    GRANT ALL ON `myshop_db`.* TO 'appuser'@'%' ;
#
#
# this sql script will auto run when the mysql container starts and the $DATA_PATH_HOST/mysql not found.
#
# if your $DATA_PATH_HOST/mysql exists and you do not want to delete it, you can run by manual execution:
#
#     docker-compose exec mysql bash
#     mysql -u root -p < /docker-entrypoint-initdb.d/createdb.sql
#

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'M[SQhHTvRXgvl4x4slNl';
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'M[SQhHTvRXgvl4x4slNl';
ALTER USER 'henry'@'%' IDENTIFIED WITH mysql_native_password BY 'WtiYJS_MkUk4mQSp04]I';

CREATE DATABASE IF NOT EXISTS `vnecos` COLLATE 'utf8_general_ci' ;
GRANT ALL ON `vnecos`.* TO 'henry'@'%' ;

CREATE DATABASE IF NOT EXISTS `cevekgam` COLLATE 'utf8_general_ci' ;
GRANT ALL ON `cevekgam`.* TO 'henry'@'%' ;

FLUSH PRIVILEGES ;
