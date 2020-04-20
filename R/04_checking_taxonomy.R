# Script to check taxonomy

# Check routine:
# get synonyms from Flora 2020
# 1. Flora 2020
# 2. Kew - World Checklist of Vascular Plants
# 3. TNRS - Taxonomic Name Resolution Service

library(dplyr)
library(flora)
library(rocc)

# reading file

tax <- read.csv("results/03_taxon_data_raw_check.csv", as.is = TRUE)

head(tax)

tax_ok <- filter(tax, check_ok == "ok")
tax_check <- filter(tax, check_ok == "checar")

table(tax$check_ok)

scientificName <- unique(tax_ok$scientificName_new)[1]
#scientificName <- unique(tax_check$scientificName_new)

teste <- suggest_bfg(scientificName)
