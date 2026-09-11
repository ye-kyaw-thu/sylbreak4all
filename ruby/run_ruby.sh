#!/bin/sh
set -eu
ruby "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/sylbreak4all.rb" "$@"
