package hera

import (
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"
)

type XFileLogger struct {
	logName   string
	logLevel  int
	logWriter *log.Logger
}

func (this *XFileLogger) Init(logName string, logLevel int) error {
	if logName == "" || logLevel <= 0 {
		return errors.New("logName is empty or logLevel is < 0")
	}
	this.logName = logName
	this.logLevel = logLevel
	this.logWriter = getFileWriter(this.logName)
	return nil
}

func getFileWriter(logName string) *log.Logger {
	f, err := os.OpenFile(SERVER["LOG_PATH"], os.O_RDWR|os.O_CREATE|os.O_APPEND, 0666)
	if err != nil {
		log.Fatalf("error opening file: %v", err)
	}
	var prefix string = logName

	writer := log.New(f, prefix, log.LstdFlags)
	return writer
}

func (this *XFileLogger) Debug(str string) {
	if this.logLevel <= LevelDebug {
		this.logWriter.Println(" [debug] " + str)
	}
}
func (this *XFileLogger) Info(str string) {
	if this.logLevel <= LevelInfo {
		this.logWriter.Println(" [info] " + str)
	}
}
func (this *XFileLogger) Warn(str string) {
	if this.logLevel <= LevelWarn {
		this.logWriter.Println(" [warn] " + str)
	}
}
func (this *XFileLogger) Error(str string) {
	if this.logLevel <= LevelError {
		this.logWriter.Println(" [error] " + str)
	}
}

func (this *XFileLogger) ServeHTTP(rw http.ResponseWriter, r *http.Request, next http.HandlerFunc) {
	start := time.Now()
	this.Info(fmt.Sprintf("Started %s %s", r.Method, r.URL.Path))

	next(rw, r)

	res := rw.(ResponseWriter)
	this.Info(fmt.Sprintf("Completed %v %s in %v", res.Status(), http.StatusText(res.Status()), time.Since(start)))

}
