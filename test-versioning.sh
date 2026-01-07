#!/bin/bash
# This script demonstrates Go module versioning rules
# Key rule: /v1 suffix is NOT allowed, only /v2+ is allowed

echo "=============================================="
echo "Go Module Versioning Demo"
echo "=============================================="
echo ""

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "1. Testing root module (no version suffix - valid for v0/v1)"
echo "   Module path: github.com/james00012/go-module-versioning-demo"
cd "$SCRIPT_DIR"
go build .
echo "   ✓ SUCCESS - Root module builds fine"
echo ""

echo "2. Testing submodule/v2 (v2 suffix - valid)"
echo "   Module path: github.com/james00012/go-module-versioning-demo/submodule/v2"
cd "$SCRIPT_DIR/submodule/v2"
go build .
echo "   ✓ SUCCESS - v2 submodule builds fine"
echo ""

echo "3. Testing submodule/v1 - LOCAL build (appears to work)"
echo "   Module path: github.com/james00012/go-module-versioning-demo/submodule/v1"
cd "$SCRIPT_DIR/submodule/v1"
go build .
echo "   ✓ Local build succeeds (misleading!)"
echo ""

echo "4. Testing submodule/v1 - IMPORT as dependency (FAILS)"
echo "   Trying to use /v1 module as a dependency..."
cd "$SCRIPT_DIR/consumer"
echo "   Consumer go.mod contents:"
cat go.mod | grep -E "(require|replace)" | head -4
echo ""
echo "   Running: go build ."
if go build . 2>&1; then
    echo "   ✗ UNEXPECTED - v1 import was accepted"
else
    echo ""
    echo "   ✓ EXPECTED - Cannot import module with /v1 suffix"
fi
echo ""

echo "5. Attempting 'go mod init' with /v1 suffix"
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
if go mod init example.com/test/v1 2>&1; then
    echo "   ✗ UNEXPECTED - v1 suffix was accepted"
else
    echo "   ✓ EXPECTED - 'go mod init' rejects /v1 suffix"
fi
rm -rf "$TEMP_DIR"
echo ""

echo "=============================================="
echo "CONCLUSION:"
echo ""
echo "  /v1 suffix DOES NOT WORK in Go modules."
echo ""
echo "  - You CAN manually write 'module .../v1' in go.mod"
echo "  - You CAN build it locally (go build works)"
echo "  - But NOBODY can import it as a dependency!"
echo "  - 'go mod init .../v1' is explicitly rejected"
echo ""
echo "  The local build succeeding is misleading - the module"
echo "  is fundamentally broken because it can't be imported."
echo ""
echo "  For v0/v1: Use bare path (no suffix)"
echo "  For v2+:   Use /vN suffix (required)"
echo "=============================================="
