


#import des fichiers
co2mapreduce <- read.csv("C:/Users/c.poirier/Desktop/new/ProjetVoiture/DATA/Mapreduce.csv", 
                         header = FALSE, sep = ",", dec = ".")
catalogue <- read.csv("C:/Users/c.poirier/Desktop/new/ProjetVoiture/DATA/Catalogue.csv", 
                      header = TRUE, sep = ",", dec = ".")
View(co2mapreduce)
View(catalogue)





#Rename les 3 colonnes
colnames(co2mapreduce) <- c("marque","Bonus/Malus","Rejet","Cout Energie")

#Lower cas pour la colonne marge
co2mapreduce$marque = tolower(co2mapreduce$marque)
catalogue$marque = tolower(catalogue$marque)




#Fusion des fichiers Mapreduce.csv et Catalogue.csv :
catalogue_modifie <- merge(catalogue,co2mapreduce, by= "marque", all = TRUE)




#Suppression des voitures qui ne sont pas dans le catalogue iniatialement
catalogue_modifie[is.na(catalogue_modifie)] <- 0
catalogue_modifie <- catalogue_modifie[catalogue_modifie[,2]!=0,]
View(catalogue_modifie)



#Export du fichier
write.table(catalogue_modifie, file = 'C:/Users/c.poirier/Desktop/new/ProjetVoiture/DATA/Catalogue_Modifie.csv', 
            sep=",", dec = ".", row.names = F, quote = F)





