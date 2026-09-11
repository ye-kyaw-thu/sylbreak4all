#!/bin/sh
set -eu

# Re-run the reference implementation on a private corpus. The corpus directory
# should contain .all files named: bamar_burmese, shan, pao, po_kayin, sgaw_kayin,
# rakhine, beik, dawei, mon. This script never copies the corpus into the repo.

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "Usage: $0 PRIVATE_CORPUS_DIR [OUTPUT_DIR]" >&2
  exit 1
fi
CORPUS_DIR=$1
OUT_DIR=${2:-"$PWD/sylbreak4all-private-results"}
mkdir -p "$OUT_DIR"

for code in bm sh po pk sk rk bk dw mo; do
  case "$code" in
    bm) stem=bamar_burmese;; sh) stem=shan;; po) stem=pao;; pk) stem=po_kayin;;
    sk) stem=sgaw_kayin;; rk) stem=rakhine;; bk) stem=beik;; dw) stem=dawei;; mo) stem=mon;;
  esac
  input="$CORPUS_DIR/$stem.all"
  [ -f "$input" ] || { echo "Skipping missing $input"; continue; }
  perl "$ROOT/perl/sylbreak4all.pl" -i "$input" -l "$code" -s ' ' > "$OUT_DIR/$stem.out.txt"
  echo "Wrote $OUT_DIR/$stem.out.txt"
done
