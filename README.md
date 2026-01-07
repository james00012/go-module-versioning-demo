# Go Module Versioning Demo

Demonstrates that `/v1` suffixes don't work in Go modules.

## Quick Start

```bash
./test-versioning.sh
```

## The Rule

| Version | Module Path | Valid? |
|---------|-------------|--------|
| v0.x.x, v1.x.x | `github.com/foo/bar` | Yes |
| v1.x.x | `github.com/foo/bar/v1` | **No** |
| v2.x.x+ | `github.com/foo/bar/v2` | Yes (required) |

## The Gotcha

| Operation | `/v1` | `/v2` |
|-----------|-------|-------|
| `go build` locally | Works | Works |
| `go get` | Fails | Works |
| `require` in go.mod | Fails | Works |

Local builds succeed but **nobody can import it** - Go doesn't recognize `/v1` as a module suffix.

## Test It

```bash
# Fails - Go looks for package in root module
go get github.com/james00012/go-module-versioning-demo/submodule/v1@v1.0.0

# Works - Go recognizes /v2 as separate module
go get github.com/james00012/go-module-versioning-demo/submodule/v2@v2.0.0
```

## Structure

```
├── go.mod              # Root module (no suffix)
├── submodule/
│   ├── v1/go.mod       # Invalid - can't be imported
│   └── v2/go.mod       # Valid
└── consumer/go.mod     # Demonstrates /v1 import failure
```
