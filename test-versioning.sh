#!/bin/bash
# This script demonstrates Go module versioning rules
# Key rule: /v1 suffix is NOT allowed, only /v2+ is allowed

set -e

echo "=============================================="
echo "Go Module Versioning Demo"
echo "=============================================="
echo ""

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "1. Testing root module (no version suffix - valid for v0/v1)"
echo "   Module path: github.com/demo/go-module-versioning-demo"
echo "   Running: go build ."
cd "$SCRIPT_DIR"
go build .
echo "   ✓ SUCCESS - Root module builds fine"
echo ""

echo "2. Testing submodule/v2 (v2 suffix - valid)"
echo "   Module path: github.com/demo/go-module-versioning-demo/submodule/v2"
echo "   Running: go build . (from submodule/v2 directory)"
cd "$SCRIPT_DIR/submodule/v2"
go build .
echo "   ✓ SUCCESS - v2 submodule builds fine"
echo ""

echo "3. Attempting to create a module with /v1 suffix (INVALID)"
echo "   Running: go mod init example.com/test/v1"
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
if go mod init example.com/test/v1 2>&1; then
    echo "   ✗ UNEXPECTED - v1 suffix was accepted"
else
    echo "   ✓ EXPECTED - v1 suffix was rejected by Go"
fi
rm -rf "$TEMP_DIR"
echo ""

echo "4. Attempting to create a module with /v0 suffix (INVALID)"
echo "   Running: go mod init example.com/test/v0"
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
if go mod init example.com/test/v0 2>&1; then
    echo "   ✗ UNEXPECTED - v0 suffix was accepted"
else
    echo "   ✓ EXPECTED - v0 suffix was rejected by Go"
fi
rm -rf "$TEMP_DIR"
echo ""

echo "5. Creating a module with /v2 suffix (VALID)"
echo "   Running: go mod init example.com/test/v2"
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
if go mod init example.com/test/v2 2>&1; then
    echo "   ✓ SUCCESS - v2 suffix was accepted"
else
    echo "   ✗ UNEXPECTED - v2 suffix was rejected"
fi
rm -rf "$TEMP_DIR"
echo ""

echo "=============================================="
echo "CONCLUSION:"
echo "- v0.x.x and v1.x.x: Use bare module path (no suffix)"
echo "- v2.x.x and higher: MUST use /vN suffix"
echo "- /v0 and /v1 suffixes are explicitly rejected by Go"
echo "=============================================="
