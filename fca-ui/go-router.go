package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"net/http"
	"io/ioutil"
	"strings"
)

var (
	port   	   int
	folder     string
	rootPage   string
)

func init() {
	flag.IntVar(&port, "port", 3001, "port to listen")
	flag.StringVar(&folder, "folder", ".", "folder to serve")
	flag.StringVar(&rootPage, "rootPage", "index.html", "root page to serve")
}

func main() {
	flag.Parse()
  	ListDir()
	fmt.Printf("Server listening port: %v;\nServe folder: %v ", port, folder)
	err := ServeStatic(port, folder)
	if err != nil {
		log.Fatalln(err)
	}
}

func ListDir() {
	flag.Parse()
    files, err := ioutil.ReadDir(folder)
    if err != nil {
        log.Fatal(err)
    }

    for _, f := range files {
            fmt.Println(f.Name())
    }
}

func exists(path string) (bool) {
    _, err := os.Stat(path)
    if err == nil { return true }
    if os.IsNotExist(err) { return false }
    return true
}

// Serve rewrite path as root page to handle React-Router
func root(w http.ResponseWriter, r *http.Request) {
	var content []byte;
	flag.Parse()

	if exists(folder + r.URL.Path) && r.URL.Path != "/" {
		content, _ = ioutil.ReadFile(folder + r.URL.Path)
		fmt.Println(r.URL.Path + " (file)")
	} else {
		content, _ = ioutil.ReadFile(folder + "/" + rootPage)
		fmt.Println(r.URL.Path + " (root) " + rootPage)
	}

	if strings.Contains(r.URL.Path, ".css") {
		w.Header().Set("Content-Type", "text/css")
	}
    w.Write(content)
}

func ServeStatic(port int, folder string) error {
	host := fmt.Sprintf(":%v", port)
	http.HandleFunc("/", root)
	return http.ListenAndServe(host, nil)
}
