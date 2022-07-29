# Vérification complétude / redondance données


# Librairies
packages = c("tidyverse", "jsonlite", "glue", "parallel", "doParallel", "foreach", "assertr")
package.check <- lapply(
  packages,
  FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
      library(x, character.only = TRUE)
    }
  }
)


# Import bases 2020
bso_data <- fromJSON("data/2.interim/subjson_BSO/unnested_bso_2020.json", flatten = TRUE)

# As.character des colonnes car format liste initialement
bso_data[,1:ncol(bso_data)] <- sapply(bso_data[,1:ncol(bso_data)], as.character)

# On remplace les "NULL" par des NA
bso_data <- bso_data %>% replace(.=="NULL", NA)



        ###----- Valeurs manquantes


# Volume et part NA par variable
nb_NA <- as.data.frame(apply(is.na(bso_data), 2, sum)) %>% 
                       rename(`nombre de NA` = `apply(is.na(bso_data), 2, sum)`) %>%
                       mutate(pourcentage = `nombre de NA`/nrow(bso_data)*100) %>% 
                       mutate(pourcentage = round(pourcentage, 2)) %>% 
                       arrange(desc(pourcentage))


# Valeurs + occurrences pour variables avec bcp NA
system("jq -c '.coi' data/1.raw/BSO/jsonl/study-apc_2020.jsonl |sort |uniq -c |sort -nr > data/1.raw/values_coi.txt")
system("jq -c '.currency_apc_doaj' data/1.raw/BSO/jsonl/study-apc_2020.jsonl |sort |uniq -c |sort -nr > data/1.raw/values_currency_apc_doaj.txt")




        ###----- Redondance


# check redondance entre 2 colonnes
identical(bso_data$doi, bso_data$id) # oui
identical(bso_data$author_useful_rank_countries, bso_data$detected_countries) # non
identical(bso_data$genre, bso_data$genre_raw) # non 


# check des colonnes Date
    # extract year de 'publication_date' et 'published_date'
bso_data <- bso_data %>% mutate(publication_date_YYYY = substr(publication_date, 1, 4),
                                published_date_YYYY = substr(published_date, 1, 4))
    # occurrences 
table(bso_data$publication_date_YYYY)
table(bso_data$published_date_YYYY)

# CONCLUSION :
  # - publication_year = YYYY de publication_date
  # - year = YYYY de published_date




        ###----- is_oa over time


# Import oa_details database
oa_details <- fromJSON("data/2.interim/subjson_BSO/oa_details_bso_2020.json", flatten = TRUE)

# On remplace les "NULL" par des NA
oa_details <- oa_details %>% replace(.=="NULL", NA)

# On garde les colonnes avec l'info 'is_oa'
is_oa_details <- oa_details %>% select(doi, oa_details.2018.is_oa, oa_details.2019.is_oa, oa_details.2020.is_oa, oa_details.2021Q4.is_oa)

# Différence entre les colonnes ?
  # 2018 vs others
identical(oa_details$oa_details.2018.is_oa, oa_details$oa_details.2019.is_oa) # non identiques
identical(oa_details$oa_details.2018.is_oa, oa_details$oa_details.2020.is_oa) # non
identical(oa_details$oa_details.2018.is_oa, oa_details$oa_details.2021Q4.is_oa) # non
  # 2019 vs others
identical(oa_details$oa_details.2019.is_oa, oa_details$oa_details.2020.is_oa) # non
identical(oa_details$oa_details.2019.is_oa, oa_details$oa_details.2021Q4.is_oa) # non
  # 2020 vs other
identical(oa_details$oa_details.2020.is_oa, oa_details$oa_details.2021Q4.is_oa) # non



        ###----- name in author and affiliation object


authors <- fromJSON("data/2.interim/subjson_BSO/authors_bso_2020.json", flatten = TRUE)
affiliations <- fromJSON("data/2.interim/subjson_BSO/affiliations_bso_2020.json", flatten = TRUE)

# test idem
identical(authors$name, affiliations$name) # non identiques

