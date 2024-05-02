DELIMITER //

CREATE TRIGGER before_insert_battaglia
BEFORE INSERT ON Battaglia
FOR EACH ROW
BEGIN
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
END;
//
DELIMITER ;

DELIMITER //

CREATE TRIGGER before_update_personaggio
BEFORE UPDATE ON Personaggio
FOR EACH ROW
BEGIN
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
END;
//
DELIMITER ;
