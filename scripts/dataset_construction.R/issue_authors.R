# Import raw data
bso_2013 <- readLines("data/1.raw/BSO/jsonl/study-apc_2013.jsonl") %>% lapply(RJSONIO::fromJSON)

# Extraction certaines infos
test <- purrr::map(
    .x = bso_2013,
    .y = data.frame(matrix(ncol = 13, nrow = 200)),
    .f = ~data.frame(    # on récupère chaque élément/variable qui nous intéresse, on les met dans un df
                   .x$authors$full_name),
    .default = NA)
test <- test %>% bind_rows()


#----------------


# Params
in_dir <- "data/1.raw/BSO/jsonl"
out_dir <- "data/2.interim/subjson_BSO"
year <- 2013


# Lignes de commande

    # Extract 'authors' nested object : 1
system(glue("cat {in_dir}/study-apc_{year}.jsonl | jq -c '{{doi, year, authors}}' | jq --slurp > {out_dir}/authors_bso_{year}.json"))

    # Import du JSON
authors_bso <- jsonlite::fromJSON(glue("{out_dir}/authors_bso_{year}.json"), flatten = TRUE)

    # unnest
unnest_authors_bso <- authors_bso %>% unnest(cols = "authors", names_repair = "universal")




#----------------


# Params
in_dir <- "data/1.raw/BSO/jsonl"
out_dir <- "data/2.interim/subjson_BSO"
year <- 2013


# Lignes de commande

    # Extract 'authors' nested object : 1
system(glue("cat {in_dir}/study-apc_{year}.jsonl | jq -c '{{doi, year, authors}}' | jq --slurp > {out_dir}/authors_bso_{year}.json"))

    # Import du JSON
authors_bso1 <- jsonlite::fromJSON(glue("{out_dir}/authors_bso_{year}.json"), flatten = TRUE) #282.698 authors, 32.999 DOIs
    # On exporte la liste des DOIs récupérés
dois1 <- authors_bso1 %>% select(doi) %>% distinct()  %>% mutate(doi = paste('"doi": "', doi, '"', sep = ""))
rio::export(dois1, glue("data/2.interim/apart_dois_authors/dois1_{year}.txt"), col.names=FALSE, quote = FALSE)
    # unnest
unnest_authors_bso1 <- authors_bso1 %>% unnest(cols = "authors", names_repair = "universal")


    # Extract 'authors' nested object : 2
system(glue("grep -F -v -f data/2.interim/apart_dois_authors/dois1_{year}.txt {in_dir}/study-apc_{year}.jsonl | jq -c '{{doi, year, authors}}' | jq --slurp > {out_dir}/authors2_bso_{year}.json")) #authors2
#grep -v -f data/2.interim/apart_dois_authors/dois1_2013.json data/1.raw/BSO/jsonl/study-apc_2013.jsonl | jq --slurp > data/2.interim/subjson_BSO/authors2_bso_2013.json
    # Import
authors_bso2 <- jsonlite::fromJSON(glue("{out_dir}/authors2_bso_{year}.json"), flatten = TRUE) # 109.754 DOIs et 3 vbles
    # Test qual data
setdiff()
unnest_authors_bso2 <- authors_bso2 %>% unnest(cols = "authors", names_repair = "universal") %>%  # 108.694 DOIs (différence 1.060 DOIs car NaN authors)
    unnest(cols = "affiliation", names_repair = "universal") #12.657 DOIs


# Check
system(glue("cat {in_dir}/study-apc_{year}.jsonl | jq -c '{{doi}}' | jq --slurp > {out_dir}/dois_bso_{year}.json"))













# censé avoir 1 is_at_least et NA pour is_french_CA (actuellement : 0)
    #10.1001/jama.2013.277165
    #10.1001/jama.2013.276300
    #10.1001/jamafacial.2013.326
    #10.1001/jamafacial.2013.335

#censé avoir NA is_at_least et NA pour is_french_CA (actuellement 0 et 0)
    #10.1002/ajh.23523
    #10.1002/ajim.22178

# doit rester en 0 et 0 (toutes aff mais aucune française)
    #10.1001/jama.2013.282043
    #10.1002/14651858.cd000332.pub3
    #10.1002/14651858.cd001792.pub3

#doit rester en 1 et 0 (toutes aff mais pas toutes françaises)
    #10.1001/jamaneurol.2013.698
    #10.1001/jamaoto.2013.4990
    #10.1002/0471142301.ns0704s63

#doit rester en 1 et 1 (toutes aff et toutes françaises)
    #10.1002/2012wr012940
    #10.1001/jamaophthalmol.2013.5297
    #10.1002/2013jd020867


#DOIs avec toutes les aff dans l'objet des auteurs et aucune française (is_at_least = 0), mais avec un detected_countries au niveau des articles qui a "fr" --> 33 articles en 2013
    #10.3389/fpls.2013.00038
    #10.1016/j.astropartphys.2013.09.004
    #10.3917/nras.064.0135