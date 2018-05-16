drop database if exists songs_sales;
CREATE database songs_sales;
use songs_sales;

CREATE table composers(
id int AUTO_INCREMENT PRIMARY KEY,
name varchar(50) not null,
address VARCHAR(50) not null
);

CREATE table singers(
id int AUTO_INCREMENT PRIMARY KEY,
name varchar(50) not null,
address VARCHAR(50) not null
);

CREATE table songs(
id int AUTO_INCREMENT PRIMARY KEY,
title varchar(50) not null,
genre VARCHAR(50) not null,
style VARCHAR(50) not null,
arrangement VARCHAR(50) not null,
duration int NOT null,
composer_id int not null ,
singer_id int not null,
CONSTRAINT FOREIGN KEY (composer_id) REFERENCES composers(id),
CONSTRAINT FOREIGN KEY (singer_id) REFERENCES singers(id)
);

INSERT INTO composers(name, address) 
VALUES 	('John Smith', 'New York'),
		('Jose Antonio', 'Madrid'),
		('Ben White', 'Los Angeles'),
        ('François Arnaud','Paris');

INSERT INTO singers(name, address) 
VALUES 	('Enrique', 'Miami'),
		('Metallica', 'Los Angeles'),
        ('The Weeknd', 'Toronto'),
		('Maître Gims', 'Paris'),
        ('Bon Jovi', 'New Jersey'),
        ('Green Day','London'),
        ('Shakira','Madrid');

INSERT INTO songs(title, duration, genre, style, arrangement, composer_id, singer_id) 
VALUES 	('Hero', 257, 'pop', 'ballade', 'english', 2,1),
		('Fade to black', 392, 'metal', 'trash', 'english', 1,2),
        ('One', 360, 'rock', 'hard', 'english', 1,2),
		('Starboy', 260, 'RnB', 'dance', 'english', 3,3),
		('Est-ce que tu maimes', 240, 'pop', 'reggaeton', 'french', 4,4),
		('Duele El Corazon', 215, 'pop', 'dance', 'spanish', 2,1),
        ('Bad medicine', 256, 'rock','soft','english',1,5);
        


SELECT songs.title as SongTitle
FROM songs JOIN singers
ON singers.id = songs.singer_id
WHERE singers.name LIKE 'Enrique';

SELECT songs.title, songs.duration, singers.name
from songs join singers
on singer_id = singers.id
where songs.duration > (select avg(songs.duration)
      from songs)
;

SELECT max(songs.duration) as MaxDuration, songs.title as SongTitle, songs.genre as Genre
FROM songs
GROUP BY songs.genre DESC;
;
SELECT songs.title as SongTitle, singers.name as Singer, composers.name as Composer
FROM songs RIGHT JOIN singers
ON songs.singer_id = singers.id
LEFT JOIN composers
ON songs.composer_id = composers.id;


DELIMITER |
CREATE PROCEDURE informationForSongs()

BEGIN
	DECLARE tempTitle VARCHAR(255);
    DECLARE tempGenre VARCHAR(255);
    DECLARE tempDuration INT;
    DECLARE finished INT;
    DECLARE songCursor CURSOR FOR 
    SELECT title, genre, duration
    FROM songs
    WHERE duration > 250;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
    
    SET finished = 0;
    
    OPEN songCursor;
    while_label: WHILE(finished = 0)
		DO
			FETCH songCursor INTO tempTitle, tempGenre, tempDuration;
            IF(finished = 1)
				THEN LEAVE while_label;
			END IF;
			SELECT tempTitle, tempGenre, tempDuration;
		END WHILE;
        
	CLOSE songCursor;
    
    SET finished = 0;
    SELECT 'Done!';
END;
|
DELIMITER ;

CALL informationForSongs;

