install.packages("RJDBC")

library(RJDBC)


##classPath : add path to drivers jdbc

drv <- RJDBC::JDBC(driverClass = "oracle.jdbc.OracleDriver", classPath =  
                     Sys.glob("C:/Logiciels/Oracle/Oracle/drivers/*"))

#Connexion OK
conn <- dbConnect(drv, "jdbc:oracle:thin:@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)
                  (HOST=144.21.67.201)(PORT=1521))(CONNECT_DATA=
                  (SERVICE_NAME=pdbest21.631174089.oraclecloud.internal)))",
                  "GUINALDO2B20", "DBAMANAGER1")

#Enregistrement de la table Marketing  dans Oracle
Marketing <- read.csv("C:/Users/v.guinaldo/Desktop/test redécoupage/test/Marketing.csv", header = TRUE, 
                      sep = ",", dec = ".")
names(Marketing)[6] = ("deuxiemeVoiture")

dbWriteTable(conn,"Marketing",Marketing,   
             rownames=FALSE, overwrite = TRUE, append = FALSE)




#Enregistrement de la table Catalogue dans  Oracle
Catalogue <- read.csv("C:/Users/v.guinaldo/Desktop/test redécoupage/test/Catalogue.csv", header = TRUE, 
                      sep = ",", dec = ".")


dbWriteTable(conn,"Catalogue",Catalogue,   
             rownames=FALSE, overwrite = TRUE, append = FALSE)

#Enregistrement de la table Client dans  Oracle
Client <- read.csv("C:/Users/v.guinaldo/Desktop/test redécoupage/test/Clients_6.csv", header = TRUE, 
                   sep = ",", dec = ".")

names(Client)[6] = ("deuxiemeVoiture")

Client$age <- as.integer(Client$age)
Client$taux <- as.integer(Client$taux)
Client$nbEnfantsAcharge <- as.integer(Client$nbEnfantsAcharge)

dbWriteTable(conn,"Client",Client,   
             rownames=FALSE, overwrite = TRUE, append = FALSE)


#Visualisation des tables
allTables <- dbGetQuery(conn, "SELECT owner, table_name FROM all_tables where 
                        owner = 'GUINALDO2B20'")

MarketingDB <- dbGetQuery(conn, "select * from Marketing")
CatalogueDB <- dbGetQuery(conn, "select * from Catalogue")
ClientsDB <- dbGetQuery(conn,"select * from Client")

write.table(ClientsDB, file='Client.csv', sep=",", dec=".", row.names = F)
write.table(CatalogueDB, file='Catalogue.csv', sep=",", dec=".", row.names = F)
write.table(MarketingDB, file='Marketing.csv', sep=",", dec=".", row.names = F)

immatriculation <- read.csv("Immatriculations.csv", header = TRUE, sep = ",", dec = ".")

doublons <- which(duplicated(immatriculation$immatriculation))
immatriculation<-immatriculation[-doublons,]

immatriculation1<-immatriculation[1:1000000,]
immatriculation2<-immatriculation[1000001:1996632,]



immatriculation <- subset(immatriculation, select = -prix)
immatriculation <- subset(immatriculation, select = -puissance)
immatriculation <- subset(immatriculation, select = -longueur)
immatriculation <- subset(immatriculation, select = -nbPlaces)
immatriculation <- subset(immatriculation, select = -nbPortes)
immatriculation <- subset(immatriculation, select = -couleur)
immatriculation <- subset(immatriculation, select = -occasion)

write.table(immatriculation1, file='D:/ImmatriculationNettoyée1.csv', sep=",", dec=".", row.names = F)
write.table(immatriculation2, file='D:/ImmatriculationNettoyée2.csv', sep=",", dec=".", row.names = F)



#Enregistrement de la table Client dans  Oracle
Client8 <- read.csv("C:/Clients_8.csv", header = TRUE, 
                   sep = ",", dec = ".")

names(Client6)[6] = ("deuxiemeVoiture")

Client6$age <- as.integer(Client6$age)
Client6$taux <- as.integer(Client6$taux)
Client6$nbEnfantsAcharge <- as.integer(Client6$nbEnfantsAcharge)

dbWriteTable(conn,"ClientHu",Client6,   
             rownames=FALSE, overwrite = TRUE, append = FALSE)

ClientsDB8 <- dbGetQuery(conn,"select * from ClientHu")

write.table(ClientsDB6, file='D:/Client.csv', sep=",", dec=".", row.names = F)
