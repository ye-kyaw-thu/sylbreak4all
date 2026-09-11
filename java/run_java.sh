#!/bin/sh
set -eu
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
java -cp "$SCRIPT_DIR" sylbreak4all "$@"
