#!/bin/sh
set -eu
node "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/sylbreak4all.js" "$@"
