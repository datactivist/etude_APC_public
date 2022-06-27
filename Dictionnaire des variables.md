# Dictionnaire des variables du jeu de données de l'étude APC

Auteurs : Diane Thierry, Antoine Blanchard, Maurits van der Graaf

Date : 16 mai 2022

**doi** : Identifiant unique de l\'article

  ----- ----------------------
  ...   chaîne de caractères
  ----- ----------------------

**year** : année de publication

  ----- ------------------------------------------------
  ...   2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020
  ----- ------------------------------------------------

**bso_classification** : discipline de l\'article

+-----+--------------------------------------------+
| ... | Biology (fond.)                            |
|     |                                            |
|     | Chemistry                                  |
|     |                                            |
|     | Computer and information sciences          |
|     |                                            |
|     | Earth, Ecology, Energy and applied biology |
|     |                                            |
|     | Engineering                                |
|     |                                            |
|     | Humanities                                 |
|     |                                            |
|     | Mathematics                                |
|     |                                            |
|     | Medical research                           |
|     |                                            |
|     | Physical sciences, Astronomy               |
|     |                                            |
|     | Social sciences                            |
|     |                                            |
|     | unknown                                    |
+-----+--------------------------------------------+

**coi** : conflit d'intérêt déclaré

  ----- ----------------------
  ...   chaîne de caractères
  ----- ----------------------

**detected_countries** : liste de tous les pays d'affiliation des
auteurs de l\'article

+-----+------------------+
| fr  | France           |
|     |                  |
| en  | Pays anglophones |
|     |                  |
| de  | Allemagne        |
|     |                  |
| ... | \[...\]          |
+-----+------------------+

**journal_issn_l** : identifiant de revue *'ISSN link'*

  ----- ---------------------------------
  ...   identifiant au format XXXX-XXXX
  ----- ---------------------------------

**journal_issns** : identifiants de revue *'ISSN print*' ou '*e-ISSN*'

  ----- ----------------------------------
  ...   identifiants au format XXXX-XXXX
  ----- ----------------------------------

**journal_name** : nom de la revue

  ----- ----------------------
  ...   chaîne de caractères
  ----- ----------------------

**lang** : langue dans laquelle est rédigée l\'article

+-----+----------+
| en  | Anglais  |
|     |          |
| fr  | Français |
|     |          |
| es  | Espagnol |
|     |          |
| ... | \[\...\] |
+-----+----------+

**title** : titre de l\'article

  ----- ----------------------
  ...   chaîne de caractères
  ----- ----------------------

**has_apc** : l'article est disponible en accès ouvert, quelle que soit
la raison : gold, hybride, bronze, delayed-OA... (l'intitulé de cette
variable, issue du BSO, est donc impropre)

+---+-----+
| 0 | Non |
|   |     |
| 1 | Oui |
+---+-----+

**apc_source** : provenance du montant des APC

+----------------------------------+----------------------------------+
| doaj                             | APC fourni par la liste de prix  |
|                                  | DOAJ                             |
| openAPC openAPC_estimation_issn  |                                  |
|                                  | APC fourni dans OpenAPC          |
| openAPC_estimation_issn_year     |                                  |
|                                  | APC estimés; moyenne des APC     |
| openAPC_estimation_publisher     | connus par revue dans OpenAPC    |
|                                  |                                  |
| o                                | APC estimés; moyenne des APC     |
| penAPC_estimation_publisher_year | connus par revue et par an dans  |
|                                  | OpenAPC                          |
|                                  |                                  |
|                                  | APC estimés; moyenne des APC     |
|                                  | connus par éditeur dans OpenAPC  |
|                                  |                                  |
|                                  | APC estimés; moyenne des APC     |
|                                  | connus par éditeur et par an     |
|                                  | dans OpenAPC                     |
+----------------------------------+----------------------------------+

**amount_apc_doaj** : montant des APC provenant du DOAJ

  ----- -----------------------
  ...   coefficient numérique
  ----- -----------------------

**amount_apc_doaj_EUR** : montant des APC provenant du DOAJ convertis en
euros

  ----- -----------------------
  ...   coefficient numérique
  ----- -----------------------

**amount_apc_openapc_EUR** : montant des APC estimés en euros

  ----- -----------------------
  ...   coefficient numérique
  ----- -----------------------

**amount_apc_EUR** : montant des APC payés en euros *(variable finale,
computation des variables 'amount_apc_doaj_EUR' et
'amount_apc_openapc_EUR')*

  ----- -----------------------
  ...   coefficient numérique
  ----- -----------------------

**count_apc_openapc_key** : nombre d'articles ayant servi de base pour
estimer les APC

  ----- -----------------------
  ...   coefficient numérique
  ----- -----------------------

**publisher_group** : nom de l'éditeur normalisé par année

  ----- ------------------------------------
  ...   Elsevier, Springer-Nature, MDPI...
  ----- ------------------------------------

**publisher_dissemination** : nom de l'éditeur normalisé par année[^1]

  ----- ------------------------------------
  ...   Elsevier, Springer-Nature, MDPI...
  ----- ------------------------------------

**hal_id** : identifiant de l'archive ouverte HAL

  ----- ----------------------
  ...   chaîne de caractères
  ----- ----------------------

**is_covered_by_couperin** : la revue est couverte par les accords
Couperin

+---+-----+
| 0 | Non |
|   |     |
| 1 | Oui |
+---+-----+

**part_APC_paid_by_couperin** : pourcentage des APC supportés par
Couperin

+------+-------------------+
| 0.25 | 25% pour Elsevier |
|      |                   |
| 1    | 100% pour EDP     |
+------+-------------------+

**part_APC_paid_by_authors** : pourcentage des APC réellement payés par
les auteurs

+------+-------------------+
| 0.75 | 75% pour Elsevier |
|      |                   |
| 0    | 0% pour EDP       |
+------+-------------------+

**tier** : classe de l'éditeur (défini à partir du rang de l'éditeur
pour l'année 2020)

+---+-----------------------------------------------------------------+
| 1 | Elsevier                                                        |
|   |                                                                 |
| 2 | Springer-Nature, Wiley, MDPI                                    |
|   |                                                                 |
| 3 | OpenEdition, CAIRN, Oxford University Press, Informa,           |
|   | Frontiers, American Chemical Society, Wolters Kluwer Health,    |
| 4 | EDP Sciences, American Physical Society, IEEE, Royal Society of |
|   | Chemistry, IOP Publishing, SAGE Publications, British Medical   |
|   | Journal, Public Library of Science, Cambridge University Press  |
|   |                                                                 |
|   | Tous les autres éditeurs ("longue traîne")                      |
+---+-----------------------------------------------------------------+

**journal_color** : couleur *open access* de la revue, construite à
partir des données du BSO, en faisant une hypothèse grossière sur la
variable *'has_apc'*. Aussi, nous avons cherché à améliorer la
détermination de la couleur par deux autres moyens (ci-après).

  ----- -------------------------------------
  ...   diamond, gold, hybrid, subscription
  ----- -------------------------------------

**journal_color_doaj** : couleur *open access* de la revue, construite à
partir des données du DOAJ : soit la revue est dans les données DOAJ et
applique des APC, alors la couleur vaut 'gold' ; soit la revue est dans
les données DOAJ et n'applique pas des APC, alors la couleur vaut
'diamond'. Nous ne pouvons pas conclure dans les autres cas.

  ----- ---------------
  ...   diamond, gold
  ----- ---------------

**journal_color_qoam** : couleur *open access* de la revue, construite à
partir des données du QOAM (https://www.qoam.eu) : soit la revue est en
accès fermé, alors la couleur vaut 'hybrid' ; soit la revue est en accès
ouvert sans APC, alors la couleur vaut 'diamond' ; soit la revue est en
accès ouvert avec APC, alors la couleur vaut 'gold'.

  ----- -----------------------
  ...   diamond, gold, hybrid
  ----- -----------------------

**is_french_CA** : il y a au moins un auteur correspondant (CA) affilié
en France (construite à partir des données du BSO)

+---+-----+
| 0 | Non |
|   |     |
| 1 | Oui |
+---+-----+

**is_french_CA_wos** : il y a au moins un auteur correspondant affilié
en France (construite à partir des données du Web of Science)

+---+-----+
| 0 | Non |
|   |     |
| 1 | Oui |
+---+-----+

**is_non_french_CA_wos** : il y a au moins un auteur correspondant
affilié à l'étranger (construite à partir des données du WOS)

+---+-----+
| 0 | Non |
|   |     |
| 1 | Oui |
+---+-----+

**is_french_CA_openalex** : il y a au moins un auteur correspondant
affilié en France (construite à partir des données OpenAlex, *pour les
articles sans info sur le CA des variables du BSO ni de WOS, et qui ne
sont pas écrits en français*)

+---+-----+
| 0 | Non |
|   |     |
| 1 | Oui |
+---+-----+

**is_french_CA_bso_wos** : il y a au moins un auteur correspondant
affilié en France selon le BSO ou le WOS

+---+-----+
| 0 | Non |
|   |     |
| 1 | Oui |
+---+-----+

**is_french_CA_bso_wos_openalex** : il y a au moins un auteur
correspondant affilié en France selon le BSO, le WOS, ou OpenAlex

+---+-----+
| 0 | Non |
|   |     |
| 1 | Oui |
+---+-----+

**is_french_CA_bso_wos_openalex_single** : il y a au moins un auteur
correspondant affilié en France selon le BSO, le WOS ou OpenAlex, ou
lorsque l'article est rédigé par un seul auteur

+---+-----+
| 0 | Non |
|   |     |
| 1 | Oui |
+---+-----+

**is_french_CA_bso_wos_openalex_single_lang** : il y a au moins un
auteur correspondant affilié en France selon le BSO, le WOS ou OpenAlex,
ou lorsque l'article est rédigé par un seul auteur ou encore lorsqu'il
est rédigé en français (*variable finale, computation des 4 variables
intermédiaires ci-dessus*)

+---+-----+
| 0 | Non |
|   |     |
| 1 | Oui |
+---+-----+

**is_at_least_one_french_author2** : il y a au moins un auteur affilié
en France (construite à partir des données du BSO)

+---+-----+
| 0 | Non |
|   |     |
| 1 | Oui |
+---+-----+

**name** : nom de l'établissement d'affiliation de l'auteur

  ----- ----------------------
  ...   chaîne de caractères
  ----- ----------------------

**author_position** : position de l'auteur

  ----- -----------------------
  ...   coefficient numérique
  ----- -----------------------

**corresponding** : l'auteur est l'auteur correspondant

  ------ -----
  TRUE   Oui
  ------ -----

**email** : adresse email de l'auteur

  ----- ----------------------
  ...   chaîne de caractères
  ----- ----------------------

**nb_authors** : nombre d'auteurs par article

  ----- -----------------------
  ...   coefficient numérique
  ----- -----------------------

**is_complete_affiliation** : toutes les affiliations des auteurs sont
connues

+---+-----+
| 0 | Non |
|   |     |
| 1 | Oui |
+---+-----+

**nb_missing_affiliation** : nombre d'affiliation des auteurs manquantes
*(complétude du **nom** de l'établissement ; variable "name")*

  ----- -----------------------
  ...   coefficient numérique
  ----- -----------------------

**oa_details.2020.is_oa** : l\'article est en accès ouvert

+-------+-----+
| FALSE | Non |
|       |     |
| TRUE  | Oui |
+-------+-----+

**oa_details.2020.journal_is_in_doaj** : la revue est dans la base du
DOAJ

+-------+-----+
| FALSE | Non |
|       |     |
| TRUE  | Oui |
+-------+-----+

**oa_details.2020.journal_is_oa** : la revue est en accès ouvert

+-------+-----+
| FALSE | Non |
|       |     |
| TRUE  | Oui |
+-------+-----+

**oa_details.2020.oa_host_type** : lieu de publication en accès ouvert

+--------------------------------+--------------------------------------+
| closed                         | pas d'accès ouvert                   |
|                                |                                      |
| publisher publisher;repository | site de l'éditeur                    |
|                                |                                      |
| repository                     | site de l'éditeur et archive ouverte |
|                                |                                      |
|                                | archive ouverte                      |
+--------------------------------+--------------------------------------+

**oa_details.2020.oa_colors** : couleur OA de l'article (plusieurs
valeurs possibles par article lorsque plusieurs versions OA coexistent)

  ----- ---------------------------------------------
  ...   gold, hybrid, green, diamond, closed, other
  ----- ---------------------------------------------

**oa_details.2020.oa_colors_with_priority_to_publisher** : couleur OA
préférée de l\'article

  ----- --------------------------------------------------
  ...   gold, hybrid, green_only, diamond, closed, other
  ----- --------------------------------------------------

**oa_details.2020.licence_publisher** : licence de l'éditeur

  ----- ----------------------------------------------------------------------------------
  ...   cc-by, cc-by-nc, cc-by-nc-nd, cc-by-nc-sa, cc-by-nd, cc-by-sa, other, no license
  ----- ----------------------------------------------------------------------------------

**oa_color_article_BSO** : reconstruction de la variable
'*oa_details.2020.oa_colors_with_priority_to_publisher*' où les
catégories "*closed*", "*green_only*" et "*other*" sont regroupées sous
la valeur "*subscription*"

  ----- -------------------------------------
  ...   gold, hybrid, subscription, diamond
  ----- -------------------------------------

**oa_color_openalex** : couleur OA de l\'article issue des données
OpenAlex, uniquement pour les articles du BSO en accès ouvert,
c'est-à-dire où *'has_apc'* vaut '*1*'

  ----- -------------------------------------
  ...   gold, hybrid, bronze, green, closed
  ----- -------------------------------------

**apc_has_been_paid** : variable booléenne indiquant si un APC a été
payé, construite à partir de la variable *'oa_color_openalex'* : elle
prend la valeur '1' lorsque la couleur est 'gold' ou 'hybrid', et la
valeur '0' dans les autres cas

+---+-----+
| 0 | Non |
|   |     |
| 1 | Oui |
+---+-----+

[^1]: La seule valeur qui différencie les 2 variables est "*American
    Geophysical Union*"pour **publisher_group** qui vaut "*Wiley*"pour
    la variable **publisher_dissemination.**
