required <- c("WikidataQueryServiceR", "tidyverse", "magrittr", "tools")
lapply(required, require, character.only = TRUE)

options(readr.show_col_types = FALSE)
options(dplyr.summarise.inform = FALSE)

source("R/query function.R")

films("fs/P2889 - QID.sparql",
      query_wikidata("
        SELECT (COUNT(*) as ?cnt)
        WHERE {?item wdt:P2889 ?o}"))


rm(required)
