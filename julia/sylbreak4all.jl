#!/usr/bin/env julia

const MY = "က-အ"
const EN = "a-zA-Z0-9"
const SS = "္"
const ATHAT = "်"
const OTHER = "ဣဤဥဦဧဩဪဿ၌၍၎၏၀-၉႐-႙၊။!-/:-@\\[-`’“”{-~\\s…"
const SH = "ၵၶငၸသၺတထၼပၽၾမယရလဝႁဢၹၷႀၻၿ"
const OTHER_SH = "႟႐-႙၊။!-/:-@\\[-`{-~\\s"
const SK = "ကခဂဃငစဆဇညတထဒနပဖဘမယရလဝသဟအဧ"
const OTHER_SK = "ဒမၡဧ၀-၉၊။!-/:-@\\[(-`{-~\\s"
const OTHER_PK = "ၥၦၡဧ၀-၉၊။!-/:-@\\[(-`{-~\\s"
const MO = "ကခဂဃၚစဆဇၛဉညဋဌဍဎဏတထဒဓနပဖဗဘမယရလဝသဟဠၜအၝ"

const PATTERNS = Dict(
    "bm" => Regex("((?<!$SS)[$MY](?![$ATHAT$SS])|[$EN$OTHER])"),
    "rk" => Regex("((?<!$SS)[$MY](?![$ATHAT$SS])|[$EN$OTHER])"),
    "dw" => Regex("((?<!$SS)[$MY](?![$ATHAT$SS])|[$EN$OTHER])"),
    "bk" => Regex("((?<!$SS)[$MY](?![$ATHAT$SS])|[$EN$OTHER])"),
    "po" => Regex("((?<!$SS)[$MY](?![$ATHAT$SS])|[$EN$OTHER])"),
    "sh" => Regex("([$SH](?![$ATHAT])|[$EN$OTHER_SH])"),
    "sk" => Regex("([$SK]|[$EN$OTHER_SK])"),
    "pk" => Regex("([$MY]|[$EN$OTHER_PK])"),
    "mo" => Regex("((?<!$SS)[$MY$MO](?![$ATHAT$SS])|[$EN$OTHER])")
)

function usage()
    println("""Syllable Breaker Tool
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
""")
end

function parse_args(args)
    input = nothing
    lang = "bm"
    sep = "|"
    print_input = false
    i = 1

    while i <= length(args)
        a = args[i]

        if a in ("-i", "--input", "--input-file")
            i += 1
            i <= length(args) || error("Missing argument for $a")
            input = args[i]

        elseif a in ("-l", "--language", "--lang")
            i += 1
            i <= length(args) || error("Missing argument for $a")
            lang = args[i]

        elseif a in ("-s", "--separator")
            i += 1
            i <= length(args) || error("Missing argument for $a")
            sep = args[i]

        elseif a in ("-p", "--print")
            print_input = true

        elseif a in ("-h", "--help")
            usage()
            exit(0)

        else
            error("Unknown argument: $a")
        end

        i += 1
    end

    return input, lang, sep, print_input
end

input_file, lang, sep, print_input = parse_args(ARGS)

# Julia uses `haskey`, not `has_key`.
haskey(PATTERNS, lang) || error("Unsupported language: $lang")

pattern = PATTERNS[lang]

io = input_file === nothing ? stdin : open(input_file, "r")

try
    for raw in eachline(io)
        clean = replace(raw, r"\s+" => "")

        output = replace(clean, pattern => (m -> sep * m))
        output = replace(output, r"^\s+|\s+$" => "")

        if print_input
            println("input: ", clean)
            println("output: ", output)
        else
            println(output)
        end
    end
finally
    input_file === nothing || close(io)
end

