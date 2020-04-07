# Combining all records in a single table

library(data.table)
library(tools)
library(dplyr)

# loading files
file_names <- list.files("results/splink_raw", full.names = TRUE)
all_files <- lapply(file_names, fread)

# creating the single table
full_data <- rbindlist(all_files, fill = TRUE)

# checking iff all rows were added
#sum(sapply(all_files, nrow))
#nrow(full_data)

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
          file = "./results/03_taxon_data_raw.csv",
          row.names = FALSE)
