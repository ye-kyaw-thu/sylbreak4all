#include <unicode/regex.h>
#include <unicode/unistr.h>
#include <unicode/ustream.h>
#include <iostream>
#include <fstream>
#include <map>
#include <memory>
#include <stdexcept>
#include <string>

using icu::RegexMatcher;
using icu::RegexPattern;
using icu::UnicodeString;

static std::map<std::string, std::string> build_patterns() {
    const std::string my = "က-အ";
    const std::string en = "a-zA-Z0-9";
    const std::string ss = "္";
    const std::string athat = "်";
    const std::string other = "ဣဤဥဦဧဩဪဿ၌၍၎၏၀-၉႐-႙၊။!-/:-@\\[-`’“”{-~\\s…";
    const std::string sh = "ၵၶငၸသၺတထၼပၽၾမယရလဝႁဢၹၷႀၻၿ";
    const std::string other_sh = "႟႐-႙၊။!-/:-@\\[-`{-~\\s";
    const std::string sk = "ကခဂဃငစဆဇညတထဒနပဖဘမယရလဝသဟအဧ";
    const std::string other_sk = "ဒမၡဧ၀-၉၊။!-/:-@\\[(-`{-~\\s";
    const std::string other_pk = "ၥၦၡဧ၀-၉၊။!-/:-@\\[(-`{-~\\s";
    const std::string mo = "ကခဂဃၚစဆဇၛဉညဋဌဍဎဏတထဒဓနပဖဗဘမယရလဝသဟဠၜအၝ";

    const std::string common = "((?<!" + ss + ")[" + my + "](?![" + athat + ss + "])|[" + en + other + "])";
    return {
        {"bm", common}, {"rk", common}, {"dw", common}, {"bk", common}, {"po", common},
        {"sh", "([" + sh + "](?![" + athat + "])|[" + en + other_sh + "])"},
        {"sk", "([" + sk + "]|[" + en + other_sk + "])"},
        {"pk", "([" + my + "]|[" + en + other_pk + "])"},
        {"mo", "((?<!" + ss + ")[" + mo + "](?![" + athat + ss + "])|[" + en + other + "])"}
    };
}

static void usage(int status = 0) {
    std::cout << R"HELP(Syllable Breaker Tool
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
)HELP";
    std::exit(status);
}

static std::string segment_line(const std::string& utf8_line, const RegexPattern& pattern, const std::string& sep_utf8) {
    UErrorCode status = U_ZERO_ERROR;
    UnicodeString line = UnicodeString::fromUTF8(utf8_line);

    // Match historical reference preprocessing: remove Unicode whitespace first.
    std::unique_ptr<RegexPattern> whitespacePattern(RegexPattern::compile(UnicodeString::fromUTF8("\\s+"), 0, status));
    if (U_FAILURE(status)) throw std::runtime_error("Failed to compile whitespace regex");
    std::unique_ptr<RegexMatcher> whitespace(whitespacePattern->matcher(line, status));
    if (U_FAILURE(status)) throw std::runtime_error("Failed to create whitespace matcher");
    line = whitespace->replaceAll(UnicodeString(), status);
    if (U_FAILURE(status)) throw std::runtime_error("Failed to strip whitespace");

    std::unique_ptr<RegexMatcher> matcher(pattern.matcher(line, status));
    if (U_FAILURE(status)) throw std::runtime_error("Failed to create matcher");
    const UnicodeString sep = UnicodeString::fromUTF8(sep_utf8);
    UnicodeString output;
    int32_t last = 0;
    while (matcher->find(status)) {
        const int32_t start = matcher->start(status);
        const int32_t end = matcher->end(status);
        output.append(line, last, start - last);
        output.append(sep);
        output.append(line, start, end - start);
        last = end;
    }
    if (U_FAILURE(status)) throw std::runtime_error("Regex matching failed");
    output.append(line, last, line.length() - last);

    std::unique_ptr<RegexPattern> trimPattern(RegexPattern::compile(UnicodeString::fromUTF8("^\\s+|\\s+$"), 0, status));
    std::unique_ptr<RegexMatcher> trimMatcher(trimPattern->matcher(output, status));
    output = trimMatcher->replaceAll(UnicodeString(), status);
    if (U_FAILURE(status)) throw std::runtime_error("Failed to trim whitespace");
    std::string out;
    output.toUTF8String(out);
    return out;
}

int main(int argc, char** argv) {
    try {
        std::string input_file, separator = "|", language = "bm";
        bool print_input = false;
        for (int i = 1; i < argc; ++i) {
            std::string arg = argv[i];
            if ((arg == "-i" || arg == "--input" || arg == "--input-file") && i + 1 < argc) input_file = argv[++i];
            else if ((arg == "-l" || arg == "--language" || arg == "--lang") && i + 1 < argc) language = argv[++i];
            else if ((arg == "-s" || arg == "--separator") && i + 1 < argc) separator = argv[++i];
            else if (arg == "-p" || arg == "--print") print_input = true;
            else if (arg == "-h" || arg == "--help") { usage(0); }
            else { std::cerr << "Unknown or incomplete argument: " << arg << "\n"; usage(1); }
        }

        const auto patterns = build_patterns();
        auto it = patterns.find(language);
        if (it == patterns.end()) { std::cerr << "Unsupported language: " << language << "\n"; usage(1); }

        UErrorCode status = U_ZERO_ERROR;
        std::unique_ptr<RegexPattern> pattern(RegexPattern::compile(UnicodeString::fromUTF8(it->second), 0, status));
        if (U_FAILURE(status)) {
            std::string msg;
            msg = u_errorName(status);
            throw std::runtime_error("Failed to compile language regex: " + msg);
        }

        std::istream* input = &std::cin;
        std::ifstream file;
        if (!input_file.empty()) {
            file.open(input_file, std::ios::binary);
            if (!file) throw std::runtime_error("Could not open file: " + input_file);
            input = &file;
        }

        std::string line;
        while (std::getline(*input, line)) {
            std::string output = segment_line(line, *pattern, separator);
            if (print_input) {
                // Recompute cleaned input by applying an empty-separator pass.
                UErrorCode clean_status = U_ZERO_ERROR;
                UnicodeString clean = UnicodeString::fromUTF8(line);
                std::unique_ptr<RegexPattern> wp(RegexPattern::compile(UnicodeString::fromUTF8("\\s+"), 0, clean_status));
                std::unique_ptr<RegexMatcher> wm(wp->matcher(clean, clean_status));
                clean = wm->replaceAll(UnicodeString(), clean_status);
                std::string clean8; clean.toUTF8String(clean8);
                std::cout << clean8 << "\noutput: " << output << "\n";
            } else {
                std::cout << output << "\n";
            }
        }
        return 0;
    } catch (const std::exception& e) {
        std::cerr << e.what() << "\n";
        return 1;
    }
}
