ROOT_DIR=`pwd`
export GOPATH=$ROOT_DIR
export GOBIN=$GOPATH/bin
echo $GOPATH
echo $GOBIN

#go get labix.org/v2/mgo
go get gopkg.in/mgo.v2

go install main
#./bin/main
