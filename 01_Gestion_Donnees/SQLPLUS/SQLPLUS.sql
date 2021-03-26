sqlplus CAOBZ2021@ORCL/CAOBZ202101;


drop table CATALOGUE;

CREATE TABLE CATALOGUE
(
    MARQUE    varchar2(30),
    NOM       varchar2(30),
    PUISSANCE varchar2(30),
    LONGUEUR  varchar2(30),
    NBPLACES  varchar2(30),
    NBPORTES  varchar2(30),
    COULEUR   varchar2(30),
    OCCASION  varchar2(30),
    PRIX      varchar2(30)
) ORGANIZATION EXTERNAL (
    TYPE ORACLE_HIVE
    DEFAULT DIRECTORY ORACLE_BIGDATA_CONFIG ACCESS PARAMETERS (
    com.oracle.bigdata.tablename=default.CATALOGUE
    )
)
REJECT LIMIT UNLIMITED;

SELECT * FROM CATALOGUE where rownum > 1 and rownum < 4;

drop table MARKETING;

CREATE TABLE MARKETING
(
    CLIENTMARKETINGID  INTEGER,
    AGE                varchar2(30),
    SEXE               varchar2(30),
    TAUX               varchar2(30),
    SITUATIONFAMILIALE varchar2(30),
    NBENFANTSACHARGE   varchar2(30),
    DEUXIEMEVOITURE    varchar2(30)
) ORGANIZATION EXTERNAL (
    TYPE ORACLE_HIVE
    DEFAULT DIRECTORY ORACLE_BIGDATA_CONFIG ACCESS PARAMETERS (
    com.oracle.bigdata.tablename=default.MARKETING
    )
)
REJECT LIMIT UNLIMITED;

SELECT * FROM MARKETING FETCH FIRST 2 ROWS ONLY;

drop table IMMATRICULATION;

CREATE TABLE IMMATRICULATION
(
    IMMATRICULATION varchar2(30),
    MARQUE          varchar2(30),
    NOM             varchar2(30),
    PUISSANCE       varchar2(30),
    LONGUEUR        varchar2(30),
    NBPLACES        varchar2(30),
    NBPORTES        varchar2(30),
    COULEUR         varchar2(30),
    OCCASION        varchar2(30),
    PRIX            varchar2(30)
) ORGANIZATION EXTERNAL (
    TYPE ORACLE_HIVE
    DEFAULT DIRECTORY ORACLE_BIGDATA_CONFIG ACCESS PARAMETERS (
    com.oracle.bigdata.tablename=default.IMMATRICULATION
    )
)
REJECT LIMIT UNLIMITED;

SELECT * FROM IMMATRICULATION FETCH FIRST 2 ROWS ONLY;
