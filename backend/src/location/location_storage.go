package location

import (
	"log"
	"os"
	"hera"
	"gopkg.in/mgo.v2"
	"gopkg.in/mgo.v2/bson"
)
type Pos struct {
	Type  string
	Coordinates []float64
}

type Location struct {
	Uid string
	Loc Pos
}

const  (
	URL = "127.0.0.1:27017"
	MAX_DISTANCE = 20000000
)

var (
	username string
    password string
    host     string
    port     string
    instance string
	conn  	 string
)

func initParams() {
	username = hera.SERVER["DB_USER"]
	password = hera.SERVER["DB_PWD"]
	host = hera.SERVER["DB_HOST"]
	port = hera.SERVER["DB_PORT"]
	instance = hera.SERVER["DB_INSTANCE"]
	
	conn := ""
	if len(username) > 0 {
		conn += username
		if len(password) > 0 {
			conn += ":" + password
		}

		conn += "@"
	}
}

func  set(uid string, longitude float64, latitude float64)  error {
	initParams()
	session, err := mgo.Dial(conn)
	if err != nil {
		panic(err)
	}
	defer session.Close()

	session.SetMode(mgo.Monotonic, true)

	mgo.SetDebug(true)
	var aLogger *log.Logger
	aLogger = log.New(os.Stderr, "", log.LstdFlags)
	mgo.SetLogger(aLogger)

	c := session.DB(instance).C("location")

	m := map[string]interface{}{ "loc": bson.M{"type":"Point", "coordinates": []float64{longitude, latitude}}, "uid": uid}
	err = c.Insert(m)
	if err != nil {
		panic(err)
	}

	return err
}

func  get(uid string, longitude float64, latitude float64)  []Location {
	initParams()
	session, err := mgo.Dial(conn)
	if err != nil {
		panic(err)
	}
	defer session.Close()

	session.SetMode(mgo.Monotonic, true)

	mgo.SetDebug(true)
	var aLogger *log.Logger
	aLogger = log.New(os.Stderr, "", log.LstdFlags)
	mgo.SetLogger(aLogger)

	c := session.DB(instance).C("location")

	var result []Location
	m := map[string]interface{}{ "loc" : bson.M{ "$nearSphere" : bson.M{ "$geometry" : bson.M{ "type" : "Point", "coordinates" : []float64{longitude, latitude}, "$maxDistance": MAX_DISTANCE}}}}
	
	err = c.Find(m).All(&result)
	if err != nil {
		panic(err)  //can not throw exception
	}
	return result
}
