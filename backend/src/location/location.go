package location

import (
	"hera"
	"strconv"
)

type LocationREST struct {
}


/*
	return 
	"errno": 0,
    "errmsg": " ",
    "data": [
        {
            "Uid": "",
            "Loc": {
                "Type": "Point",
                "Coordinates": [
                    -73.97,
                    40.77
                ]
            }
        },
        {
            "Uid": "",
            "Loc": {
                "Type": "Point",
                "Coordinates": [
                    73.88,
                    -20.78
                ]
            }
        }
    ]
}*/

//curl 'localhost:8083/Location/Get?uid=123'
func (this *LocationREST) Get(c *hera.Context) error {
	params := c.Params
	uid := params["uid"]
	longitude, _ 	:= strconv.ParseFloat(params["longitude"], 64)  //jingdu
	latitude, _	:= strconv.ParseFloat(params["latitude"], 64)   //weidu

	ret := get(uid, longitude, latitude)
	return c.Success(ret)
}

//curl 'localhost:8083/Location/Get?uid=123&longitude=-8&latitude=2'
func (this *LocationREST) Set(c *hera.Context) error {
		params 		:= c.Params
		uid		:= params["uid"]
		longitude, _ 	:= strconv.ParseFloat(params["longitude"], 64)  //jingdu
		latitude, _	:= strconv.ParseFloat(params["latitude"], 64)   //weidu

		set(uid, longitude, latitude)
		return c.Success("")
}

func init() {
	hera.NewRouter().AddRouter(&LocationREST{})
}
