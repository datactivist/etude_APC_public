### Variable sélection / création / transformation


# Librairies
packages = c("tidyverse", "jsonlite", "glue", "readxl", "data.table")
package.check <- lapply(
  packages,
  FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
      library(x, character.only = TRUE)
    }
  }
)



        ###----- DIRECTORIES 


# Dossier où sont les inputs
in_dir <- "data/2.interim/subjson_BSO"

# Nouveau dossier pour les outputs
out_dir <- "data/4.process/managing-variables"
#system(glue("mkdir {out_dir}"))



        ###----- EXTERNAL DATA


# DOAJ data : https://doaj.org/docs/public-data-dump/
doaj_data <- fromJSON("data/3.external/doaj_dump-data_journal.json", flatten = TRUE)
  # journaux sans ISSN ?
doaj_data %>% filter(is.na(bibjson.eissn) & is.na(bibjson.pissn)) %>% nrow()  #non, donc pas besoin de fuzzymatching sur le titre du journal
  # sélection de variables utiles
doaj_data <- doaj_data %>% mutate(is_in_doaj_data = 1) %>% select(bibjson.pissn, bibjson.eissn, is_in_doaj_data, bibjson.apc.has_apc) %>% distinct()


# Couperin data
    # import et sélection de variables
couperin_agreements <- read_excel("data/3.external/Couperin/Produits à categoriser_complétésVL_listes de titres.xlsx", sheet = "Listes titres") %>% select(c("Print ISNN", "E-ISSN", "REVUE"))
elsevier <- read_excel("data/3.external/Couperin/Produits à categoriser_complétésVL_listes de titres.xlsx", sheet = "Elsevier_Freedom") %>% select(c("ISSN", "Journal Title"))
wiley <- read_excel("data/3.external/Couperin/Produits à categoriser_complétésVL_listes de titres.xlsx", sheet = "Wiley", skip = 1) %>% select(c("P-ISSN", "E-ISSN", "Title"))
springer <- read_excel("data/3.external/Couperin/Produits à categoriser_complétésVL_listes de titres.xlsx", sheet = "Springer") %>% select(c("Print ISSN", "Online ISSN", "Journal"))
taylor_francis <- read_excel("data/3.external/Couperin/Produits à categoriser_complétésVL_listes de titres.xlsx", sheet = "Taylor&Francis") %>% select(c("Print ISSN", "Online ISSN", "Title"))
cairn <- read_excel("data/3.external/Couperin/Produits à categoriser_complétésVL_listes de titres.xlsx", sheet = "Cairn") %>% select(c("ISSN", "eISSN", "REVUE"))
    # renommage et suppression des doublons
couperin_agreements <- couperin_agreements %>% rename(pISSN =  `Print ISNN`, eISSN = `E-ISSN`, title = REVUE) %>% distinct
elsevier <- elsevier %>% rename(pISSN =  `ISSN`, title = `Journal Title`) %>% distinct %>% mutate(eISSN = NA) %>% select(pISSN, eISSN, title)
wiley <- wiley %>% rename(pISSN =  `P-ISSN`, eISSN = `E-ISSN`, title = Title) %>% distinct
springer <- springer %>% rename(pISSN =  `Print ISSN`, eISSN = `Online ISSN`, title = Journal) %>% distinct
taylor_francis <- taylor_francis %>% rename(pISSN =  `Print ISSN`, eISSN = `Online ISSN`, title = Title) %>% distinct
cairn <- cairn %>% rename(pISSN =  `ISSN`, title = REVUE) %>% distinct
    # merge des fichiers en un seul, création de la variable 'is_covered_by_couperin'
couperin_agreements <- rbind(couperin_agreements, elsevier, wiley, springer, taylor_francis, cairn) %>% mutate(is_covered_by_couperin = 1)
    # titre des journaux sans accent et en majuscule
couperin_agreements <- couperin_agreements %>% mutate(title = toupper(title))
couperin_agreements <- data.table::data.table(couperin_agreements)
couperin_agreements[, title := stringi::stri_trans_general (str = title, id = "Latin-ASCII")]
    # suppression des doublons éventuels
couperin_agreements <- couperin_agreements %>% distinct()
  # journaux sans ISSN ?
couperin_agreements %>% filter(is.na(eISSN) & is.na(pISSN)) %>% nrow() # 238, donc on garde la colonne du titre du journal pour match avec BSO


# Couperin data 2 (% APC really paid by authors)
elsevier_articles <- read_excel("data/3.external/Couperin/Elsevier_ArticlesOA_2019-2021.xlsx") %>% select(DOI) %>% mutate(part_APC_paid_by_couperin = 0.25,
                                                                                                                          part_APC_paid_by_authors = 0.75)
edp_articles <- read_excel("data/3.external/Couperin/EDP_données_2017-2020.xlsx") %>% select(DOI) %>% distinct() %>%  mutate(part_APC_paid_by_couperin = 1,
                                                                                                                             part_APC_paid_by_authors = 0)






        ###----- FUNCTION 


managing_variables <- function(year) {

    
        #----- Import
  
    unnested_bso <- fromJSON(glue("{in_dir}/unnested_bso_{year}.json"))
    authors_bso <- fromJSON(glue("{in_dir}/authors_bso_{year}.json"), flatten = TRUE)
    if (ncol(authors_bso) == 3) {
    authors_bso <- authors_bso %>% unnest(cols = "authors", names_repair = "universal")
    } 
    oa_details_bso <- fromJSON(glue("{in_dir}/oa-details_bso_{year}.json"), flatten = TRUE)

    
    
        #----- Selection

    unnested_bso <- unnested_bso %>% 
      select(doi, year, bso_classification, coi, detected_countries, genre, journal_issn_l, journal_issns, journal_name, lang, title, has_apc, amount_apc_EUR, apc_source, amount_apc_doaj_EUR, amount_apc_doaj, amount_apc_openapc_EUR, count_apc_openapc_key, publisher_group, publisher_dissemination, hal_id) %>%
      mutate(detected_countries = as.character(detected_countries)) %>% 
      replace(.=="NULL", NA) 

    authors_bso <- authors_bso %>% select(doi, year, affiliations, author_position, affiliation, corresponding, email)

    oa_details_bso <- oa_details_bso %>% select(doi, year, oa_details.2020.is_oa, oa_details.2020.journal_is_in_doaj, oa_details.2020.journal_is_oa, oa_details.2020.oa_host_type, oa_details.2020.oa_colors, oa_details.2020.oa_colors_with_priority_to_publisher, oa_details.2020.licence_publisher)  %>%
      mutate(oa_details.2020.oa_host_type = as.character(oa_details.2020.oa_host_type), oa_details.2020.oa_colors = as.character(oa_details.2020.oa_colors), oa_details.2020.oa_colors_with_priority_to_publisher = as.character(oa_details.2020.oa_colors_with_priority_to_publisher), oa_details.2020.licence_publisher = as.character(oa_details.2020.licence_publisher)) %>% 
      replace(.=="NULL", NA)

    
    
        #----- Filter on journal-articles publications and remove column

    unnested_bso <- unnested_bso %>% filter(genre == "journal-article") %>% select(-genre)
     
    
    
        #----- Join

    
              # Split values into new rows when there is more than 1 ISSN
    unnested_bso <- unnested_bso %>% mutate(journal_issns = strsplit(as.character(journal_issns), ",")) %>% unnest(journal_issns)

    
              # Join with DOAJ data by ISSNs
    unnested_bso <- left_join(unnested_bso, doaj_data, by = c("journal_issns" = "bibjson.pissn"), na_matches = "never") # print ISSN
    unnested_bso <- left_join(unnested_bso, doaj_data, by = c("journal_issns" = "bibjson.eissn"), na_matches = "never") # e-ISSN
    
              # Merge and remove duplicated columns
    unnested_bso <- unnested_bso %>% 
        mutate(is_in_doaj_data = coalesce(is_in_doaj_data.x, is_in_doaj_data.y),
               doaj_has_apc = coalesce(bibjson.apc.has_apc.x, bibjson.apc.has_apc.y)) %>% 
        select(-is_in_doaj_data.x, -is_in_doaj_data.y, 
               -bibjson.apc.has_apc.x, -bibjson.apc.has_apc.y, 
               -bibjson.pissn, -bibjson.eissn)

    
              # Join with Couperin data by ISSNs [journal covered by Couperin ?]
    unnested_bso <- left_join(unnested_bso, couperin_agreements[,c(1,4)], by = c("journal_issns" = "pISSN"), na_matches = "never") # print ISSN
    unnested_bso <- left_join(unnested_bso, couperin_agreements[,c(2,4)], by = c("journal_issns" = "eISSN"), na_matches = "never") # e-ISSN
    
              # Join with Couperin data by journal title (for 238 Couperin revues wihout ISSNs)
      # filter on revues without ISSN
    couperin_na_issn <- couperin_agreements %>% filter(is.na(eISSN) & is.na(pISSN))
      # creation journal title variable toupper and without special characters to improve mathcing
    unnested_bso <- unnested_bso %>% mutate(journal_name_upper = toupper(journal_name))
    unnested_bso <- data.table::data.table(unnested_bso)
    unnested_bso[, journal_name_upper := stringi::stri_trans_general (str = journal_name_upper, id = "Latin-ASCII")]
      # join
    unnested_bso <- left_join(unnested_bso, couperin_na_issn[,c(3,4)], by = c("journal_name_upper" = "title"), na_matches = "never")

              # Merge and remove intermediate columns
    unnested_bso <- unnested_bso %>% 
        mutate(is_covered_by_couperin = coalesce(is_covered_by_couperin.x, is_covered_by_couperin.y, is_covered_by_couperin)) %>% 
        select(-c(is_covered_by_couperin.x, is_covered_by_couperin.y, journal_name_upper))
    
    
              # Join with Couperin data by DOIs [percentage APC paid by Couperin]
    unnested_bso <- left_join(unnested_bso, elsevier_articles, by = c("doi" = "DOI"), na_matches = "never")
    unnested_bso <- left_join(unnested_bso, edp_articles, by = c("doi" = "DOI"), na_matches = "never")

              # Merge and remove duplicated columns
    unnested_bso <- unnested_bso %>% 
        mutate(part_APC_paid_by_couperin = coalesce(part_APC_paid_by_couperin.x, part_APC_paid_by_couperin.y),
               part_APC_paid_by_authors = coalesce(part_APC_paid_by_authors.x, part_APC_paid_by_authors.y)) %>% 
        select(-c(part_APC_paid_by_couperin.x, part_APC_paid_by_couperin.y, part_APC_paid_by_authors.x, part_APC_paid_by_authors.y))    

        
   
    
    
        #----- Creation

    unnested_bso <- unnested_bso %>% 
      
                # tier variable
      mutate(tier = case_when(publisher_dissemination == "Elsevier" ~ 1, 
                              publisher_dissemination == "Springer-Nature" | publisher_dissemination == "Wiley" | publisher_dissemination == "MDPI" ~ 2,
                              publisher_dissemination == "OpenEdition" | publisher_dissemination == "CAIRN"  | publisher_dissemination == "Oxford University Press" | publisher_dissemination == "Informa" | publisher_dissemination == "Frontiers" | publisher_dissemination == "American Chemical Society" | publisher_dissemination == "Wolters Kluwer Health" | publisher_dissemination == "EDP Sciences" | publisher_dissemination == "American Physical Society" | publisher_dissemination == "IEEE" | publisher_dissemination == "Royal Society of Chemistry" | publisher_dissemination == "IOP Publishing" | publisher_dissemination == "SAGE Publications" | publisher_dissemination == "British Medical Journal" | publisher_dissemination == "Public Library of Science" | publisher_dissemination == "Cambridge University Press" ~ 3,
                              TRUE ~ 4)) %>% 
      
                # journal_color variables (based on BSO and DOAJ data)
      group_by(journal_issns) %>% 
      mutate(journal_color = case_when(apc_source == "doaj" & has_apc == 0 ~ "diamond",
                                       (apc_source == "doaj" | !is.na(amount_apc_doaj)) & has_apc == 1 ~ "gold",
                                       any(has_apc == 1) ~ "hybrid",
                                       any(has_apc == 0) ~ "subscription"),
             journal_color_doaj = case_when(is_in_doaj_data == 1 & doaj_has_apc == 'FALSE' ~ "diamond",
                                            is_in_doaj_data == 1 & doaj_has_apc == 'TRUE' ~ "gold")) %>% ungroup() %>% 
      select(-c(is_in_doaj_data, doaj_has_apc)) %>% 
      
      # unsplit values
      group_by(doi) %>% 
      mutate(journal_issns = paste0(unique(na.omit(journal_issns)), collapse = ","),
             journal_color_doaj = paste0(unique(na.omit(journal_color_doaj)), collapse = ","),
             journal_color = paste0(unique(na.omit(journal_color)), collapse = ","),
             journal_color = str_replace_all(journal_color, c("hybrid,subscription" = "subscription,hybrid",
                                                              "subscription,hybrid" = "hybrid")),
             is_covered_by_couperin = paste0(unique(na.omit(is_covered_by_couperin)), collapse = ",")) %>% distinct() %>% ungroup()
    
    
    
    
    authors_bso <- authors_bso %>% group_by(doi) %>% 
      
                # nb_authors variable
      mutate(nb_authors = n()) %>% ungroup()

        
    # Unnest affiliations to create other variables
    authors_bso <- authors_bso %>% mutate(res = map_chr(affiliations, class)) %>% 
      group_split(res) %>% 
      map(~unnest(data = ., affiliations, keep_empty = TRUE, names_repair = "universal")) %>% bind_rows() %>% 
      select(doi, year, detected_countries, name, author_position, affiliation, corresponding, email, nb_authors) %>% ungroup() %>% 
      mutate(detected_countries = as.character(detected_countries),
             name = as.character(name),
             affiliation = as.character(affiliation),
             name = coalesce(name, affiliation)) %>% 
      select(-affiliation) %>% 
      replace(.=="NULL", NA) %>% replace(.=="character(0)", NA) %>% replace(.=="list()", NA)
    
    
    authors_bso <- authors_bso %>% group_by(doi) %>% 
      
                # is_complete_affiliation variable
      mutate(is_complete_affiliation = case_when(all(!is.na(name)) ~ 1,
                                                 TRUE ~ 0), 
             
                # nb_missing_affiliation variable
             nb_missing_affiliation = sum(is.na(name)),
             
                # is_french_CA variable
             is_french_CA = case_when((corresponding == 'TRUE' & ((grepl("fr", detected_countries) == TRUE) | grepl("France", name) == TRUE)) | # french CA
                                        all(grepl("fr", detected_countries) == TRUE) |  # all authors are french
                                        all(grepl("France", name) == TRUE) ~ 1,
                                 (corresponding == 'TRUE' & ((grepl("fr", detected_countries) != TRUE) | grepl("France", name) != TRUE)) |
                                        all(!is.na(name)) & (all(grepl("fr", detected_countries) == FALSE) | all(grepl("France", name) == FALSE)) ~ 0), #non french CA
              
                # is_at_least_one_french_author
             is_at_least_one_french_author = case_when(any(grepl("fr", detected_countries) == TRUE) | any(grepl("France", name) == TRUE) ~ 1,
                                                       all(!is.na(name)) & (all(grepl("fr", detected_countries) == FALSE) | all(grepl("France", name) == FALSE)) ~ 0)) %>% 
      
      ungroup() %>% arrange(doi)
    
    
    
        #----- Filters on top and bottom 5 author affiliations when more than 10, and keep corresponding author affiliation
    
    head <- authors_bso %>% group_by(doi) %>% slice_head(n = 5)
    tail <- authors_bso %>% group_by(doi) %>% slice_tail(n = 5)
    corresponding <- authors_bso %>% filter(corresponding == 'TRUE')
    authors_bso <- bind_rows(head, tail, corresponding) %>% distinct() %>% arrange(doi)
       
     
    
        #----- Compilation
    
    final_data <- left_join(unnested_bso, authors_bso[,c(1, 4:ncol(authors_bso))], by = "doi")
    final_data <- left_join(final_data, oa_details_bso[,c(1, 3:ncol(oa_details_bso))], by = "doi")
    
    
    
        #----- Enrich is_at_least_one_french_author with detected_countries field from unnested_bso object
    
    final_data <- final_data %>% group_by(doi) %>% 
      mutate(is_at_least_one_french_author2 = case_when(any(grepl("fr", detected_countries) == TRUE) ~ 1,
                                                        TRUE ~ is_at_least_one_french_author),
             .after = is_at_least_one_french_author) %>% 
      ungroup() %>% select(-is_at_least_one_french_author)
    
    
    
        #----- Format columns, last treatments

        # NAs
    final_data <- final_data %>% replace(.=="", NA)
    
        # as.factor
    final_data[,c("has_apc", "tier", "is_covered_by_couperin", "is_complete_affiliation", "is_french_CA", "is_at_least_one_french_author2")] <- sapply(final_data[,c("has_apc", "tier", "is_covered_by_couperin", "is_complete_affiliation", "is_french_CA", "is_at_least_one_french_author2")], as.factor)
    
        # as.character
    final_data <- final_data %>% mutate(author_position = as.character(author_position))
    
        # Set to 0 (not NA) journals not covered by Couperin (= unmatched with Couperin journals data)
    final_data <- final_data %>% mutate(is_covered_by_couperin = case_when(is.na(is_covered_by_couperin) ~ 0,
                                                                           TRUE ~ 1))
    
        # Article-level dataset (paste author data into one row per DOI)
    final_data <- final_data %>% group_by(doi) %>% mutate(name = paste0(unique(na.omit(name)), collapse = ","),
                                                          author_position = paste0(unique(na.omit(author_position)), collapse = ","),
                                                          corresponding = paste0(unique(na.omit(corresponding)), collapse = ","),
                                                          email = paste0(unique(na.omit(email)), collapse = ",")) %>% distinct()
    
        # For some DOIs is_french_CA takes 2 values : keep only the '1' one
    final_data <- final_data %>% group_by(doi) %>% arrange(desc(is_french_CA)) %>% slice(1) %>% distinct() %>% ungroup()
    
        # NAs again after pasting all author values in one row
    final_data <- final_data %>% replace(.=="", NA)
    
    
    
        #----- Export

    rio::export(final_data, glue("{out_dir}/final_bso_{year}.csv"))
}




### On applique la fonction aux différentes années

managing_variables(2013)
managing_variables(2014)
managing_variables(2015)
managing_variables(2016)
managing_variables(2017)
managing_variables(2018)
managing_variables(2019)
managing_variables(2020)


### On regroupe les différentes années
    # Import 8 fichiers de données
rbindlist_fread <- function(path, pattern = "*.csv") {
    files = list.files(path, pattern, full.names = TRUE)
    rbindlist(lapply(files, function(x) fread(x)))
}
    # Compilation via rbind()
whole_bso <- rbindlist_fread(out_dir) %>% replace(.=="", NA)
    # Export
rio::export(whole_bso, glue("{out_dir}/whole_bso.csv"))

