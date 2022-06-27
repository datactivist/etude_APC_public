# Dictionnaire des variables du jeu de données de l’étude APC

Auteurs : Diane Thierry, Antoine Blanchard, Maurits van der Graaf

Date : May 16, 2022

**doi** : Identifiant unique de l'article


<table>
  <tr>
   <td>…
   </td>
   <td>chaîne de caractères
   </td>
  </tr>
</table>


**year** : année de publication


<table>
  <tr>
   <td>…
   </td>
   <td>2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020
   </td>
  </tr>
</table>


**bso_classification** : discipline de l'article


<table>
  <tr>
    <td></td>
    <td>Biology (fond.)</td>
  </tr>
  <tr>
     <td></td>
    <td>Chemistry</td>
  </tr>
  <tr>
     <td></td>
    <td>Computer and information sciences</td>
      </tr>
  <tr>
     <td></td>
    <td>Earth, Ecology, Energy and applied biology</td>
      </tr>
  <tr>
     <td>…</td>
    <td>Engineering</td>
      </tr>
  <tr>
       <td></td>
    <td>Humanities</td>
      </tr>
  <tr>
       <td></td>
    <td>Mathematics</td>
      </tr>
  <tr>
       <td></td>
    <td>Medical research</td>
      </tr>
  <tr>
       <td></td>
    <td>Physical sciences, Astronomy</td>
      </tr>
  <tr>
    <td></td>
    <td>Social sciences</td>
      </tr>
  <tr>
    <td></td>
    <td>unknown</td>
      </tr>
</table>


**coi** : conflit d’intérêt déclaré


<table>
  <tr>
   <td>…
   </td>
   <td>chaîne de caractères
   </td>
  </tr>
</table>


**detected_countries** : liste de tous les pays d’affiliation des auteurs de l'article


<table>
  <tr>
    <td>fr</td>
    <td>France</td>
  </tr>    <tr>
  <tr>
    <td>en</td>
    <td>Pays anglophones</td>
  </tr>    <tr>
  <tr>
    <td>de</td>
    <td>Allemagnes</td>
  </tr> 
</table>


**journal_issn_l** : identifiant de revue _‘ISSN link’_


<table>
  <tr>
   <td>…
   </td>
   <td>identifiant au format XXXX-XXXX
   </td>
  </tr>
</table>


**journal_issns** : identifiants de revue _‘ISSN print_’ ou ‘_e-ISSN_’


<table>
  <tr>
   <td>…
   </td>
   <td>identifiants au format XXXX-XXXX
   </td>
  </tr>
</table>


**journal_name** : nom de la revue


<table>
  <tr>
   <td>…
   </td>
   <td>chaîne de caractères
   </td>
  </tr>
</table>


**lang** : langue dans laquelle est rédigée l'article


<table>
  <tr>
    <td>en</td>
    <td>Anglais</td>
  </tr>
  <tr>
        <td>fr</td>
    <td>Français</td>
    </tr>
  <tr>
        <td>es</td>
    <td>Espagnol</td>
  </tr>
</table>


**title** : titre de l'article


<table>
  <tr>
   <td>…
   </td>
   <td>chaîne de caractères
   </td>
  </tr>
</table>


**has_apc** : l’article est disponible en accès ouvert, quelle que soit la raison : gold, hybride, bronze, delayed-OA… (l’intitulé de cette variable, issue du BSO, est donc impropre) 


<table>
  <tr>
   <td>0</td>
    <td>Non</td>
  </tr>
  <tr>
    <td>1</td>
    <td>Oui</td>
  </tr>
</table>


**apc_source** : provenance du montant des APC


<table>
  <tr>
    <td>doaj</td>
    <td>APC fourni par la liste de prix DOAJ</td>
  </tr>
  <tr>
    <td>openAPC</td>
    <td>APC fourni dans OpenAPC</td>
  </tr>
  <tr>
    <td>openAPC_estimation_issn</td>
    <td>APC estimés : moyenne des APC connus par revue dans OpenAPC</td>
  </tr>
  <tr>
    <td>openAPC_estimation_issn_year</td>
    <td>APC estimés : moyenne des APC connus par revue et par an dans OpenAPC</td>
  </tr>
  <tr>
    <td>openAPC_estimation_publisher</td>
    <td>APC estimés : moyenne des APC connus par éditeur dans OpenAPC</td>
  </tr>
  <tr>
    <td>openAPC_estimation_publisher_year</td>
    <td>APC estimés : moyenne des APC connus par éditeur et par an dans OpenAPC</td>
  </tr>
</table>


**amount_apc_doaj** : montant des APC provenant du DOAJ


<table>
  <tr>
   <td>…
   </td>
   <td>coefficient numérique
   </td>
  </tr>
</table>


**amount_apc_doaj_EUR** : montant des APC provenant du DOAJ convertis en euros


<table>
  <tr>
   <td>…
   </td>
   <td>coefficient numérique
   </td>
  </tr>
</table>


**amount_apc_openapc_EUR** : montant des APC estimés en euros


<table>
  <tr>
   <td>…
   </td>
   <td>coefficient numérique
   </td>
  </tr>
</table>


**amount_apc_EUR** : montant des APC payés en euros_ (variable finale, computation des variables ‘amount_apc_doaj_EUR’ et ‘amount_apc_openapc_EUR’)_


<table>
  <tr>
   <td>…
   </td>
   <td>coefficient numérique
   </td>
  </tr>
</table>


**count_apc_openapc_key** : nombre d’articles ayant servi de base pour estimer les APC


<table>
  <tr>
   <td>…
   </td>
   <td>coefficient numérique
   </td>
  </tr>
</table>


**publisher_group** : nom de l’éditeur normalisé par année 


<table>
  <tr>
   <td>…
   </td>
   <td>Elsevier, Springer-Nature, MDPI…
   </td>
  </tr>
</table>


**publisher_dissemination** : nom de l’éditeur normalisé par année[^1]


<table>
  <tr>
   <td>…
   </td>
   <td>Elsevier, Springer-Nature, MDPI…
   </td>
  </tr>
</table>


**hal_id** : identifiant de l’archive ouverte HAL


<table>
  <tr>
   <td>…
   </td>
   <td>chaîne de caractères
   </td>
  </tr>
</table>


**is_covered_by_couperin** : la revue est couverte par les accords Couperin


<table>
  <tr>
   <td>0
<p>
1
   </td>
   <td>Non
<p>
Oui
   </td>
  </tr>
</table>


**part_APC_paid_by_couperin** : pourcentage des APC supportés par Couperin


<table>
  <tr>
   <td>0.25
<p>
1
   </td>
   <td>25% pour Elsevier
<p>
100% pour EDP
   </td>
  </tr>
</table>


**part_APC_paid_by_authors** : pourcentage des APC réellement payés par les auteurs


<table>
  <tr>
   <td>0.75
<p>
0
   </td>
   <td>75% pour Elsevier
<p>
0% pour EDP
   </td>
  </tr>
</table>


**tier** : classe de l’éditeur (défini à partir du rang de l’éditeur pour l’année 2020)


<table>
  <tr>
   <td>1
<p>
2
<p>
3
<p>
4
   </td>
   <td>Elsevier
<p>
Springer-Nature, Wiley, MDPI
<p>
OpenEdition, CAIRN, Oxford University Press, Informa, Frontiers, American Chemical Society, Wolters Kluwer Health, EDP Sciences, American Physical Society, IEEE, Royal Society of Chemistry, IOP Publishing, SAGE Publications, British Medical Journal, Public Library of Science, Cambridge University Press
<p>
Tous les autres éditeurs (“longue traîne”)
   </td>
  </tr>
</table>


**journal_color** : couleur _open access_ de la revue, construite à partir des données du BSO, en faisant une hypothèse grossière sur la variable _‘has_apc’_. Aussi, nous avons cherché à améliorer la détermination de la couleur par deux autres moyens (ci-après).


<table>
  <tr>
   <td>…
   </td>
   <td>diamond, gold, hybrid, subscription
   </td>
  </tr>
</table>


**journal_color_doaj** : couleur _open access_ de la revue, construite à partir des données du DOAJ : soit la revue est dans les données DOAJ et applique des APC, alors la couleur vaut ‘gold’ ; soit la revue est dans les données DOAJ et n’applique pas des APC, alors la couleur vaut ‘diamond’. Nous ne pouvons pas conclure dans les autres cas.


<table>
  <tr>
   <td>…
   </td>
   <td>diamond, gold
   </td>
  </tr>
</table>


**journal_color_qoam** : couleur _open access_ de la revue, construite à partir des données du QOAM (https://www.qoam.eu) : soit la revue est en accès fermé, alors la couleur vaut ‘hybrid’ ; soit la revue est en accès ouvert sans APC, alors la couleur vaut ‘diamond’ ; soit la revue est en accès ouvert avec APC, alors la couleur vaut ‘gold’.


<table>
  <tr>
   <td>…
   </td>
   <td>diamond, gold, hybrid
   </td>
  </tr>
</table>


**is_french_CA** : il y a au moins un auteur correspondant (CA) affilié en France (construite à partir des données du BSO)


<table>
  <tr>
   <td>0
<p>
1
   </td>
   <td>Non
<p>
Oui
   </td>
  </tr>
</table>


**is_french_CA_wos** : il y a au moins un auteur correspondant affilié en France (construite à partir des données du Web of Science)


<table>
  <tr>
   <td>0
<p>
1
   </td>
   <td>Non
<p>
Oui
   </td>
  </tr>
</table>


**is_non_french_CA_wos** : il y a au moins un auteur correspondant affilié à l’étranger (construite à partir des données du WOS)


<table>
  <tr>
   <td>0
<p>
1
   </td>
   <td>Non
<p>
Oui
   </td>
  </tr>
</table>


**is_french_CA_openalex** : il y a au moins un auteur correspondant affilié en France (construite à partir des données OpenAlex, _pour les articles sans info sur le CA des variables du BSO ni de WOS, et qui ne sont pas écrits en français_)


<table>
  <tr>
   <td>0
<p>
1
   </td>
   <td>Non
<p>
Oui
   </td>
  </tr>
</table>


**is_french_CA_bso_wos** : il y a au moins un auteur correspondant affilié en France selon le BSO ou le WOS


<table>
  <tr>
   <td>0
<p>
1
   </td>
   <td>Non
<p>
Oui
   </td>
  </tr>
</table>


**is_french_CA_bso_wos_openalex** : il y a au moins un auteur correspondant affilié en France selon le BSO, le WOS, ou OpenAlex


<table>
  <tr>
   <td>0
<p>
1
   </td>
   <td>Non
<p>
Oui
   </td>
  </tr>
</table>


**is_french_CA_bso_wos_openalex_single** : il y a au moins un auteur correspondant affilié en France selon le BSO, le WOS ou OpenAlex, ou lorsque l’article est rédigé par un seul auteur


<table>
  <tr>
   <td>0
<p>
1
   </td>
   <td>Non
<p>
Oui
   </td>
  </tr>
</table>


**is_french_CA_bso_wos_openalex_single_lang** : il y a au moins un auteur correspondant affilié en France selon le BSO, le WOS ou OpenAlex, ou lorsque l’article est rédigé par un seul auteur ou encore lorsqu’il est rédigé en français (_variable finale, computation des 4 variables intermédiaires ci-dessus_)


<table>
  <tr>
   <td>0
<p>
1
   </td>
   <td>Non
<p>
Oui
   </td>
  </tr>
</table>


**is_at_least_one_french_author2** : il y a au moins un auteur affilié en France (construite à partir des données du BSO)


<table>
  <tr>
   <td>0
<p>
1
   </td>
   <td>Non
<p>
Oui
   </td>
  </tr>
</table>


**name** : nom de l’établissement d’affiliation de l’auteur


<table>
  <tr>
   <td>…
   </td>
   <td>chaîne de caractères
   </td>
  </tr>
</table>


**author_position** : position de l’auteur


<table>
  <tr>
   <td>…
   </td>
   <td>coefficient numérique
   </td>
  </tr>
</table>


**corresponding** : l’auteur est l’auteur correspondant


<table>
  <tr>
   <td>TRUE
   </td>
   <td>Oui
   </td>
  </tr>
</table>


**email** : adresse email de l’auteur


<table>
  <tr>
   <td>…
   </td>
   <td>chaîne de caractères
   </td>
  </tr>
</table>


**nb_authors** : nombre d’auteurs par article


<table>
  <tr>
   <td>…
   </td>
   <td>coefficient numérique
   </td>
  </tr>
</table>


**is_complete_affiliation** : toutes les affiliations des auteurs sont connues


<table>
  <tr>
   <td>0
<p>
1
   </td>
   <td>Non
<p>
Oui
   </td>
  </tr>
</table>


**nb_missing_affiliation** : nombre d’affiliation des auteurs manquantes _(complétude du **nom** de l’établissement ; variable “name”)_


<table>
  <tr>
   <td>…
   </td>
   <td>coefficient numérique
   </td>
  </tr>
</table>


**oa_details.2020.is_oa** : l'article est en accès ouvert


<table>
  <tr>
   <td>FALSE
<p>
TRUE
   </td>
   <td>Non
<p>
Oui
   </td>
  </tr>
</table>


**oa_details.2020.journal_is_in_doaj** : la revue est dans la base du DOAJ


<table>
  <tr>
   <td>FALSE
<p>
TRUE
   </td>
   <td>Non
<p>
Oui
   </td>
  </tr>
</table>


**oa_details.2020.journal_is_oa** : la revue est en accès ouvert


<table>
  <tr>
   <td>FALSE
<p>
TRUE
   </td>
   <td>Non
<p>
Oui
   </td>
  </tr>
</table>


**oa_details.2020.oa_host_type** : lieu de publication en accès ouvert


<table>
  <tr>
   <td>closed
<p>
publisher
  <p>publisher;repository       
<p>
repository
   </td>
   <td>pas d’accès ouvert
<p>
site de l’éditeur
<p>
site de l’éditeur et archive ouverte
<p>
archive ouverte
   </td>
  </tr>
</table>


**oa_details.2020.oa_colors** : couleur OA de l’article (plusieurs valeurs possibles par article lorsque plusieurs versions OA coexistent)


<table>
  <tr>
   <td>…
   </td>
   <td>gold, hybrid, green, diamond, closed, other
   </td>
  </tr>
</table>


**oa_details.2020.oa_colors_with_priority_to_publisher** : couleur OA préférée de l'article


<table>
  <tr>
   <td>…
   </td>
   <td>gold, hybrid, green_only, diamond, closed, other
   </td>
  </tr>
</table>


**oa_details.2020.licence_publisher** : licence de l’éditeur


<table>
  <tr>
   <td>…
   </td>
   <td>cc-by, cc-by-nc, cc-by-nc-nd, cc-by-nc-sa, cc-by-nd, cc-by-sa, other, no license
   </td>
  </tr>
</table>


**oa_color_article_BSO** : reconstruction de la variable ‘_oa_details.2020.oa_colors_with_priority_to_publisher_’ où les catégories “_closed_”, “_green_only_” et “_other_” sont regroupées sous la valeur “_subscription_”


<table>
  <tr>
   <td>…
   </td>
   <td>gold, hybrid, subscription, diamond
   </td>
  </tr>
</table>


**oa_color_openalex** : couleur OA de l'article issue des données OpenAlex, uniquement pour les articles du BSO en accès ouvert, c’est-à-dire où _‘has_apc’_ vaut ‘_1_’


<table>
  <tr>
   <td>…
   </td>
   <td>gold, hybrid, bronze, green, closed
   </td>
  </tr>
</table>


**apc_has_been_paid** : variable booléenne indiquant si un APC a été payé, construite à partir de la variable _‘oa_color_openalex’_ : elle prend la valeur ‘1’ lorsque la couleur est ‘gold’ ou ‘hybrid’, et la valeur ‘0’ dans les autres cas


<table>
  <tr>
   <td>0
<p>
1
   </td>
   <td>Non
<p>
Oui
   </td>
  </tr>
</table>



<!-- Footnotes themselves at the bottom. -->
## Notes

[^1]:
     La seule valeur qui différencie les 2 variables est “_American Geophysical Union_” pour **publisher_group** qui vaut “_Wiley_” pour la variable **publisher_dissemination.**
