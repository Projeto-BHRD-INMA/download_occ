# Script to test taxonomy before downloading data

# loading packages
library(taxize)
library(flora)
library(stringr)

# loading data
tax <- read.csv("results/03_taxon_data_raw.csv")

head(tax)

a <- str_split(tax$genus, " ")
b <- str_split(tax$specificEpithet, " ")
sum(sapply(a, length) > 1)
gen_check <- a[sapply(a, length) > 1]
sp_check <- b[sapply(b, length) > 1]
gen_check

head(a)

tax[23, ]

species <- unique(tax$scientificName)[1:200]

# 1. Flora Check ####
flora <- get.taxa(species)

table(flora$taxon.status)

flora[is.na(flora$taxon.status), ]
flora[23, ]

species[23]

