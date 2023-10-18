required <- c("WikidataQueryServiceR", "tidyverse", "magrittr", "tools")
lapply(required, require, character.only = TRUE)

options(readr.show_col_types = FALSE)

source("R/query function.R")

films("companies/P345 - imdb.sparql", 40000) ## capping this at 40000, since it's under
films("companies/P31 - company details.sparql", 40000) ## capping this at 40000, since it's under
films("companies/P17 - country.sparql", 40000) ## capping this at 40000, since it's under

rm(required)
