#!/bin/bash
# Demonstrates that /v1 module suffixes don't work in Go

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Go Module /v1 Suffix Test ==="
echo ""

echo "1. Root module (no suffix) - go build"
cd "$SCRIPT_DIR" && go build . && echo "   OK"
echo ""

echo "2. submodule/v2 - go build"
cd "$SCRIPT_DIR/submodule/v2" && go build . && echo "   OK"
echo ""

echo "3. submodule/v1 - go build (local)"
cd "$SCRIPT_DIR/submodule/v1" && go build . && echo "   OK (but misleading!)"
echo ""

echo "4. submodule/v1 - import as dependency"
cd "$SCRIPT_DIR/consumer"
if go build . 2>&1; then
    echo "   UNEXPECTED: import succeeded"
else
    echo "   FAILS as expected - /v1 cannot be imported"
fi
echo ""

echo "5. go mod init with /v1"
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
if go mod init example.com/test/v1 2>&1; then
    echo "   UNEXPECTED: accepted"
else
    echo "   FAILS as expected"
fi
rm -rf "$TEMP_DIR"
echo ""

echo "=== Conclusion ==="
echo "/v1 builds locally but cannot be imported."
echo "Use bare path for v0/v1, use /vN suffix for v2+."
