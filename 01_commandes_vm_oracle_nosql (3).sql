-------------------------------------------------------
-- Import du fichier Marketing.csv dans ORACLE NOSQL --
-------------------------------------------------------

-- Sur la machine virtuelle Oracle@BigDataLite (en local)

-- Dans un invite de commandes : 
 
    -- Ceci est le chemin vers notre projet sur la machine virtuelle
    [oracle@bigdatalite ~]$ export MYPROJECTHOME=/home/CAO/projetMBDS/

    -- Compiler le code java pour importer la table MARKETING à partir du fichier csv
    [oracle@bigdatalite ~]$ javac -g -cp $KVHOME/lib/kvclient.jar:$MYPROJECTHOME/ $MYPROJECTHOME/voiture/DataImportMarketing.java

    -- Executer le code java pour importer la table MARKETING à partir du fichier csv
    [oracle@bigdatalite ~]$ java -Xmx256m -Xms256m  -cp $KVHOME/lib/kvclient.jar:$MYPROJECTHOME/ voiture.DataImportMarketing

/*

****** Dans : executeDDL ********
===========================
Statement was successful:
        drop table MARKETING
Results:
        Plan DropTable MARKETING
Id:                    3621
State:                 SUCCEEDED
Attempt number:        1
Started:               2021-03-22 11:00:42 UTC
Ended:                 2021-03-22 11:00:52 UTC
Total tasks:           3
 Successful:           3

****** Dans : executeDDL ********
===========================
Statement was successful:
        Create table MARKETING (CLIENTMARKETINGID INTEGER,AGE STRING,SEXE STRING,TAUX STRING,SITUATIONFAMILIALE STRING,NBENFANTSACHARGE STRING,DEUXIEMEVOITURE STRING,PRIMARY KEY (CLIENTMARKETINGID))
Results:
        Plan CreateTable MARKETING
Id:                    3622
State:                 SUCCEEDED
Attempt number:        1
Started:               2021-03-22 11:00:54 UTC
Ended:                 2021-03-22 11:00:54 UTC
Total tasks:           1
 Successful:           1

********************************** Dans : loadmarketingDataFromFile *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************

*/

-- Connection à Oracle NoSQL
[oracle@bigdatalite ~]$ java -jar $KVHOME/lib/kvstore.jar runadmin -port 5000 -host bigdatalite.localdomain

kv-> connect store -name kvstore

-- Vérification du contenu de la table MARKETING
kv-> get table -name MARKETING

-- Réponse :
{"CLIENTMARKETINGID":16,"AGE":"60","SEXE":"M","TAUX":"524","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"true"}
{"CLIENTMARKETINGID":3,"AGE":"35","SEXE":"M","TAUX":"223","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":4,"AGE":"48","SEXE":"M","TAUX":"401","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":21,"AGE":"59","SEXE":"M","TAUX":"748","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"true"}
{"CLIENTMARKETINGID":10,"AGE":"64","SEXE":"M","TAUX":"559","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":1,"AGE":"age","SEXE":"sexe","TAUX":"taux","SITUATIONFAMILIALE":"situationFamiliale","NBENFANTSACHARGE":"nbEnfantsAcharge","DEUXIEMEVOITURE":"2eme voiture"}
{"CLIENTMARKETINGID":9,"AGE":"43","SEXE":"F","TAUX":"431","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":15,"AGE":"34","SEXE":"F","TAUX":"1112","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":13,"AGE":"55","SEXE":"M","TAUX":"588","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":5,"AGE":"26","SEXE":"F","TAUX":"420","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"3","DEUXIEMEVOITURE":"true"}
{"CLIENTMARKETINGID":6,"AGE":"80","SEXE":"M","TAUX":"530","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"3","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":12,"AGE":"79","SEXE":"F","TAUX":"981","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"2","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":14,"AGE":"19","SEXE":"F","TAUX":"212","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":19,"AGE":"54","SEXE":"F","TAUX":"452","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"3","DEUXIEMEVOITURE":"true"}
{"CLIENTMARKETINGID":20,"AGE":"35","SEXE":"M","TAUX":"589","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":7,"AGE":"27","SEXE":"F","TAUX":"153","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"2","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":8,"AGE":"59","SEXE":"F","TAUX":"572","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"2","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":17,"AGE":"22","SEXE":"M","TAUX":"411","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"3","DEUXIEMEVOITURE":"true"}
{"CLIENTMARKETINGID":2,"AGE":"21","SEXE":"F","TAUX":"1396","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":11,"AGE":"22","SEXE":"M","TAUX":"154","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"1","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":18,"AGE":"58","SEXE":"M","TAUX":"1192","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}

21 rows returned


/*
Ici, nous remarquons que la ligne avec CLIENTMARKETINGID:1 est la ligne des entêtes qui n'aurait pas dû être importée. 
Nous décidons de la laisser et de la trier plus tard, quand la table MARKETING aura été importée dans HIVE puis dans Oracle SQL.
*/

