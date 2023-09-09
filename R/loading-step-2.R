library(tidyverse)
library(jsonlite)

###### split the files into folders for easier analysis

## Create the folders
FileList <- list.files("./chunks")
FolderNumber = floor(0:length(FileList)/5) + 1
for(f in unique(FolderNumber)) { dir.create(paste0("chunks-sorted/",f)) }

## Move the files
for(i in 1:length(FileList)) {
  file.copy(
    from = paste0("./chunks/", FileList[i]),
    to = paste0("chunks-sorted/", FolderNumber[i], "/", FileList[i]))}

rm(FileList, FolderNumber, i)
