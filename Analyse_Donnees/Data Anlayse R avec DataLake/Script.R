##### installation des librairies
install.packages("stringr")
install.packages("ggplot2")
install.packages("C50")
install.packages("randomForest")
install.packages("naivebayes")
install.packages("e1071")
install.packages("nnet")
install.packages("kknn")
install.packages("pROC")


library(stringr)
library(ggplot2)
library(C50)
library(randomForest)
library(naivebayes)
library(e1071)
library(nnet)
library(kknn)
library(pROC)


install.packages("RODBC")


library(RODBC)

##----connexion à la machine vituelle---------

connexion <- odbcConnect("ORCLPROJETDB_DNS", uid="PROJET", pwd="123", believeNRows=FALSE)

##----création des dataframes---------

immatriculation<-sqlQuery(connexion, "SELECT * FROM IMMATRICULATION")
marketing<-sqlQuery(connexion, "SELECT * FROM MARKETING")
catalogue<-sqlQuery(connexion, "SELECT * FROM CATALOGUE")
clients<-sqlQuery(connexion, "SELECT * FROM CLIENTS")


##DéBUT ANALYSE EXPLORATOIRE DES DONNéES
##nous mettons toutes les data au bons formats
clients$age <- as.integer(clients$age)
clients$taux <- as.integer(clients$taux)
clients$situationFamiliale <- as.factor(clients$situationFamiliale)
clients$nbEnfantsAcharge <- as.integer(clients$nbEnfantsAcharge)
clients$X2eme.voiture <- as.logical(clients$X2eme.voiture)
clients$sexe <- as.factor(clients$sexe)
clients$immatriculation <- as.character(clients$immatriculation)
clients <- na.omit(clients)

marketing$age <- as.integer(marketing$age)
marketing$taux <- as.integer(marketing$taux)
marketing$situationFamiliale <- as.factor(marketing$situationFamiliale)
marketing$nbEnfantsAcharge <- as.integer(marketing$nbEnfantsAcharge)
marketing$X2eme.voiture <- as.logical(marketing$X2eme.voiture)
marketing$sexe <- as.factor(marketing$sexe)
marketing <- na.omit(marketing)


catalogue$marque <- as.character(catalogue$marque)
catalogue$nom <- as.character(catalogue$nom)
catalogue$puissance <- as.integer(catalogue$puissance)
catalogue$longueur <- as.character(catalogue$longueur)
catalogue$nbplaces <- as.integer(catalogue$nbplaces)
catalogue$nbportes <- as.integer(catalogue$nbportes)
catalogue$couleur <- as.character(catalogue$couleur)
catalogue$occasion <- as.character(catalogue$occasion)
catalogue$prix <- as.integer(catalogue$prix)
catalogue <- na.omit(catalogue)

immatriculation$marque <- as.character(immatriculation$marque)
immatriculation$nom <- as.character(immatriculation$nom)
immatriculation$puissance <- as.integer(immatriculation$puissance)
immatriculation$longueur <- as.character(immatriculation$longueur)
immatriculation$nbplaces <- as.integer(immatriculation$nbplaces)
immatriculation$nbportes <- as.integer(immatriculation$nbportes)
immatriculation$couleur <- as.character(immatriculation$couleur)
immatriculation$occasion <- as.character(immatriculation$occasion)
immatriculation$prix <- as.integer(immatriculation$prix)
immatriculation$immatriculation <- as.character(immatriculation$immatriculation)
immatriculation <- na.omit(immatriculation)

attach(clients)


#Nettoyage age


clients <- subset(clients, clients$age >= 17)



#Nettoyage sexe



clients <- subset(clients, clients$sexe!="?" & clients$sexe!=" " & clients$sexe!="N/D")

clients$sexe <- str_replace(clients$sexe, "Homme", "M")
clients$sexe <- str_replace(clients$sexe, "Masculin", "M")
clients$sexe <- str_replace(clients$sexe, "Féminin", "F")
clients$sexe <- str_replace(clients$sexe, "Femme", "F")
clients$sexe <- as.factor(clients$sexe)
clients$sexe <- droplevels(clients$sexe)


#Nettoyage taux

clients <- subset(clients, clients$taux >= 544)



#Nettoyage situation familiale

clients <- subset(clients, clients$situationFamiliale != "?" & clients$situationFamiliale != " " & clients$situationFamiliale != "N/D")



clients$situationFamiliale <- droplevels(clients$situationFamiliale)



#Nettoyage enfants a charge


clients <- subset(clients, clients$nbEnfantsAcharge >= 0)






detach(clients)



###-------------Suppression des doublons dans le fichier immatriculations

doublons <- which(duplicated(immatriculation$immatriculation))
immatriculation<-immatriculation[-doublons,]


#-------------------- Categories de voitures

#--creation de 6 categories (citadine, compact, routière, familiale, sportive, berline)

catalogue$categories <- ifelse(catalogue$longueur=="courte","citadine",
                               ifelse(catalogue$longueur=="moyenne","compacte",
                                      ifelse(catalogue$longueur=="longue"& catalogue$nbPlaces== 5& catalogue$puissance<180,"routi?re",
                                             ifelse(catalogue$longueur=="longue"&catalogue$nbPlaces== 7&catalogue$puissance<180,"familiale",
                                                    ifelse(catalogue$longueur=="longue" | catalogue$longueur=="très longue" & catalogue$puissance >180 & catalogue$puissance <300,"sportive",
                                                           ifelse(catalogue$longueur == "très longue" & catalogue$puissance >300, "berline","rien"))))))


#------ applications au fichiers Immatriculation.csv



immatriculation$categories <- ifelse(immatriculation$longueur=="courte","citadine",
                                     ifelse(immatriculation$longueur=="moyenne","compacte",
                                            ifelse(immatriculation$longueur=="longue"& immatriculation$nbPlaces== 5& immatriculation$puissance<180,"routière",
                                                   ifelse(immatriculation$longueur=="longue"&immatriculation$nbPlaces== 7&immatriculation$puissance<180,"familiale",
                                                          ifelse(immatriculation$longueur=="longue" | immatriculation$longueur=="très longue" & immatriculation$puissance >180 & immatriculation$puissance <300,"sportive",
                                                                 ifelse(immatriculation$longueur == "très longue" & immatriculation$puissance >300, "berline","rien"))))))


#----- fusion du fichiers client et Immatriculation

clients_immatriculations <- merge(immatriculation, clients , by ="immatriculation")
# fusionne les data frames x et y par la colonne immmatriculation.





#----mise en forme des données
#-------- suppresion de  la première colonne immatriculation car c'est une variable inutile----
clients_immatriculations<-clients_immatriculations[,-1]

clients_immatriculations <- subset(clients_immatriculations, select = -marque)
clients_immatriculations <- subset(clients_immatriculations, select = -nom)
clients_immatriculations <- subset(clients_immatriculations, select = -puissance)
clients_immatriculations <- subset(clients_immatriculations, select = -longueur)
clients_immatriculations <- subset(clients_immatriculations, select = -nbPlaces)
clients_immatriculations <- subset(clients_immatriculations, select = -nbPortes)
clients_immatriculations <- subset(clients_immatriculations, select = -couleur)
clients_immatriculations <- subset(clients_immatriculations, select = -occasion)
clients_immatriculations <- subset(clients_immatriculations, select = -prix)



####-----transformation des données en facteur-----


clients_immatriculations$categories <- as.factor(clients_immatriculations$categories)
clients_immatriculations$age <- as.factor(clients_immatriculations$age)
clients_immatriculations$sexe <- as.factor(clients_immatriculations$sexe)
clients_immatriculations$situationFamiliale <- as.factor(clients_immatriculations$situationFamiliale)
clients_immatriculations$nbEnfantsAcharge <- as.factor(clients_immatriculations$nbEnfantsAcharge)
clients_immatriculations$X2eme.voiture <- as.factor(clients_immatriculations$X2eme.voiture)


##############################
#                            #
#     3eme jeu de test       #
#                            #
##############################

#Ce dernier jeu de donnees a pour but de faire coincider les variables entre le  fichier Marketing et clients_immatriculation
#afin de faire apparaitre le taux pour C5.0

##------ creation de deux nouveaux assembles d'apprentissage et de test
clients_immatriculations_EA3 <- clients_immatriculations[1:29014,]

clients_immatriculations_ET3 <- clients_immatriculations[29015:43521,]


# Apprentissage du classifeur de type arbre de decision
treeCFinal <- C5.0(categories ~., clients_immatriculations_EA3)

print(treeCFinal)

C_classFinal <- predict(treeCFinal, clients_immatriculations_ET3, type="class")

table(C_classFinal)
# berline citadine compacte routière sportive 
# 2199     4739      911     2250     4408 

table(clients_immatriculations_ET3$categories, C_classFinal)
##          berline citadine compacte routière sportive
##berline     2149        3        1      534     1418
##citadine       4     4182      457        1        2
##compacte       1      544      451        2        3
##routière      25        6        0     1290      172
##sportive      20        4        2      423     2813

# Test du classifieur : probabilites pour chaque prediction
c_probFinal <- predict(treeCFinal, clients_immatriculations_ET3, type="prob")

# Calcul de l'AUC
c_aucFinal <-multiclass.roc(clients_immatriculations_ET3$categories, c_probFinal)
print (c_aucFinal)

#
#Call:
#  multiclass.roc.default(response = clients_immatriculations_ET3$categories,     predictor = c_probFinal)
#
#Data: multivariate predictor c_probFinal with 5 levels of clients_immatriculations_ET3$categories: berline, citadine, compacte, routière, sportive.
#Multi-class area under the curve: 0.9471


#--------------------------------#
# APPLICATION DE LA METHODE C5.0 #
#--------------------------------#


# Visualisation des donnees a predire
View(marketing)

####-----transformation des donnees en facteur-----
marketing$X2eme.voiture <- marketing$X2eme.voiture %>% str_to_upper()

marketing$age <- as.factor(marketing$age)

marketing$taux <- as.factor(marketing$taux)

marketing$nbEnfantsAcharge <- as.factor(marketing$nbEnfantsAcharge)


#=== C5.0 ===#
class.treeCpred <- predict(treeCFinal, marketing)

class.treeCpred

resultat1 <- data.frame(marketing, class.treeCpred)

names(resultat1)[7]= ("Catégorie prédite")

View(resultat1)

