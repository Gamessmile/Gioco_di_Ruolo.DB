-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Creato il: Apr 26, 2024 alle 18:55
-- Versione del server: 10.4.32-MariaDB
-- Versione PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gioco_di_ruolo`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `abilita`
--

CREATE TABLE `abilita` (
  `id` int(11) NOT NULL,
  `nome` varchar(60) DEFAULT NULL,
  `tipologia` int(11) DEFAULT NULL,
  `danno` int(11) DEFAULT NULL,
  `costo` int(11) DEFAULT NULL,
  `descrizione` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `abilita`
--

INSERT INTO `abilita` (`id`, `nome`, `tipologia`, `danno`, `costo`, `descrizione`) VALUES
(0, 'Attacco con arma', NULL, NULL, NULL, 'Effettua un attacco con l\'arma'),
(1, 'Palla di fuoco', 3, 3, 2, 'Lancia una sfera infiammata'),
(2, 'Fiamma Sopita', 1, 6, 10, 'Provoca una esplosione di fiamme ravvicinata'),
(3, 'Palla d\'Acqua', 3, 2, 1, 'Lancia una sfera d\'acqua'),
(4, 'Fendente Fulmineo', 2, 5, 5, 'Un piccolo fulmine sprigionato dai palmi delle mani'),
(5, 'Luce Solenne', 1, 10, 15, 'Sprigiona una luce talmente intensa da infliggere danno'),
(6, 'Tsunami', 3, 40, 30, 'Da una tempesta da te creata sul momento, si sprigionerà uno Tsunami che travolgerá i tuoi nemici'),
(7, 'Tornado', 3, 15, 30, 'Invoca un tornado dai cieli'),
(8, 'Fulmine', 2, 20, 30, 'Invoca un fulmine che va a colpire un\'area designata'),
(9, 'Proiettile Temporale', 3, 50, 50, 'Emetti un proiettile dalle tue mani che distrugge il flusso temporale del bersaglio');

-- --------------------------------------------------------

--
-- Struttura della tabella `arma`
--

CREATE TABLE `arma` (
  `id` int(11) NOT NULL,
  `nome` varchar(60) DEFAULT NULL,
  `tipologia` int(11) DEFAULT NULL,
  `danno` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `arma`
--

INSERT INTO `arma` (`id`, `nome`, `tipologia`, `danno`) VALUES
(0, 'Tirapugni', 1, 2),
(1, 'Picca', 2, 3),
(2, 'Arco', 3, 4),
(3, 'Shotel', 1, 4),
(4, 'Alabarda', 2, 5),
(5, 'Ascia', 1, 7),
(6, 'Claymore', 2, 7),
(7, 'Zweihander', 2, 10),
(8, 'Balestra Mezzaluna', 3, 11),
(9, 'Arco SpezzaScudi', 3, 12),
(10, 'Falce delle nubi', 2, 15),
(11, 'Spadone sacro di Artis', 2, 20);

-- --------------------------------------------------------

--
-- Struttura della tabella `battaglia`
--

CREATE TABLE `battaglia` (
  `id_mittente` int(11) NOT NULL,
  `id_ricevente` int(11) NOT NULL,
  `id_abilita` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Trigger `battaglia`
--
DELIMITER $$
CREATE TRIGGER `before_insert_battaglia` BEFORE INSERT ON `battaglia` FOR EACH ROW BEGIN
    DECLARE attacker_hp INT;
    DECLARE attacker_mana INT;
    DECLARE defender_hp INT;
    DECLARE defender_mana INT;
    DECLARE attacker_damage INT;
    DECLARE ability_cost INT;
    DECLARE attacker_is_character BOOL;
    
    -- Ottieni le informazioni sull'attaccante e sul difensore
    SELECT hp, mana, id_Personaggio IS NOT NULL INTO attacker_hp, attacker_mana, attacker_is_character
    FROM Entita WHERE id = NEW.id_mittente;
    
    SELECT hp, mana INTO defender_hp, defender_mana
    FROM Entita WHERE id = NEW.id_ricevente;
    
    -- Controlla se entrambi gli enti sono vivi
    IF attacker_hp > 0 AND defender_hp > 0 THEN
        -- Se l'abilità è Attacco con arma (id_abilita = 0)
        IF NEW.id_abilita = 0 THEN
            -- Verifica se l'attaccante è un personaggio o un nemico
            IF attacker_is_character THEN
                -- Ottieni il danno dell'arma del personaggio
                SELECT Arma.danno INTO attacker_damage FROM Entita, Personaggio, Arma
                WHERE Entita.id = NEW.id_mittente and Entita.id_Personaggio = Personaggio.id and Personaggio.id_Arma = Arma.id;
                
                -- Infliggi il danno al difensore
                IF NEW.id_mittente = NEW.id_ricevente THEN
                    SET attacker_hp = GREATEST(attacker_hp - attacker_damage, 0);
                ELSE
                    SET defender_hp = GREATEST(defender_hp - attacker_damage, 0);
                END IF;
            ELSE
                -- L'attaccante non può essere un nemico, generare errore
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Impossibile attaccare con arma: l attaccante non può essere un nemico.';
            END IF;
        ELSE
            -- L'abilità non è Attacco con arma
            -- Ottieni il costo e il danno dell'abilità
            SELECT costo, danno INTO ability_cost, attacker_damage
            FROM Abilita
            WHERE id = NEW.id_abilita;
            
            -- Verifica se l'attaccante ha abbastanza mana per utilizzare l'abilità
            IF attacker_mana < ability_cost THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Impossibile avviare la battaglia: mana insufficiente per utilizzare l abilità.';
            ELSE
                -- Infliggi il danno al difensore e riduci il mana dell'attaccante
                IF NEW.id_mittente = NEW.id_ricevente THEN
                    SET attacker_hp = GREATEST(attacker_hp - attacker_damage, 0);
                ELSE
                    SET defender_hp = GREATEST(defender_hp - attacker_damage, 0);
                END IF;
                SET attacker_mana = attacker_mana - ability_cost;
            END IF;
        END IF;
        
        -- Aggiorna le informazioni sull'attaccante e sul difensore
        UPDATE Entita SET hp = defender_hp WHERE id = NEW.id_ricevente;
        UPDATE Entita SET hp = attacker_hp, mana = attacker_mana WHERE id = NEW.id_mittente;
    ELSE
        -- Uno o entrambi gli enti non sono vivi, genera errore
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Impossibile avviare la battaglia: uno o entrambi gli enti non sono vivi.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `entita`
--

CREATE TABLE `entita` (
  `id` int(11) NOT NULL,
  `hp` int(11) DEFAULT NULL,
  `mana` int(11) DEFAULT NULL,
  `id_Nemico` int(11) DEFAULT NULL,
  `id_Personaggio` int(11) DEFAULT NULL
) ;

--
-- Dump dei dati per la tabella `entita`
--

INSERT INTO `entita` (`id`, `hp`, `mana`, `id_Nemico`, `id_Personaggio`) VALUES
(0, 5, 10, 0, NULL),
(1, 1, 5, 1, NULL),
(2, 20, 22, 2, NULL),
(3, 60, 4, 3, NULL),
(4, 40, 30, 4, NULL),
(5, 60, 25, 5, NULL),
(6, 2, 50, 6, NULL),
(7, 10, 4, 7, NULL),
(8, 100, 100, 8, NULL),
(9, 0, 10, NULL, 0),
(10, 0, 4, NULL, 1),
(11, 0, 12, NULL, 2),
(12, 0, 0, NULL, 3),
(13, 60, 40, NULL, 4),
(14, 0, 5, NULL, 5),
(15, 90, 50, NULL, 6),
(16, 0, 0, NULL, 7),
(17, 50, 30, NULL, 8),
(18, 110, 60, NULL, 9);

-- --------------------------------------------------------

--
-- Struttura della tabella `giocatore`
--

CREATE TABLE `giocatore` (
  `id` int(11) NOT NULL,
  `nome` varchar(60) DEFAULT NULL,
  `cognome` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `giocatore`
--

INSERT INTO `giocatore` (`id`, `nome`, `cognome`) VALUES
(0, 'Gabriel', 'Rossi'),
(1, 'Sara', 'Sciacca'),
(2, 'Manuel', 'Monticatti');

-- --------------------------------------------------------

--
-- Struttura della tabella `nemico`
--

CREATE TABLE `nemico` (
  `id` int(11) NOT NULL,
  `nome` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `nemico`
--

INSERT INTO `nemico` (`id`, `nome`) VALUES
(0, 'Goblin'),
(1, 'Umano'),
(2, 'Gargolla'),
(3, 'Zombie'),
(4, 'Cavaliere [BOSS]'),
(5, 'Guardiano della Luce [BOSS]'),
(6, 'Sanguisuga'),
(7, 'Mercenario'),
(8, 'Satan');

-- --------------------------------------------------------

--
-- Struttura della tabella `personaggio`
--

CREATE TABLE `personaggio` (
  `id` int(11) NOT NULL,
  `nome` varchar(60) DEFAULT NULL,
  `id_Giocatore` int(11) NOT NULL,
  `livello` int(11) NOT NULL,
  `id_Arma` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `personaggio`
--

INSERT INTO `personaggio` (`id`, `nome`, `id_Giocatore`, `livello`, `id_Arma`) VALUES
(0, 'Adventurier Mag', 0, 3, 0),
(1, 'Pientolo', 0, 4, 1),
(2, 'Algiova', 2, 5, 3),
(3, 'Destroyer', 0, 4, 2),
(4, 'Solaire', 1, 7, 6),
(5, 'San Giuds', 0, 2, 0),
(6, 'Artorias', 2, 10, 11),
(7, 'Marušić', 0, 5, 5),
(8, 'Kamada', 0, 6, 3),
(9, 'Exa', 1, 12, 10);

--
-- Trigger `personaggio`
--
DELIMITER $$
CREATE TRIGGER `before_update_personaggio` BEFORE UPDATE ON `personaggio` FOR EACH ROW BEGIN
    DECLARE livello_precedente INT;
    DECLARE livello_successivo INT;
    DECLARE differenza_livello INT;
    DECLARE hp_incremento INT;
    DECLARE mana_incremento INT;

    -- Ottieni il livello precedente e il livello successivo
    SELECT OLD.livello, NEW.livello INTO livello_precedente, livello_successivo;

    -- Controlla che il personaggio sia vivo
    IF (SELECT hp FROM Entita WHERE id_Personaggio = NEW.id) <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Impossibile aggiornare il livello: il personaggio non è vivo.';
    END IF;

    -- Verifica se il nuovo livello è maggiore del precedente
    IF livello_successivo > livello_precedente THEN
        -- Calcola la differenza di livello
        SET differenza_livello = livello_successivo - livello_precedente;

        -- Calcola l'incremento di HP e mana per ogni livello aumentato
        SET hp_incremento = differenza_livello * 10;
        SET mana_incremento = differenza_livello * 5;

        -- Aggiorna le colonne hp e mana dell'entità associata al personaggio
        UPDATE Entita 
        SET hp = hp + hp_incremento,
            mana = mana + mana_incremento 
        WHERE id_Personaggio = NEW.id;
    ELSE
        -- Se il nuovo livello non è maggiore del precedente, genera un errore
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Impossibile aggiornare il livello: il nuovo livello deve essere superiore al precedente.';
    END IF;
END
$$
DELIMITER ;

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `abilita`
--
ALTER TABLE `abilita`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `arma`
--
ALTER TABLE `arma`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `battaglia`
--
ALTER TABLE `battaglia`
  ADD KEY `id_mittente` (`id_mittente`),
  ADD KEY `id_ricevente` (`id_ricevente`),
  ADD KEY `id_abilita` (`id_abilita`);

--
-- Indici per le tabelle `entita`
--
ALTER TABLE `entita`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_Nemico` (`id_Nemico`),
  ADD KEY `id_Personaggio` (`id_Personaggio`);

--
-- Indici per le tabelle `giocatore`
--
ALTER TABLE `giocatore`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `nemico`
--
ALTER TABLE `nemico`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `personaggio`
--
ALTER TABLE `personaggio`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_Giocatore` (`id_Giocatore`),
  ADD KEY `id_Arma` (`id_Arma`);

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `battaglia`
--
ALTER TABLE `battaglia`
  ADD CONSTRAINT `battaglia_ibfk_1` FOREIGN KEY (`id_mittente`) REFERENCES `entita` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `battaglia_ibfk_2` FOREIGN KEY (`id_ricevente`) REFERENCES `entita` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `battaglia_ibfk_3` FOREIGN KEY (`id_abilita`) REFERENCES `abilita` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Limiti per la tabella `entita`
--
ALTER TABLE `entita`
  ADD CONSTRAINT `entita_ibfk_1` FOREIGN KEY (`id_Nemico`) REFERENCES `nemico` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `entita_ibfk_2` FOREIGN KEY (`id_Personaggio`) REFERENCES `personaggio` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Limiti per la tabella `personaggio`
--
ALTER TABLE `personaggio`
  ADD CONSTRAINT `personaggio_ibfk_1` FOREIGN KEY (`id_Giocatore`) REFERENCES `giocatore` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `personaggio_ibfk_2` FOREIGN KEY (`id_Arma`) REFERENCES `arma` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
