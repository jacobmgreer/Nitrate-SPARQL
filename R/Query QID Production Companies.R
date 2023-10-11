required <- c("WikidataQueryServiceR", "tidyverse", "magrittr")
lapply(required, require, character.only = TRUE)

options(readr.show_col_types = FALSE)

QueryData <-
  bind_rows(
    query_wikidata(sprintf(read_file('SPARQL/P31.prod.P17.sparql'), "Q11396960")),
    query_wikidata(sprintf(read_file('SPARQL/P31.prod.P17.sparql'), "Q1762059"))
  ) %>%
  bind_rows(.,
    query_wikidata(sprintf(read_file('SPARQL/P31.prod.P17.sparql'), "Q10689397"))) %>%
  rename(QID = item) %>%
  mutate(QID = basename(QID)) %>%
  distinct() %T>%
  write.csv(., file = "output/wikidata-companies-country.csv", row.names = FALSE)

QueryData <-
  query_wikidata(
    read_file('SPARQL/P31.prod.P345.sparql')
  ) %>%
  rename(QID = item) %>%
  mutate(QID = basename(QID)) %>%
  distinct() %T>%
  write.csv(., file = "output/wikidata-companies-imdb.csv", row.names = FALSE)

QueryData <-
  query_wikidata(
    read_file('SPARQL/P31.prod.sparql')
  ) %>%
  rename(QID = item) %>%
  mutate(QID = basename(QID)) %>%
  distinct() %T>%
  write.csv(., file = "output/wikidata-companies-QID.csv", row.names = FALSE)

rm(required)
