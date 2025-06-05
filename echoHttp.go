package main

import (
	"bytes"
	"encoding/json"
	"io"
	"log"
	"net/http"
)

type RequestInfo struct {
	Method  string              `json:"method"`
	URI     string              `json:"uri"`
	Host    string              `json:"host"`
	Headers map[string][]string `json:"headers"`
	Body    string              `json:"body,omitempty"`
}

func handler(w http.ResponseWriter, r *http.Request) {
	log.Println("========== Incoming Request ==========")
	log.Printf("Method: %s, URI: %s\n", r.Method, r.RequestURI)

	defer func() {
		if rec := recover(); rec != nil {
			log.Printf("[PANIC] Recovered in handler: %v\n", rec)
			http.Error(w, "Internal Server Error", http.StatusInternalServerError)
		}
	}()

	var body string
	if r.Body != nil {
		bodyBytes, err := io.ReadAll(r.Body)
		if err != nil {
			log.Printf("[ERROR] Reading body: %v\n", err)
		} else {
			body = string(bodyBytes)
			r.Body = io.NopCloser(bytes.NewReader(bodyBytes))
		}
	}

	log.Println("Headers:")
	for k, v := range r.Header {
		log.Printf("  %s: %v\n", k, v)
	}
	log.Printf("Body: %s\n", body)

	info := RequestInfo{
		Method:  r.Method,
		URI:     r.RequestURI,
		Host:    r.Host,
		Headers: r.Header,
		Body:    body,
	}

	w.Header().Set("Content-Type", "application/json")
	if err := json.NewEncoder(w).Encode(info); err != nil {
		log.Printf("[ERROR] Encoding response: %v\n", err)
		http.Error(w, "Failed to encode JSON", http.StatusInternalServerError)
		return
	}

	log.Println("[INFO] JSON response sent successfully")
}

func main() {
	log.Println("[INFO] Starting echo service on :8081")

	// Register the handler function with the root path
	http.HandleFunc("/", handler)

	if err := http.ListenAndServe(":8081", nil); err != nil {
		log.Fatalf("[FATAL] Server failed to start: %v", err)
	}
}
