<h1>Visualizzazione della Abilità col danno maggiore</h>

```
SELECT abilita.nome as Abilità, abilita.danno
FROM abilita
ORDER BY abilita.danno DESC
LIMIT 1
```
<p align="center">
<img src="/Immagini/Operazioni/o5.png" width="400" height="400" center>
</p>