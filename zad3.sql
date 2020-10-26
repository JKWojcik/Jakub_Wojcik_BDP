CREATE EXTENSION postgis;

--pkt 4
CREATE TABLE tableB AS
SELECT DISTINCT p.geom AS "Liczba budynków" FROM popp p INNER JOIN majrivers m ON st_dwithin(p.geom, m.geom, 100000) 
WHERE f_codedesc LIKE 'Building';

--pkt 5
CREATE TABLE airportsNew AS
SELECT name, geom, elev FROM airports;

--pkt 5 a
SELECT name AS "Najbardziej na wschód", geom AS "Współrzędne" FROM airportsnew WHERE st_y(geom) in 
(SELECT MAX(st_y(geom)) FROM airportsnew);
SELECT name AS "Najbardziej na zachód", geom AS "Współrzędne" FROM airportsnew WHERE st_y(geom) in 
(SELECT MIN(st_y(geom)) FROM airportsnew);

--pkt 5 b
INSERT INTO airportsnew(name, geom, elev) VALUES ('airportB',
(SELECT st_centroid(st_union((SELECT geom FROM airportsnew WHERE st_y(geom) in (SELECT MIN(st_y(geom)) FROM airportsnew)), 
(SELECT geom FROM airportsnew WHERE st_y(geom) in (SELECT MAX(st_y(geom)) FROM airportsnew))))) ,0);

--pkt 6
 SELECT st_area(st_buffer(st_makeline((SELECT st_centroid(geom) FROM lakes WHERE names LIKE 'Iliamna Lake'),
(SELECT geom FROM airports WHERE name LIKE 'AMBLER')),1000)) AS "Pole Powierzchni";

--pkt 7
SELECT vegdesc, SUM(st_area(st_intersection(st_buffer(tu.geom,0),st_intersection(st_buffer(t.geom,0),st_buffer(s.geom,0))))) 
FROM trees t, swamp s, tundra tu GROUP BY vegdesc;