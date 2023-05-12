library(tidyverse)
library(jsonlite)

## last version enwiki-20230501-cirrussearch-content.json

###### separate the wiki dump into chunked Rdata files

# f = function(x, pos){
#   filename = paste("chunks/chunk_", pos, ".RData", sep="")
#   save(x, file = filename)
# }
#
# read_lines_chunked(file = 'enwiki-20230501-cirrussearch-content.json', chunk_size = 100000, callback = SideEffectChunkCallback$new(f))


###### split the files into folders for easier analysis

# ## Create the folders
# FileList <- list.files("./chunks")
# FolderNumber = floor(0:length(FileList)/5) + 1
# for(f in unique(FolderNumber)) { dir.create(paste0("chunks-sorted/",f)) }
#
# ## Move the files
# for(i in 1:length(FileList)) {
#   file.copy(
#     from = paste0("./chunks/", FileList[i]),
#     to = paste0("chunks-sorted/", FolderNumber[i], "/", FileList[i]))}
#
# rm(f, FileList, FolderNumber, i)
