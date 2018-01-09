package main

import "testing"

func TestMultiply(t *testing.T) {
	total := multiplybythree(5)
	if total != 15 {
		t.Errorf("Multiplybythree was incorrect, got: %d, want: %d.", total, 15)
	}
}
