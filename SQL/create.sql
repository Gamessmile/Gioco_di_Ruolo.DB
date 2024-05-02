CREATE DATABASE Gioco_Di_Ruolo;
USE Gioco_Di_Ruolo;

CREATE TABLE Abilita(
    id INT NOT NULL,
    nome varchar(60),
    tipologia INT,
    danno INT,
    costo INT,
    descrizione varchar(255),
    PRIMARY KEY (id)
);  

CREATE TABLE Arma(
    id INT NOT NULL,
    nome varchar(60),
    tipologia INT,
    danno INT,
    PRIMARY KEY (id)
);  

CREATE TABLE Nemico(
    id INT NOT NULL,
    nome varchar(60),
    PRIMARY KEY (id)
);

CREATE TABLE Giocatore(
    id INT NOT NULL,
    nome varchar(60),
    cognome varchar(60),
    PRIMARY KEY (id)
);

CREATE TABLE Personaggio(
    id INT NOT NULL,
    nome varchar(60),
    id_Giocatore INT NOT NULL,
    livello INT NOT NULL,
    id_Arma INT,
    PRIMARY KEY (id),
    FOREIGN KEY (id_Giocatore) REFERENCES Giocatore(id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
    FOREIGN KEY (id_Arma) REFERENCES Arma(id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
);

CREATE TABLE Entita(
    id INT NOT NULL,
    hp int,
    mana int,
    id_Nemico INT,
    id_Personaggio INT,
    PRIMARY KEY (id),
    FOREIGN KEY (id_Nemico) REFERENCES  Nemico(id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
    FOREIGN KEY (id_Personaggio) REFERENCES  Personaggio(id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
    CHECK (id_Nemico IS NOT NULL XOR id_Personaggio IS NOT NULL)
);

CREATE TABLE Battaglia (
    id_mittente INT NOT NULL,
    id_ricevente INT NOT NULL,
    id_abilita INT NOT NULL,
    FOREIGN KEY (id_mittente) REFERENCES Entita(id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
    FOREIGN KEY (id_ricevente) REFERENCES Entita(id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
    FOREIGN KEY (id_abilita) REFERENCES Abilita(id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
);
