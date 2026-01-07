# Go Module Versioning Demo

This repository demonstrates Go's semantic import versioning rules, specifically that **`/v1` suffixes are NOT allowed**.

## Quick Start

```bash
git clone <this-repo>
cd go-module-versioning-demo
./test-versioning.sh
```

## The Rule

Go's module system has specific rules for version suffixes in module paths:

| Version | Module Path | Valid? |
|---------|-------------|--------|
| v0.x.x | `github.com/foo/bar` | Yes |
| v1.x.x | `github.com/foo/bar` | Yes |
| v1.x.x | `github.com/foo/bar/v1` | **No** |
| v2.x.x | `github.com/foo/bar/v2` | Yes (required) |
| v3.x.x | `github.com/foo/bar/v3` | Yes (required) |

## The Gotcha: Local Builds Succeed!

This is what can mislead people:

| Operation | `/v1` works? |
|-----------|--------------|
| Manually write `module .../v1` in go.mod | Yes |
| `go build` locally | Yes |
| `go test` locally | Yes |
| **`require .../v1` as dependency** | **No** |
| **`replace .../v1` directive** | **No** |
| `go mod init .../v1` | No |

**The local build succeeding is misleading!** The module appears to work, but nobody can actually import it.

## Repository Structure

```
.
├── go.mod                    # Root module (no suffix - valid)
├── greeter.go
├── submodule/
│   ├── v1/
│   │   ├── go.mod            # /v1 suffix (INVALID - can't be imported)
│   │   └── submodule.go
│   └── v2/
│       ├── go.mod            # /v2 suffix (valid)
│       └── submodule.go
├── consumer/
│   ├── go.mod                # Tries to import /v1 - FAILS
│   └── main.go
├── test-versioning.sh
└── README.md
```

## Error Messages

### When trying to import a /v1 module:

```
$ cd consumer && go build .
go: errors parsing go.mod:
go.mod:5: require github.com/james00012/go-module-versioning-demo/submodule/v1:
    version "v1.0.0" invalid: malformed module path
    "github.com/james00012/go-module-versioning-demo/submodule/v1"
go.mod:7: replace github.com/james00012/go-module-versioning-demo/submodule/v1:
    invalid module path
```

### When using go mod init:

```
$ go mod init example.com/mylib/v1
go: invalid module path "example.com/mylib/v1": major version suffixes must be
in the form of /vN and are only allowed for v2 or later
```

## Why This Matters

From the [Go Modules Reference](https://go.dev/ref/mod#major-version-suffixes):

> Starting with major version 2, module paths MUST have a major version suffix like /v2 that matches the major version.

The `/v0` and `/v1` suffixes are explicitly rejected because they are unnecessary - the bare path already represents v0 and v1.

## Implications for Modularization

If you have a monolithic Go module and want to split it into submodules:

1. **You cannot use `/v1` suffixes** to differentiate the new submodules
2. **You must use `/v2` or higher** for new submodules that need distinct import paths
3. The root module keeps its original path (no suffix)
