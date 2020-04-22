#!/bin/bash

set -e 

if [[ ${READ_CONF_FROM_ENV} == "false" ]]; then source .env; fi

dump-import-data () {
    IGNORE_TABLES=$(if [[ -n "${SOURCE_DB_TABLES_IGNORE}" ]]; then for tables in ${SOURCE_DB_TABLES_IGNORE[*]}; do echo "--ignore-table=${DB_NAME}.${tables}"; done fi)
    if [[ "${INPUT}" == 1 ]]; then NO_DATA="--no-data" && MESSAGE="[SCHEMA ONLY]"; else NO_DATA="" && MESSAGE="[DATA INCLUDED]"; fi
    printf "Starting to mysqldump and import ${DB_NAME} Database ${MESSAGE} ...\n" \
        && mysqldump -alv -h ${SOURCE_DB_HOST} --port ${SOURCE_DB_PORT} -u ${SOURCE_USER} -p${SOURCE_PASS} ${IGNORE_TABLES} ${NO_DATA} ${DB_NAME} \
            | mysql -v -h ${DEST_DB_HOST} --port ${DEST_DB_PORT} -u ${DEST_USER} -p${DEST_PASS} ${DB_NAME} \
        && printf "mysqldump and import ${DB_NAME} Database ${MESSAGE} Done.\n"
}

db-compare () {
    if [[ "${INPUT}" == 3 ]]; then NO_DATA="--no-data" && MESSAGE="[SCHEMA ONLY]"; else NO_DATA="" && MESSAGE="[DATA INCLUDED]"; fi
    printf "Starting dump ${MESSAGE} first database...\n" \
        && mysqldump -alv -h ${SOURCE_DB_HOST} --port ${SOURCE_DB_PORT} -u ${SOURCE_USER} -p${SOURCE_PASS} ${NO_DATA} ${DB_NAME} > ${DB_NAME}-source-db-dump.sql \
        && printf "Starting dump ${MESSAGE} second database...\n" \
        && mysqldump -alv -h ${DEST_DB_HOST} --port ${DEST_DB_PORT} -u ${DEST_USER} -p${DEST_PASS} ${NO_DATA} ${DB_NAME} > ${DB_NAME}-destination-db-dump.sql
    diff -u ${DB_NAME}-source-db-dump.sql ${DB_NAME}-destination-db-dump.sql > db-compare-result.txt \
        && printf "Compare database Done, exported to 'db-compare-result.txt' file.\n"
    cat db-compare-result.txt && rm -rf *-db-dump.sql
}

create-db-on-destination-host () {
    printf "Creating ${DB_NAME} Database...\n" \
        && mysql -h ${DEST_DB_HOST} --port ${DEST_DB_PORT} -u ${DEST_USER} -p${DEST_PASS} -e "CREATE DATABASE \`${DB_NAME}\`;" \
        && printf "${DB_NAME} Database created.\n"
}

dump-and-compressed-file () {
    printf "Dumping ${DB_NAME} Database...\n" \
        && mysqldump -alv -h ${SOURCE_DB_HOST} --port ${SOURCE_DB_PORT} -u ${SOURCE_USER} -p${SOURCE_PASS} ${DB_NAME} | gzip -9 > $(date +\%Y-\%m-\%d--\%H:\%M:\%S)_${DB_NAME}.sql.gz \
        && printf "${DB_NAME} Database dumped.\n"
}

# MAIN SCRIPT
printf "[1] MySQLdump and import [SCHEMA ONLY]\n"
printf "[2] MySQLdump and import [DATA INCLUDED]\n"
printf "[3] Compare database between source_db and destination_db [SCHEMA ONLY]\n"
printf "[4] Compare database between source_db and destination_db [DATA INCLUDED]\n"
printf "[5] Create database on destination host\n"
printf "[6] MySQLdump database [DATA INCLUDED], compressed in 'sql.gz'\n"
if [[ -n "${INPUT_OPERATION}" ]]; then INPUT=${INPUT_OPERATION}; else read INPUT; fi
case ${INPUT} in
    1)
        dump-import-data
        ;;
    2)
        dump-import-data
        ;;
    3)
        db-compare 
        ;;
    4)
        db-compare 
        ;;
    5)
        create-db-on-destination-host
        ;;
    6)
        dump-and-compressed-file
        ;;
    *)
        printf "unknown input.\n"
        ;;
esac