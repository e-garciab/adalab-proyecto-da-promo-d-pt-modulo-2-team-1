
USE music_stream;
-- Limpieza de datos, borramos los duplicados
CREATE TABLE  last_fm_ok AS
SELECT DISTINCT 
	artist_name,
	listeners,
	reproductions,
	biography,
	similar_artist,
	artist_id
FROM last_fm;
-- Comprobamos que ya no hay repetidos
SELECT * FROM music_stream.last_fm_ok;
-- Borramos la tabla que tenía duplicados
DROP TABLE last_fm;
-- Renombramos la tabla actual y sin repetidos como se llamaba la tabla inicial
RENAME TABLE last_fm_ok TO last_fm;

-- Repetimos el proceso con la otra tabla
-- Comprobamos que hay repetidos 
SELECT 
	name_track,
	genre,
	name_artist,
	year,
	type,
	COUNT(*) AS count
FROM spotify_ok
GROUP BY name_track, genre, name_artist, year, type
HAVING COUNT(*) > 1;

-- Creamos una tabla sin repetidos
CREATE TABLE  spotify_ok AS
SELECT DISTINCT *
FROM spotify;

-- Borramos la tabla con repetidos y creamos y renombramos la tabla nueva
SELECT *
FROM spotify_ok;
DROP TABLE spotify;
RENAME TABLE spotify_ok TO spotify;

-- Renombramos algunas columnas para que esten las dos bases de datos en el mismo idioma.

ALTER TABLE last_fm
RENAME COLUMN artista TO artist_name;
ALTER TABLE last_fm
RENAME COLUMN oyentes TO listeners;
ALTER TABLE last_fm
RENAME COLUMN reproducciones TO reproductions;
ALTER TABLE last_fm
RENAME COLUMN biografia TO biography;
ALTER TABLE last_fm
RENAME COLUMN artistas_similares TO similar_artist;
ALTER TABLE last_fm
RENAME COLUMN artist_name TO name_artist;

-- Tenemos la base de datos sin repetidos y procedemos a hacer las queries

-- 1. ¿Qué género fue escuchado en cada año? Gráfica por año y género?

SELECT 
	SUM(lf.reproductions),
	s.genre,
	s.year
FROM spotify s
INNER JOIN last_fm lf
	ON  lf.name_artist = s.name_artist
GROUP BY s.year, s.genre
HAVING s.year = 2020
ORDER BY SUM(lf.reproductions) DESC
LIMIT 1;

SELECT 
	SUM(lf.reproductions),
	s.genre,
	s.year
FROM spotify s
INNER JOIN last_fm lf
	ON  lf.name_artist = s.name_artist
GROUP BY s.year, s.genre
HAVING s.year = 2021
ORDER BY SUM(lf.reproductions) DESC
LIMIT 1;

SELECT 
	SUM(lf.reproductions),
	s.genre,
	s.year
FROM spotify s
INNER JOIN last_fm lf
	ON  lf.name_artist = s.name_artist
GROUP BY s.year, s.genre
HAVING s.year = 2022
ORDER BY SUM(lf.reproductions) DESC
LIMIT 1;

SELECT 
	SUM(lf.reproductions),
	s.genre,
	s.year
FROM spotify s
INNER JOIN last_fm lf
	ON  lf.name_artist = s.name_artist
GROUP BY s.year, s.genre
HAVING s.year = 2023
ORDER BY SUM(lf.reproductions) DESC
LIMIT 1;

SELECT 
	SUM(lf.reproductions),
	s.genre,
	s.year
FROM spotify s
INNER JOIN last_fm lf
	ON  lf.name_artist = s.name_artist
GROUP BY s.year, s.genre
HAVING s.year = 2024
ORDER BY SUM(lf.reproductions) DESC
LIMIT 1;

SELECT 
	SUM(lf.reproductions),
	s.genre,
	s.year
FROM spotify s
INNER JOIN last_fm lf
	ON  lf.name_artist = s.name_artist
GROUP BY s.year, s.genre
HAVING s.year = 2025
ORDER BY SUM(lf.reproductions) DESC
LIMIT 1;

-- 2. ¿Qué artista se escuchó más en cada año? TOP 5 con sus canciones más reproducidas.

SELECT 
    s.year,
    s.name_artist,
    s.name_track,
    SUM(lf.reproductions) AS total_reproductions
FROM spotify s
INNER JOIN last_fm lf
    ON lf.name_artist = s.name_artist
GROUP BY s.year, s.name_artist, s.name_track
HAVING s.year =2020
ORDER BY s.year, total_reproductions DESC
LIMIT 1;

SELECT 
    s.year,
    s.name_artist,
    s.name_track,
    SUM(lf.reproductions) AS total_reproductions
FROM spotify s
INNER JOIN last_fm lf
    ON lf.name_artist = s.name_artist
GROUP BY s.year, s.name_artist, s.name_track
HAVING s.year =2021
ORDER BY s.year, total_reproductions DESC
LIMIT 1;

SELECT 
    s.year,
    s.name_artist,
    s.name_track,
    SUM(lf.reproductions) AS total_reproductions
FROM spotify s
INNER JOIN last_fm lf
    ON lf.name_artist = s.name_artist
GROUP BY s.year, s.name_artist, s.name_track
HAVING s.year =2022
ORDER BY s.year, total_reproductions DESC
LIMIT 1;

SELECT 
    s.year,
    s.name_artist,
    s.name_track,
    SUM(lf.reproductions) AS total_reproductions
FROM spotify s
INNER JOIN last_fm lf
    ON lf.name_artist = s.name_artist
GROUP BY s.year, s.name_artist, s.name_track
HAVING s.year =2023
ORDER BY s.year, total_reproductions DESC
LIMIT 1;

SELECT 
    s.year,
    s.name_artist,
    s.name_track,
    SUM(lf.reproductions) AS total_reproductions
FROM spotify s
INNER JOIN last_fm lf
    ON lf.name_artist = s.name_artist
GROUP BY s.year, s.name_artist, s.name_track
HAVING s.year =2024
ORDER BY s.year, total_reproductions DESC
LIMIT 1;

SELECT 
    s.year,
    s.name_artist,
    s.name_track,
    SUM(lf.reproductions) AS total_reproductions
FROM spotify s
INNER JOIN last_fm lf
    ON lf.name_artist = s.name_artist
GROUP BY s.year, s.name_artist, s.name_track
HAVING s.year =2025
ORDER BY s.year, total_reproductions DESC
LIMIT 1;

-- 3. ¿Qué género ha sacado más discos por año?

SELECT 
    s.year,
    s.genre,
    COUNT(DISTINCT s.name_track) AS total_albums
FROM spotify s
WHERE s.type = "album"
GROUP BY s.year, s.genre
ORDER BY total_albums DESC;

-- 4. ¿Cuántas reproducciones tienen los/las artistas similares del/la artista más escuchado/a?

SELECT 
    lf.similar_artist,
    SUM(lf.reproductions) AS total_reproductions
FROM last_fm lf
WHERE lf.name_artist = (
    SELECT 
      lf.name_artist
    FROM last_fm lf
    GROUP BY lf.name_artist
    ORDER BY SUM(lf.reproductions) DESC
    LIMIT 1
)
GROUP BY lf.similar_artist
ORDER BY total_reproductions DESC;

-- 5. ¿Qué canción ha sido la más escuchada cada año?

SELECT 
    s.year,
    s.name_track,
    SUM(lf.reproductions) AS total_reproductions
FROM spotify s
INNER JOIN last_fm lf
    ON lf.name_artist = s.name_artist
GROUP BY s.year, s.name_track
HAVING s.year= 2020
ORDER BY s.year, total_reproductions DESC
LIMIT 1;

SELECT 
    s.year,
    s.name_track,
    SUM(lf.reproductions) AS total_reproductions
FROM spotify s
INNER JOIN last_fm lf
    ON lf.name_artist = s.name_artist
GROUP BY s.year, s.name_track
HAVING s.year= 2021
ORDER BY s.year, total_reproductions DESC
LIMIT 1;

SELECT 
    s.year,
    s.name_track,
    SUM(lf.reproductions) AS total_reproductions
FROM spotify s
INNER JOIN last_fm lf
    ON lf.name_artist = s.name_artist
GROUP BY s.year, s.name_track
HAVING s.year= 2022
ORDER BY s.year, total_reproductions DESC
LIMIT 1;

SELECT 
	s.year,
	s.name_track,
	SUM(lf.reproductions) AS total_reproductions
FROM spotify s
INNER JOIN last_fm lf
	ON lf.name_artist = s.name_artist
GROUP BY s.year, s.name_track
HAVING s.year= 2023
ORDER BY s.year, total_reproductions DESC
LIMIT 1;

SELECT 
	s.year,
	s.name_track,
	SUM(lf.reproductions) AS total_reproductions
FROM spotify s
INNER JOIN last_fm lf
	ON lf.name_artist = s.name_artist
GROUP BY s.year, s.name_track
HAVING s.year= 2024
ORDER BY s.year, total_reproductions DESC
LIMIT 1;

SELECT 
	s.year,
	s.name_track,
	SUM(lf.reproductions) AS total_reproductions
FROM spotify s
INNER JOIN last_fm lf
	ON lf.name_artist = s.name_artist
GROUP BY s.year, s.name_track
HAVING s.year= 2025
ORDER BY s.year, total_reproductions DESC
LIMIT 1;

-- 6. ¿Qué año ha habido más reproducciones? En total, sin clasificar por artistas?

SELECT 
	s.year,
	SUM(lf.reproductions) AS total_reproductions
FROM spotify s
INNER JOIN last_fm lf
	ON lf.name_artist = s.name_artist
GROUP BY s.year
ORDER BY total_reproductions DESC
LIMIT 1;

-- 7. ¿Cuántas canciones salen cada año? Filtrar por género.

SELECT 
	s.year,
	s.genre,
	COUNT(DISTINCT s.name_track) AS total_tracks
FROM spotify s
GROUP BY s.year, s.genre
ORDER BY s.year, s.genre;

-- 8. ¿Qué artistas son de genero R&B?

SELECT DISTINCT
	s.name_artist,
	lf.name_artist,
	lf.reproductions
FROM spotify s
INNER JOIN last_fm lf
	ON s.name_artist = lf.name_artist
WHERE genre = "R&B"
ORDER BY lf.reproductions DESC;

-- 9. Canciones más populares de cada artista

SELECT 
	s.name_artist,
	s.name_track,
	lf.reproductions
FROM spotify s
INNER JOIN last_fm lf
	ON s.name_artist = lf.name_artist
ORDER BY s.name_artist, lf.reproductions DESC;

-- 10. Artista, género y reproducciones. 2024: tendencia de cada género.

SELECT 
	s.name_artist,
	s.genre,
	SUM(lf.reproductions) AS total_reproductions
FROM spotify s
INNER JOIN last_fm lf
	ON lf.name_artist = s.name_artist
WHERE s.year = 2024
GROUP BY s.name_artist, s.genre
ORDER BY total_reproductions DESC;

-- 11. ¿Álbumes lanzados en 2025 con más reproducciones? TOP 5 con sus número de reproducciones (tendencia 2025?)

SELECT 
    s.name_track,
    s.name_artist,
	SUM(lf.reproductions) AS total_reproductions
FROM spotify s
INNER JOIN last_fm lf
	ON lf.name_artist = s.name_artist
WHERE s.year = 2025 AND s.type = 'album'
GROUP BY s.name_track, s.name_artist
ORDER BY total_reproductions DESC
LIMIT 5;

-- 12. ¿Cuáles son los artistas con biografía más extensa?

SELECT 
    name_artist, 
    biography,
	LENGTH(biography) AS bio_length 
FROM last_fm 
ORDER BY bio_length DESC;
 
-- 13. ¿Cuál es el género con más canciones?

SELECT 
	genre,
	COUNT(*) AS num_tracks
FROM spotify
GROUP BY genre
ORDER BY num_tracks DESC;

-- 14. ¿Cuáles son las tres canciones más populares en total y por género?

SELECT 
	s.genre,
	s.name_track,
	s.name_artist,
	lf.reproductions
FROM spotify s
INNER JOIN last_fm lf
	ON s.name_artist = lf.name_artist
ORDER BY lf.reproductions DESC
LIMIT 3;

-- 15. ¿Qué artistas tienen canciones en colaboración con otros artistas?

SELECT 
	s.name_track,
	s.name_artist
FROM spotify s
WHERE s.name_track LIKE '%feat.%' 
	OR s.name_track LIKE '%ft.%' 
	OR s.name_track LIKE '%with%'  
	OR s.name_track LIKE '%and%';


