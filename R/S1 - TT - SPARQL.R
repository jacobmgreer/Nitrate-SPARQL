required <- c("WikidataQueryServiceR", "tidyverse", "magrittr", "tools")
lapply(required, require, character.only = TRUE)

options(readr.show_col_types = FALSE)

source("R/query function.R")

films("films/P345 - imdb.sparql",
      query_wikidata("
        SELECT (COUNT(*) as ?cnt)
        WHERE {?item wdt:P345 ?o}"))

films("films/P3056 - tcm.sparql",
      query_wikidata("
        SELECT (COUNT(*) as ?cnt)
        WHERE {?item wdt:P3056 ?o}"))

films("films/P2704 - eidr.sparql",
      query_wikidata("
        SELECT (COUNT(*) as ?cnt)
        WHERE {?item wdt:P2704 ?o}"))

films("films/Q11424 - films wo imdb.sparql",
      query_wikidata("
        SELECT (COUNT(*) as ?cnt)
        WHERE {
          ?i wdt:P31 wd:Q11424
          MINUS {?i wdt:P345 ?v.}}"))

# films("films/P57 - director.sparql",
#       query_wikidata("
#         SELECT (COUNT(*) as ?cnt)
#         WHERE {?item wdt:P57 ?o.}"))

# films("films/P495 - country.sparql",
#       query_wikidata("
#         SELECT (COUNT(*) as ?cnt)
#         WHERE {
#           ?i wdt:P31 wd:Q11424.
#           ?i wdt:P495 ?o.}"))

# films("films/P364 - language.sparql",
#       query_wikidata("
#         SELECT (COUNT(*) as ?cnt)
#         WHERE {
#           ?i wdt:P31 wd:Q11424.
#           ?i wdt:P364 ?o.}"))

rm(required)
