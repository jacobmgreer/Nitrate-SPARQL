required <- c("WikidataQueryServiceR", "tidyverse", "magrittr")
lapply(required, require, character.only = TRUE)

options(readr.show_col_types = FALSE)

QueryData <- NULL
QID.IMDB <- as.numeric(query_wikidata("SELECT (COUNT(*) as ?cnt) WHERE {?s wdt:P345 ?o}"))

for (i in 1:ceiling(QID.IMDB / 47000)) {
  QueryData <-
    bind_rows(QueryData,
              query_wikidata(
                sprintf(read_file('SPARQL/P345.sparql'), format((i-1) * 47000, scientific = F))
                )
              )

  message(paste("SPARQL", i))
}

QueryData <-
  QueryData %>%
  rename(QID=work) %>%
  mutate(QID = basename(QID)) %>%
  distinct()

QID.IMDbCO <-
  QueryData %>% filter(grepl("^co", imdb)) %T>%
  write.csv(., file = "output/wikidata-imdb-companies.csv", row.names = FALSE)
QID.IMDbNM <-
  QueryData %>% filter(grepl("^nm", imdb)) %T>%
  write.csv(., file = "output/wikidata-imdb-names.csv", row.names = FALSE)
QID.IMDbTT <-
  QueryData %>% filter(grepl("^tt", imdb)) %T>%
  write.csv(., file = "output/wikidata-imdb-films.csv", row.names = FALSE)

rm(i, required)
