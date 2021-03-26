export MYPROJECTHOME=/home/CAO/

-- suppressionn du fichier si on souhaite le remplacer
hadoop fs -rm -r /user/cao

hadoop fs -mkdir /user/cao
hadoop fs -mkdir /user/cao/projetMBDS
hadoop fs -mkdir /user/cao/projetMBDS/Catalogue

hadoop fs -put $MYPROJECTHOME/projetMBDS/Catalogue.csv /user/cao/projetMBDS/Catalogue

hadoop fs -ls /user/cao/projetMBDS/Catalogue