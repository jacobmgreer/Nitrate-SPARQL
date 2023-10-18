films <-
  function(file, count) {
    QueryData <- NULL
    for (i in 1:ceiling(as.numeric(count) / 50000)) {
      QueryData <-
        bind_rows(QueryData,
                  query_wikidata(
                    sprintf(read_file(paste0("SPARQL/", file)),
                            format((i-1) * 50000, scientific = F))))
      message(paste("Film Details:", file, i, "/", ceiling(as.numeric(count) / 50000)))
    }
    QueryData <-
      QueryData %>%
      mutate(item = basename(item)) %>%
      rename(QID = item)

    assign(gsub( " .*$", "", file), QueryData, envir = .GlobalEnv)
    write.csv(QueryData, paste0("output/", file_path_sans_ext(file), ".csv"), row.names = FALSE)
  }
