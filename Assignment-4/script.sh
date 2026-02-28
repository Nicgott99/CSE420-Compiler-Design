#!/bin/bash
# CSE420 Assignment 4 - Build & Test Script
# One-shot script to compile and run the intermediate code generator

echo "===== CSE420 Assignment 4 ====="
echo "Intermediate Code Generation (Three-Address Code)"
echo ""
echo "Building compiler..."
make clean > /dev/null 2>&1
make

if [ $? -eq 0 ]; then
    echo ""
    echo "Build successful!"
    echo ""
    echo "Running test..."
    make test
else
    echo "Build failed. Please check the errors above."
    exit 1
fi
