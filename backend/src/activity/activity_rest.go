package activity

import (
	"fmt"
	"hera"
	"strconv"
)

type ActivityREST struct {
}


/*
{
	"errno": 0,
    "errmsg": " ",
    "data": [
        {
            "Uid": "1111",
            "Title": "yuepao",
            "Time": "34234",
            "Site": {
                "Name": "xx",
                "Loc": {
                    "Type": "Point",
                    "Coordinates": [
                        44.22,
                        42.42
                    ]
                },
                "Discuss": false
            },
            "Tags": "Ů",
            "Remark": "Ů",
            "Ext": {
                "People_num": "5",
                "Sex": "Ů"
            },
            "State": 1
        },
        {
            "Uid": "1111",
            "Title": "yuepao",
            "Time": "34234",
            "Site": {
                "Name": "xx",
                "Loc": {
                    "Type": "Point",
                    "Coordinates": [
                        44,
                        42
                    ]
                },
                "Discuss": false
            },
            "Tags": "Ů",
            "Remark": "Ů",
            "Ext": {
                "People_num": "5",
                "Sex": "Ů"
            },
            "State": 1
        },
        {
            "Uid": "1111",
            "Title": "yuepao",
            "Time": "34234",
            "Site": {
                "Name": "xxx",
                "Loc": {
                    "Type": "Point",
                    "Coordinates": [
                        44,
                        42
                    ]
                },
                "Discuss": false
            },
            "Tags": "Ů",
            "Remark": "Ů",
            "Ext": {
                "People_num": "5",
                "Sex": "Ů"
            },
            "State": 1
        },
	   
}

*/
//curl 'localhost:8083/Activity/List?longitude=&latitude='
func (this *ActivityREST) List(c *hera.Context) error {
	params		:= c.Params
	longitude, _ 	:= strconv.ParseFloat(params["longitude"], 64)  //jingdu
	latitude, _	:= strconv.ParseFloat(params["latitude"], 64)   //weidu

	entity_obj := NewActivity()
	ret := entity_obj.List(longitude, latitude)
	return c.Success(ret)
}

//curl 'localhost:8083/Activity/Get?uid=123'
func (this *ActivityREST) Get(c *hera.Context) error {
	params		:= c.Params
	uid			:= params["uid"]
	fmt.Printf("uid= %#v", uid)

	entity_obj := NewActivity()
	ret := entity_obj.Get(uid)
	return c.Success(ret)
}

//curl 'localhost:8083/Activity/Create?uid=123&title=&time=&site=&is_discuss=&tags=&remark=&sex=&people_num=&longitude=&latitude='
/*
   return  actiivty id
*/
func (this *ActivityREST) Create(c *hera.Context) error {
		params		:= c.Params
		uid			:= params["uid"]
		title		:= params["title"]
		time		:= params["time"]
		site		:= params["site"]
		is_discuss	:= params["is_discuss"]
		tags		:= params["tags"]
		remark		:= params["remark"]
		sex			:= params["sex"]
		people_num	:= params["people_num"]
		longitude, _ 	:= strconv.ParseFloat(params["longitude"], 64)  //jingdu
		latitude, _	:= strconv.ParseFloat(params["latitude"], 64)   //weidu

		entity_obj := NewActivity()
		entity_obj.Create(uid, title, time, site, is_discuss, tags, remark, sex, people_num, longitude, latitude)
		return c.Success("")
}

//curl 'localhost:8083/Activity/Cancel?activity_id='
func (this *ActivityREST) Cancel(c *hera.Context) error {
		entity_obj := NewActivity()
		entity_obj.Cancel()
		return c.Success("")
}

func init() {
	hera.NewRouter().AddRouter(&ActivityREST{})
}
