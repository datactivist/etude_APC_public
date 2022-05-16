# Installation et/ou chargement des packages
packages = c("tidyverse", "jsonlite", "glue", "parallel", "doParallel", "foreach")
package.check <- lapply(
  packages,
  FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
      library(x, character.only = TRUE)
    }
  }
)


# Nouveau dossier pour les sous json
out_dir <- "data/2.interim/subjson_BSO"
#system(glue("mkdir {out_dir}"))

# Dossier où sont les inputs
in_dir <- "data/1.raw/BSO/jsonl"


# Fonction traitements from .jsonl to tabular
subjson_bso <- function(year) {
    
            #### Création d'une sous-base pour les objets non imbriqués
    system(glue("cat {in_dir}/study-apc_{year}.jsonl | jq -c '{{doi, year, bso_classification, coi, datasource, detected_countries, domains, genre, grants, has_grant, id, is_paratext, journal_issn_l, journal_issns, journal_name, journal_title, keywords, lang, mesh_headings, pmid, publication_date, publication_year, published_date, publisher, sources, title, title_first_author, title_first_author_raw, url, has_apc, currency_apc_doaj, amount_apc_EUR, apc_source, amount_apc_doaj_EUR, amount_apc_doaj, amount_apc_openapc_EUR, count_apc_openapc_key, publisher_in_bealls_list, journal_or_publisher_in_bealls_list, publisher_normalized, publisher_group, publisher_dissemination, genre_raw, french_affiliations_types, author_useful_rank_fr, author_useful_rank_countries, observation_dates, has_coi, bso_local_affiliations, hal_id}}' | jq --slurp > {out_dir}/unnested_bso_{year}.json"))
    
  
            #### Création de sous-bases pour les objets imbriqués
    
    ## AUTHORS -----------------------------------
    
    # On converti le JSONL en JSON pour mettre flatten=TRUE à l'import
    system(glue("cat {in_dir}/study-apc_{year}.jsonl | jq -c '{{doi, year, authors}}' | jq --slurp > {out_dir}/authors_bso_{year}.json"))
    
    # Import
    authors_bso <- jsonlite::fromJSON(glue("{out_dir}/authors_bso_{year}.json"), flatten = TRUE)
        # unnest si pas déjà le cas
    if (ncol(authors_bso) == 3) {
    authors_bso <- authors_bso %>% unnest(cols = "authors", names_repair = "universal")
    }
    
    # Export
    rio::export(authors_bso, glue("{out_dir}/authors_bso_{year}.json"))
    
    
    ## BSSO_CLASSIFICATION -----------------------------------
    
    # On converti en json
    system(glue("cat {in_dir}/study-apc_{year}.jsonl | jq -c '{{doi, year, bsso_classification}}' | jq --slurp > {out_dir}/bsso-classif_bso_{year}.json"))
    
    
    ## OA_DETAILS -----------------------------------
    
    # On converti en json
    system(glue("cat {in_dir}/study-apc_{year}.jsonl | jq -c '{{doi, year, oa_details}}' | jq --slurp > {out_dir}/oa-details_bso_{year}.json"))
    
    
    ## AFFILIATIONS -----------------------------------
    
    # On converti en json
    system(glue("cat {in_dir}/study-apc_{year}.jsonl | jq -c '{{doi, year, affiliations}}' | jq --slurp > {out_dir}/affiliations_bso_{year}.json"))
    
    # Import
    affiliations_bso <- jsonlite::fromJSON(glue("{out_dir}/affiliations_bso_{year}.json"), flatten = TRUE)
        # unnest si pas déjà le cas
    if (ncol(affiliations_bso) == 3) {
    affiliations_bso <- affiliations_bso %>% unnest(cols = "affiliations", names_repair = "universal")
    }
    
    # Export
    rio::export(affiliations_bso, glue("{out_dir}/affiliations_bso_{year}.json"))

    
        ###----------------------- Check qu'on a le bon nombre d'observations par année

    n <- system(glue("jq length {out_dir}/unnested_bso_{year}.json"))
    assign(glue("n_{year}"), n, envir = .GlobalEnv)
}





### On applique la fonction aux différentes années

years <- 2013:2020

numCores <- 2
registerDoParallel(numCores)

foreach (year=years) %dopar% {
  subjson_bso(year)
}

stopImplicitCluster()


