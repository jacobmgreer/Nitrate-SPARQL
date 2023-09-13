library(WikidataQueryServiceR)
library(tidyverse)
library(jsonlite)
library(magrittr)

options(readr.show_col_types = FALSE)

GetIMDbCount <-
  as.numeric(query_wikidata("SELECT (COUNT(*) as ?cnt) WHERE {?s wdt:P345 ?o}"))
IMDbPasses <- ceiling(GetIMDbCount / 50000)

WikiData.Films <- NULL

for (i in 1:IMDbPasses) {
  WikiData.Films <- bind_rows(WikiData.Films,
                              query_wikidata(paste("
        SELECT ?work ?imdb
        WHERE {
          ?work wdt:P345 ?imdb.
        }
        LIMIT 50000 OFFSET ",
        format((i-1) * 50000, scientific = F))
  ))
  #Sys.sleep(5)
}

WikiData.Films <- WikiData.Films %>% distinct()

WikiData.IMDBDistinct <- WikiData.Films %>% distinct(imdb, .keep_all = TRUE)

rm(i, IMDbPasses)

