#!/bin/sh
set -eu
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
exec perl "$SCRIPT_DIR/../perl/sylbreak4all.pl" "$@"
