# Script to check taxonomy

# Check routine:
# get synonyms from Flora 2020
# 1. Flora 2020
# 2. Kew - World Checklist of Vascular Plants
# 3. TNRS - Taxonomic Name Resolution Service

# Synonym check in flora's api
## example for one species
scientificName <- "Myrcia splendens"
name <- gsub(" ", "%20", scientificName)
api <- "http://servicos.jbrj.gov.br/flora/taxon/"
res <- jsonlite::fromJSON(paste0(api, name))
if (!is.null(res$result$SINONIMO)) {
  sin.df <- res$result$SINONIMO[[1]]
}
# so os nomes
sin.df$scientificname
