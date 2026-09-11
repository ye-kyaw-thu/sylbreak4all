# Experiment and code-review report

Date: 2026-09-10

## Scope

This report records the validation performed before preparing the public `sylbreak4all` release. The source material was the supplied ZIP archive plus the published paper supplied with the project.

## Paper baseline

The paper presents `sylbreak4all` as a regular-expression-based syllable segmentation tool for nine language/variety codes: Burmese, Shan, Pa'O, Pwo Kayin, S'gaw Kayin, Rakhine, Myeik, Dawei, and Mon. It describes the Burmese-style rule using Unicode character classes and contextual checks around the `U+1039` subscript symbol and `U+103A` aThat, and gives separate patterns for Shan, Pwo Kayin, S'gaw Kayin, and Mon.

The paper reports 139,136 sentences and 1,910,822 syllables in its evaluation corpus and reports a 100% result on the sampled manual evaluation, with a note about a small residual Mon error rate. Those are paper results and are not re-claimed as new measurements here.

## Archive inspection

The supplied archive contains:

- eight private `.all` corpora (no full Burmese `.all` file);
- archived segmented `.out.txt` files for those eight datasets;
- Perl, Python, PHP, Java, JavaScript, Ruby, Bash, R, Julia, and C++ source variants;
- historical/temporary directories and older source copies;
- compiled Java/C++ artifacts; and
- language-detection/profile resources derived from corpus data.

The public release removes the private corpus, corpus-derived resources, temporary variants, and compiled binaries.

## Implementation findings

### 1. Perl language-selection bug

The archived Perl source stored the requested language but always applied one generic Burmese-style regex. The release Perl implementation now dispatches to the corresponding language-specific regex family.

This is the most important source-level correctness fix because the public repository promises nine language-specific rules.

### 2. PHP alignment

The archived PHP implementation did not match the paper/reference pattern family consistently. It has been aligned with the same five rule groups used in the maintained Perl/Python/etc. implementations.

### 3. Build portability

The archived Java `.class` file was not treated as a portable release artifact. The release ships source and UTF-8 compilation instructions.

The original C++ binary required a Boost.Regex shared library that was unavailable in the validation environment. The release C++ source therefore uses ICU for Unicode regular expressions and ships a reproducible compile script.

### 4. Preprocessing consistency

The release ports use the historical reference behavior of removing Unicode whitespace before applying the segmentation pattern and trimming separator whitespace from the final output. This preserves the expected behavior when a space is selected as the separator for corpus experiments.

## Full-corpus rerun

The corrected Perl reference was run on all eight supplied `.all` datasets. The total was 164,868 sentences and 1,897,812 generated output units.

| Language | Code | Sentences | Output units | Unique output units | Changed vs supplied archived output |
|---|---:|---:|---:|---:|---:|
| Myeik/Beik | `bk` | 6,622 | 68,076 | 1,261 | 0 lines |
| Dawei | `dw` | 6,622 | 67,245 | 1,626 | 0 lines |
| Mon | `mo` | 10,631 | 110,412 | 3,238 | 20 lines |
| Pa'O | `po` | 18,353 | 185,917 | 3,606 | 0 lines |
| Pwo Kayin | `pk` | 19,141 | 234,749 | 1,645 | 5 lines |
| Rakhine | `rk` | 18,373 | 231,636 | 1,781 | 0 lines |
| S'gaw Kayin | `sk` | 68,571 | 846,040 | 1,797 | 3,084 lines |
| Shan | `sh` | 16,555 | 153,737 | 3,745 | 11 lines |

The supplied archive contains ordinary input text and generated outputs rather than a gold syllable annotation, so the table deliberately labels the count as generated output units.

A separate private ZIP contains the complete corrected outputs for all eight rerun datasets and is marked **DO NOT RELEASE**.

## Public 10-line corpus

Nine public 10-line input files were created, one for each supported language code. Their corresponding segmented outputs are included under `examples/results/`.

The public examples are intended for:

- quick reproducibility;
- regression tests;
- learning how the rule operates; and
- documentation without exposing the full research corpus.

## Port validation

The following eight executable implementations/wrappers were tested against the Perl reference on every public language sample:

Perl, Python, PHP, Java, JavaScript, Ruby, Bash, and C++/ICU.

All matched byte-for-byte for all nine samples.

R and Julia were included as source ports but were not runtime-tested because the corresponding runtimes were unavailable in the environment.

## Recommendation

For the first public version, keeping the published rule-based algorithm is the right choice. The necessary corrections are implementation-level rather than a redesign of the segmentation method. The repository should explicitly describe the Perl language-dispatch correction and the deliberate removal of private corpus-derived artifacts, as done in the release README and release notes.
