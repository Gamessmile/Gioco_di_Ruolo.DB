SELECT arma.nome AS Nome_Arma, COUNT(*) AS Numero_Personaggi_Che_la_usano
FROM personaggio, arma
WHERE personaggio.id_Arma=arma.id
GROUP BY personaggio.id_Arma
ORDER BY COUNT(*) DESC
LIMIT 1;