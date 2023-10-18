required <- c("tidyverse", "magrittr")
lapply(required, require, character.only = TRUE)

options(readr.show_col_types = FALSE)





QueryData2 <-
  read_csv("output/films/Q11424 - films wo imdb.csv") %>%
  left_join(title_basics_tsv %>%
              select(tconst, primaryTitle, originalTitle, isAdult, startYear),
            by=c("itemLabel" = "primaryTitle"),
            relationship = "many-to-many") %>%
  left_join(title_crew %>%
              select(tconst, directors),
            by=c("tconst"),
            relationship = "many-to-many") %>%
  left_join(name_basics_tsv %>%
              select(nconst, primaryName),
            by=c("directors" = "nconst"),
            relationship = "many-to-many") %>%
  filter(!is.na(tconst))

write.csv(QueryData2, "output/missing-imdb.csv", row.names = FALSE)

# left_join(title_basics_tsv %>%
#             select(tconst, originalTitle, startYear),
#           by=c("itemLabel" = "originalTitle"),
#           relationship = "many-to-many")

rm(required, title_basics_tsv, title_crew, name_basics_tsv)
