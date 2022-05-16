### 2è partie des sélection / création / transformation de variables
## Intégration des données externes : Web of Science, OpenAlex et QOAM



        ###----- DIRECTORIES & LIBRARIES  


# Dossier où sont les inputs
in_dir <- "data/4.process/managing-variables"

# Nouveau dossier pour les outputs
out_dir <- "data/4.process/managing-variables_2nd-part"
#system(glue("mkdir {out_dir}"))

# Librairies
packages = c("tidyverse", "data.table", "summarytools", "kableExtra", "knitr", "jsonlite", "purrr", "glue", "readxl")
package.check <- lapply(
  packages,
  FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
      library(x, character.only = TRUE)    }  })
#devtools::install_github("JorisChau/rrapply")
library(rrapply)




                            #############
                            #### WOS #### 
                            #############



        ###----- Pre-processing WOS data


# Import données (qui ont subi un premier traitement sur python pour ne garder que les affiliations des auteurs correspondants : CA --> voir script wos_sample_parsing.ipynb)
rbindlist_fread <- function(path, pattern = "*.csv") {
    files = list.files(path, pattern, full.names = TRUE)
    rbindlist(lapply(files, function(x) fread(x)))
}
wos <- rbindlist_fread("data/3.external/WebofScience/output_python/")


# Nettoyage des données : 1 même DOI présent dans plusieurs notices du WOS, parfois avec un CA, parfois sans
    # on retire les doublons
wos <- wos %>% distinct()
    # on retire les "unknown" quand un CA est connu
wos <- wos %>% group_by(doi) %>% mutate(n = n()) %>% filter(country_eta != "unknown_by_WOS" | country_eta == "unknown_by_WOS" & n == 1)


# Création des variables (tous les auteurs listés sont des CA !!!)
wos <- wos %>% group_by(doi) %>% mutate(is_french_CA_wos = case_when(any(country_eta == "France") ~ 1,
                                                                     country_eta != "unknown_by_WOS" & all(country_eta != "France") ~ 0),
                                        is_non_french_CA_wos = case_when(country_eta != "unknown_by_WOS" & any(country_eta != "France") ~ 1,
                                                                         all(country_eta == "France") ~ 0))

# On remplace les NA par "unknown by WOS" pour garder cette info dans les nouvelles variables
wos <- wos %>% mutate(is_french_CA_wos = as.character(is_french_CA_wos),
                      is_non_french_CA_wos = as.character(is_non_french_CA_wos)) %>% replace(is.na(.), "unknown_by_WOS")

# Checks
wos %>% filter(is_french_CA_wos == "unknown_by_WOS") %>% nrow()
wos %>% filter(is_non_french_CA_wos == "unknown_by_WOS") %>% nrow()
wos %>% filter(country_eta == "unknown_by_WOS") %>% nrow() # correspondent bien, 32282
# Machens, Christian K. : auteur with french and portugal affiliation



        ###----- Jointure avec les données du BSO


    ## 1) Jointure pour les 8 années confondues

# Import whole BSO
whole_bso <- read_csv(glue("{in_dir}/whole_bso.csv"))

# Jointure
whole_bso <- left_join(whole_bso, unique(wos[,c(1,6,7)]), by = "doi")

# Nombre d'articles
whole_bso %>% filter(is_french_CA_wos == 1 & is_non_french_CA_wos == 1) %>% nrow() #50.003
whole_bso %>% filter(is_french_CA_wos == 1 & is_non_french_CA_wos == 0) %>% nrow() #338.207
whole_bso %>% filter(is_french_CA_wos == 0 & is_non_french_CA_wos == 1) %>% nrow() #223.608
whole_bso %>% filter(is_french_CA_wos == "unknown_by_WOS") %>% nrow() #23.156, soit 2.24% des articles

# Nombre de valeurs manquantes
whole_bso %>% filter(is.na(is_french_CA_wos)) %>% nrow() #397.543, soit 61.5% de valeurs connues pour le WOS
whole_bso %>% filter(is.na(is_non_french_CA_wos)) %>% nrow() #397.543

# Export
rio::export(whole_bso, glue("{out_dir}/whole_bso.csv"))


    ## 2) Jointure par année

# Fonction
jointure_wos_bso <- function(year){
    
    # Import BSO
    data <- read_csv(glue("{in_dir}/final_bso_{year}.csv"))
    
    # Jointure
    data <- left_join(data, unique(wos[,c(1,6,7)]), by = "doi")
    
    # Export
    rio::export(data, glue("{out_dir}/final_bso_{year}.csv"))
    
}

# On applique la fonction aux 8 années
jointure_wos_bso(2013)
jointure_wos_bso(2014)
jointure_wos_bso(2015)
jointure_wos_bso(2016)
jointure_wos_bso(2017)
jointure_wos_bso(2018)
jointure_wos_bso(2019)
jointure_wos_bso(2020)




                            ############################
                            #### OPENALEX : AUTHORS #### 
                            ############################



        ###----- Appels API Open Alex


# Import données du BSO
whole_bso <- read_csv(glue("{out_dir}/whole_bso.csv"))

# Échantillon de DOIs à checker sur OpenAlex
    # pas d'informations sur French CA (ni du BSO ni du WOS)
dois_bso <- whole_bso %>% filter(is.na(is_french_CA) & (is.na(is_french_CA_wos) | is_french_CA_wos == "unknown_by_WOS"))


# Fonction pour extraire les données OpenAlex
parse_api_open_alex <- function(start, end){
    
    # Import des données : Works dataset, appels de l'API
    works_data <- purrr::map(
        .x = dois_bso[start:end,]$doi,
        .y = data.frame(matrix(ncol = 1, nrow = 1)),
        possibly(.f = ~fromJSON(txt = paste("https://api.openalex.org/works/mailto:diane@datactivist.coop/doi:", .x, sep = ""), flatten = T), otherwise = NA_character_),
        .default = NA)
    
    # Aplatissement
        # sélection des 2 variables qui nous intéressent
    works_df <- purrr::map(
        .x = works_data,
        .y = data.frame(matrix(ncol = 1, nrow = 1)),
        possibly(.f = ~unnest(data.frame(    # on récupère chaque élément/variable qui nous intéresse, on les met dans un df
                       doi = .x$doi, 
                       .x$authorships),
                   cols = "institutions", names_repair = "universal") %>% select(doi, country_code), otherwise = NA_character_), 
        .default = NA)
        # suppression des NA et mise au format tabulaire
    works_df <- works_df[works_df != "NA"] # replace NA (DOIs non matchés avec OpenAlex) by NULL
    works_df <- rrapply(works_df, condition = Negate(is.null), how = "prune") #remove NULL
    works_df <- works_df %>% bind_rows()
    
    # Export du df
    rio::export(works_df, glue("data/3.external/OpenAlex/french_CA/API_{start}_{end}.csv"))

}


### On applique la fonction par 50.000 DOIs (~1h15 pour 10.000 appels)
parse_api_open_alex(1,50000)
parse_api_open_alex(50001,100000)
parse_api_open_alex(100001,150000)
parse_api_open_alex(150001,200000)
parse_api_open_alex(200001,250000)
parse_api_open_alex(250001,298750)  # ~ 33 heures pour 298.750 DOIs





        ###----- Processing OpenAlex data


# Import données OpenAlex
rbindlist_fread <- function(path, pattern = "*.csv") {
    files = list.files(path, pattern, full.names = TRUE)
    rbindlist(lapply(files, function(x) fread(x)))
}
openalex <- rbindlist_fread("data/3.external/OpenAlex/french_CA") %>% replace(. == "", NA)  # 91.993 DOIs

# Création de la variable is_french_CA (ici liste de tous les auteurs)
openalex <- openalex %>% group_by(doi) %>% mutate(is_french_CA_openalex = case_when(all(country_code == "FR") ~ 1,
                                                                                    all(!is.na(country_code)) & all(country_code != "FR") ~ 0)) %>% ungroup()

# On retire le lien avant le DOI
openalex <- openalex %>% mutate(doi = str_replace_all(doi, "https://doi.org/", ""))





        ###----- Jointure avec les données du BSO


    ## 1) Jointure pour les 8 années confondues

# Import whole BSO
whole_bso <- read_csv(glue("{out_dir}/whole_bso.csv"))

# Jointure
whole_bso <- left_join(whole_bso, unique(openalex[,c(1,3)]), by = "doi")

# Export
rio::export(whole_bso, glue("{out_dir}/whole_bso.csv"))


    ## 2) Jointure par année

# Fonction
jointure_openalex_bso <- function(year){
    
    # Import BSO
    data <- read_csv(glue("{out_dir}/final_bso_{year}.csv"))
    
    # Jointure
    data <- left_join(data, unique(openalex[,c(1,3)]), by = "doi")
    
    # Export
    rio::export(data, glue("{out_dir}/final_bso_{year}.csv"))
    
}

# On applique la fonction aux 8 années
jointure_openalex_bso(2013)
jointure_openalex_bso(2014)
jointure_openalex_bso(2015)
jointure_openalex_bso(2016)
jointure_openalex_bso(2017)
jointure_openalex_bso(2018)
jointure_openalex_bso(2019)
jointure_openalex_bso(2020)







                            ############################
                            #### OPENALEX : HAS_APC #### 
                            ############################




# Import données du BSO
whole_bso <- read_csv(glue("{out_dir}/whole_bso.csv"))

# Échantillon de DOIs à checker sur OpenAlex : has_apc == 1
dois_bso <- whole_bso %>% filter(has_apc == 1) %>% select(doi) %>% 
    mutate(group = c(rep(1:5570, each = 50), rep(5571, each = 7))) %>%  # on créé un indice fictif qui compte tous les 50 DOIs
    group_by(group) %>% mutate(doi = paste0(doi, collapse = "|")) %>% ungroup() %>% unique()  #on colle les DOIs par indice séparés par "|" --> pour récupérer 50 DOIs par appel, et non 1 par appel

# Fonction pour extraire les données OpenAlex
parse_api_open_alex <- function(start, end){
    
    # Import des données : Works dataset, appels de l'API
    works_data <- purrr::map(
        .x = dois_bso[start:end,]$doi,
        .y = data.frame(matrix(ncol = 1, nrow = 1)),
        possibly(.f = ~fromJSON(txt = paste("https://api.openalex.org/works?per_page=50&filter=doi:", .x, sep = ""), flatten = T), otherwise = NA_character_),
        .default = NA)
    
    # Aplatissement
        # sélection des 2 variables qui nous intéressent
    works_df <- purrr::map(
        .x = works_data,
        .y = data.frame(matrix(ncol = 1, nrow = 1)),
        possibly(.f = ~data.frame(    # on récupère chaque élément/variable qui nous intéresse, on les met dans un df
                       doi = .x$results$doi, 
                       oa_color_openalex = .x$results$open_access.oa_status), otherwise = NA_character_), 
        .default = NA)
        # suppression des NA et mise au format tabulaire
    works_df <- works_df[works_df != "NA"] # replace NA (DOIs non matchés avec OpenAlex) by NULL
    works_df <- rrapply(works_df, condition = Negate(is.null), how = "prune") #remove NULL
    works_df <- works_df %>% bind_rows()
    
    # Export du df
    rio::export(works_df, glue("data/3.external/OpenAlex/has_apc/API_{start}_{end}.csv"))

}


# On applique la fonction par 1000*50 = 50.000 DOIs
parse_api_open_alex(1,1000)
parse_api_open_alex(1001,2000)
parse_api_open_alex(2001,3000)
parse_api_open_alex(3001,4000)
parse_api_open_alex(4001,5000)
parse_api_open_alex(5001,5571)  # ~ 4 heures pour 278.507 DOIs





        ###----- Processing OpenAlex data


# Import données OpenAlex
rbindlist_fread <- function(path, pattern = "*.csv") {
    files = list.files(path, pattern, full.names = TRUE)
    rbindlist(lapply(files, function(x) fread(x)))
}
openalex <- rbindlist_fread("data/3.external/OpenAlex/has_apc") %>% replace(. == "", NA) %>% na.omit() %>% unique() %>% rename(oa_color_openalex = oa_status_openalex) 
n_distinct(openalex$doi) # 271.300 DOIs

# Création de la variable apc_has_been_paid
openalex <- openalex %>% mutate(apc_has_been_paid = case_when(oa_color_openalex == "gold" | oa_color_openalex == "hybrid" ~ 1,
                                                             TRUE ~ 0))

# On retire le lien avant le DOI
openalex <- openalex %>% mutate(doi = str_replace_all(doi, "https://doi.org/", ""))





        ###----- Jointure avec les données du BSO


    ## 1) Jointure pour les 8 années confondues

# Import whole BSO
whole_bso <- read_csv(glue("{out_dir}/whole_bso.csv"))

# Jointure
whole_bso <- left_join(whole_bso, openalex, by = "doi")

# Export
rio::export(whole_bso, glue("{out_dir}/whole_bso.csv"))


    ## 2) Jointure par année

# Fonction
jointure_openalex_bso <- function(year){
    
    # Import BSO
    data <- read_csv(glue("{out_dir}/final_bso_{year}.csv"))
    
    # Jointure
    data <- left_join(data, openalex, by = "doi")
    
    # Export
    rio::export(data, glue("{out_dir}/final_bso_{year}.csv"))
    
}

# On applique la fonction aux 8 années
jointure_openalex_bso(2013)
jointure_openalex_bso(2014)
jointure_openalex_bso(2015)
jointure_openalex_bso(2016)
jointure_openalex_bso(2017)
jointure_openalex_bso(2018)
jointure_openalex_bso(2019)
jointure_openalex_bso(2020)








                            ###################
                            #### QOAM DATA #### 
                            ###################






        ###----- Processing QOAM data


# Import données QOAM
qoam <- read_excel("data/3.external/QOAM journal list.xlsx") # 44.637 ISSNs

# Création de la variable journal_color_qoam
qoam <- qoam %>% mutate(journal_color_qoam = case_when(`Open Access` == "No" ~ "hybrid",
                                                       `Open Access` == "Yes" & `No-Fee Journal` == "Yes" ~ "diamond",
                                                       `Open Access` == "Yes" & `No-Fee Journal` == "No" ~ "gold")) %>% select(1, 2, 11, 12, 17)



        ###----- Jointure avec les données du BSO


    ## 1) Jointure pour les 8 années confondues

# Import whole BSO
whole_bso <- read_csv(glue("{out_dir}/whole_bso.csv"))

# Split journal_issns column 
whole_bso <- whole_bso %>% mutate(journal_issns = strsplit(as.character(journal_issns), ",")) %>% unnest(journal_issns)

# Join with QOAM data by ISSNs
whole_bso <- left_join(whole_bso, unique(qoam[,c(2,5)]), by = c("journal_issns" = "ISSN"), na_matches = "never") #740.423 articles, 19.123 journals

# Join with QOAM data by journal title
  # creation journal title variable: toupper and without special characters to improve matching
whole_bso <- whole_bso %>% mutate(journal_name_upper = toupper(journal_name))
whole_bso <- data.table::data.table(whole_bso)
whole_bso[, journal_name_upper := stringi::stri_trans_general (str = journal_name_upper, id = "Latin-ASCII")]
  # idem for QOAM data
qoam <- qoam %>% mutate(journal_name_upper = toupper(IF))
qoam <- data.table::data.table(qoam)
qoam[, journal_name_upper := stringi::stri_trans_general (str = journal_name_upper, id = "Latin-ASCII")]
  # join
whole_bso <- left_join(whole_bso, qoam[,c(5,6)], by = "journal_name_upper", na_matches = "never") %>% # 389.073 articles en plus, 10.596 journals
  select(-49)  #remove journal_name_upper 

# Merge and remove intermediate columns
whole_bso <- whole_bso %>% 
    mutate(journal_color_qoam = coalesce(journal_color_qoam.x, journal_color_qoam.y)) %>% 
    select(-c(journal_color_qoam.x, journal_color_qoam.y))
    
# Unsplit values
whole_bso <- whole_bso %>% group_by(doi) %>% 
  mutate(journal_issns = paste0(unique(na.omit(journal_issns)), collapse = ","),
         journal_color_qoam = paste0(unique(na.omit(journal_color_qoam)), collapse = ","),
         journal_color_qoam = str_replace_all(journal_color_qoam, c("diamond,gold|diamond,hybrid" = "diamond",
                                                                    "gold,diamond|gold,hybrid" = "gold",
                                                                    "hybrid,diamond|hybrid,gold" = "hybrid"))) %>% 
  replace(. == "", NA) %>% distinct() %>% ungroup()

# Export
rio::export(whole_bso, glue("{out_dir}/whole_bso.csv"))



    ## 2) Jointure par année

# Fonction
jointure_qoam_bso <- function(year){
    
    # Import BSO
    data <- read_csv(glue("{out_dir}/final_bso_{year}.csv"))
    
    # Split journal_issns column 
    data <- data %>% mutate(journal_issns = strsplit(as.character(journal_issns), ",")) %>% unnest(journal_issns)
    
    # Join with QOAM data by ISSNs
    data <- left_join(data, unique(qoam[,c(2,5)]), by = c("journal_issns" = "ISSN"), na_matches = "never")
    
    # Join with QOAM data by journal title
      # creation journal title variable toupper and without special characters to improve mathcing
    data <- data %>% mutate(journal_name_upper = toupper(journal_name))
    data <- data.table::data.table(data)
    data[, journal_name_upper := stringi::stri_trans_general (str = journal_name_upper, id = "Latin-ASCII")]
      # idem for QOAM data
    qoam <- qoam %>% mutate(journal_name_upper = toupper(IF))
    qoam <- data.table::data.table(qoam)
    qoam[, journal_name_upper := stringi::stri_trans_general (str = journal_name_upper, id = "Latin-ASCII")]
      # join
    data <- left_join(data, qoam[,c(5,6)], by = "journal_name_upper", na_matches = "never") %>% 
      select(-49)  #remove journal_name_upper 
    
    # Merge and remove intermediate columns
    data <- data %>% 
        mutate(journal_color_qoam = coalesce(journal_color_qoam.x, journal_color_qoam.y)) %>% 
        select(-c(journal_color_qoam.x, journal_color_qoam.y))
        
    # Unsplit values
    data <- data %>% group_by(doi) %>% 
      mutate(journal_issns = paste0(unique(na.omit(journal_issns)), collapse = ","),
             journal_color_qoam = paste0(unique(na.omit(journal_color_qoam)), collapse = ","),
             journal_color_qoam = str_replace_all(journal_color_qoam, c("diamond,gold|diamond,hybrid" = "diamond",
                                                                        "gold,diamond|gold,hybrid" = "gold",
                                                                        "hybrid,diamond|hybrid,gold" = "hybrid"))) %>% 
      replace(. == "", NA) %>% distinct() %>% ungroup()
    
    # Export
    rio::export(data, glue("{out_dir}/final_bso_{year}.csv"))
    
}

# On applique la fonction aux 8 années
jointure_qoam_bso(2013)
jointure_qoam_bso(2014)
jointure_qoam_bso(2015)
jointure_qoam_bso(2016)
jointure_qoam_bso(2017)
jointure_qoam_bso(2018)
jointure_qoam_bso(2019)
jointure_qoam_bso(2020)









                            ##############################
                            #### BSO : FINALES MODIFS #### 
                            ##############################







    ## 1) Gestion des variables pour les 8 années confondues

# Import whole BSO
whole_bso <- read_csv(glue("{out_dir}/whole_bso.csv"))

# Regroupement des catégories oa_details du BSO
whole_bso <- whole_bso %>% mutate(oa_color_article_BSO = str_replace_all(oa_details.2020.oa_colors_with_priority_to_publisher, "green_only|other|closed", "subscription"))

# Combinaison des variables sur le French CA
whole_bso <- whole_bso %>% replace(. == "unknown_by_WOS", NA) %>% 
  mutate(is_french_CA_bso_wos = case_when(is_french_CA == "1" | is_french_CA_wos == "1" ~ "1",
                                          (is_french_CA_wos == "0" & (is_french_CA != "1" | is.na(is_french_CA))) | (is_french_CA == "0" & (is_french_CA_wos != "1" | is.na(is_french_CA_wos))) ~ "0"),
         is_french_CA_bso_wos_openalex = case_when(is_french_CA_bso_wos == "1" | (is.na(is_french_CA_bso_wos) & is_french_CA_openalex == "1") ~ "1",
                                                   is_french_CA_bso_wos == "0" | (is.na(is_french_CA_bso_wos) & is_french_CA_openalex == "0") ~ "0"),
         is_french_CA_bso_wos_openalex_single = case_when(is_french_CA_bso_wos_openalex == "1" | (is.na(is_french_CA_bso_wos_openalex) & nb_authors == 1) ~ "1",
                                                              is_french_CA_bso_wos_openalex == "0" ~ "0"),
         is_french_CA_bso_wos_openalex_single_lang = case_when(is_french_CA_bso_wos_openalex_single == "1" | (is.na(is_french_CA_bso_wos_openalex_single) & lang == "fr") ~ "1",
                                                                   is_french_CA_bso_wos_openalex_single == "0" ~ "0"))
                
# Export
rio::export(whole_bso, glue("{out_dir}/whole_bso.csv"))




    ## 2) Jointure par année

# Fonction
modifs_bso <- function(year){
    
    # Import BSO
    data <- read_csv(glue("{out_dir}/final_bso_{year}.csv"))
    
    # Regroupement catégories oa_details from BSO
    data <- data %>% mutate(oa_color_article_BSO = str_replace_all(oa_details.2020.oa_colors_with_priority_to_publisher, "green_only|other|closed", "subscription"))
    
    # Combinaison des variables sur le French CA
    data <- data %>% replace(. == "unknown_by_WOS", NA) %>% 
      mutate(is_french_CA_bso_wos = case_when(is_french_CA == "1" | is_french_CA_wos == "1" ~ "1",
                                              (is_french_CA_wos == "0" & (is_french_CA != "1" | is.na(is_french_CA))) | (is_french_CA == "0" & (is_french_CA_wos != "1" | is.na(is_french_CA_wos))) ~ "0"),
             is_french_CA_bso_wos_openalex = case_when(is_french_CA_bso_wos == "1" | (is.na(is_french_CA_bso_wos) & is_french_CA_openalex == "1") ~ "1",
                                                       is_french_CA_bso_wos == "0" | (is.na(is_french_CA_bso_wos) & is_french_CA_openalex == "0") ~ "0"),
             is_french_CA_bso_wos_openalex_single = case_when(is_french_CA_bso_wos_openalex == "1" | (is.na(is_french_CA_bso_wos_openalex) & nb_authors == 1) ~ "1",
                                                              is_french_CA_bso_wos_openalex == "0" ~ "0"),
             is_french_CA_bso_wos_openalex_single_lang = case_when(is_french_CA_bso_wos_openalex_single == "1" | (is.na(is_french_CA_bso_wos_openalex_single) & lang == "fr") ~ "1",
                                                                   is_french_CA_bso_wos_openalex_single == "0" ~ "0"))
        
    # Export
    rio::export(data, glue("{out_dir}/final_bso_{year}.csv"))
    
}

# On applique la fonction aux 8 années
modifs_bso(2013)
modifs_bso(2014)
modifs_bso(2015)
modifs_bso(2016)
modifs_bso(2017)
modifs_bso(2018)
modifs_bso(2019)
modifs_bso(2020)




