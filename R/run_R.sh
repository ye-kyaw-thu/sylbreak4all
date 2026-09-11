#!/bin/sh
set -eu
Rscript "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/sylbreak4all.R" "$@"
