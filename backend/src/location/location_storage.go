package location

import (
//	"log"
	"fmt"
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


func  set(uid string, longitude float64, latitude float64)  error {
	session, err := mgo.Dial("127.0.0.1:27017")
	if err != nil {
		panic(err)
	}
	defer session.Close() 

	session.SetMode(mgo.Monotonic, true)

	c := session.DB("test").C("location")

	fmt.Println(uid);
	fmt.Println(longitude);
	fmt.Println(latitude);

	m := map[string]interface{}{ "loc": bson.M{"type":"Point", "coordinates": []float64{longitude, latitude}}, "uid": uid}
	err = c.Insert(m)
	if err != nil {
		panic(err)
	}

	return err
}

func  get(uid string)  Location {
	session, err := mgo.Dial("127.0.0.1:27017")
	if err != nil {
		panic(err)
	}
	defer session.Close()

	session.SetMode(mgo.Monotonic, true)

	c := session.DB("test").C("location")

	fmt.Println(uid);

	var result Location
	err = c.Find(bson.M{"uid":uid}).One(&result)
	if err != nil {
		panic(err)
	}
	fmt.Println(result);
	return result
}
