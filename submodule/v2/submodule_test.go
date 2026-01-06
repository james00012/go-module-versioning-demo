package submodule

import "testing"

func TestGreet(t *testing.T) {
	got := Greet()
	if got == "" {
		t.Error("Greet() returned empty string")
	}
}
