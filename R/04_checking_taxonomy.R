# Script to check taxonomy

# Check routine:
# get synonyms from Flora 2020
# 1. Flora 2020
# 2. Kew - World Checklist of Vascular Plants
# 3. TNRS - Taxonomic Name Resolution Service

library(dplyr)
library(flora)
library(rocc)
library(parallel)

# reading file
tax <- read.csv("results/03_taxon_data_raw_check.csv", as.is = TRUE)

head(tax)

tax_ok <- tax %>% filter(check_ok == "ok")

scientificName <- unique(tax_ok$scientificName_new)
length(scientificName)

# 1. suggesting a name ####
# using parallel

# Calculate the number of cores
no_cores <- detectCores() - 1
# Initiate cluster
cl <- makeCluster(no_cores)

start_time <- Sys.time()
list_taxa <- parLapply(cl, scientificName, suggest_flora)
end_time <- Sys.time()

t1 <- end_time - start_time

stopCluster(cl)

suggest_taxa <- bind_rows(list_taxa)

search_taxa <- suggest_taxa$scientificName_suggest %>%
  unique() %>%
  na.omit()

search_df <- data.frame(scientificName_search = search_taxa,
                        search_id = 1:length(search_taxa))
# 2. checking if the name exists in Brazilian Flora ####

flora_taxa <- list()
for (i in 1:length(search_taxa)) {
  message(paste(i, "species"))
  flora_taxa[[i]] <- check_flora(search_taxa[i],
                                 get_synonyms = FALSE,
                                 infraspecies = TRUE)
}

length(flora_taxa)

flora_taxa2 <- lapply(flora_taxa, function(x) x[1]$taxon)

flora_df <- bind_rows(flora_taxa2)

head(flora_df)

table(flora_df$taxonomicstatus)

flora_df2 <- left_join(flora_df, search_df, by = "scientificName_search")

# writing output
write.csv(flora_df2,
          file = "results/04_taxon_data_flora_check.csv",
          row.names = FALSE)
