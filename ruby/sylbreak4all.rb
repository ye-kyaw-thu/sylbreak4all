#!/usr/bin/env ruby
# frozen_string_literal: true
# encoding: UTF-8

require 'optparse'

MY_CONSONANT = 'က-အ'
EN_CHAR = 'a-zA-Z0-9'
SS = '္'
ATHAT = '်'
OTHER = 'ဣဤဥဦဧဩဪဿ၌၍၎၏၀-၉႐-႙၊။!-/:-@\\[-`’“”{-~\\s…'
SH = 'ၵၶငၸသၺတထၼပၽၾမယရလဝႁဢၹၷႀၻၿ'
OTHER_SH = '႟႐-႙၊။!-/:-@\\[-`{-~\\s'
SK = 'ကခဂဃငစဆဇညတထဒနပဖဘမယရလဝသဟအဧ'
OTHER_SK = 'ဒမၡဧ၀-၉၊။!-/:-@\\[(-`{-~\\s'.delete(' ')
OTHER_PK = 'ၥၦၡဧ၀-၉၊။!-/:-@\\[(-`{-~\\s'.delete(' ')
MO = 'ကခဂဃၚစဆဇၛဉညဋဌဍဎဏတထဒဓနပဖဗဘမယရလဝသဟဠၜအၝ'

PATTERNS = {
  'bm' => /((?<!#{SS})[#{MY_CONSONANT}](?![#{ATHAT}#{SS}])|[#{EN_CHAR}#{OTHER}])/,
  'rk' => /((?<!#{SS})[#{MY_CONSONANT}](?![#{ATHAT}#{SS}])|[#{EN_CHAR}#{OTHER}])/,
  'dw' => /((?<!#{SS})[#{MY_CONSONANT}](?![#{ATHAT}#{SS}])|[#{EN_CHAR}#{OTHER}])/,
  'bk' => /((?<!#{SS})[#{MY_CONSONANT}](?![#{ATHAT}#{SS}])|[#{EN_CHAR}#{OTHER}])/,
  'po' => /((?<!#{SS})[#{MY_CONSONANT}](?![#{ATHAT}#{SS}])|[#{EN_CHAR}#{OTHER}])/, 
  'sh' => /([#{SH}](?![#{ATHAT}])|[#{EN_CHAR}#{OTHER_SH}])/,
  'sk' => /([#{SK}]|[#{EN_CHAR}#{OTHER_SK}])/,
  'pk' => /([#{MY_CONSONANT}]|[#{EN_CHAR}#{OTHER_PK}])/,
  'mo' => /((?<!#{SS})[#{MO}](?![#{ATHAT}#{SS}])|[#{EN_CHAR}#{OTHER}])/,
}

HELP_TEXT = <<~TEXT
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
TEXT

options = { language: 'bm', separator: '|', print_input: false, input: nil }
args = ARGV.dup
i = 0
while i < args.length
  case args[i]
  when '-h', '--help'
    puts HELP_TEXT
    exit 0
  when '-i', '--input', '--input-file'
    i += 1; options[:input] = args[i] or abort 'Missing value for -i/--input-file'
  when '-l', '--language', '--lang'
    i += 1; options[:language] = args[i] or abort 'Missing value for -l/--language'
  when '-s', '--separator'
    i += 1; options[:separator] = args[i] or abort 'Missing value for -s/--separator'
  when '-p', '--print'
    options[:print_input] = true
  else
    warn "Unknown argument: #{args[i]}"
    puts HELP_TEXT
    exit 1
  end
  i += 1
end


pattern = PATTERNS[options[:language]]
abort "Unsupported language: #{options[:language]}" unless pattern

input = options[:input] ? File.open(options[:input], 'r:UTF-8') : $stdin
begin
  input.each_line do |line|
    line = line.chomp
    clean = line.gsub(/\s+/, '')
    output = clean.gsub(pattern) { |match| options[:separator] + match }
    output = output.gsub(/^\s+|\s+$/, "")
    if options[:print_input]
      puts "input: #{clean}"
      puts "output: #{output}"
    else
      puts output
    end
  end
ensure
  input.close if options[:input]
end
