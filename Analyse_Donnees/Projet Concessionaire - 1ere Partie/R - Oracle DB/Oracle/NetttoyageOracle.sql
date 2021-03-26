####----Opérations sur la variable age :

delete from clientHu where age < 18 ;

####----Opérations sur la variable sexe :

On réalise un update pour mettre toute les données au bon format :

UPDATE clientHu SET clientHu.sexe ='M' WHERE sexe = 'Masculin' OR sexe='Homme' ;
UPDATE clientHu SET clientHu.sexe ='F' WHERE sexe = 'Féminin' OR sexe='Femme' ;

Maintenant on supprime les données qui ne sont pas au bon format :

delete from clientHu where sexe != 'M' And sexe != 'F' ;

####----Opérations sur la variable taux :

delete from clientHu where taux < 544 ;

####----Opérations sur la variable situation situationfamiliale :

delete from clientHu
where situationfamiliale != 'Célibataire'
AND  situationfamiliale != 'Divorcée'
AND situationfamiliale != 'En Couple'
AND situationfamiliale != 'Marié(e)'
AND situationfamiliale != 'Seul'
AND situationfamiliale != 'Seule';

####----Opérations sur la variable nombreEnfantsAcharge

delete from clientHu where nbenfantsacharge <0;

####----Opérations sur la variable X2èmevoiture

delete from clientHu where deuxiemevoiture !='true' and deuxiemevoiture !='false';
