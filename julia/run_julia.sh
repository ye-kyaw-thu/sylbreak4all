#!/bin/sh
set -eu
julia "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/sylbreak4all.jl" "$@"
