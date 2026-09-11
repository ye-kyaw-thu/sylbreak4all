#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
mkdir -p "$ROOT/examples/results"
run() {
  code=$1; stem=$2
  in="$ROOT/examples/corpus/$stem.txt"
  out="$ROOT/examples/results/$stem.txt"
  perl "$ROOT/perl/sylbreak4all.pl" -i "$in" -l "$code" > "$out"
}
run bm bamar_burmese
run bk beik
run dw dawei
run mo mon
run po pao
run pk po_kayin
run rk rakhine
run sk sgaw_kayin
run sh shan
echo "Wrote canonical Perl-reference results to examples/results/."
