<?php

declare(strict_types=1);

$options = getopt("i:s:l:ph", [
    "input-file:", "input:", "separator:", "language:", "lang:", "print", "help"
]);

$inputFile = $options['i'] ?? $options['input-file'] ?? $options['input'] ?? null;
$separator = $options['s'] ?? $options['separator'] ?? "|";
$language = $options['l'] ?? $options['language'] ?? $options['lang'] ?? "bm";
$printInput = isset($options['p']) || isset($options['print']);

$myConsonant = "က-အ";
$enChar = "a-zA-Z0-9";
$ssSymbol = "္";
$aThat = "်";
$otherChar = "ဣဤဥဦဧဩဪဿ၌၍၎၏၀-၉႐-႙၊။!-/:-@\\[-`’“”{-~\\s…";
$shConsonant = "ၵၶငၸသၺတထၼပၽၾမယရလဝႁဢၹၷႀၻၿ";
$otherShChar = "႟႐-႙၊။!-/:-@\\[-`{-~\\s";
$skConsonant = "ကခဂဃငစဆဇညတထဒနပဖဘမယရလဝသဟအဧ";
$otherSkChar = "ဒမၡဧ၀-၉၊။!-/:-@\\[(-`{-~\\s";
$otherPkChar = "ၥၦၡဧ၀-၉၊။!-/:-@\\[(-`{-~\\s";
$moConsonant = "ကခဂဃၚစဆဇၛဉညဋဌဍဎဏတထဒဓနပဖဗဘမယရလဝသဟဠၜအၝ";

$common = "#((?<!$ssSymbol)[$myConsonant](?![$aThat$ssSymbol])|[$enChar$otherChar])#u";
$patterns = [
    "bm" => $common,
    "rk" => $common,
    "dw" => $common,
    "bk" => $common,
    "po" => $common,
    "sh" => "#([$shConsonant](?![$aThat])|[$enChar$otherShChar])#u",
    "sk" => "#([$skConsonant]|[$enChar$otherSkChar])#u",
    "pk" => "#([$myConsonant]|[$enChar$otherPkChar])#u",
    "mo" => "#((?<!$ssSymbol)[$moConsonant](?![$aThat$ssSymbol])|[$enChar$otherChar])#u",
];

if (isset($options['h']) || isset($options['help'])) {
    usage(0);
}
if (!array_key_exists($language, $patterns)) {
    fwrite(STDERR, "Unsupported language: $language\n");
    usage(1);
}

$handle = $inputFile === null ? STDIN : fopen($inputFile, "rb");
if ($handle === false) {
    fwrite(STDERR, "Could not open file: $inputFile\n");
    exit(1);
}

while (($line = fgets($handle)) !== false) {
    $line = rtrim($line, "\r\n");
    $line = preg_replace('/\s+/u', '', $line) ?? $line;
    $output = preg_replace($patterns[$language], $separator . '$1', $line) ?? $line;
    $output = preg_replace('/^\s+|\s+$/u', '', $output) ?? $output;
    if ($printInput) {
        echo "input: $line\n";
        echo "output: $output\n";
    } else {
        echo $output . PHP_EOL;
    }
}

if ($inputFile !== null) {
    fclose($handle);
}

function usage(int $status): void
{
    $text = <<<'TXT'
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

TXT;
    echo $text;
    exit($status);
}
