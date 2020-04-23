#------------------------------------------------------
# Script to check species names, just raw string check
# using rocc, to install:
# remotes::install_github("saramortara/rocc")
#------------------------------------------------------

# loading packages
library(rocc)
library(dplyr)

# loading data
tax <- read.csv("results/02_taxon_data_raw.csv")

# 1. using rocc::check_string() ####
check <- check_string(scientificName = tax$scientificName)

table(check$scientificName_status)

# vamos ficar com: possibly_ok, subspecies, variety, name_w_authors, name_w_non_ascii
fica <- c("possibly_ok",
          "subspecies",
          "variety",
          "name_w_authors",
          "name_w_wrong_case")

checar <- c("name_w_non_ascii",
            "not_Genus_epithet_format",
            "not_name_has_digits")

# 2. checking fields ####
## name_w_non_ascii
## remove Não identificada
tax %>% filter(check$scientificName_status %in% checar[1])

## not_Genus_epithet_format
## too much
#tax %>% filter(check$scientificName_status %in% checar[2])

## not_name_has_digits
tax %>% filter(check$scientificName_status %in% checar[3]) # ok

check$check_ok <- "fora"
check$check_ok[check$scientificName_status %in% c(fica, checar[-2])] <- "ok"
check$check_ok[check$scientificName_status %in% checar[1] &
                 check$scientificName == "Não identificada"] <- "fora"
check$check_ok[check$scientificName_status %in% "not_Genus_epithet_format"] <- "checar"

table(check$check_ok)

# e agora juntando com o objeto inicial
tax_check <- cbind(tax, check[, -1])

# exportando os dados depois do check
write.csv(tax_check,
          file = "results/03_taxon_data_raw_check.csv",
          row.names = FALSE)
