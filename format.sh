#!/usr/bin/env bash

# Format all shell scripts
find . -name '*.sh' -exec shfmt -w {} +
echo "Formatting completed."
