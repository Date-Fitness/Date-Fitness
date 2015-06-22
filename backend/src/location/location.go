package location

import (
	hera  "github.com/xcodecraft/hera"
	"strconv"
)

type LocationREST struct {
}

//curl 'localhost:8083/Location/Get?uid=123'
func (this *LocationREST) Get(c *hera.Context) error {
	params := c.Params
	uid := params["uid"]
	ret := get(uid)
	return c.Success(ret)
}

//curl 'localhost:8083/Location/Set?uid=123&longitude=&latitude='
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
