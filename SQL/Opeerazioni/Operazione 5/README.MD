![Visualizzazione della Abilità col danno maggiore](/Immagini/Operazioni/o5.png)

```
SELECT abilita.nome as Abilità, abilita.danno
FROM abilita
ORDER BY abilita.danno DESC
LIMIT 1
```
