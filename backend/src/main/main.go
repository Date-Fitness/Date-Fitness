package main

import (
	_ "api1"
	"fmt"
	hera "github.com/xcodecraft/hera"
	"os"
)

func main() {
	hera.Run(fmt.Sprintf("%s/conf/app.yaml", os.Getenv("GOPATH")))
}
