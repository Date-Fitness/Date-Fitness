package hera

import (
	"net/http"
)

type XLogger interface {
	Init(logName string, logLevel int) error
	Debug(str string)
	Info(str string)
	Warn(str string)
	Error(str string)
	ServeHTTP(rw http.ResponseWriter, r *http.Request, next http.HandlerFunc)
}

const (
	LevelDebug = iota
	LevelInfo
	LevelWarn
	LevelError
)

var Logger XLogger = nil

func NewLogger(logName string, logLevel int) XLogger {
	if SERVER["LOG_MODE"] == "file" {
		Logger = &XFileLogger{}
	} else if SERVER["LOG_MODE"] == "syslog" {
		Logger = &XSysLogger{}
	} else {
		panic("logger mode is illegal")
	}
	if err := Logger.Init(logName, logLevel); err != nil {
		panic("logName is empty or logLevel is < 0")
	}
	return Logger
}
