package main

import (
	_ "api1"
	_ "location"
	"os"
	"fmt"
	hera  "github.com/xcodecraft/hera"
)

func main() {
	curentDir, _ := os.Getwd()
	hera.Run(fmt.Sprintf("%s/conf/conf.yaml",curentDir))
}
