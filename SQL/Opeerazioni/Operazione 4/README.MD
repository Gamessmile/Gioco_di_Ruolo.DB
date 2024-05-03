<h1>Visualizzazione dell’Arma posseduta da più Personaggio</h1>

```
SELECT arma.nome AS Nome_Arma, COUNT(*) AS Numero_Personaggi_Che_la_usano
FROM personaggio, arma
WHERE personaggio.id_Arma=arma.id
GROUP BY personaggio.id_Arma
ORDER BY COUNT(*) DESC
LIMIT 1;
```
<p align="center">
<img src="/Immagini/Operazioni/o4.png" width="400" height="400" center>
</p>