package activity 

import (
	"fmt"
	"log"
	"os"
	"gopkg.in/mgo.v2"
	"gopkg.in/mgo.v2/bson"
)

type Pos struct {
	Type  string
	Coordinates []float64
}

type Place struct {
	Name string
	Loc Pos
	Discuss bool
}

type Extra struct {
	People_num string
	Sex        string
}

type  Activity struct {
	Uid  string
	Title string
	Time string
	Site Place
	Tags string    // biaoqian
	Remark string    // beizhu
	Ext Extra
	State  uint     //activity statu: 1 doing 2 end  3 del
}

const (
	URL 		= "127.0.0.1:27017"
	STATE_DOING = iota
	STATE_END	
	STATE_DEL 
	MAX_DISTANCE = 20000000
)
type ActivityEntity struct {
}

func NewActivity() *ActivityEntity {
	return &ActivityEntity{}
}

func (this *ActivityEntity) Create(uid string, title string, time string, site string, is_discuss string, tags string, remark string, sex string, people_num string, longitude float64, latitude float64) error {
	session, err := mgo.Dial(URL)  //connect db
	if err != nil {
		panic(err)
	}
	defer session.Close()
	session.SetMode(mgo.Monotonic, true)

	mgo.SetDebug(true)
	var aLogger *log.Logger
	aLogger = log.New(os.Stderr, "", log.LstdFlags)
	mgo.SetLogger(aLogger)

	c := session.DB("test").C("activity")

	m := map[string]interface{}{ "uid": uid, "title": title, "time" : time, "site" : bson.M{"name": site, "discuss": is_discuss, "loc": bson.M{"type": "Point", "coordinates": []float64{longitude, latitude}}}, "tags": tags, "remark": remark, "ext": bson.M{"people_num" : people_num, "sex" : sex}, "state" : STATE_DOING}
	err = c.Insert(m) 
	if err != nil {
		fmt.Printf("%#v\n", err)
		panic(err)
	}
	
	return nil 
}

func (this *ActivityEntity) Get(uid string) []Activity {
	session, err := mgo.Dial(URL)  //connect db
	if err != nil {
		panic(err)
	}
	defer session.Close()
	session.SetMode(mgo.Monotonic, true)

	mgo.SetDebug(true)
	var aLogger *log.Logger
	aLogger = log.New(os.Stderr, "", log.LstdFlags)
	mgo.SetLogger(aLogger)

	c := session.DB("test").C("activity")

	var result []Activity
	m := map[string]interface{}{ "uid" : uid}
	
	err = c.Find(m).All(&result)
	fmt.Printf("result= %#v\n", result)

	if err != nil {
		fmt.Printf("%#v\n", err)
		panic(err)  //can not throw exception
	}
	return result
}

func (this *ActivityEntity) Cancel() error {
	return nil
}

func (this *ActivityEntity) List(longitude float64, latitude float64) []Activity {
	session, err := mgo.Dial(URL)  //connect db
	if err != nil {
		panic(err)
	}
	defer session.Close()
	session.SetMode(mgo.Monotonic, true)

	mgo.SetDebug(true)
	var aLogger *log.Logger
	aLogger = log.New(os.Stderr, "", log.LstdFlags)
	mgo.SetLogger(aLogger)

	c := session.DB("test").C("activity")

	var result []Activity
	m := map[string]interface{}{ "site.loc" : bson.M{ "$nearSphere" : bson.M{ "$geometry" : bson.M{ "type" : "Point", "coordinates" : []float64{longitude, latitude}, "$maxDistance": MAX_DISTANCE}}}}
	
	err = c.Find(m).All(&result)
	fmt.Printf("result= %#v\n", result)

	if err != nil {
		fmt.Printf("%#v\n", err)
		panic(err)  //can not throw exception
	}
	return result
}
