module github.com/demo/consumer

go 1.21

require github.com/demo/go-module-versioning-demo/submodule/v1 v1.0.0

replace github.com/demo/go-module-versioning-demo/submodule/v1 => ../submodule/v1
