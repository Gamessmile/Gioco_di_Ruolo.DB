--Operazione 1
INSERT INTO Personaggio VALUES
(10, "Darius", 0, 5, 5);

INSERT INTO Entita (id, hp, mana, id_Personaggio) VALUES
(19, 50, 15 ,10);

--Operazione 2
INSERT INTO Abilita VALUES
(10,"Pugno infiammato", 2, 10, 20,"Sferra un pugno infiammato");

--Operazione 3
INSERT INTO Arma VALUES
(12, "Spada curva", 2, 13);

--Operazione 4
SELECT arma.nome AS Nome_Arma, COUNT(*) AS Numero_Personaggi_Che_la_usano
FROM personaggio, arma
WHERE personaggio.id_Arma=arma.id
GROUP BY personaggio.id_Arma
ORDER BY COUNT(*) DESC
LIMIT 1;

--Operazione 5
SELECT abilita.nome as Abilità, abilita.danno
FROM abilita
ORDER BY abilita.danno DESC
LIMIT 1

--Operazione 6
SELECT AVG(personaggio.livello) AS LivelloMedio
FROM personaggio
