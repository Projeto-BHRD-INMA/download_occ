# First we will download species that occur in the municipalities inside the BHRD

# install package rocc
# remotes::install_github("saramortara/rocc")

library(rocc)
library(rgdal)
library(tools)

# 1. loading shapefile w/ municipalities of the BHRD ####
muni <- readOGR("data/munic_BHRD/munic_BHRD.shp", encoding = "UTF-8")
nomes_muni <- data.frame(muni = toTitleCase(as.character(muni@data$NOMEMUNICP)),
                         uf = toTitleCase(as.character(muni@data$NOMEUF)))

# converting again to character :P
nomes_muni$muni <- as.character(nomes_muni$muni)
nomes_muni$uf <- as.character(nomes_muni$uf)
# creating names to print in files' name
## removing ' from Pingo D'Agua
nomes_muni$muni <- gsub("'", " ", nomes_muni$muni)
## creating vector for filename
nomes_muni$muni2 <- gsub(" ", "_", nomes_muni$muni)
nomes_muni$uf2 <- ifelse(nomes_muni$uf == "MINAS GERAIS", "MG", "ES")

# 2. using rspeciesLink function ####
sp_muni <- list()

for (i in 1:nrow(nomes_muni)) {
  sp_muni[[i]] <- rspeciesLink(dir = "results/splink_raw/",
                               filename = paste(nomes_muni$muni2[i],
                                                nomes_muni$uf2[i],
                                                sep = "_"),
                               county = nomes_muni$muni[i],
                               stateProvince = nomes_muni$uf[i],
                               Scope = "plants")
}

# alguns vazios e vem indet
