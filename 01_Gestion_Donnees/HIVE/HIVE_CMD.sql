[oracle@bigdatalite ~]$ beeline
Beeline version 1.1.0-cdh5.4.0 by Apache Hive

-- Connexion à Hive
beeline> !connect jdbc:hive2://localhost:10000

-- identifiants: oracle/welcome1

-- Supprimer la table MARKETING si elle existe déjà
drop table MARKETING;

-- Création de la table externe MARKETING pointant vers la table MARKETING de ORACLE NOSQL (kv)
CREATE EXTERNAL TABLE MARKETING(
    CLIENTMARKETINGID int,
    AGE string ,
    SEXE string,
    TAUX string,
    SITUATIONFAMILIALE string,
    NBENFANTSACHARGE string,
    DEUXIEMEVOITURE string
)
STORED BY 'oracle.kv.hadoop.hive.table.TableStorageHandler'
TBLPROPERTIES (
"oracle.kv.kvstore" = "kvstore",
"oracle.kv.hosts" = "bigdatalite.localdomain:5000",
"oracle.kv.hadoop.hosts" = "bigdatalite.localdomain/127.0.0.1",
"oracle.kv.tableName" = "MARKETING");

-- Vérification du contenu de la table MARKETING externe dans HIVE
select *
from MARKETING;

-- Supprimer la table IMMATRICULATION si elle existe déjà
jdbc
:hive2://localhost:10000>
drop table IMMATRICULATION;

-- Création de la table externe IMMATRICULATION pointant vers la table IMMATRICULATION de ORACLE NOSQL (kv)
jdbc
:hive2://localhost:10000> CREATE
EXTERNAL TABLE IMMATRICULATION(
    IMMATRICULATION string,
    MARQUE string,
    NOM string,
    PUISSANCE string,
    LONGUEUR string,
    NBPLACES string,
    NBPORTES string,
    COULEUR string,
    OCCASION string,
    PRIX string
)
STORED BY 'oracle.kv.hadoop.hive.table.TableStorageHandler'
TBLPROPERTIES (
"oracle.kv.kvstore" = "kvstore",
"oracle.kv.hosts" = "bigdatalite.localdomain:5000",
"oracle.kv.hadoop.hosts" = "bigdatalite.localdomain/127.0.0.1",
"oracle.kv.tableName" = "IMMATRICULATION");

-- Vérification du contenu de la table IMMATRICULATION externe dans HIVE
0: jdbc:hive2://localhost:10000>
select *
from IMMATRICULATION;


drop table CATALOGUE;

-- marque,nom,puissance,longueur,nbPlaces,nbPortes,couleur,occasion,prix
CREATE EXTERNAL TABLE CATALOGUE (
    MARQUE string,
    NOM string ,
    PUISSANCE string,
    LONGUEUR string,
    NBPLACES string,
    NBPORTES string,
    COULEUR string,
    OCCASION string,
    PRIX string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE LOCATION 'hdfs:/user/cao/projetMBDS/Catalogue';

-- 7.2.2.4 v�rifications
-- v�rifier la pr�sence des lignes et de la table
select * from CATALOGUE;
