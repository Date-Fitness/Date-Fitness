package hera

import (
	"errors"
	"fmt"
	"log/syslog"
	"net/http"
	"time"
)

type XSysLogger struct {
	logName   string
	logLevel  int
	logWriter *syslog.Writer
}

func (this *XSysLogger) Init(logName string, logLevel int) error {
	if logName == "" || logLevel <= 0 {
		return errors.New("logName is empty or logLevel is < 0")
	}
	this.logName = logName
	this.logLevel = logLevel
	this.logWriter = getSyslogWriter(this.logName)
	return nil
}

func getSyslogWriter(logName string) *syslog.Writer {
	writer, _ := syslog.New(syslog.LOG_INFO|syslog.LOG_LOCAL6, logName)
	return writer
}

func (this *XSysLogger) Debug(str string) {
	if this.logLevel <= LevelDebug {
		this.logWriter.Info(" [debug] " + str)
	}
}
func (this *XSysLogger) Info(str string) {
	if this.logLevel <= LevelInfo {
		this.logWriter.Info(" [info] " + str)
	}
}
func (this *XSysLogger) Warn(str string) {
	if this.logLevel <= LevelWarn {
		this.logWriter.Info(" [warn] " + str)
	}
}
func (this *XSysLogger) Error(str string) {
	if this.logLevel <= LevelError {
		this.logWriter.Info(" [error] " + str)
	}
}

func (this *XSysLogger) ServeHTTP(rw http.ResponseWriter, r *http.Request, next http.HandlerFunc) {
	start := time.Now()
	this.Info(fmt.Sprintf("Started %s %s", r.Method, r.URL.Path))

	next(rw, r)

	res := rw.(ResponseWriter)
	this.Info(fmt.Sprintf("Completed %v %s in %v", res.Status(), http.StatusText(res.Status()), time.Since(start)))

}
