#!/usr/bin/env node
'use strict';

const fs = require('fs');
const readline = require('readline');

const myConsonant = 'က-အ';
const enChar = 'a-zA-Z0-9';
const ss = '္';
const athat = '်';
const other = 'ဣဤဥဦဧဩဪဿ၌၍၎၏၀-၉႐-႙၊။!-/:-@\\[-`’“”{-~\\s…';
const sh = 'ၵၶငၸသၺတထၼပၽၾမယရလဝႁဢၹၷႀၻၿ';
const otherSh = '႟႐-႙၊။!-/:-@\\[-`{-~\\s';
const sk = 'ကခဂဃငစဆဇညတထဒနပဖဘမယရလဝသဟအဧ';
const otherSk = 'ဒမၡဧ၀-၉၊။!-/:-@\\[(-`{-~\\s';
const otherPk = 'ၥၦၡဧ၀-၉၊။!-/:-@\\[(-`{-~\\s';
const mo = 'ကခဂဃၚစဆဇၛဉညဋဌဍဎဏတထဒဓနပဖဗဘမယရလဝသဟဠၜအၝ';

function compilePatterns() {
  const common = new RegExp(`((?<!${ss})[${myConsonant}](?![${athat}${ss}])|[${enChar}${other}])`, 'gu');
  return {
    bm: common,
    rk: new RegExp(common.source, 'gu'),
    dw: new RegExp(common.source, 'gu'),
    bk: new RegExp(common.source, 'gu'),
    po: new RegExp(common.source, 'gu'),
    sh: new RegExp(`([${sh}](?![${athat}])|[${enChar}${otherSh}])`, 'gu'),
    sk: new RegExp(`([${sk}]|[${enChar}${otherSk}])`, 'gu'),
    pk: new RegExp(`([${myConsonant}]|[${enChar}${otherPk}])`, 'gu'),
    mo: new RegExp(`((?<!${ss})[${mo}](?![${athat}${ss}])|[${enChar}${other}])`, 'gu')
  };
}

function segmentLine(line, pattern, separator) {
  const clean = line.replace(/\s+/gu, '');
  pattern.lastIndex = 0;
  const output = clean.replace(pattern, (_, match) => separator + match);
  return output.replace(/^\s+|\s+$/gu, "");
}

function usage(status = 0) {
  console.log(`Syllable Breaker Tool
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
    -h | --help         Show this help`);
  process.exit(status);
}

const args = process.argv.slice(2);
let inputFile = null;
let separator = '|';
let language = 'bm';
let printInput = false;

for (let i = 0; i < args.length; i++) {
  switch (args[i]) {
    case '-i': case '--input': case '--input-file': inputFile = args[++i]; break;
    case '-s': case '--separator': separator = args[++i]; break;
    case '-l': case '--language': language = args[++i]; break;
    case '-p': case '--print': printInput = true; break;
    case '-h': case '--help': usage(0); break;
    default: console.error(`Unknown argument: ${args[i]}`); usage(1);
  }
}

const patterns = compilePatterns();
if (!patterns[language]) {
  console.error(`Unsupported language: ${language}`);
  usage(1);
}

const input = inputFile ? fs.createReadStream(inputFile, { encoding: 'utf8' }) : process.stdin;
const reader = readline.createInterface({ input, crlfDelay: Infinity });

reader.on('line', (line) => {
  const clean = line.replace(/\s+/gu, '');
  const output = segmentLine(line, patterns[language], separator);
  if (printInput) {
    console.log(`input: ${clean}`);
    console.log(`output: ${output}`);
  } else {
    console.log(output);
  }
});
