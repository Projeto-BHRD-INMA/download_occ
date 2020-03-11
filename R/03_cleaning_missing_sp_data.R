# Combining all records in a single table

library(data.table)

# loading files
file_names <- list.files("results/splink_raw", full.names = TRUE)
all_files <- lapply(file_names, fread)

# creating the single table
full_data <- rbindlist(all_files, fill = TRUE)

# checking iff all rows were added
#sum(sapply(all_files, nrow))
#nrow(full_data)

# removing rows without complete species names
clean_data <- full_data[!is.na(full_data$genus),]  # removing records with NA in genus
clean_data <- clean_data[!is.na(clean_data$specificEpithet),] # removing records with NA in specificEpithet
clean_data <- clean_data[which(clean_data$specificEpithet != "sp"),] # removing records with "sp" in specificEpithet
clean_data <- clean_data[which(clean_data$specificEpithet != "sp."),] # removing  records with "sp." in specificEpithet
clean_data$clean_id <- seq(1:nrow(clean_data)) # adding a new id

# creating smaller table, with only taxonomic data
# probably need more info here, but will come back later
clean_taxon_data <- clean_data[, c("clean_id", "kingdom", "phylum", "order", "family", "genus", "specificEpithet", "scientificName", "scientificNameAuthorship")]

# write outputs
write.csv(clean_data, file = "./results/clean_data.csv") # this generated a 104.6 MB file, exceeding github's limit
write.csv(clean_taxon_data, file = "./results/clean_taxon_data.csv")
