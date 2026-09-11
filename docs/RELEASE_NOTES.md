# Release notes — version 0.9.0

Version 0.9.0 packages the `sylbreak4all` rule-based syllable-breaking work for public reproducibility while keeping the published regular-expression approach intact.

## Implementation updates

- The Perl reference implementation now uses the requested language code to select the corresponding language-specific rule.
- The PHP implementation is aligned with the same language-specific rule families.
- UTF-8 input handling and whitespace preprocessing are kept consistent across the maintained ports.
- Java is distributed as UTF-8 source plus a compile script rather than as compiled class files.
- C++ is distributed as source plus an ICU build script rather than as a compiled binary.
- R and Julia source implementations are included together with simple run wrappers.
- All maintained command-line implementations use the same `--help` content and language-code descriptions.

## Public examples

The repository contains 10-line demonstration corpora for all nine supported language codes and the corresponding Perl-reference segmented results. The examples are intended for reproducibility, smoke testing, documentation, and learning how the rule-based segmenter behaves.

The executable ports were cross-checked against the Perl reference on the public examples during release preparation.

## Data policy

The full research corpus is not included in the public release. Full-corpus data and full-corpus segmented outputs remain outside the repository.

Only the small public examples and their reference results are distributed.

## License

The code and the small public example corpus are released under the MIT License.
