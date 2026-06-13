package main

import (
	"io"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestGetHello(t *testing.T) {
	// Define different test scenarios
	tests := []struct {
		name           string
		queryString    string
		expectedStatus int
		expectedBody   string
	}{
		{
			name:           "With name parameter",
			queryString:    "?name=Shaun",
			expectedStatus: http.StatusOK,
			expectedBody:   "Hello Shaun\n",
		},
		{
			name:           "With empty name parameter",
			queryString:    "?name=",
			expectedStatus: http.StatusOK,
			expectedBody:   "Hello \n",
		},
		{
			name:           "Without query parameter",
			queryString:    "",
			expectedStatus: http.StatusOK,
			expectedBody:   "Hello \n",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			// 1. Create a simulated HTTP request
			req, err := http.NewRequest("GET", "/"+tt.queryString, nil)
			if err != nil {
				t.Fatalf("Failed to create request: %v", err)
			}

			// 2. Create a ResponseRecorder to capture the server's response
			rr := httptest.NewRecorder()

			// 3. Call the handler function directly
			getHello(rr, req)

			// 4. Assert the status code is what we expect (200 OK)
			if rr.Code != tt.expectedStatus {
				t.Errorf("handler returned wrong status code: got %v want %v",
					rr.Code, tt.expectedStatus)
			}

			// 5. Read the response body
			res := rr.Result()
			defer res.Body.Close()
			bodyBytes, err := io.ReadAll(res.Body)
			if err != nil {
				t.Fatalf("Failed to read response body: %v", err)
			}
			bodyStr := string(bodyBytes)

			// 6. Assert the body content matches our expected message
			if bodyStr != tt.expectedBody {
				t.Errorf("handler returned unexpected body: got %q want %q",
					bodyStr, tt.expectedBody)
			}
		})
	}
}