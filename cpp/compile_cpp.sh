#!/bin/sh
set -eu
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$SCRIPT_DIR"
CXX=${CXX:-g++}
"$CXX" -std=c++17 -O2 -Wall -Wextra sylbreak4all.cpp -o sylbreak4all $(pkg-config --cflags --libs icu-uc icu-i18n)
