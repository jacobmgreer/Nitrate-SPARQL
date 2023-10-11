required <- c("WikidataQueryServiceR", "tidyverse", "magrittr")
lapply(required, require, character.only = TRUE)

options(readr.show_col_types = FALSE)

QueryData <- NULL

for (i in 1:ceiling(as.numeric(query_wikidata("SELECT (COUNT(*) as ?cnt) WHERE {?s wdt:P2704 ?o}")) / 50000)) {
  QueryData <-
    bind_rows(QueryData,
              query_wikidata(
                sprintf(read_file('R/SPARQL/queries/P2704.sparql'), format((i-1) * 50000, scientific = F))
              )
    )

  message(paste("SPARQL",i))
}

QueryData <-
  QueryData %>%
  rename(QID=work) %>%
  mutate(QID = basename(QID)) %>%
  distinct() %T>%
  write.csv(., file = "output/SPARQL/wikidata-films-eidr.csv", row.names = FALSE)

rm(i, required)
