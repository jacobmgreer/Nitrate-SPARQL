library(tidyverse)
library(jsonlite)
library(magrittr)

##### Unpacking the RData json data

for (dir in 1:27) {
  WikiJson <- NULL

  for (i in list.files(paste0("output/chunks-sorted/", dir), "*.RData")) {
    WikiJson[[i]] <- get(load(paste0("output/chunks-sorted/", dir, "/", i)))
  }

  WikiJson <- WikiJson %>%
    enframe %>%
    unnest(cols = c(value)) %>%
    filter(!grepl('^\\{\"index\"', value)) %>%
    rowwise() %>%
    mutate(data = list(fromJSON(value))) %>%
    unnest_wider(data) %>%
    select(name, title, weighted_tags, wikibase_item, source_text, text, opening_text, external_link, text_bytes, popularity_score) %>%
    #filter(grepl("Culture.Media.Films",weighted_tags)) %>%
    filter(grepl("imdb.com/title/",external_link)) %>%
    rowwise %>%
    mutate_if(is.list, ~paste(unlist(.), collapse = '|')) %>%
    write.csv(., paste0("output/wiki-exports/film-list-", dir, ".csv"), row.names = FALSE)

  print(paste("Run", dir, "completed!"))
  rm(i, x, dir)
}

rm(WikiJson)

