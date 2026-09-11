#!/bin/sh
set -eu
"$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/sylbreak4all.sh" "$@"
