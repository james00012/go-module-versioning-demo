# Go Module Versioning Demo

This repository demonstrates Go's semantic import versioning rules, specifically that **`/v1` suffixes are NOT allowed**.

## The Rule

Go's module system has specific rules for version suffixes in module paths:

| Version | Module Path | Valid? |
|---------|-------------|--------|
| v0.x.x | `github.com/foo/bar` | ✓ Yes |
| v1.x.x | `github.com/foo/bar` | ✓ Yes |
| v1.x.x | `github.com/foo/bar/v1` | ✗ **No** |
| v2.x.x | `github.com/foo/bar/v2` | ✓ Yes (required) |
| v3.x.x | `github.com/foo/bar/v3` | ✓ Yes (required) |

## Why?

From the [Go Modules Reference](https://go.dev/ref/mod#major-version-suffixes):

> Starting with major version 2, module paths MUST have a major version suffix like /v2 that matches the major version. For example, if a module has the path example.com/mod at v1.0.0, it must have the path example.com/mod/v2 at version v2.0.0.

The `/v0` and `/v1` suffixes are explicitly rejected because they are unnecessary - the bare path already represents v0 and v1.

## Repository Structure

```
.
├── go.mod                    # Root module (no suffix - valid for v0/v1)
├── greeter.go
├── submodule/
│   └── v2/
│       ├── go.mod            # Submodule with /v2 suffix (valid)
│       └── submodule.go
├── test-versioning.sh        # Script demonstrating the rules
└── README.md
```

## Run the Demo

```bash
chmod +x test-versioning.sh
./test-versioning.sh
```

## Error Message

When you try to create a module with `/v1` suffix:

```
$ go mod init example.com/mylib/v1
go: invalid module path "example.com/mylib/v1": major version suffixes must be
in the form of /vN and are only allowed for v2 or later
```

## Implications for Modularization

If you have a monolithic Go module and want to split it into submodules while maintaining backward compatibility:

1. **You cannot use `/v1` suffixes** to differentiate the new submodules
2. **You must use `/v2` suffixes** for new submodules
3. The root module keeps its original path (no suffix)
4. This is why the terratest modularization uses paths like:
   - `github.com/gruntwork-io/terratest` (root, v0/v1)
   - `github.com/gruntwork-io/terratest/modules/terraform/v2` (submodule, v2)
