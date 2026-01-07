package main

import (
	"fmt"
	submodule "github.com/demo/go-module-versioning-demo/submodule/v1"
)

func main() {
	fmt.Println(submodule.Greet())
}
