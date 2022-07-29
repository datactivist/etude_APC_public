# Packages
packages = c("tidyverse", "glue")

## Installation des packages si besoin et chargement des librairies
package.check <- lapply(packages,
  FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
      library(x, character.only = TRUE)}})

# Import BSO complet (2013-2020)
data <- read_csv("data/4.process/managing-variables_2nd-part/whole_bso.csv", col_types = cols(author_position = "c"), na = c("", "NA"))



        #----------------
        ### Fonctions ###
        #----------------


# Nr. of articles with (at least one) French author
nb_articles_french_author <- function(data, group) {

    n <- data %>% group_by_at(group) %>% filter(is_at_least_one_french_author2 == 1) %>% summarise(n = n())
    assign("nb_articles_french_author", n, envir = .GlobalEnv) # on assigne l'objet à l'environnement
}
data %>% nb_articles_french_author("year")


# Nr. of articles with French corresponding author
nb_articles_french_CA <- function(data, group) {

    n <- data %>% group_by_at(group) %>% filter(is_french_CA_bso_wos_lang_openalex == 1) %>% summarise(n = n()) # based on BSO data
    assign("nb_articles_french_CA", n, envir = .GlobalEnv)
}
data %>% nb_articles_french_CA("year")


# Nr. of articles published in hybrid journals
nb_articles_hybrid_journal <- function(data, group) {

    n <- data %>% group_by_at(group) %>% filter(oa_color_article_BSO == "hybrid") %>% summarise(n = n()) 
    assign("nb_articles_hybrid_journal", n, envir = .GlobalEnv)
}
data %>% nb_articles_hybrid_journal("year")


# Nr. of articles published in subscription journals
nb_articles_subscription_journal <- function(data, group) {

    n <- data %>% group_by_at(group) %>% filter(oa_color_article_BSO == "subscription") %>% summarise(n = n()) 
    assign("nb_articles_subscription_journal", n, envir = .GlobalEnv)
}
data %>% nb_articles_subscription_journal("year")


# Nr. of articles published in APC-Gold journals
nb_articles_gold_journal <- function(data, group) {

    n <- data %>% group_by_at(group) %>% filter(oa_color_article_BSO == "gold") %>% summarise(n = n())
    assign("nb_articles_gold_journal", n, envir = .GlobalEnv)
}
data %>% nb_articles_gold_journal("year")


# Nr. of articles published in Diamond journals
nb_articles_diamond_journal <- function(data, group) {

    n <- data %>% group_by_at(group) %>% filter(oa_color_article_BSO == "diamond") %>% summarise(n = n())
    assign("nb_articles_diamond_journal", n, envir = .GlobalEnv)
}
data %>% nb_articles_diamond_journal("year")


# Nr. of articles with missing oa_color_article_BSO
nb_articles_missing_color <- function(data, group) {

    n <- data %>% group_by_at(group) %>% filter(is.na(oa_color_article_BSO)) %>% summarise(n = n())
    assign("nb_articles_missing_color", n, envir = .GlobalEnv)
}
data %>% nb_articles_missing_color("year")


# Nr. of articles in journals covered by Couperin contracts
nb_articles_covered_by_couperin <- function(data, group) {

    n <- data %>% group_by_at(group) %>% filter(is_covered_by_couperin == 1) %>% summarise(n = n())
    assign("nb_articles_covered_by_couperin", n, envir = .GlobalEnv)
}
data %>% nb_articles_covered_by_couperin("year")


# APC costs paid
sum_APC <- function(data, group) {

    n <- data %>% group_by_at(group) %>% summarise(n = sum(amount_apc_EUR, na.rm = TRUE))
    assign("sum_APC", n, envir = .GlobalEnv)
}
data %>% sum_APC("tier")


# Nr. of articles with APC (has_apc == 1)
nb_articles_with_APC <- function(data, group) {

    n <- data %>% group_by_at(group) %>% filter(has_apc == 1) %>% summarise(n = n())
    assign("nb_articles_with_APC", n, envir = .GlobalEnv)
}
data %>% nb_articles_with_APC("year")


# APC costs financed by Couperin Read & Publish contracts








