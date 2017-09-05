#!/bin/bash

DATABASE_USERNAME=`echo $DATABASE_URL | sed -n 's/\([A-z0-9]*\):.*/\1/p'`
DATABASE_PASSWORD=`echo $DATABASE_URL | sed -n 's/.*:\([A-z0-9]*\)@.*/\1/p'`
DATABASE_HOST=`echo $DATABASE_URL | sed -n 's/.*@tcp(\([A-z0-9\.\-]*\).*/\1/p'`
DATABASE_PORT=`echo $DATABASE_URL | sed -n 's/.*@tcp([A-z0-9\.\-]*:\([0-9]*\)).*/\1/p'`
DATABASE_NAME=`echo $DATABASE_URL | sed -n 's/.*\/\([A-z0-9]*\)$/\1/p'`
BASE=`dirname $0`
cat $BASE/drop-tables.sql | mysql --show-warnings=FALSE --column-names=FALSE -u $DATABASE_USERNAME --password=$DATABASE_PASSWORD --host=$DATABASE_HOST --port=$DATABASE_PORT $DATABASE_NAME

