sqlplus CAOBZ2021@ORCL/CAOBZ202101

DROP TABLE CLIENT;

CREATE TABLE CLIENT(
  AGE varchar2(30), 
  SEXE varchar2(30), 
  TAUX varchar2(30), 
  SITUATIONFAMILIALE varchar2(30), 
  NBENFANTSACHARGE varchar2(30), 
  XVOITURE varchar2(30), 
  IMMATRICULATION varchar2(30)
);

exit

--Table : client
sqlldr CAOBZ2021@ORCL/CAOBZ202101 control=$MYPROJECTHOME/projetMBDS/SQLLOADER/control_clients.ctl 
  log=$MYPROJECTHOME/projetMBDS/SQLLOADER/track_clients.log skip=1

sqlplus CAOBZ2021@ORCL/CAOBZ202101

select * from CLIENT LIMIT 10;
