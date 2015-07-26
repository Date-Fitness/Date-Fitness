package main

import (
	_ "api1"
	"fmt"
	hera "github.com/xcodecraft/hera"
	"os"
)

func main() {
	curentDir, _ := os.Getwd()
	fmt.Printf("%s/conf/app.yaml", curentDir)
	hera.Run(fmt.Sprintf("%s/conf/app.yaml", curentDir))
}
