segment_line <- function(line, pattern, separator) {
  line <- gsub("\\s+", "", line, perl = TRUE)
  gsub(pattern, paste0(separator, "\\1"), line, perl = TRUE)
}

patterns <- list(
  bm = "((?<!္)[က-အ](?![်္])|[a-zA-Z0-9ဣဤဥဦဧဩဪဿ၌၍၎၏၀-၉႐-႙၊။!-/:-@\\[-`’“”{-~\\s…])",
  rk = "((?<!္)[က-အ](?![်္])|[a-zA-Z0-9ဣဤဥဦဧဩဪဿ၌၍၎၏၀-၉႐-႙၊။!-/:-@\\[-`’“”{-~\\s…])",
  dw = "((?<!္)[က-အ](?![်္])|[a-zA-Z0-9ဣဤဥဦဧဩဪဿ၌၍၎၏၀-၉႐-႙၊။!-/:-@\\[-`’“”{-~\\s…])",
  bk = "((?<!္)[က-အ](?![်္])|[a-zA-Z0-9ဣဤဥဦဧဩဪဿ၌၍၎၏၀-၉႐-႙၊။!-/:-@\\[-`’“”{-~\\s…])",
  po = "((?<!္)[က-အ](?![်္])|[a-zA-Z0-9ဣဤဥဦဧဩဪဿ၌၍၎၏၀-၉႐-႙၊။!-/:-@\\[-`’“”{-~\\s…])",
  sh = "([ၵၶငၸသၺတထၼပၽၾမယရလဝႁဢၹၷႀၻၿ](?![်])|[a-zA-Z0-9႟႐-႙၊။!-/:-@\\[-`{-~\\s])",
  sk = "([ကခဂဃငစဆဇညတထဒနပဖဘမယရလဝသဟအဧ]|[a-zA-Z0-9ဒမၡဧ၀-၉၊။!-/:-@\\[(-`{-~\\s])",
  pk = "([က-အ]|[a-zA-Z0-9ၥၦၡဧ၀-၉၊။!-/:-@\\[(-`{-~\\s])",
  mo = "((?<!္)[ကခဂဃၚစဆဇၛဉညဋဌဍဎဏတထဒဓနပဖဗဘမယရလဝသဟဠၜအၝ](?![်္])|[a-zA-Z0-9ဣဤဥဦဧဩဪဿ၌၍၎၏၀-၉႐-႙၊။!-/:-@\\[-`’“”{-~\\s…])"
)

HELP_TEXT <- paste0(
  "Syllable Breaker Tool\n",
  "Version: 0.9.0\n\n",
  "Supported Languages:\n",
  "    bm  - Burmese\n",
  "    bk  - Beik\n",
  "    dw  - Dawei\n",
  "    rk  - Rakhine\n",
  "    mo  - Mon\n",
  "    po  - PaO\n",
  "    sh  - Shan\n",
  "    sk  - Sgaw Kayin\n",
  "    pk  - Pwo Kayin\n\n",
  "Usage: sylbreak4all [-i filename] [-l language] [-s separator] [-p]\n",
  "    -i | --input-file   Input file name (default: STDIN)\n",
  "    -s | --separator    Separator (default: '|')\n",
  "    -l | --language     Language (default: bm for Burmese)\n",
  "    -p | --print        Print input alongside the output (default: 0)\n",
  "    -h | --help         Show this help\n"
)

args <- commandArgs(trailingOnly = TRUE)
input_file <- NULL; language <- "bm"; separator <- "|"; print_input <- FALSE
idx <- 1
while (idx <= length(args)) {
  arg <- args[[idx]]
  if (arg %in% c("-h", "--help")) { cat(HELP_TEXT); quit(status = 0)
  } else if (arg %in% c("-i", "--input", "--input-file")) {
    idx <- idx + 1; if (idx > length(args)) stop("Missing value for -i/--input-file"); input_file <- args[[idx]]
  } else if (arg %in% c("-l", "--language", "--lang")) {
    idx <- idx + 1; if (idx > length(args)) stop("Missing value for -l/--language"); language <- args[[idx]]
  } else if (arg %in% c("-s", "--separator")) {
    idx <- idx + 1; if (idx > length(args)) stop("Missing value for -s/--separator"); separator <- args[[idx]]
  } else if (arg %in% c("-p", "--print")) { print_input <- TRUE
  } else { stop(paste("Unknown argument:", arg)) }
  idx <- idx + 1
}
if (!(language %in% names(patterns))) stop(paste("Unsupported language:", language))

con <- if (is.null(input_file)) file("stdin", "r", encoding = "UTF-8") else file(input_file, "r", encoding = "UTF-8")
while (TRUE) {
  line <- readLines(con, n = 1, warn = FALSE)
  if (length(line) == 0) break
  clean <- gsub("\\s+", "", line, perl = TRUE)
  output <- segment_line(line, patterns[[language]], separator)
  if (print_input) { cat("input: ", clean, "\n", sep = ""); cat("output: ", output, "\n", sep = "") }
  else cat(output, "\n", sep = "")
}
close(con)
