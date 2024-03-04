#!/bin/bash

#====
# run: compose up
# run restore --dump sql_file --data data_folder
# run <args>: compose <args>
#====

PROJECT='odoo-base'
COMPOSE_FILE='./dev/docker-compose.yml'

DATABASE='odoo'
DUMP='./backup/techcoop_pgdump_odoox_22-12-10-14-45.sql'
DATA='./tmp/odoo/data'

function confirm () {
    read -r -p "Continue? [y/N] " -n 1 -r
    [[ ! $REPLY =~ ^[Yy]$ ]] && exit 9999
    echo ""
}

function compose_cmd () {
    cmd="docker-compose -p ${PROJECT} -f ${COMPOSE_FILE} $@"
    echo $cmd
    eval " $cmd"
}

# Main Flow
if [ -z "$1" ]
then
    compose_cmd up
fi

if [ $1 = "restore" ]
then
    shift
    while [ "$1" != "" ]; do
        case $1 in
            --dump )       shift
                           DUMP="$1"
                           ;;
            --data )       shift
                           DATA="$1"
                           ;;
            *)             break
        esac
        shift
    done

    echo $DUMP
    echo $DATA
    confirm

    compose_cmd down -v
    compose_cmd up -d db
    #wait for psql started
    for i in {1..10}; do
        docker logs ${PROJECT}-db-1 | grep -q 'database system is ready to accept connections'
        if [ $? -eq 0 ]; then
            break
        fi
        if [ $i -eq 7 ]; then
            echo "Postgres did not start up successfully"
            exit 1
        fi
        sleep 2
    done    
    cmd="docker exec -i -e PGPASSWORD=123456 ${PROJECT}-db-1 psql -U odoo16 -d odoo16 < $DUMP"
    echo $cmd    
    eval " $cmd"
    
    compose_cmd up -d odoo
    cmd="docker cp ${DATA}/. ${PROJECT}-odoo-1:/odoo/data/"
    echo $cmd    
    eval " $cmd"
else
    compose_cmd $@
    exit 0	
fi

