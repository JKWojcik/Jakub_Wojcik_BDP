--pkt 2
CREATE DATABASE zad2;

--pkt 3
CREATE EXTENSION postgis;

--pkt 4
CREATE TABLE budynki
(
	id SMALLINT NOT NULL PRIMARY KEY,
	geometria GEOMETRY,
	nazwa VARCHAR(25)
); 
CREATE TABLE drogi
(
id SMALLINT NOT NULL PRIMARY KEY,
geometria GEOMETRY,
nazwa VARCHAR(25)
);
CREATE TABLE punkty_informacyjne
(
id SMALLINT NOT NULL PRIMARY KEY,
geometria GEOMETRY,
nazwa VARCHAR(25)
);

--pkt 5
INSERT INTO budynki (id, geometria, nazwa) VALUES
	(1, ST_GeomFROMText('POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))', 0), 'BuildingA'),
	(2, ST_GeomFROMText('POLYGON((4 5, 6 5, 6 7, 4 7, 4 5))', 0), 'BuildingB'),
	(3, ST_GeomFROMText('POLYGON((3 6, 5 6, 5 8, 3 8, 3 6))', 0), 'BuildingC'),
	(4, ST_GeomFROMText('POLYGON((9 8, 10 8, 10 9, 9 9, 9 8))', 0), 'BuildingD'),
	(5, ST_GeomFROMText('POLYGON((1 1, 2 1, 2 2, 1 2, 1 1))', 0), 'BuildingF');
INSERT INTO	drogi (id, geometria, nazwa) VALUES
	(1, ST_GeomFROMText('LINESTRING(0.4 5, 12.4 4.5)', 0), 'RoadX'),
	(2, ST_GeomFROMText('LINESTRING(7.5 0, 7.5 10.5)', 0), 'RoadY');
INSERT INTO punkty_informacyjne (id, geometria, nazwa) VALUES
	(1, ST_GeomFROMText('POINT(1 3.5)', 0), 'G'),
	(2, ST_GeomFROMText('POINT(5.5 1.5)', 0), 'H'),
	(3, ST_GeomFROMText('POINT(9.5 6)', 0), 'I'),
	(4, ST_GeomFROMText('POINT(6.5 6)', 0), 'J'),
	(5, ST_GeomFROMText('POINT(6 9.5)', 0), 'K');
	
--pkt 6 a
SELECT SUM(st_length(geometria)) AS "długość dróg" FROM drogi;

--pkt 6 b
SELECT st_asewkt(geometria) AS "WKT", st_area(geometria) AS "Pole powierzchni", st_perimeter(geometria) AS "Obwód" 
FROM budynki WHERE nazwa LIKE 'BuildingA';

--pkt 6 c
SELECT nazwa, st_area(geometria) AS "Pole powierzchni" FROM budynki ORDER BY nazwa;

--pkt 6 d
SELECT nazwa, st_perimeter(geometria) AS "Obwód" FROM budynki 
ORDER BY st_perimeter(geometria) DESC LIMIT 2;

--pkt 6 e
SELECT st_distance(budynki.geometria, punkty_informacyjne.geometria) AS "Najkrótszy dystans" FROM budynki, punkty_informacyjne 
WHERE budynki.nazwa LIKE 'BuildingC' AND punkty_informacyjne.nazwa LIKE 'G';

--pkt 6 f
SELECT st_area(st_difference((SELECT geometria FROM budynki WHERE nazwa LIKE 'BuildingC'), 
st_buffer((SELECT geometria FROM budynki WHERE nazwa LIKE 'BuildingB'),0.5))) AS "Pole powierzchni" 
FROM budynki WHERE nazwa LIKE 'BuildingC';

--pkt 6 g
SELECT nazwa FROM budynki WHERE st_y(st_centroid(geometria))>(SELECT st_y(st_centroid(geometria)) 
FROM drogi WHERE nazwa LIKE 'RoadX');

--pkt 6 h
SELECT st_area(st_symdifference((SELECT geometria FROM budynki WHERE nazwa 
LIKE 'BuildingC'), 'polygon((4 7, 6 7, 6 8, 4 8, 4 7))')) 
AS "Pole powierzchni" FROM budynki WHERE nazwa LIKE 'BuildingC'; 