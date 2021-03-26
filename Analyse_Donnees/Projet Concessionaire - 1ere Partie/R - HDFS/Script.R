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


##----import des divers fichiers csv---------


immatriculation <- read.csv("Immatriculations.csv", header = TRUE, sep = ",", dec = ".")
catalogue <- read.csv("Catalogue.csv", header = TRUE, sep = ",", dec = ".")
marketing <- read.csv("Marketing.csv", header = TRUE, sep = ",", dec = ".")
clients <- read.csv("Clients_6.csv", header = TRUE, sep = ",", dec = ".")



#----------------------------------------DÈBUT ANALYSE EXPLORATOIRE DES DONNEES

#Affichage du nom des variables
names(immatriculation)

#res:  [1] "immatriculation" "marque"          "nom"             "puissance"       "longueur"        "nbPlaces"        "nbPortes"       
#[8] "couleur"         "occasion"        "prix"

names(clients)

#res : [1] "age"                "sexe"               "taux"               "situationFamiliale" "nbEnfantsAcharge"   "X2eme.voiture"     
#[7] "immatriculation" 

#Statistiques √©l√©mentaires

summary(immatriculation)

##immatriculation       marque              nom              puissance     longueur            nbPlaces    nbPortes    
##Length:2000000     Length:2000000     Length:2000000     Min.   : 55   Length:2000000     Min.   :5   Min.   :3.000  
##Class :character   Class :character   Class :character   1st Qu.: 75   Class :character   1st Qu.:5   1st Qu.:5.000  
#Mode  :character   Mode  :character   Mode  :character   Median :150   Mode  :character   Median :5   Median :5.000  
                                                          #Mean   :199                      Mean   :5   Mean   :4.868  
                                                          #3rd Qu.:245                      3rd Qu.:5   3rd Qu.:5.000  
                                                          #Max.   :507                      Max.   :5   Max.   :5.000  
#couleur            occasion              prix       
#Length:2000000     Length:2000000     Min.   :  7500  
#Class :character   Class :character   1st Qu.: 18310  
#Mode  :character   Mode  :character   Median : 25970  
                                      #Mean   : 35783  
                                      #3rd Qu.: 49200  
                                      #Max.   :101300 



#####Histogramme et tables d'effectifs
qplot(longueur, data = immatriculation)

qplot(longueur, data = immatriculation)
qplot(nbPlaces, data = immatriculation)
qplot(nbPortes, data = immatriculation)
qplot(marque, data = immatriculation)
qplot(couleur, data = immatriculation)
qplot(occasion, data = immatriculation)


###Boites a moustache
boxplot(immatriculation$puissance , data=immatriculation, ylab="valeur de la puissance", main="Distribution de la puissance")
summary(immatriculation$puissance)
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#55      75     150     199     245     507
boxplot(immatriculation$prix , data=immatriculation, ylab="valeur du prix", main="Distribution du prix")
summary(immatriculation$prix)
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#7500   18310   25970   35783   49200  101300

boxplot(puissance~prix, data=immatriculation, ylab="valeur de la puissance", xlab="valeur du prix", main="Distribution de la puissance selon le prix", col=c("red","blue"))





D√âBUT ANALYSE EXPLORATOIRE DES DONN√âES
#Import fichier clients
clients <- read.csv("Clients_6.csv", header = TRUE, sep = ",", dec = ".")
clients$age <- as.integer(clients$age)
clients$taux <- as.integer(clients$taux)
clients$situationFamiliale <- as.factor(clients$situationFamiliale)
clients$nbEnfantsAcharge <- as.integer(clients$nbEnfantsAcharge)
clients$X2eme.voiture <- as.logical(clients$X2eme.voiture)
clients$sexe <- as.factor(clients$sexe)
clients <- na.omit(clients)

summary (clients)

###age              sexe            taux          situationFamiliale nbEnfantsAcharge X2eme.voiture   immatriculation   
###Min.   :-1.00   M       :67756   Min.   :  -1.0   En Couple  :63346    Min.   :-1.000   Mode :logical   Length:99194      
###1st Qu.:28.00   F       :29131   1st Qu.: 420.0   C√©libataire:29589    1st Qu.: 0.000   FALSE:86319     Class :character  
###Median :42.00   Homme   :  735   Median : 520.0   Seule      : 4960    Median : 1.000   TRUE :12875     Mode  :character  
###Mean   :43.73   Masculin:  679   Mean   : 607.8   Mari√©(e)   :  652    Mean   : 1.245                                     
###3rd Qu.:57.00   F√©minin :  318   3rd Qu.: 827.0   Seul       :  280    3rd Qu.: 2.000                                     
###Max.   :84.00   Femme   :  287   Max.   :1399.0   N/D        :  111    Max.   : 4.000                                     
##                 (Other) :  288                    (Other)    :  256                                                     


attach(clients)


#Nettoyage age
qplot(age, data = clients)

clients <- subset(clients, clients$age >= 17)



#Nettoyage sexe

qplot(sexe, data = clients)

clients <- subset(clients, clients$sexe!="?" & clients$sexe!=" " & clients$sexe!="N/D")

clients$sexe <- str_replace(clients$sexe, "Homme", "M")
clients$sexe <- str_replace(clients$sexe, "Masculin", "M")
clients$sexe <- str_replace(clients$sexe, "FÈminin", "F")
clients$sexe <- str_replace(clients$sexe, "Femme", "F")
clients$sexe <- as.factor(clients$sexe)
clients$sexe <- droplevels(clients$sexe)

qplot(sexe, data = clients)

#Nettoyage taux

qplot(taux, data = clients)

clients <- subset(clients, clients$taux >= 544)



#Nettoyage situation familiale

qplot(situationFamiliale, data = clients)
clients <- subset(clients, clients$situationFamiliale != "?" & clients$situationFamiliale != " " & clients$situationFamiliale != "N/D")



clients$situationFamiliale <- droplevels(clients$situationFamiliale)

qplot(situationFamiliale, data = clients)

#Nettoyage enfants a charge
qplot(nbEnfantsAcharge, data = clients)

clients <- subset(clients, clients$nbEnfantsAcharge >= 0)

qplot(nbEnfantsAcharge, data = clients)



#Resume du data frame clients
summary(clients)

#age        sexe           taux          situationFamiliale nbEnfantsAcharge X2eme.voiture   immatriculation   
#Min.   :18.00   F:13017   Min.   : 544.0   C√©libataire:13096    Min.   :0.000    Mode :logical   Length:43521      
#1st Qu.:28.00   M:30504   1st Qu.: 589.0   Divorc√©e   :   22    1st Qu.:0.000    FALSE:37915     Class :character  
#Median :42.00             Median : 893.0   En Couple  :27724    Median :1.000    TRUE :5606      Mode  :character  
#Mean   :43.83             Mean   : 901.7   Mari√©(e)   :  310    Mean   :1.245                                      
#3rd Qu.:57.00             3rd Qu.:1147.0   Seul       :  124    3rd Qu.:2.000                                      
#Max.   :84.00             Max.   :1399.0   Seule      : 2245    Max.   :4.000


detach(clients)


###-------------Suppression des doublons dans le fichier immatriculations

doublons <- which(duplicated(immatriculation$immatriculation))
immatriculation<-immatriculation[-doublons,]





qplot(longueur, data =catalogue)
qplot(nbPlaces, data = catalogue)
qplot(nbPortes, data = catalogue)
qplot(couleur, data = catalogue)
qplot(occasion, data = catalogue)

boxplot(puissance~prix, data=catalogue, ylab="valeur de la puissance", xlab="valeur du prix", main="Distribution de la puissance selon le prix")

#-------------------- Categories de voitures

#--creation de 6 categories (citadine, compact, routiËre, familiale, sportive, berline)

catalogue$categories <- ifelse(catalogue$longueur=="courte","citadine",
                               ifelse(catalogue$longueur=="moyenne","compacte",
                                      ifelse(catalogue$longueur=="longue"& catalogue$nbPlaces== 5& catalogue$puissance<180,"routi?re",
                                             ifelse(catalogue$longueur=="longue"&catalogue$nbPlaces== 7&catalogue$puissance<180,"familiale",
                                                    ifelse(catalogue$longueur=="longue" | catalogue$longueur=="trËs longue" & catalogue$puissance >180 & catalogue$puissance <300,"sportive",
                                                           ifelse(catalogue$longueur == "trËs longue" & catalogue$puissance >300, "berline","rien"))))))

#-----test permettant de voir si les categories ont bien ete implementees

catalogue[catalogue$categories=="citadine", ]
catalogue[catalogue$categories == "compacte", ]
catalogue[catalogue$categories=="routiËre", ]
catalogue[catalogue$categories=="familiale", ]
catalogue[catalogue$categories=="sportive", ]
catalogue[catalogue$categories=="berline", ]
catalogue[catalogue$categories=="rien", ]

qplot(categories, data = catalogue)
qplot(categories, data = immatriculation)

#------ applications au fichiers Immatriculation.csv



immatriculation$categories <- ifelse(immatriculation$longueur=="courte","citadine",
                                     ifelse(immatriculation$longueur=="moyenne","compacte",
                                            ifelse(immatriculation$longueur=="longue"& immatriculation$nbPlaces== 5& immatriculation$puissance<180,"routiËre",
                                                   ifelse(immatriculation$longueur=="longue"&immatriculation$nbPlaces== 7&immatriculation$puissance<180,"familiale",
                                                          ifelse(immatriculation$longueur=="longue" | immatriculation$longueur=="trËs longue" & immatriculation$puissance >180 & immatriculation$puissance <300,"sportive",
                                                                 ifelse(immatriculation$longueur == "trËs longue" & immatriculation$puissance >300, "berline","rien"))))))


#----- fusion du fichiers client et Immatriculation

clients_immatriculations <- merge(immatriculation, clients , by ="immatriculation") 
# fusionne les data frames x et y par la colonne immmatriculation.

print(clients_immatriculations)



#----mise en forme des donnÈes
#-------- suppresion de  la premiËre colonne immatriculation car c'est une variable inutile----
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
  


####-----transformation des donnÈes en facteur-----


clients_immatriculations$categories <- as.factor(clients_immatriculations$categories)
clients_immatriculations$age <- as.factor(clients_immatriculations$age)
clients_immatriculations$sexe <- as.factor(clients_immatriculations$sexe)
clients_immatriculations$situationFamiliale <- as.factor(clients_immatriculations$situationFamiliale)
clients_immatriculations$nbEnfantsAcharge <- as.factor(clients_immatriculations$nbEnfantsAcharge)
clients_immatriculations$X2eme.voiture <- as.factor(clients_immatriculations$X2eme.voiture)



##############################
#                            #
#       1er jeu de test      #
#                            #
##############################


"clients_immatriculations : sÈlection des 29014 premiËres lignes de clients_immatriculations.(70% de donnÈes)"


clients_immatriculations_EA <- clients_immatriculations[1:29014,]


"clients_immatriculations : s?lection des  derni?res lignes de clients_immatriculations.(30% de donnees)"


clients_immatriculations_ET <- clients_immatriculations[29015:43521,]

"suppression de la colonne taux de ce data-frame"
clients_immatriculations_EA <- subset(clients_immatriculations_EA, select = -taux)
clients_immatriculations_ET <- subset(clients_immatriculations_ET, select = -taux)

table(clients_immatriculations_EA$categories)
#berline citadine compacte routiËre sportive 
#8129     9302     2081     3000     6502

table(clients_immatriculations_ET$categories)
#berline citadine compacte routiËre sportive 
#4114     4635     1005     1494     3259 

#___________________#
#                   #
#       C5.0        #
#                   #
#___________________#

# Apprentissage du classifeur de type arbre de dÈcision
treeC <- C5.0(categories ~., clients_immatriculations_EA)

print(treeC)
#Call:
#  C5.0.formula(formula = categories ~ ., data
#               = clients_immatriculations_EA)
#
#Classification Tree
#Number of samples: 29014 
#Number of predictors: 5 
#
#Tree size: 8 
#
#Non-standard options: attempt to group attributes

# Test du classifieur : classe predite

C_class <- predict(treeC, clients_immatriculations_ET, type="class")

table(C_class)
##berline citadine compacte routiËre sportive 
##2931     5642        0     1145     4789 

# Matrice de confusion
table(clients_immatriculations_ET$categories, C_class)

####        berline citadine compacte routiËre sportive
##berline     2424        3        0      400     1287
##citadine       2     4632        0        0        1
##compacte       0     1003        0        1        1
##routiËre      30        3        0      744      717
##sportive     475        1        0        0     2783

##Taux d'erreur :0.270
##Rappel :
##      berline : 0.589
##      citadine:0.999
##      compacte:0
##      routiËre:0.498
##      sportive:0.854
##PrÈcision :
##      berline :0.827
##      citadine:0.821
##      routiËre:0.650
##      sportive:0.581

# Test du classifieur : probabilites pour chaque prediction
c_prob <- predict(treeC, clients_immatriculations_ET, type="prob")

# Calcul de l'AUC
c_auc <-multiclass.roc(clients_immatriculations_ET$categories, c_prob)
print (c_auc)


##Call:
##multiclass.roc.default(response = clients_immatriculations_ET$categories,     predictor = c_prob)
##
##Data: multivariate predictor c_prob with 5 levels of clients_immatriculations_ET$categories: berline, citadine, compacte, routi?re, sportive.
##Multi-class area under the curve: 0.8947

#___________________#
#                   #
#   naive bayes     #
#                   #
#___________________#

# Apprentissage du classifeur de type naive bayes
nb <- naive_bayes(categories~., clients_immatriculations_EA)

# Test du classifieur : classe predite
nb_class <- predict(nb, clients_immatriculations_ET, type="class")
table(nb_class)

##berline citadine compacte routiËre sportive 
##4012     4299      681     1145     4370


# Matrice de confusion
table( clients_immatriculations_ET$categories, nb_class)

##nb_class
##          berline citadine compacte routiËre sportive
##berline     2484       55        0      400     1175
##citadine     860     3444      330        0        1
##compacte       0      652      351        1        1
##routiËre      67       35        0      744      648
##sportive     601      113        0        0     2545

##Taux d'erreur :0.340
##Rappel :
##      berline : 0.603
##      citadine:0.743
##      compacte:0.349
##      routiËre:0.498
##      sportive:0.781
##PrÈcision :
##      berline :0.619
##      citadine:0.801
##      compacte:0.515
##      routiËre:0.650
##      sportive:0.582


# Test du classifieur : probabilites pour chaque prediction
nb_prob <- predict(nb, clients_immatriculations_ET, type="prob")



# Calcul de l'AUC
nb_auc <-multiclass.roc(clients_immatriculations_ET$categories, nb_prob)
print (nb_auc)

##Call:
##  multiclass.roc.default(response = clients_immatriculations_ET$categories,     predictor = nb_prob)
##
##Data: multivariate predictor nb_prob with 5 levels of clients_immatriculations_ET$categories: berline, citadine, compacte, routi?re, sportive.
##Multi-class area under the curve: 0.8873

#___________________#
#                   #
#       svm         #
#                   #
#___________________#

# Apprentissage du classifeur de type svm
svm <- svm(categories~., clients_immatriculations_EA, probability=TRUE)

# Test du classifieur : classe predite
svm_class <- predict(svm, clients_immatriculations_ET, type="response")
svm_class
table(svm_class)
##berline citadine compacte routiËre sportive 
##3488     5648        0      810     4561 

# Matrice de confusion
table(clients_immatriculations_ET$categories, svm_class)

##svm_class
##          berline citadine compacte routiËre sportive
##berline     2597        5        0      288     1224
##citadine       2     4632        0        0        1
##compacte       1     1003        0        0        1
##routiËre     286        4        0      522      682
##sportive     602        4        0        0     2653

##Taux d'erreur :0.28
##Rappel :
##      berline : 0.631
##      citadine:0.999
##      compacte:0
##      routiËre:0.349
##      sportive:0.814
##Pr√©cision :
##      berline :0.745
##      citadine:0.820
##      routiËre:0.644
##      sportive:0.582

# Test du classifieur : probabilites pour chaque prediction
svm_prob <- predict(svm, clients_immatriculations_ET, probability=TRUE)



# Recuperation des probabilites associees aux predictions
svm_prob <- attr(svm_prob, "probabilities")

# Conversion en un data frame 
svm_prob <- as.data.frame(svm_prob)


# Calcul de l'AUC
svm_auc <-multiclass.roc(clients_immatriculations_ET$categories, svm_prob)
print (svm_auc) 


## sCall:
##multiclass.roc.default(response = clients_immatriculations_ET$categories,     predictor = svm_prob)
##
##Data: multivariate predictor svm_prob with 5 levels of clients_immatriculations_ET$categories: citadine, berline, routi?re, sportive, compacte.
##Multi-class area under the curve: 0.9019

#___________________#
#                   #
#       kknn        #
#                   #
#___________________#

kknn<-kknn(categories~., clients_immatriculations_EA, clients_immatriculations_ET)

# Matrice de confusion
table(clients_immatriculations_ET$categories, kknn$fitted.values)

##        berline citadine compacte routiËre sportive
##berline     2579        2        1      396     1136
##citadine       2     4178      454        0        1
##compacte       1      724      279        1        0
##routi?re     400        3        0      558      533
##sportive     911        0        1      270     2077

##Taux d'erreur :0.332
##Rappel :
##      berline : 0.629
##      citadine:0.901
##      compacte:0.278
##      routiËre:0.374
##      sportive:0.637
##PrÈcision :
##      berline :0.664
##      citadine:0.851
##      compacte:0.380
##      routiËre:0.456
##      sportive:0.554

# Conversion des probabilites en data frame
knn_prob <- as.data.frame(kknn$prob)

knn_auc <-multiclass.roc(clients_immatriculations_ET$categories, knn_prob)
print(knn_auc)

##Call:
#multiclass.roc.default(response = clients_immatriculations_ET$categories,     predictor = knn_prob)
#
#Data: multivariate predictor knn_prob with 5 levels of clients_immatriculations_ET$categories: berline, citadine, compacte, routi?re, sportive.
#Multi-class area under the curve: 0.8706

#___________________#
#                   #
#       nnet        #
#                   #
#___________________#


nnet<-nnet(categories ~., clients_immatriculations_EA, size=6)

# Test du classifieur : classe predite
nn_class <- predict(nnet, clients_immatriculations_ET, type="class")
nn_class
table(nn_class)

##berline citadine compacte routiËre sportive 
##2917     5278      364     1164     4784 



# Matrice de confusion
table(clients_immatriculations_ET$categories, nn_class)

##        berline citadine compacte routiËre sportive
##berline     2414        3        0      408     1289
##citadine       2     4469      163        0        1
##compacte       0      802      201        1        1
##routiËre      19        3        0      755      717
##sportive     482        1        0        0     2776

##Taux d'erreur :0.268
##Rappel :
##      berline : 0.586
##      citadine:0.964
##      compacte:0.2
##      routi√®re:0.506
##      sportive:0.852
##PrÈcision :
##      berline :0.826
##      citadine:0.847
##      compacte:0.552
##      routiËre:0.649
##      sportive:0.580

# Test du classifieur : probabilites pour chaque prediction
nn_prob <- predict(nnet, clients_immatriculations_ET, type="raw")
nn_auc <-multiclass.roc(clients_immatriculations_ET$categories, nn_prob)
print(nn_auc)

##Call:
##multiclass.roc.default(response = clients_immatriculations_ET$categories,     predictor = nn_prob)
##
##Data: multivariate predictor nn_prob with 5 levels of clients_immatriculations_ET$categories: berline, citadine, compacte, routi?re, sportive.
##Multi-class area under the curve: 0.9076

#___________________#
#                   #
#   randomForest    #
#                   #
#___________________#

##------ on supprime la colonne age qui comporte un trop grand nombre de niveau, empechant l'execution du classifieur

clients_immatriculations_EA <- subset(clients_immatriculations_EA, select = -age)
clients_immatriculations_ET <- subset(clients_immatriculations_ET, select = -age)

RF <- randomForest(categories ~ ., data = clients_immatriculations_EA)

result.RF <- predict(RF,clients_immatriculations_ET, type="response")

table(result.RF)

##result.RF1
##berline citadine compacte routiËre sportive 
##2889     5642        0        0     5976 



table(clients_immatriculations_ET$categories, result.RF)

##result.RF
##  berline citadine compacte routiËre sportive
##berline     2411        3        0        0     1700
##citadine       2     4632        0        0        1
##compacte       0     1003        0        0        2
##routi?re       1        3        0        0     1490
##sportive     475        1        0        0     2783

##Taux d'erreur :0.323
##Rappel :
##      berline : 0.586
##      citadine:0.999
##      compacte:0
##      routiËre:0
##      sportive:0.854
##PrÈcision :
##      berline :0.835
##      citadine:0.821
##      sportive:0.466

rf_prob <- predict(RF, clients_immatriculations_ET, type="prob")


RF_auc <-multiclass.roc(clients_immatriculations_ET$categories, rf_prob)
print (RF_auc)

##Call:
##multiclass.roc.default(response = clients_immatriculations_ET$categories,     predictor = rf_prob)
##
##Data: multivariate predictor rf_prob with 5 levels of clients_immatriculations_ET$categories: berline, citadine, compacte, routi?re, sportive.
##Multi-class area under the curve: 0.6938


################################
#                            #
#     2eme jeu de test       #
#                            #
##############################


##------ creation de deux nouveaux assembles d'apprentissage et de test
clients_immatriculations_EA2 <- clients_immatriculations[1:29014,]

clients_immatriculations_ET2 <- clients_immatriculations[29015:43521,]

##-------------Creation de categorie de taux (ctaux) abaissantle nombres de niveaux de cette donnees
clients_immatriculations$taux <- as.integer(clients_immatriculations$taux)
boxplot(clients_immatriculations$taux, main = "R√©partition du taux", ylab = "euros")

summary(clients_immatriculations$taux)
##Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##544.0   589.0   893.0   901.7  1147.0  1399.0 

clients_immatriculations_EA2$ctaux<- ifelse(clients_immatriculations_EA2$taux <589, "Faible",
                                            ifelse(clients_immatriculations_EA2$taux <901.7, "Moyen",
                                                   ifelse(clients_immatriculations_EA2$taux < 1147, "ElevÈ","TrËs ElevÈ")))

clients_immatriculations_ET2$ctaux<- ifelse(clients_immatriculations_ET2$taux <589, "Faible",
                                            ifelse(clients_immatriculations_ET2$taux <901.7, "Moyen",
                                                   ifelse(clients_immatriculations_ET2$taux < 1147, "ElevÈ","TrËs ElevÈ")))


#histogramme permattant d'observer la repartition des diffferentes categories de taux dans clients_immatriculations_EA2
qplot(ctaux, data=clients_immatriculations_EA2, main = "R?partition des cat?gories de taux")

clients_immatriculations_EA2$ctaux <- as.factor(clients_immatriculations_EA2$ctaux)
clients_immatriculations_ET2$ctaux <- as.factor(clients_immatriculations_ET2$ctaux)

clients_immatriculations_EA2$taux <- as.factor(clients_immatriculations_EA2$taux)
clients_immatriculations_ET2$taux <- as.factor(clients_immatriculations_ET2$taux)

##-------------Suppression de la colonne taux

clients_immatriculations_EA2 <- subset(clients_immatriculations_EA2, select = -taux)
clients_immatriculations_ET2 <- subset(clients_immatriculations_ET2, select = -taux)

#___________________#
#                   #
#       C5.0        #
#                   #
#___________________#
# Apprentissage du classifeur de type arbre de dÈcision
treeC2 <- C5.0(categories ~., clients_immatriculations_EA2)


print(treeC2)
##Call:Call:
##C5.0.formula(formula = categories ~ ., data = clients_immatriculations_EA2)
##
##Classification Tree
##Number of samples: 29014 
##Number of predictors: 6 
##
##Tree size: 29 

##Non-standard options: attempt to group attributes

# Test du classifieur : classe predite
C_class2 <- predict(treeC2, clients_immatriculations_ET2, type="class")

table(C_class2)
##berline citadine compacte routiËre sportive 
##2333     4921      721     2359     4173 

# Matrice de confusion
table(clients_immatriculations_ET2$categories, C_class2)

##        C_class2
##          berline citadine compacte routiËre sportive
##berline     2226        2        1      545     1340
##citadine       2     4263      369        0        1
##compacte       0      652      351        1        1
##routiËre       0        3        0     1352      139
##sportive     105        1        0      461     2692

##Taux d'erreur :0.25
##Rappel :
##      berline : 0.541
##      citadine:0.92
##      compacte:0.349
##      routiËre:0.905
##      sportive:0.826
##PrÈcision :
##      berline :0.954
##      citadine:0.866
##      compacte:0.487
##      routiËre:0.573
##      sportive:0.645

# Test du classifieur : probabilites pour chaque prediction
c_prob2 <- predict(treeC2, clients_immatriculations_ET2, type="prob")



# Calcul de l'AUC
c_auc2 <-multiclass.roc(clients_immatriculations_ET2$categories, c_prob2)
print (c_auc2)

## Call:
##multiclass.roc.default(response = clients_immatriculations_ET2$categories,     predictor = c_prob2)
##
##Data: multivariate predictor c_prob2 with 5 levels of clients_immatriculations_ET2$categories: berline, citadine, compacte, routi?re, sportive.
##Multi-class area under the curve: 0.9349

#___________________#
#                   #
#   naive bayes     #
#                   #
#___________________#
# Apprentissage du classifeur de type naive bayes
nb2 <- naive_bayes(categories~., clients_immatriculations_EA2)

# Test du classifieur : classe predite
nb_class2 <- predict(nb2, clients_immatriculations_ET2, type="class")
table(nb_class2)

##berline citadine compacte routiËre sportive 
##4287     4679      778      698     4065 

# Matrice de confusion
table( clients_immatriculations_ET2$categories, nb_class2)

##nb_class2
##          berline citadine compacte routiËre sportive
##berline     2592      246        1      240     1035
##citadine     855     3374      400        0        6
##compacte       0      628      376        1        0
##routiËre     269       67        0      457      701
##sportive     571      364        1        0     2323


##Taux d'erreur :0.371
##Rappel :
##      berline : 0.63
##      citadine:0.728
##      compacte:0.374
##      routiËre:0.306
##      sportive:0.713
##PrÈcision :
##      berline :0.605
##      citadine:0.721
##      compacte:0.483
##      routiËre:0.655
##      sportive:0.571

# Test du classifieur : probabilites pour chaque prediction
nb_prob2 <- predict(nb2, clients_immatriculations_ET2, type="prob")



# Calcul de l'AUC
nb_auc2 <-multiclass.roc(clients_immatriculations_ET2$categories, nb_prob2)
print (nb_auc2)

##Call:
##multiclass.roc.default(response = clients_immatriculations_ET2$categories,     predictor = nb_prob2)
##
##Data: multivariate predictor nb_prob2 with 5 levels of clients_immatriculations_ET2$categories: berline, citadine, compacte, routi?re, sportive.
##Multi-class area under the curve: 0.915

#___________________#
#                   #
#       svm         #
#                   #
#___________________#
# Apprentissage du classifeur de type svm
svm2 <- svm(categories~., clients_immatriculations_EA2, probability=TRUE)

# Test du classifieur : classe predite
svm_class2 <- predict(svm2, clients_immatriculations_ET2, type="response")
table(svm_class2)


##berline citadine compacte routiËre sportive 
##4020     5653        0     1376     3458 

# Matrice de confusion
table(clients_immatriculations_ET2$categories, svm_class2)


##svm_class2
##        berline citadine compacte routiËre sportive
##berline     2788        5        0      217     1104
##citadine       2     4632        0        0        1
##compacte       1     1003        0        0        1
##routiËre     627        9        0      728      130
##sportive     602        4        0      431     2222

##Taux d'erreur :0.285
##Rappel :
##      berline : 0.678
##      citadine:0.999
##      compacte:0
##      routiËre:0.487
##      sportive:0.681
##PrÈcision :
##      berline :0.693
##      citadine:0.819
##      routiËre:0.529
##      sportive:0.643

# Test du classifieur : probabilites pour chaque prediction
svm_prob2 <- predict(svm2, clients_immatriculations_ET2, probability=TRUE)



# Recuperation des probabilites associees aux predictions
svm_prob2 <- attr(svm_prob2, "probabilities")

# Conversion en un data frame 
svm_prob2 <- as.data.frame(svm_prob2)


# Calcul de l'AUC
svm_auc2 <-multiclass.roc(clients_immatriculations_ET2$categories, svm_prob2)
print (svm_auc2)

##Call:
##multiclass.roc.default(response = clients_immatriculations_ET2$categories,     predictor = svm_prob2)
##
##Data: multivariate predictor svm_prob2 with 5 levels of clients_immatriculations_ET2$categories: citadine, berline, routi?re, sportive, compacte.
##Multi-class area under the curve: 0.9332

#___________________#
#                   #
#       kknn        #
#                   #
#___________________#
kknn2<-kknn(categories~., clients_immatriculations_EA2, clients_immatriculations_ET2)

# Matrice de confusion
table(clients_immatriculations_ET2$categories, kknn2$fitted.values)

##          berline citadine compacte routiËre sportive
##berline     2632        3        0      336     1143
##citadine       2     4136      496        0        1
##compacte       0      569      434        0        2
##routiËre     247        3        0      831      413
##sportive     673        1        1      318     2266

# Conversion des probabilites en data frame
knn_prob2 <- as.data.frame(kknn2$prob)

knn_auc2 <-multiclass.roc(clients_immatriculations_ET2$categories, knn_prob2)
print(knn_auc2)

## Call:
##multiclass.roc.default(response = clients_immatriculations_ET2$categories,     predictor = knn_prob2)
##
##Data: multivariate predictor knn_prob2 with 5 levels of clients_immatriculations_ET2$categories: berline, citadine, compacte, routi?re, sportive.
##Multi-class area under the curve: 0.9164

##Taux d'erreur :0.29
##Rappel :
##      berline : 0.640
##      citadine:0.892
##      compacte:0.432
##      routiËre:0.556
##      sportive:0.695
##PrÈcision :
##      berline :0.741
##      citadine:0.878
##      compacte:0.466
##      routiËre:0.56
##      sportive:0.592

#___________________#
#                   #
#       nnet        #
#                   #
#___________________#


nnet2<-nnet(categories ~., clients_immatriculations_EA2, size=7)

# Test du classifieur : classe predite
nn_class2 <- predict(nnet2, clients_immatriculations_ET2, type="class")

table(nn_class2)

## berline citadine compacte routiËre sportive 
##2403     4837      805     2185     4277 

# Matrice de confusion
table(clients_immatriculations_ET2$categories, nn_class2)

##nn_class2
##        berline citadine compacte routiËre sportive
##berline     2247        2        1      504     1360
##citadine       2     4226      406        0        1
##compacte       0      606      397        1        1
##routiËre      34        3        0     1259      198
##sportive     120        0        1      421     2717

# Test du classifieur : probabilites pour chaque prediction
nn_prob2 <- predict(nnet2, clients_immatriculations_ET2, type="raw")
nn_auc2 <-multiclass.roc(clients_immatriculations_ET2$categories, nn_prob2)
print(nn_auc2)

##Call:
##multiclass.roc.default(response = clients_immatriculations_ET2$categories,     predictor = nn_prob2)
##
##Data: multivariate predictor nn_prob2 with 5 levels of clients_immatriculations_ET2$categories: berline, citadine, compacte, routi?re, sportive.
##Multi-class area under the curve: 0.9463


##Taux d'erreur :0.25
##Rappel :
##      berline : 0.546
##      citadine:0.912
##      compacte:0.395
##      routiËre:0.843
##      sportive:0.834
##PrÈcision :
##      berline :0.935
##      citadine:0.874
##      compacte:0.493
##      routiËre:0.576
##      sportive:0.635


#___________________#
#                   #
#   randomForest    #
#                   #
#___________________#
##------ on supprime la colonne age qui comporte un trop grand nombre de niveau, emp√™chant l'ex√©cution du classifieur
clients_immatriculations_EA2 <- subset(clients_immatriculations_EA2, select = -age)
clients_immatriculations_ET2 <- subset(clients_immatriculations_ET2, select = -age)

RF2 <- randomForest(categories ~ ., data = clients_immatriculations_EA2)

result.RF2 <- predict(RF2,clients_immatriculations_ET2, type="response")

table(result.RF2)

##result.RF2
##result.RF2
##berline citadine compacte routiËre sportive 
##2170     5642        0     1458     5237 


table(clients_immatriculations_ET2$categories, result.RF2)

##result.RF2
##          berline citadine compacte routiËre sportive
##berline     2078        3        0      231     1802
##citadine       2     4632        0        0        1
##compacte       0     1003        0        0        2
##routiËre       0        3        0      766      725
##sportive      90        1        0      461     2707


##Taux d'erreur :0.298
##Rappel :
##      berline : 0.505
##      citadine:0.999
##      compacte:0
##      routiËre:0.513
##      sportive:0.831
##PrÈcision :
##      berline :0.958
##      citadine:0.821
##      routiËre:0.525
##      sportive:0.517

rf_prob2 <- predict(RF2, clients_immatriculations_ET2, type="prob")


RF2_auc <-multiclass.roc(clients_immatriculations_ET2$categories, rf_prob2)
print (RF2_auc)

##Call:
##multiclass.roc.default(response = clients_immatriculations_ET2$categories,     predictor = rf_prob2)
##
##Data: multivariate predictor rf_prob2 with 5 levels of clients_immatriculations_ET2$categories: berline, citadine, compacte, routi?re, sportive.
##Multi-class area under the curve: 0.8156


##############################
#                            #
#       resume des auc       #
#                            #
##############################





##              1er jeu de test         2eme jeu de test
##C5.0          0.8947                  0.9349
##naive-bayes   0.8873                  0.915
##svm           0.9019                  0.9332
##kknn          0.87                    0.9164 
##nnet          0.9076                  0.9463
##randomforest  0.6938                  0.8156
##

##############################
#                            #
# resume des taux d'erreur   #
#                            #
##############################

##              1er jeu de test         2eme jeu de test
##C5.0          0.27                     0.25
##naive-bayes   0.34                     0.37
##svm           0.28                     0.285
##kknn          0.33                     0.29 
##nnet          0.268                    0.25
##randomforest  0.323                    0.298
##


##au vu des differents auc et taux d'erreurs le classifieur le plus perfomant est C5.0.
##En effet meme si nnet permet d avoir un meilleur auc, le fait que le calcul qui accompagne ce classifieur
##soit trop lent par rapport a C5.0

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
##Call:
##        C5.0.formula(formula = categories ~ ., data = clients_immatriculations_EA)

## Classification Tree
## Number of samples: 29014 
## Number of predictors: 7 

## Tree size: 7 

## Non-standard options: attempt to group attributes
# Test du classifieur : classe predite

C_classFinal <- predict(treeCFinal, clients_immatriculations_ET3, type="class")

table(C_classFinal)
##berline citadine compacte routiËre sportive 
##2160     4703      939     2640     4065 

# Matrice de confusion
table(clients_immatriculations_ET3$categories, C_classFinal)

##        berline citadine compacte routiËre sportive
##berline     2155        2        1      571     1385
##citadine       2     4162      470        0        1
##compacte       0      536      467        1        1
##routi?re       0        3        0     1489        2
##sportive       3        0        1      579     2676

##Taux d'erreur :0.245
##Rappel :
##      berline : 0.524
##      citadine:0.898
##      compacte:0.465
##      routiËre:0.997
##      sportive:0.821
##PrÈcision :
##      berline :0.998
##      citadine:0.884
##      compacte:0.497
##      routiËre:0.564
##      sportive:0.658

# Test du classifieur : probabilites pour chaque prediction
c_probFinal <- predict(treeCFinal, clients_immatriculations_ET3, type="prob")

# Calcul de l'AUC
c_aucFinal <-multiclass.roc(clients_immatriculations_ET3$categories, c_probFinal)
print (c_aucFinal)

##Call:
##  multiclass.roc.default(response = clients_immatriculations_ET3$categories,     predictor = c_probFinal)
##
##Data: multivariate predictor c_probFinal with 5 levels of clients_immatriculations_ET3$categories: berline, citadine, compacte, routi?re, sportive.
##Multi-class area under the curve: 0.9505


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

names(resultat1)[7]= ("CatÈgorie prÈdite")

#---------------------------------#
# ENREGISTREMENT DES PREDICTIONS  #
#---------------------------------#
# Enregistrement du fichier de resultats au format csv
write.table(resultat1, file='predictions.csv', sep="\t", dec=".", row.names = F)
