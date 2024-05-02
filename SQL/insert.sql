INSERT INTO Arma VALUES
(0, "Tirapugni", 1, 2),
(1, "Picca", 2, 3),
(2, "Arco", 3, 4),
(3, "Shotel", 1, 4),
(4, "Alabarda", 2, 5),
(5, "Ascia", 1, 7),
(6, "Claymore", 2, 7),
(7, "Zweihander", 2, 10),
(8, "Balestra Mezzaluna", 3, 11),
(9, "Arco SpezzaScudi", 3, 12),
(10, "Falce delle nubi", 2, 15),
(11, "Spadone sacro di Artis", 2, 20);

INSERT INTO Giocatore VALUES
(0, "Gabriel", "Rossi"),
(1, "Sara", "Sciacca"),
(2, "Manuel", "Monticatti");

INSERT INTO Personaggio VALUES
(0, "Adventurier Mag", 0, 3, 0),
(1, "Pientolo", 0, 4, 1),
(2, "Algiova", 2, 5, 3),
(3, "Destroyer", 0, 4, 2),
(4, "Solaire", 1, 7, 6),
(5, "San Giuds", 0, 2, 0),
(6, "Artorias", 2, 10, 11),
(7, "Marušić", 0, 5, 5),
(8, "Kamada", 0, 6, 3),
(9, "Exa", 1, 12, 10);

INSERT INTO Nemico VALUES
(0,"Goblin"),
(1,"Umano"),
(2,"Gargolla"),
(3,"Zombie"),
(4,"Cavaliere [BOSS]"),
(5,"Guardiano della Luce [BOSS]"),
(6,"Sanguisuga"),
(7,"Mercenario"),
(8,"Satan");

INSERT INTO Abilita VALUES
(0,"Attacco con arma", null, null, null,"Effettua un attacco con l'arma"),
(1,"Palla di fuoco", 3, 3, 2,"Lancia una sfera infiammata"),
(2,"Fiamma Sopita", 1, 6, 10,"Provoca una esplosione di fiamme ravvicinata"),
(3,"Palla d'Acqua", 3, 2, 1,"Lancia una sfera d'acqua"),
(4,"Fendente Fulmineo", 2, 5, 5,"Un piccolo fulmine sprigionato dai palmi delle mani"),
(5,"Luce Solenne", 1, 10, 15,"Sprigiona una luce talmente intensa da infliggere danno"),
(6,"Tsunami", 3, 40, 30,"Da una tempesta da te creata sul momento, si sprigionerà uno Tsunami che travolgerá i tuoi nemici"),
(7,"Tornado", 3, 15, 30,"Invoca un tornado dai cieli"),
(8,"Fulmine", 2, 20, 30,"Invoca un fulmine che va a colpire un'area designata"),
(9,"Proiettile Temporale", 3, 50, 50,"Emetti un proiettile dalle tue mani che distrugge il flusso temporale del bersaglio");

INSERT INTO Entita (id, hp, mana, id_Nemico) VALUES
(0, 5, 10 ,0),
(1, 1, 5, 1),
(2, 20, 22, 2),
(3, 60, 4, 3),
(4, 40, 30, 4),
(5, 60, 25, 5),
(6, 2 , 50, 6),
(7, 10 , 4, 7),
(8, 100, 100, 8);

INSERT INTO Entita (id, hp, mana, id_Personaggio) VALUES
(9, 0, 10, 0),
(10, 0, 4, 1),
(11, 0, 12, 2),
(12, 0, 0, 3),
(13, 60, 40, 4),
(14, 0, 5, 5),
(15, 90, 50, 6),
(16, 0, 0, 7),
(17, 50, 30, 8),
(18, 110, 60, 9);
