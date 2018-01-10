package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"strconv"
	"strings"
	"time"
)

func multiplybythree(n int) (r int) {
	r = n * 3
	return
}

func handler(w http.ResponseWriter, r *http.Request) {
	timeout := time.Duration(2 * time.Second)
	client := http.Client{
		Timeout: timeout,
	}

	var instanceID string

	resp, err := client.Get("http://169.254.169.254/latest/meta-data/instance-id")
	if err != nil {
		instanceID = "localhost"
	} else {
		tmp, err := ioutil.ReadAll(resp.Body)
		instanceID = string(tmp)
		if err != nil {
			fmt.Println("error")
		}
		resp.Body.Close()
	}

	numberToMultiply, err := strconv.Atoi(r.URL.Path[1:])
	if err != nil {
		fmt.Println("The path is not a number")
	}

	if os.Getenv("APP_COLOUR") != "" {
		fmt.Fprintf(w, "<html><body bgcolor=%s>", os.Getenv("APP_COLOUR"))
	} else {
		fmt.Fprintf(w, "<html><body bgcolor='grey'>")
	}

	fmt.Fprint(w, "<style>.outer { display: table; position: absolute; height: 100%; width: 100%;} .inner { margin-left: auto; margin-right: auto; width: 95%;} </style> ")
	fmt.Fprintf(w, "<div class=\"outer\"><div class=\"inner\">")

	if os.Getenv("APP_ENV") != "" {

		fmt.Fprintf(w, "<h1>Hi there, I'm running on instance: %s in the %s environment</h1>", instanceID, strings.ToUpper(os.Getenv("APP_ENV")))
	} else {
		fmt.Fprintf(w, "<h1>Hi there, I'm running on instance: %s in an unknown environment</h1> ", instanceID)
	}
	fmt.Fprintf(w, "<p> %d multiplied by 3 = %d </p>", numberToMultiply, multiplybythree(numberToMultiply))
	fmt.Fprintf(w, "</div></div></body></html>")
}

func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)
}
