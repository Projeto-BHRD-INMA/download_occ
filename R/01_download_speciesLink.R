# First we will download species that occur in the municipalities inside the BHRD

# install package rocc

#remotes::install_github("saramortara/rocc")

library(rocc)
library(rgdal)

# loading shapefile w/ municipalities
muni <- readOGR("data/munic_BHRD/munic_BHRD.shp")
nomes_muni <- data.frame(muni = as.character(muni@data$NOMEMUNICP),
                         uf = as.character(muni@data$NOMEUF))

# using rspeciesLink function
sp_muni <- list()

for (i in 1:10) {
  sp_muni[[i]] <- rspeciesLink(filename = paste(nomes_muni$muni[i],
                                                nomes_muni$uf[i],
                                                sep = "_"),
                               county = nomes_muni$muni[i],
                               stateProvince = nomes_muni$uf[i])
}
