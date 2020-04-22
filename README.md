![Docker Automated build](https://img.shields.io/docker/automated/ichsanwahyudi/mysql-dump-restore) ![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/ichsanwahyudi/mysql-dump-restore)


# mysql-dump-restore
Just playing with some bash scripts. Some input and suggestion is very welcome. This script basicaly will dump data from db source and restore to destination db directly. This script run on docker container with some environment variables OR run in your local with some prerequisites.

What's included?
1. MySQLdump and import [SCHEMA ONLY]
2. MySQLdump and import [DATA INCLUDED]
3. Simple Compare database between source_db and destination_db [SCHEMA ONLY]
4. Simple Compare database between source_db and destination_db [DATA INCLUDED]
5. Create database on destination host
6. MySQLdump database [DATA INCLUDED], compressed in 'sql.gz'\n"

**Notes:** *the numbers above will used in INPUT_OPERATION variable. (example. 5 for create database on destination host task)*

### run as docker container
```
 docker run --rm --env-file ./.env ichsanwahyudi/sql-dump-import:latest
```

Don't forget to fill these ENVIRONMENT VARIABLES on `.env` file.
```
INPUT_OPERATION=                // base on number above, example. 5 for create database on destination host task
DB_NAME=                        // database name
SOURCE_DB_TABLES_IGNORE=()      // put your ignore tables, example (app user)
SOURCE_DB_HOST=                 // source database host
SOURCE_USER=                    // source database user
SOURCE_PASS=                    // source database password
SOURCE_DB_PORT=3306             // mysql port, default to 3306
DEST_DB_HOST=                   // destination database host
DEST_USER=                      // destination database user
DEST_PASS=                      // destination database password
DEST_DB_PORT=3306               // mysql port, default to 3306
```

### run on your local
Make sure already installed these packages:
- `mysql-client (5.7)`
- `gzip`

This script will read params from environment variable by default, to read param from `.env` file, please export and set this environment variable to false:
```
export READ_CONF_FROM_ENV=false
```

Don't forget to fill params in `.env` file:
```
INPUT_OPERATION=                // base on number above, if you want manualy imput by prompt leave it blank
DB_NAME=                        // database name
SOURCE_DB_TABLES_IGNORE=()      // put your ignore tables, example (app user)
SOURCE_DB_HOST=                 // source database host
SOURCE_USER=                    // source database user
SOURCE_PASS=                    // source database password
SOURCE_DB_PORT=3306             // mysql port, default to 3306
DEST_DB_HOST=                   // destination database host
DEST_USER=                      // destination database user
DEST_PASS=                      // destination database password
DEST_DB_PORT=3306               // mysql port, default to 3306
```

and then run it using:
```
./sql-dump-import.sh
```

It should be look like this:
```
~ ❯ bash sql-dump-import.sh 
[1] MySQLdump and import [SCHEMA ONLY]
[2] MySQLdump and import [DATA INCLUDED]
[3] Compare database between source_db and destination_db [SCHEMA ONLY]
[4] Compare database between source_db and destination_db [DATA INCLUDED]
[5] Create database on destination host
[6] MySQLdump database [DATA INCLUDED], compressed in 'sql.gz'
```