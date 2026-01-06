// Package demo provides a simple greeter to demonstrate Go module versioning.
package demo

// Greet returns a greeting message from the root module (v0/v1).
func Greet() string {
	return "Hello from root module (v0/v1 - no version suffix required)"
}
