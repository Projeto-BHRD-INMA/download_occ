# Generating the list of species that occur in the BHRD 

Download and clean records of species that occur in the BHRD in steps:

- [x] Download from speciesLink all plant species that occurr in the municipalities inside the BHRD - `rocc::rspeciesLink()`

- [X] Check empty outputs

- [X] Check standard in scientific name string - `rocc::check_status()`

- [ ] Clean taxonomic names to generate list - synonyms and flora2020 (and other bases) 

- [ ] Download from speciesLink, jabot and gbif all records from species generated in step one 

- [ ] Taxonomic standardization

- [ ] Geographic cleaning - `CoordinateCleaner` and `plantR`
