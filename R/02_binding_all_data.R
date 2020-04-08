#----------------------------------------------------
# Script to check downloaded files and bind all data
## Checking common errors in species names
## Binding all data and exporting file
#----------------------------------------------------

library(data.table)
library(stringr)
library(tools)
library(dplyr)

# which ones are empty?
file_names <- list.files("results/splink_raw", full.names = TRUE)
all_files <- lapply(file_names, fread)

id <- which(sapply(all_files, nrow) == 1)

empty <- file_names[id]

# testando selecionar todos os municipios que tem são no nome
sao <- file_names[str_detect(file_names, "SAO_")]

sao %in% empty # alguns sim, outros não. não é problema do acento!

# teste de busca de um municipio vazio com acento
# teste <- rspeciesLink(county = "Capitão Andrade",
#                       stateProvince = "MG",
#                       Scope = "plants")
#
# # apagando o arquivo
# unlink("results/output.csv")

# Combining all records in a single table, except empty ones
id1 <- which(sapply(all_files, nrow) != 1)
data_filenames <- file_names[id1]
data_files <- lapply(data_filenames, fread)

# creating the single table
full_data <- rbindlist(data_files, fill = TRUE)

# removing rows without complete species names
# removing records with NA in genus or epithet
clean_data <- full_data[!is.na(full_data$genus)
                        & !is.na(full_data$specificEpithet), ]
# removing records with "sp" or "sp." in specificEpithet
clean_data <- clean_data[!clean_data$specificEpithet %in% c("sp", "sp."), ]

# creating smaller table, with only taxonomic data
# probably need more info here, but will come back later
clean_taxon_data <- clean_data[, c("kingdom", "phylum",
                                   "order", "family",
                                   "genus", "specificEpithet",
                                   "scientificName", "scientificNameAuthorship")]

plants <- clean_taxon_data[clean_taxon_data$kingdom %in% "Plantae", ]

# excluding duplicated names
plants_nodup <- plants[!duplicated(plants), ]
plants_nodup$id_name <- paste("name",
                              sprintf("%05d", 1:nrow(plants_nodup)),
                              sep = "_")

# write outputs
write.csv(plants_nodup,
          file = "./results/02_taxon_data_raw.csv",
          row.names = FALSE)
