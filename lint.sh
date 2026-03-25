#!/usr/bin/env bash
# Lint all shell scripts
find . -name '*.sh' -exec shellcheck {} +

echo "Linting completed."
