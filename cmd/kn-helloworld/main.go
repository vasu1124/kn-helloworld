package main

import (
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"

	"github.com/vasu1124/kn-helloworld/pkg/version"
)

func main() {

	log.Printf("[kn-helloworld] Version = %s", version.VERSION)

	// index.html
	http.HandleFunc("/", serveHTTP)

	http.HandleFunc("/favicon.ico", http.NotFound)

	log.Fatal(http.ListenAndServe(":8080", nil))
}

func serveHTTP(w http.ResponseWriter, r *http.Request) {
	t, err := template.New("index").Parse(`
		<!DOCTYPE html>
		<html>
			<head>
			<title>kn-helloworld</title>
			</head>
			<body>
			<h1>kn-HelloWorld-{{ .VERSION}}</h1>
			<p>Received ENV_MSG = <code>{{ .ENVMSG}}</code> from environment.</p>
			</body>
		</html>
  `)
	if err != nil {
		log.Println("[kn-helloworld] parse template:", err)
		fmt.Fprint(w, "[kn-helloworld] parse template: ", err)
		return
	}

	type EnvData struct {
		VERSION string
		ENVMSG  string
	}
	data := EnvData{version.VERSION, os.Getenv("ENV_MSG")}

	err = t.Execute(w, data)
	if err != nil {
		log.Println("[kn-helloworld] executing template:", err)
		fmt.Fprint(w, "[kn-helloworld] executing template: ", err)
	}
}
