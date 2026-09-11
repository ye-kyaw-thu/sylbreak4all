import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.regex.Pattern;

public class sylbreak4all {
    private static final Map<String, Pattern> PATTERNS = new LinkedHashMap<>();

    static {
        String myConsonant = "က-အ";
        String enChar = "a-zA-Z0-9";
        String ss = "္";
        String athat = "်";
        String other = "ဣဤဥဦဧဩဪဿ၌၍၎၏၀-၉႐-႙၊။!-/:-@\\[-`’“”{-~\\s…";
        String sh = "ၵၶငၸသၺတထၼပၽၾမယရလဝႁဢၹၷႀၻၿ";
        String otherSh = "႟႐-႙၊။!-/:-@\\[-`{-~\\s";
        String sk = "ကခဂဃငစဆဇညတထဒနပဖဘမယရလဝသဟအဧ";
        String otherSk = "ဒမၡဧ၀-၉၊။!-/:-@\\[(-`{-~\\s";
        String otherPk = "ၥၦၡဧ၀-၉၊။!-/:-@\\[(-`{-~\\s";
        String mo = "ကခဂဃၚစဆဇၛဉညဋဌဍဎဏတထဒဓနပဖဗဘမယရလဝသဟဠၜအၝ";

        String common = "((?<!" + ss + ")[" + myConsonant + "](?![" + athat + ss + "])|[" + enChar + other + "])";
        PATTERNS.put("bm", Pattern.compile(common));
        PATTERNS.put("rk", Pattern.compile(common));
        PATTERNS.put("dw", Pattern.compile(common));
        PATTERNS.put("bk", Pattern.compile(common));
        PATTERNS.put("po", Pattern.compile(common));
        PATTERNS.put("sh", Pattern.compile("([" + sh + "](?![" + athat + "])|[" + enChar + otherSh + "])"));
        PATTERNS.put("sk", Pattern.compile("([" + sk + "]|[" + enChar + otherSk + "])"));
        PATTERNS.put("pk", Pattern.compile("([" + myConsonant + "]|[" + enChar + otherPk + "])"));
        PATTERNS.put("mo", Pattern.compile("((?<!" + ss + ")[" + mo + "](?![" + athat + ss + "])|[" + enChar + other + "])"));
    }

    public static void main(String[] args) throws Exception {
        String inputFile = null, separator = "|", language = "bm";
        boolean printInput = false;
        for (int i = 0; i < args.length; i++) {
            switch (args[i]) {
                case "-i": case "--input": case "--input-file": inputFile = args[++i]; break;
                case "-s": case "--separator": separator = args[++i]; break;
                case "-l": case "--language": language = args[++i]; break;
                case "-p": case "--print": printInput = true; break;
                case "-h": case "--help": usage(0); return;
                default: System.err.println("Unknown argument: " + args[i]); usage(1); return;
            }
        }
        Pattern pattern = PATTERNS.get(language);
        if (pattern == null) { System.err.println("Unsupported language: " + language); usage(1); }

        BufferedReader reader = inputFile == null
                ? new BufferedReader(new InputStreamReader(System.in, StandardCharsets.UTF_8))
                : Files.newBufferedReader(Path.of(inputFile), StandardCharsets.UTF_8);
        try (reader) {
            String line;
            while ((line = reader.readLine()) != null) {
                String clean = line.replaceAll("\\s+", "");
                String output = pattern.matcher(clean).replaceAll(MatcherCompat.replacement(separator));
                output = output.replaceAll("^\\s+|\\s+$", "");
                if (printInput) {
                    System.out.println("input: " + clean);
                    System.out.println("output: " + output);
                } else {
                    System.out.println(output);
                }
            }
        }
    }

    private static void usage(int status) {
        System.out.print("""
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
""");
        if (status != 0) System.exit(status);
    }

    private static final class MatcherCompat {
        static String replacement(String separator) {
            // Group 1 is the matched unit. Quote only the separator so $ and \\ in
            // a user supplied separator cannot be interpreted by replaceAll().
            return java.util.regex.Matcher.quoteReplacement(separator) + "$1";
        }
    }
}
