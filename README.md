# sylbreak4all

**Version 0.9.0**

**Regular-expression-based syllable breaking for nine Myanmar languages/varieties**

`sylbreak4all` is a small rule-based syllable segmentation toolkit derived from the earlier [`sylbreak`](https://github.com/ye-kyaw-thu/sylbreak) regular-expression approach and extended to the nine language/variety codes used in the published study:

- Burmese (`bm`)
- Shan (`sh`)
- Pa'O (`po`)
- Pwo Kayin (`pk`)
- S'gaw Kayin (`sk`)
- Rakhine (`rk`)
- Beik (`bk`)
- Dawei (`dw`)
- Mon (`mo`)

The published study presents regular-expression rules for these nine languages and describes syllable segmentation as an important preprocessing step for NLP tasks such as grapheme-to-phoneme conversion, machine translation, and romanization.

> **Terminology.** The published paper uses the title “Nine Major Ethnic Languages of Myanmar.” This repository uses “nine Myanmar languages/varieties” as a neutral repository description while preserving the published paper title in the citation below.

## Published paper and citation

**Please cite the published paper when using this repository, its code, or its syllable-breaking rules.**

> Ye Kyaw Thu, Hlaing Myat Nwe, Hnin Aye Thant, Hay Man Htun, Htay Mon, May Myat Myat Khaing, Hsu Pan Oo, Pale Phyu, Nang Aeindray Kyaw, Thazin Myint Oo, Thazin Oo, Thet Thet Zin, and Thida Oo. “sylbreak4all: Regular Expressions for Syllable Breaking of Nine Major Ethnic Languages of Myanmar.” *2021 16th International Joint Symposium on Artificial Intelligence and Natural Language Processing (iSAI-NLP)*, 2021, pp. 1–6. DOI: https://doi.org/10.1109/iSAI-NLP54397.2021.9678188

### BibTeX

```bibtex
@inproceedings{Thu2021Sylbreak4all,
  author = {Ye Kyaw Thu and Hlaing Myat Nwe and Hnin Aye Thant and Hay Man Htun and Htay Mon and May Myat Myat Khaing and Hsu Pan Oo and Pale Phyu and Nang Aeindray Kyaw and Thazin Myint Oo and Thazin Oo and Thet Thet Zin and Thida Oo},
  title = {sylbreak4all: Regular Expressions for Syllable Breaking of Nine Major Ethnic Languages of Myanmar},
  booktitle = {2021 16th International Joint Symposium on Artificial Intelligence and Natural Language Processing (iSAI-NLP)},
  pages = {1--6},
  year = {2021},
  doi = {10.1109/iSAI-NLP54397.2021.9678188}
}
```

## Relationship to `sylbreak`

The earlier [`sylbreak`](https://github.com/ye-kyaw-thu/sylbreak) repository is the predecessor of this work. `sylbreak4all` keeps the same central idea: use Unicode-aware regular-expression rules to insert a separator at candidate syllable boundaries. The published paper groups the rules by orthography and language; this repository keeps that grouping rather than replacing the method with a different segmentation model.

For the Burmese-style rule, the important Unicode context includes the `U+1039` subscript symbol and `U+103A` aThat sign. The paper also notes the use of `U+AA7B` for the Pa'O tone sign Mine Ngar. The language-specific patterns are documented in `docs/PATTERNS.md` and in the source files.

## Supported languages

| Code | Language / variety |
|---|---|
| `bm` | Burmese |
| `bk` | Beik |
| `dw` | Dawei |
| `rk` | Rakhine |
| `mo` | Mon |
| `po` | PaO |
| `sh` | Shan |
| `sk` | Sgaw Kayin |
| `pk` | Pwo Kayin |

## Input and output

Input is UTF-8 text. The reference behavior removes Unicode whitespace before applying the syllable-breaking rule. The default separator is `|`; use `-s` to select another separator.

Example:

```text
perl perl/sylbreak4all.pl -i examples/corpus/bamar_burmese.txt -l bm
```

The public example corpus contains **10 lines for each of the nine language codes**, and `examples/results/` contains the corresponding segmented results.

## Important notice about Unicode typing order

**Warning:** `sylbreak4all` assumes that the input text is correctly typed and encoded in the expected Unicode character order for the target language. The syllable breaker is a rule-based regular-expression system; it does **not** normalize, reorder, or repair characters before segmentation.

If a user types a Myanmar-language word with the wrong Unicode typing order, or if an input file contains incorrectly ordered combining characters, the regular-expression rules may detect the wrong syllable boundaries and therefore produce incorrect segmentation. This is expected behavior for malformed or incorrectly ordered input and should not be interpreted as a failure of the segmentation rules on correctly ordered text.

For example, the following inputs demonstrate incorrect segmentation caused by wrong Unicode typing order:

### Shan

Input:

```text
ပဵၼ်ၵူၼ်းဢၼ်လဵၼ်ႈၸိူင်းၶႅၼ်ႇႄတႉယဝ်ႈ
```

Output:

```text
|ပဵၼ်|ၵူၼ်း|ဢၼ်|လဵၼ်ႈ|ၸိူင်း|ၶႅၼ်ႇႄ|တႉ|ယဝ်ႈ
```

Here, `ႄတႉ` contains characters in the wrong typing order.

### Beik

Input:

```text
ဘဇာလောက်မြင့်မြတ်ရိ။
```

Output:

```text
/ဘ/ဇာ/လောက်/မြ/င့်/မြတ်/ရိ/။
```

Here, `င့်` contains characters in the wrong typing order, causing the expected syllable boundary to be broken incorrectly.

### Rakhine

Input:

```text
နောက်ဆုံးတစ်ကြိမ်သူ့ကိုချစ်ပါရေလို့ပြောခွင့်တောင်မရပါ။
```

Output:

```text
​_နောက်_ဆုံး_တစ်_ကြိမ်_သူ့_ကို_ချစ်_ပါ_ရေ_လို့_ပြော_ခွ_င့်_တောင်_မ_ရ_ပါ_။
```

Again, the incorrectly ordered `င့်` sequence causes the syllable to be split incorrectly.

**Recommendation:** Before using `sylbreak4all`, make sure that the source text has been entered with the correct Unicode typing order and does not contain incorrectly ordered combining characters. If your input comes from OCR, copied text, legacy encodings, or mixed text-processing pipelines, inspect and normalize the text appropriately before syllable segmentation.

## Command-line help

All maintained ports use the same help content and language-code descriptions. For example:

```text
$ perl perl/sylbreak4all.pl --help
Syllable Breaker Tool
Version: 0.9.0

Supported Languages:
    bm  - Burmese
    bk  - Beik
    dw  - Dawei
    rk  - Rakhine
    mo  - Mon
    po  - PaO
    sh  - Shan
    sk  - Sgaw Kayin
    pk  - Pwo Kayin

Usage: sylbreak4all [-i filename] [-l language] [-s separator] [-p]
    -i | --input-file   Input file name (default: STDIN)
    -s | --separator    Separator (default: '|')
    -l | --language     Language (default: bm for Burmese)
    -p | --print        Print input alongside the output (default: 0)
    -h | --help         Show this help
```

## Quick start

### Perl

```text
perl perl/sylbreak4all.pl -i examples/corpus/bamar_burmese.txt -l bm
```

### Python

```text
python3 python/sylbreak4all.py -i examples/corpus/shan.txt -l sh
```

### PHP

```text
php php/sylbreak4all.php -i examples/corpus/mon.txt -l mo
```

### Java

```text
cd java
./compile.sh
./run_java.sh -i ../examples/corpus/pao.txt -l po
```

### JavaScript / Node.js

```text
node java_script/sylbreak4all.js -i examples/corpus/rakhine.txt -l rk
```

### Ruby

```text
ruby ruby/sylbreak4all.rb -i examples/corpus/sgaw_kayin.txt -l sk
```

### Bash wrapper

The Bash script is a compatibility wrapper around the Perl reference implementation:

```text
bash bash/sylbreak4all.sh -i examples/corpus/po_kayin.txt -l pk
```

### C++

The C++ implementation uses ICU for Unicode regular expressions. Compile it with:

```text
cd cpp
./compile_cpp.sh
./run_cpp.sh -i ../examples/corpus/shan.txt -l sh
```

A working ICU development installation and `pkg-config` are required.

### R

Run the R implementation directly with `Rscript`:

```text
Rscript R/sylbreak4all.R --help
Rscript R/sylbreak4all.R -i examples/corpus/mon.txt -l mo
```

A convenience wrapper is also provided:

```text
./R/run_R.sh -i examples/corpus/mon.txt -l mo
```

### Julia

Run the Julia implementation directly with Julia 1.x:

```text
julia julia/sylbreak4all.jl --help
julia julia/sylbreak4all.jl -i examples/corpus/shan.txt -l sh
```

A convenience wrapper is also provided:

```text
./julia/run_julia.sh -i examples/corpus/shan.txt -l sh
```

## Public 10-line corpus and results

The repository deliberately includes only a **small public demonstration corpus**: 10 lines per language. It is intended for reproducibility, smoke testing, documentation, and learning how the rule-based segmenter behaves.

Input files:

```text
examples/corpus/bamar_burmese.txt
examples/corpus/beik.txt
examples/corpus/dawei.txt
examples/corpus/mon.txt
examples/corpus/pao.txt
examples/corpus/po_kayin.txt
examples/corpus/rakhine.txt
examples/corpus/sgaw_kayin.txt
examples/corpus/shan.txt
```

Matching reference outputs are in:

```text
examples/results/
```

Regenerate them with:

```text
./scripts/run_examples.sh
```

Syllable segmented results:  

```
head ./examples/results/*
==> ./examples/results/bamar_burmese.txt <==
|က|ခ|ဂ|ဃ|င|၀|၁|၂|၃|၄|၅|၆|၇|၈|၉
|နေ|ကောင်း|လား|။
|ကျန်း|မာ|တယ်|၊|ဒါ|ပေ|မဲ့|အ|လုပ်|များ|တယ်|။
|မင်္ဂ|လာ|ပါ|ဆ|ရာ|မ|။
|တက္က|သိုလ်|အ|သွား|အ|ပြန်|ကို|သင်္ဘော|စီး|ပြီး|သွား|ရ|တယ်|။
|ပုပ္ပါး|တောင်|ကို|ထပ်|တက်|ချင်|သေး|တယ်|။
|ကျောင်း|သား|ကျောင်း|သွား|ပါ|။
|က|လေး|က|အိမ်|မှာ|ပါ
|ကျောင်း|သား|ကျောင်း|သူ|ကျောင်း|မှာ
|ပါ|ပါ|သ|မီး|ကို|လွမ်း|နေ|တယ်|။

==> ./examples/results/beik.txt <==
|နင်|ဘာ|စီ|စဉ်|နေ|ရယ်|ဆို|တာ|ငါ့|ဝို|ပြော|သင့်|ပေါ့|လန်း|။
|သူ|လို့|စာ|အုပ်|သုံး|ထောင်|ကျော်|ရောင်း|ပီး|ဟော|ဘီ|။
|ငယ်|ငယ်|တည်း|က|မင်း|သား|လုပ်|ဝို့|ဝါ|သ|နာ|ပါ|စ|။
|သူ|တစ်|ချိန်|လုံး|လုပ်|နေ|ဇာ|ဂ|ညဉ်း|ပဲ့|ညည်း|နေ|ဇာ|။
|ဒယ်|ကောင်|မ|ငယ်|နင့်|ဝို|ဂ|ရု|စိုက်|ရယ်|လား|။
|ဘ|ဇာ|လောက်|မြင့်|မြတ်|ရိ|။
|နင်|ဒယ်|မှာ|အ|လုပ်|လုပ်|ဝယ်|။
|ဒယ်|ကောင်|မ|ငယ်|ဟ|မင်း|ဟက်|သ|ဘော|တူ|မှာ|မ|ဟုတ်|ဝ|။
|နင့်|ရဲ့|သွား|နှစ်|ချောင်း|ကို|နုတ်|ပစ်|ရ|မရ်|။
|သူ့|ဆီ|ကို|နင်|ဖုန်း|ဆက်|မယ်|မ|ဟုတ်|ဝ|လား|။

==> ./examples/results/dawei.txt <==
|နန်|ဟှဲ|ဇာ|စီ|စဉ်|နေ|ဟှယ်|ဆို|တာ|ငါ့|ကို|ပြော|သင့်|ဟှယ်|။
|သူး|နို့|စာ|အုပ်|သုံး|ထော်|ကျော်|ရော|ပီး|ပီ|။
|ချို့|လူ|လေ|ဟှာ|မွီး|ရာ|ပါ|ဇာတ်|မှန်း|သား|လေ|မား|။
|ချို့|လူ|လေ|ဟှာ|မွီး|ရာ|ပါ|ပွဲ|မှန်း|သား|လေ|ပဲ့|။
|သူ|နန့်|ဟှို|ဂ|ရု|စိုက်|ပဲ့|လား|။
|ဟှယ်|လော့|မြတ်|ဟှယ်|။
|နန်|အဲ့|မာ|လောက်|လောက်|ဟှယ်|။
|ဝယ်|ရား|က|နန့်|နဲ့|ဘော|တူ|မှာ|မှု|ဝ|။
|နန့်|သွား|နှေ့|ရှော|ဟှို|နှု|ပစ်|ရ|မယ်|။
|အဲ|ဝယ်|ဟှား|နား|ဟှို|နန်|ဖောင်း|ဆစ်|ဟှို့|မှု|ဟှ|လား|။

==> ./examples/results/mon.txt <==
|၂|၀|မိ|ဏေတ်|ပၠန်|တှ်ေ|ဘာ|ရပ်|ဏောၚ်|။
|ဗှ်ေ|ဟ|ယျ|တုဲ|မာန်|ဟာ|။
|ယဝ်|ဗှ်ေ|ဟွံ|ပ|ယှုက်|အဲ|ရ|တှ်ေ|တုဲ|မာန်|ဏောၚ်|။
|အဲ|ဟ|ယျ|ဗှ်ေ|တိၚ်|ဂီ|တာ|လေပ်|မံၚ်|။
|လၟုဟ်|အဲဗ္တောန်|တိၚ်|မံၚ်|ဂီ|တာ|။
|ပေါဲ|ဂီ|တ|ဂှ်|ဂိ|တု|ဂ|တ|မှ|ကၠောန်|ဏောၚ်|။
|သွက်|အဲ|ဂွံ|အံၚ်|ဇၞး|ရာ|ဒ|နာ|ကဵု|ညိ|။
|ခိုဟ်|ယျ|ဆက်|ဂ|စာန်|ညိ|ပၠန်|။
|ဂ|လာန်|ဗှ်ေ|ပ|တိုန်|လဝ်|နူ|ဏေအ်ဗ္တံ|ဂှ်|ခိုဟ်|ကွေံ|ကွေံ|။
|ၜိုတ်|အဲ|ကၠောန်|မာန်|အဲ|ဂ|စာန်|လဝ်|ရ|။

==> ./examples/results/pao.txt <==
|လို|မူႏ|ပေႏ|မာꩻ|တ|မုဲင်ꩻ|ဟောင်း
|ဝွေꩻ|သီး|အီး|ကွီႏ|သ|ညင်ꩻ|နာꩻ|တ|မွေး|တဝ်း
|နီ|တ|ယူႏ|လ|တဝ်း|ခင်ႏ|လမ်း|နဝ်ꩻ
|နာꩻ|ပါꩻ|မုဲင်ꩻ|မန်|နေ|ဂျာ|ဟောင်း
|ဝွေꩻ|မူႏ|ခြောဝ်|ငဝ်း
|နာꩻ|နမ်း|တွမ်ႏ|နာꩻ|နမ်း|ယွုမ်း|အံႏ|မုꩻ|မဉ်|အဝ်ႏ|တဲ့|ကျိုꩻ|စာꩻ|စံ|ဟုဲင်း
|ချာ|နေ|နမ်း|မဉ်|ဟောင်း
|ဝွေꩻ|မူႏ|တွမ်ႏ|ဝွေꩻ|ထေင်|ညင်|ချာ|ငါꩻ|ဝင်ꩻ|ဟောင်း
|နာꩻ|နဝ်ꩻ|လို|လွစ်|ဟောင်း
|အ|ရီး|သွတ်|တ|ဗာႏ|အ|နေႏ|ဝွေꩻ|မူႏ|အဝ်ႏ|လိုႏ|ဖျင်ꩻ|ဆင်ꩻ|ဒဲဉ်ꩻ|ရဝ်ꩻ|တာႏ

==> ./examples/results/po_kayin.txt <==
|န|ဂဲၫ|ထဲၩ့|မၩ|ဆၧ|လ|ဖၪ|အ|ဂး|န|နီၪ့|ယါ|လၩ့|န|ၥၭ|အ့ၬ|ဧၪ
|ယ|ခိၭ|နၧၩ|လၧ|ယ|က|ကိၭ|ဖံၭ|ၥိၭ|နၧၩ|အ|ဂး|လီၫ
|မ|နီၪ|လဲၪ|ဂၭ|ဂီၩ့|လဲၪ|နီၪ|န|ၥ့ၪ|ယၫ|ဧၪ
|ယ|ၥၭ|လ|မုၬ|ဘၪ|လၧ|န|ထံၩ|ၥိၭ|အ|ဂး|နီၪ|လီၩ|အ့ၪ|ဆံၭ
|က|ဘၪ|အၪ့|လံၩ့|တၨၭ|ဒူၭ|ဧၪ|လ|မွဲ|ဘၪ|က|ဘၪ|ဎွ့ၩ|ခွံၬ|ဧၪ|နီၪ|ယ|ၥ့ၪ|ယၫ|အ့ၬ
|ထိၪ|ၥံၪ|ယူၩ|လီၫ
|ဆၧ|အ|မွဲ|လ|ၥၨၩ|လၩ့|ထံး|လ|ၥၨၩ
|ဂဲၫ|ထဲၩ့|ဎွ့ၩ|န့|ဘိၩ|လၧ|မု|ဂၪ|နံၩ|အိၩ|လၧ|ဆၧ|အၪ|မံၩ့|ဆဲၫ့|ဖၭ|ဒိၪ|နီၪ|လီၫ
|ဘိၩ့|နဲၪ့|ယီၩ|နီၪ|အ|ဝ့ၫ|အီၪ|ကၠၧၫ့|ကၠၧၫ့|လၧ|အ|မိ|အ|ဖါ|ၥံၪ|လီၫ
|န|က|ယိ|ၦ|မုၪ|နီၪ|ဧၪ

==> ./examples/results/rakhine.txt <==
|မင်း|ယင်း|ချင့်|ကို|အ|ခြား|တစ်|ခု|နန့်|မ|ချိတ်|ပါ|လား|။
|ထို|မ|ချေ|တစ်|ယောက်|လေ့|မ|မှတ်|မိ|ပါ|ယာ|။
|ယင်း|ချင့်|ကျွန်|တော်|ရို့|အ|တွက်|ခက်|ခ|ရေ|။
|မင်း|ပြော|ခ|ရေ|ပိုင်|ကျွန်|တော်|ယှင်း|ပြ|ခ|ရေ|။
|သူ့|ကို|ထိန်း|ဖို့|မင်း|ရာ|တတ်|နိုင်|ရေ|။
|ယင်း|ချင့်|ကို|ငါ|တက်|နင်း|မိ|လား|လာ|။
|ငါ|စဉ်း|စား|ရေ|ပိုင်|စဉ်း|စား|ပါ|။
|အ|တင်း|ပြော|ရ|စွာ|မုန်း|ရေ|။
​|နောက်|ဆုံး|တစ်|ကြိမ်|သူ့|ကို|ချစ်|ပါ|ရေ|လို့|ပြော|ခွင့်|တောင်|မ|ရ|ပါ|။
|နာ|ဆာ|မှ|ဒုံး|ပျံ|စ|တက်|စွာ|နန့်|သူ|မှတ်|တမ်း|ရွီး|ခ|ရေ|။

==> ./examples/results/sgaw_kayin.txt <==
|န|ဘၣ်|သံ|ကွၢ်|တၢ်|မ|တၤ|န့ၣ်|လဲၣ်
|တၢ်|ဂ့ၢ်|ဝဲ|အံၤ|န|ဘၣ်|တဲ|တၢ်|မ|တၤ|န့ၣ်|လဲၣ်
|န|ဘၣ်|ထံၣ်|လိာ်|သး|ဒီး|မ|တၤ|န့ၣ်|လဲၣ်
|န|ဘၣ်|တၢ်|ဃု|ထၢ|မ|တၤ|န့ၣ်|လဲၣ်
|န|ဘၣ်|စံၣ်|ညီၣ်|တၢ်|မ|တၤ|န့ၣ်|လဲၣ်
|န|ဘၣ်|ကွၢ်|ဃု|တၢ်|မ|တၤ|န့ၣ်|လဲၣ်
|န|တဲ|တ့ၢ်|မ|တၤ|န့ၣ်|လဲၣ်
|န|ဟ့ၣ်|တ့ၢ်|မ|တၤ|န့ၣ်|လဲၣ်
|န|ကိး|တ့ၢ်|မ|တၤ|န့ၣ်|လဲၣ်
|န|ထံၣ်|တ့ၢ်|မ|တၤ|သ့ၣ်|န့ၣ်|လဲၣ်

==> ./examples/results/shan.txt <==
|ယွင်ႈ|ၵုင်ႇ|ၵူၼ်း|ႁတ်း|ႁၢၼ်|ႁႃႉ
|ဢၼ်|ၸႅတ်ႈ|တူၺ်း|သူ|ႁေႃႈ|ၵႃး|ၼႆႉ|တွပ်ႇ|ယဝ်ႉ|ယဝ်ႉ|ႁႃႉ
|လွင်ႈ|ၶူင်|သၢင်ႈ|မႂ်း|ဢမ်ႇ|ႁိုင်|သင်|တေ|ဢွင်ႇ|မၢၼ်|ယဝ်ႉ
|ဢၼ်|ၼၼ်ႉ|ပဵၼ်|လွင်ႈ|ၵိတ်ႇ|ၶွင်ႈ|သူ
|တေ|ၵိၼ်|သေ|ဢၼ်|ဢၼ်|ႁႃႉ
|ဢွမ်|မူင်း|ၵဝ်|ႁႃ|ဢမ်ႇ|ႁၼ်
|ပဵၼ်|ၵူၼ်း|ဢၼ်|လဵၼ်ႈ|ၸိူင်း|ၶႅၼ်ႇ|တႄႉ|ယဝ်ႈ
|ၵုပ်ႉ|ၵူႈ|သူ|ၼႆႉ|တႄႇ|ၽုၺ်ႇ|သႅင်ႇ|ၵိၼ်|ယမ်ႉ|ၼႆႉ|မႃး|တေႃႇ|မိူဝ်ႈ|လဵဝ်|ဢၼ်|ၽႅဝ်|မႃး|ၼႆႉ|ပဵၼ်|႙|႙|႙|ၵူႈ|ယဝ်ႉ
|ၼင်ႈ|ႁွင်ႈ|တၢင်း|ၼႃႈ|ဢဝ်|ၼႄႈ
|လႆႈ|ႁႅင်း|လီ|ၵႃႈ|ႁိုဝ်

```

## Release notes

Version **0.9.0** keeps the published regular-expression syllable-breaking approach and makes only necessary implementation and release-quality updates.

1. The Perl reference implementation now uses the requested language code to select the corresponding language-specific rule.
2. The PHP implementation is aligned with the same language-specific rule families.
3. UTF-8 input handling and whitespace preprocessing are kept consistent across the maintained ports.
4. Java is compiled from source with UTF-8 explicitly enabled.
5. The C++ implementation uses ICU for Unicode regular expressions rather than distributing a compiled binary.
6. The repository includes only the small public example corpus and its segmented reference outputs.

No new segmentation model or machine-learning component was introduced.

## Repository layout

```text
perl/            Perl reference implementation
python/          Python implementation
php/             PHP implementation
cpp/             C++ implementation (ICU)
java/            Java implementation
java_script/     JavaScript / Node.js implementation
ruby/            Ruby implementation
bash/             Bash compatibility wrapper using the Perl reference
R/               R implementation
julia/            Julia implementation
examples/        Public 10-line input/output examples
scripts/         Example runners
docs/            Pattern and release notes
LICENSE           MIT license
VERSION           Release version (0.9.0)
```

## Data and privacy note

The full research corpus is intentionally **not** included in this public release. The public repository contains only the nine 10-line demonstration files and their corresponding segmented outputs.

The full corpus and any full-corpus segmented results remain outside the public release.


## License

The code and the small public example corpus are released under the **MIT License**. See `LICENSE`.

The published paper is not relicensed by this repository; its publisher's copyright and distribution terms continue to apply.

## References

1. [Sgaw Kayin Language](https://my.wikipedia.org/wiki/%E1%80%85%E1%80%80%E1%80%B1%E1%80%AC%E1%80%80%E1%80%9B%E1%80%84%E1%80%BA%E1%80%98%E1%80%AC%E1%80%9E%E1%80%AC%E1%80%85%E1%80%80%E1%80%AC%E1%80%B8)
2. [A Grammar of the Sgaw Karen, by REV. DAVID GILMORE, M.A., Of the American Baptist Mission
in Burma., 1898](https://gutenberg.net.au/ebooks09/0900201p.pdf)  
3. [Anglo Karen Dictionary, by Rev. Jonathan Wade, D.D., 1st Edition 1883, 2nd Edition 1954](https://gutenberg.net.au/ebooks08/0801341p.pdf)
4. [Languages of Pwo Karen](https://my.wikipedia.org/wiki/%E1%80%95%E1%80%AD%E1%80%AF%E1%80%B8%E1%80%80%E1%80%9B%E1%80%84%E1%80%BA%E1%80%98%E1%80%AC%E1%80%9E%E1%80%AC%E1%80%85%E1%80%80%E1%80%AC%E1%80%B8%E1%80%99%E1%80%BB%E1%80%AC%E1%80%B8)
