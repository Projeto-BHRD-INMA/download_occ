# Download species records
# get from each database, then merge final results

library(rocc)

# reading final species list
spp <- read.csv("results/03_taxon_data_raw_check.csv")

spnames <- as.character(unique(spp$scientificName))

records <- rspeciesLink(dir = "results/spp_records/",
                        filename = "records_specieslink",
                        scientificName = spnames,
                        Scope = "plants")
