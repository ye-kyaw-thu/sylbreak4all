# RE pattern map

The implementation follows the language grouping described in the published paper:

- `bm`, `rk`, `dw`, `bk`, `po`: Burmese-style RE
- `sh`: Shan RE
- `pk`: Pwo Kayin RE
- `sk`: S\'gaw Kayin RE
- `mo`: Mon RE

The release ports intentionally keep the rule-based core intact. Implementation-only fixes cover language selection, UTF-8 I/O, consistent preprocessing, and build/runtime portability.
