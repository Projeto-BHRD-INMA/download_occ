# Script to test taxonomy before downloading data
# Check taxonomy errors, synonyms at flora2020 and other databases

# using rocc, to install:
# remotes::install_github("saramortara/rocc")

# loading packages
library(rocc)

# loading data
tax <- read.csv("results/02_taxon_data_raw.csv")

check <- check_status(scientificName = tax$scientificName)

table(check$scientificName_status)

# vamos ficar com: possibly_ok, subspecies, variety, name_w_authors
check$check_ok <- ifelse(check$scientificName_status
                         %in% c("possibly_ok",
                                "subspecies",
                                "variety",
                                "name_w_authors"),
                         TRUE,
                         FALSE)

# e agora juntando com o objeto inicial
tax_check <- cbind(tax, check[, -1])

head(tax_check)

str(tax_check)

# exportando os dados depois do check
# write outputs
write.csv(tax_check,
          file = "results/03_taxon_data_raw_check.csv",
          row.names = FALSE)
