#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Getopt::Long qw(GetOptions);

binmode STDIN,  ":encoding(UTF-8)";
binmode STDOUT, ":encoding(UTF-8)";
binmode STDERR, ":encoding(UTF-8)";

my ($input_file, $language, $separator, $print_input, $help);
$language    = 'bm';
$separator   = '|';
$print_input = 0;

my $myConsonant = "က-အ";
my $enChar      = "a-zA-Z0-9";
my $ssSymbol    = "္";
my $aThat       = "်";
my $otherChar = "ဣဤဥဦဧဩဪဿ၌၍၎၏၀-၉႐-႙၊။!-\/:-\@\[-`’“”{-~\\s…";
my $shConsonant = "ၵၶငၸသၺတထၼပၽၾမယရလဝႁဢၹၷႀၻၿ";
my $otherShChar = "႟႐-႙၊။!-\\/:\\@\\[-`{-~\\s";
my $skConsonant = "ကခဂဃငစဆဇညတထဒနပဖဘမယရလဝသဟအဧ";
my $otherSkChar = "ဒမၡဧ၀-၉၊။!-\\/:\\@\\[(-`{-~\\s";
my $otherPkChar = "ၥၦၡဧ၀-၉၊။!-\\/:\\@\\[(-`{-~\\s";
my $moConsonant = "ကခဂဃၚစဆဇၛဉညဋဌဍဎဏတထဒဓနပဖဗဘမယရလဝသဟဠၜအၝ";

my %pattern = (
    bm => "((?<!$ssSymbol)[$myConsonant](?![$aThat$ssSymbol])|[$enChar$otherChar])",
    rk => "((?<!$ssSymbol)[$myConsonant](?![$aThat$ssSymbol])|[$enChar$otherChar])",
    dw => "((?<!$ssSymbol)[$myConsonant](?![$aThat$ssSymbol])|[$enChar$otherChar])",
    bk => "((?<!$ssSymbol)[$myConsonant](?![$aThat$ssSymbol])|[$enChar$otherChar])",
    po => "((?<!$ssSymbol)[$myConsonant](?![$aThat$ssSymbol])|[$enChar$otherChar])",
    sh => "([$shConsonant](?![$aThat])|[$enChar$otherShChar])",
    sk => "([$skConsonant]|[$enChar$otherSkChar])",
    pk => "([$myConsonant]|[$enChar$otherPkChar])",
    mo => "((?<!$ssSymbol)[$moConsonant](?![$aThat$ssSymbol])|[$enChar$otherChar])",
);

GetOptions(
    'input-file|input|i=s' => \$input_file,
    'language|lang|l=s'    => \$language,
    'separator|s=s'       => \$separator,
    'print|p'              => \$print_input,
    'help|h'               => \$help,
) or usage(1);

usage(0) if $help;
usage(1, "Unsupported language: $language") unless exists $pattern{$language};

my $fh;
if (defined $input_file) {
    open($fh, '<:encoding(UTF-8)', $input_file)
        or die "Could not open file '$input_file': $!\n";
} else {
    $fh = *STDIN;
}

while (my $line = <$fh>) {
    chomp $line;
    $line =~ s/\s+//g;
    my $output = $line;
    $output =~ s/($pattern{$language})/$separator$1/g;
    $output =~ s/^\s+|\s+$//g;

    if ($print_input) {
        print "input: $line\n";
        print "output: $output\n";
    } else {
        print "$output\n";
    }
}

close($fh) if defined $input_file;
exit 0;

sub usage {
    my ($status, $message) = @_;
    print STDERR "$message\n\n" if defined $message;
    print <<'EOF';
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
EOF
    exit($status);
}
