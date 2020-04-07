# Checking empty outputs from rspeciesLink function

library(data.table)
library(stringr)

# which ones are empty?
file_names <- list.files("results/splink_raw", full.names = TRUE)
all_files <- lapply(file_names, fread)

id <- which(sapply(all_files, nrow) == 1)

empty <- file_names[id]

# testando selecionar todos os municipios que tem são no nome
sao <- file_names[str_detect(file_names, "SAO_")]

sao %in% empty # alguns sim, outros não. não é problema do acento!

# teste de busca de um municippio vazio com acento
teste <- rspeciesLink(county = "Capitão Andrade",
                      stateProvince = "MG",
                      Scope = "plants")

# apagando o arquivo
unlink("results/output.csv")
