#
# Clean_texts.R
#
# Keep ASCII
#
#

suppressPackageStartupMessages({
  library(dedslog)
  library(logger)
  library(cli)
  library(optigrab)
  library(rprojroot)
  library(jsonlite)
  library(tibble)
  library(dplyr)
  library(tidyr)
  library(purrr)
  library(readr)
  library(vroom)
  library(arrow)
  library(stringr)
})

root <- rprojroot::is_renv_project


# "R/lib_utils.R" |> root$find_file() |> source()

# options(dplyr.summarise.inform=FALSE)

#
# Logging
#

bDebug <- opt_get("debug", default = TRUE)

fileSelf <- this_file(full.path = FALSE)

if (is.na(fileSelf)) {
  log_appender(appender_console())
} else {
  fileLog <- fileSelf %>%
    basename() %>%
    paste0(".log")
  log_appender(appender_file(fileLog))
  info_glance(fileSelf)
}
if (bDebug) {
  log_threshold(DEBUG)
} else {
  log_threshold(INFO)
}
log_errors()
log_messages()
log_warnings()
info_log("START : %s -- %s", toJSON(fileSelf), R.version.string)
debug_log("... --debug")


#
# Params
#

fileOut <- opt_get("out", default = "cache/Clean_texts.txt")
info_glance(fileOut)

if (!is.na(fileSelf)) {
  fileLog = file.path("log", fileOut %>% basename() %>% paste0(".log"))
  info_glance(fileLog)

  log_appender(appender_file(fileLog))

  info_log("START : %s -- %s", toJSON(fileSelf), R.version.string)
  debug_log("... --debug")

  info_glance(fileOut)
  info_glance(fileLog)
}

fileIn <- opt_get("in", default = "data_in/fi_FI.twitter.txt")
info_glance(fileIn)


#
# Functions
#

Text_dirt <- function() {
  c(
    "\\N{REPLACEMENT CHARACTER}",
    "\\N{<private use area-E001>}",
    "\\N{<private use area-E002>}",
    "\\N{<private use area-E003>}",
    "\\N{<private use area-E004>}",
    "\\N{<private use area-E005>}",
    "\\N{<private use area-E009>}",
    "\\N{<private use area-E00A>}",
    "\\N{<private use area-E00C>}",
    "\\N{<private use area-E00D>}",
    "\\N{<private use area-E00E>}",
    "\\N{<private use area-E00F>}",
    "\\N{<private use area-E011>}",
    "\\N{<private use area-E018>}",
    "\\N{<private use area-E019>}",
    "\\N{<private use area-E01B>}",
    "\\N{<private use area-E01D>}",
    "\\N{<private use area-E022>}",
    "\\N{<private use area-E030>}",
    "\\N{<private use area-E033>}",
    "\\N{<private use area-E036>}",
    "\\N{<private use area-E037>}",
    "\\N{<private use area-E039>}",
    "\\N{<private use area-E03C>}",
    "\\N{<private use area-E040>}",
    "\\N{<private use area-E043>}",
    "\\N{<private use area-E044>}",
    "\\N{<private use area-E045>}",
    "\\N{<private use area-E046>}",
    "\\N{<private use area-E048>}",
    "\\N{<private use area-E049>}",
    "\\N{<private use area-E04A>}",
    "\\N{<private use area-E04B>}",
    "\\N{<private use area-E04C>}",
    "\\N{<private use area-E04E>}",
    "\\N{<private use area-E04F>}",
    "\\N{<private use area-E054>}",
    "\\N{<private use area-E056>}",
    "\\N{<private use area-E057>}",
    "\\N{<private use area-E058>}",
    "\\N{<private use area-E05A>}",
    "\\N{<private use area-E104>}",
    "\\N{<private use area-E105>}",
    "\\N{<private use area-E106>}",
    "\\N{<private use area-E107>}",
    "\\N{<private use area-E108>}",
    "\\N{<private use area-E10B>}",
    "\\N{<private use area-E110>}",
    "\\N{<private use area-E111>}",
    "\\N{<private use area-E112>}",
    "\\N{<private use area-E113>}",
    "\\N{<private use area-E118>}",
    "\\N{<private use area-E119>}",
    "\\N{<private use area-E11A>}",
    "\\N{<private use area-E11B>}",
    "\\N{<private use area-E11C>}",
    "\\N{<private use area-E11D>}",
    "\\N{<private use area-E120>}",
    "\\N{<private use area-E12A>}",
    "\\N{<private use area-E12F>}",
    "\\N{<private use area-E131>}",
    "\\N{<private use area-E132>}",
    "\\N{<private use area-E13A>}",
    "\\N{<private use area-E13C>}",
    "\\N{<private use area-E13D>}",
    "\\N{<private use area-E142>}",
    "\\N{<private use area-E145>}",
    "\\N{<private use area-E146>}",
    "\\N{<private use area-E14C>}",
    "\\N{<private use area-E155>}",
    "\\N{<private use area-E15A>}",
    "\\N{<private use area-E201>}",
    "\\N{<private use area-E22E>}",
    "\\N{<private use area-E234>}",
    "\\N{<private use area-E303>}",
    "\\N{<private use area-E304>}",
    "\\N{<private use area-E305>}",
    "\\N{<private use area-E306>}",
    "\\N{<private use area-E308>}",
    "\\N{<private use area-E30C>}",
    "\\N{<private use area-E30E>}",
    "\\N{<private use area-E30F>}",
    "\\N{<private use area-E310>}",
    "\\N{<private use area-E311>}",
    "\\N{<private use area-E312>}",
    "\\N{<private use area-E31D>}",
    "\\N{<private use area-E31E>}",
    "\\N{<private use area-E31F>}",
    "\\N{<private use area-E322>}",
    "\\N{<private use area-E324>}",
    "\\N{<private use area-E327>}",
    "\\N{<private use area-E328>}",
    "\\N{<private use area-E329>}",
    "\\N{<private use area-E32E>}",
    "\\N{<private use area-E337>}",
    "\\N{<private use area-E33A>}",
    "\\N{<private use area-E33B>}",
    "\\N{<private use area-E340>}",
    "\\N{<private use area-E341>}",
    "\\N{<private use area-E345>}",
    "\\N{<private use area-E347>}",
    "\\N{<private use area-E34B>}",
    "\\N{<private use area-E34D>}",
    "\\N{<private use area-E401>}",
    "\\N{<private use area-E402>}",
    "\\N{<private use area-E403>}",
    "\\N{<private use area-E404>}",
    "\\N{<private use area-E405>}",
    "\\N{<private use area-E406>}",
    "\\N{<private use area-E407>}",
    "\\N{<private use area-E408>}",
    "\\N{<private use area-E409>}",
    "\\N{<private use area-E40A>}",
    "\\N{<private use area-E40C>}",
    "\\N{<private use area-E40D>}",
    "\\N{<private use area-E40E>}",
    "\\N{<private use area-E40F>}",
    "\\N{<private use area-E410>}",
    "\\N{<private use area-E411>}",
    "\\N{<private use area-E412>}",
    "\\N{<private use area-E413>}",
    "\\N{<private use area-E414>}",
    "\\N{<private use area-E415>}",
    "\\N{<private use area-E416>}",
    "\\N{<private use area-E417>}",
    "\\N{<private use area-E418>}",
    "\\N{<private use area-E419>}",
    "\\N{<private use area-E41C>}",
    "\\N{<private use area-E41E>}",
    "\\N{<private use area-E41F>}",
    "\\N{<private use area-E420>}",
    "\\N{<private use area-E421>}",
    "\\N{<private use area-E423>}",
    "\\N{<private use area-E424>}",
    "\\N{<private use area-E426>}",
    "\\N{<private use area-E429>}",
    "\\N{<private use area-E42E>}",
    "\\N{<private use area-E430>}",
    "\\N{<private use area-E431>}",
    "\\N{<private use area-E432>}",
    "\\N{<private use area-E435>}",
    "\\N{<private use area-E437>}",
    "\\N{<private use area-E440>}",
    "\\N{<private use area-E444>}",
    "\\N{<private use area-E447>}",
    "\\N{<private use area-E448>}",
    "\\N{<private use area-E502>}",
    "\\N{<private use area-E50C>}",
    "\\N{<private use area-E50F>}",
    "\\N{<private use area-E512>}",
    "\\N{<private use area-E515>}",
    "\\N{<private use area-E516>}",
    "\\N{<private use area-E517>}",
    "\\N{<private use area-E518>}",
    "\\N{<private use area-E519>}",
    "\\N{<private use area-E51A>}",
    "\\N{<private use area-E51C>}",
    "\\N{<private use area-E51F>}",
    "\\N{<private use area-E520>}",
    "\\N{<private use area-E522>}",
    "\\N{<private use area-E523>}",
    "\\N{<private use area-E528>}",
    "\\N{<private use area-E52B>}",
    "\\N{<private use area-EF03>}",
    "\\N{<private use area-F04A>}",
    "\\N{<private use area-F49C>}",
    "\\N{<private use area-F60C>}",
    "\\N{<private use area-F620>}",
    "\\N{<private use area-F8FF>}",
    "\\N{<private use area-E007>}",
    "\\N{<private use area-E012>}",
    "\\N{<private use area-E017>}",
    "\\N{<private use area-E01C>}",
    "\\N{<private use area-E023>}",
    "\\N{<private use area-E028>}",
    "\\N{<private use area-E032>}",
    "\\N{<private use area-E035>}",
    "\\N{<private use area-E03D>}",
    "\\N{<private use area-E03E>}",
    "\\N{<private use area-E041>}",
    "\\N{<private use area-E047>}",
    "\\N{<private use area-E050>}",
    "\\N{<private use area-E052>}",
    "\\N{<private use area-E055>}",
    "\\N{<private use area-E059>}",
    "\\N{<private use area-E10C>}",
    "\\N{<private use area-E10F>}",
    "\\N{<private use area-E115>}",
    "\\N{<private use area-E122>}",
    "\\N{<private use area-E126>}",
    "\\N{<private use area-E129>}",
    "\\N{<private use area-E12B>}",
    "\\N{<private use area-E130>}",
    "\\N{<private use area-E134>}",
    "\\N{<private use area-E13B>}",
    "\\N{<private use area-E13E>}",
    "\\N{<private use area-E13F>}",
    "\\N{<private use area-E140>}",
    "\\N{<private use area-E141>}",
    "\\N{<private use area-E147>}",
    "\\N{<private use area-E148>}",
    "\\N{<private use area-E20A>}",
    "\\N{<private use area-E20C>}",
    "\\N{<private use area-E20D>}",
    "\\N{<private use area-E20E>}",
    "\\N{<private use area-E20F>}",
    "\\N{<private use area-E219>}",
    "\\N{<private use area-E230>}",
    "\\N{<private use area-E231>}",
    "\\N{<private use area-E251>}",
    "\\N{<private use area-E301>}",
    "\\N{<private use area-E307>}",
    "\\N{<private use area-E30A>}",
    "\\N{<private use area-E30B>}",
    "\\N{<private use area-E314>}",
    "\\N{<private use area-E316>}",
    "\\N{<private use area-E317>}",
    "\\N{<private use area-E326>}",
    "\\N{<private use area-E32A>}",
    "\\N{<private use area-E32B>}",
    "\\N{<private use area-E32C>}",
    "\\N{<private use area-E32D>}",
    "\\N{<private use area-E330>}",
    "\\N{<private use area-E331>}",
    "\\N{<private use area-E333>}",
    "\\N{<private use area-E335>}",
    "\\N{<private use area-E336>}",
    "\\N{<private use area-E339>}",
    "\\N{<private use area-E33F>}",
    "\\N{<private use area-E40B>}",
    "\\N{<private use area-E41D>}",
    "\\N{<private use area-E428>}",
    "\\N{<private use area-E42A>}",
    "\\N{<private use area-E43E>}",
    "\\N{<private use area-E443>}",
    "\\N{<private use area-E445>}",
    "\\N{<private use area-E44B>}",
    "\\N{<private use area-E44C>}",
    "\\N{<private use area-E503>}",
    "\\N{<private use area-E505>}",
    "\\N{<private use area-E50B>}",
    "\\N{<private use area-E50D>}",
    "\\N{<private use area-E50E>}",
    "\\N{<private use area-E521>}",
    "\\N{<private use area-E524>}",
    "\\N{<private use area-E52C>}"
  )
}

Clean_text <- function(v, additional = NULL) {

  v |>
    str_remove_all("\\p{Control}+") |>
    str_remove_all("\\p{Bidi_Control}+") |>
    str_remove_all("\\N{ZERO WIDTH SPACE}+") |>
    str_remove_all("\\N{COMBINING ENCLOSING KEYCAP}+") |>
    # ---
    str_replace_all("\\N{COMBINING CYRILLIC MILLIONS SIGN}+", " ") |>
    str_replace_all("\\p{Punctuation}+", " ") |>
    str_replace_all("\\p{Symbol}+", " ") |>
    str_replace_all("\\p{Control}+", " ") |>
    str_replace_all("\\p{Number}+", " ") |>
    str_replace_all("\\p{Math}+", " ") |>
    str_replace_all("\\p{Hyphen}+", " ") |>
    str_replace_all("\\p{Diacritic}+", " ") |>
    str_replace_all("\\p{Extended_Pictographic}+", " ") |>
    # ---
    str_squish() |>
    unique() |>
    sort()
}


#
# Body
#

# %% ---
"Leer {.file {fileIn}}" |>
  cli_h3()
#

v_lines <- fileIn |>
  root$find_file() |>
  vroom_lines()
info_desc(v_lines)

n_lines <- length(v_lines)

"{prettyNum(n_lines, decimal.mark=',', big.mark = '.')} lines" |>
  cli_alert_success()


# %% ---
"Calcular" |>
  cli_h3()
#

v_out <- v_lines |>
  Clean_text()
info_desc(v_out)

n_out <- length(v_out)

"{prettyNum(n_out, decimal.mark=',', big.mark = '.')} lines" |>
  cli_alert_success()


# %% ---
"Guardar {.file {fileOut}}" |>
  cli_h3()
#

write_lines(v_out, fileOut)


#
# ---
#

info_log("proc.time: {toString(proc.time())}")
info_log("gc.time: {toString(gc.time())}")
info_log("mem: {sum(gc()[,6])}")
info_log("STOP")
