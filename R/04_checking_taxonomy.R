# Script to check taxonomy

# Check routine:
# get synonyms from Flora 2020
# 1. Flora 2020
# 2. Kew - World Checklist of Vascular Plants
# 3. TNRS - Taxonomic Name Resolution Service

library(dplyr)
library(flora)

# reading file

tax <- read.csv("results/03_taxon_data_raw_check.csv", as.is = TRUE)

head(tax)

tax_ok <- filter(tax, check_ok == "ok")
tax_check <- filter(tax, check_ok == "checar")

table(tax$check_ok)

scientificName <- unique(tax_ok$scientificName_new)[1:20]
#scientificName <- unique(tax_check$scientificName_new)

length(scientificName)

trim_sp <- flora::trim(scientificName)
suggest_sp <- sapply(trim_sp, flora::suggest.names)

search_flora <- function(x){
  api <- "http://servicos.jbrj.gov.br/flora/taxon/"
  search_sp <- gsub(" ", "%20", x)
  res <- jsonlite::fromJSON(paste0(api, x))
  return(res)
}

res_list <- lapply(suggest_sp, search_flora)

if (!is.null(res$result$SINONIMO)) {
  sin.df <- res$result$SINONIMO[[1]]
}
# so os nomes
sin.df$scientificname
