#!/bin/bash

ROOT_DIR="/gopath/app/Date-Fitness/backend"
cd $ROOT_DIR
export GOPATH=$ROOT_DIR
export GOBIN=$GOPATH/bin
echo $ROOT_DIR
echo $GOPATH
echo $GOBIN

go get github.com/garyburd/redigo/redis
go get gopkg.in/mgo.v2

go install main

exec  /gopath/app/Date-Fitness/backend/bin/main
