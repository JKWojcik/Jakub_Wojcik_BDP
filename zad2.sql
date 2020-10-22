CREATE DATABASE "Baza1"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Polish_Poland.1250'
    LC_CTYPE = 'Polish_Poland.1250'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
	
CREATE EXTENSION postgis;
CREATE TABLE Budynki (
	id int PRIMARY KEY,
	geometria geometry,
	nazwa varchar(30)
);

CREATE TABLE Drogi (
	id int PRIMARY KEY,
	geometria geometry,
	nazwa varchar(30)
);

CREATE TABLE Punkty_informacyjne (
	id int PRIMARY KEY, 
	geometria geometry, 
	nazwa varchar(30)
);

INSERT INTO budynki (id, geometria, nazwa) VALUES
	(1, ST_GeomFromText('POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))', 0), 'BuildingA'),
	(2, ST_GeomFromText('POLYGON((4 5, 6 5, 6 7, 4 7, 4 5))', 0), 'BuildingB'),
	(3, ST_GeomFromText('POLYGON((3 6, 5 6, 5 8, 3 8, 3 6))', 0), 'BuildingC'),
	(4, ST_GeomFromText('POLYGON((9 8, 10 8, 10 9, 9 9, 9 8))', 0), 'BuildingD'),
	(5, ST_GeomFromText('POLYGON((1 1, 2 1, 2 2, 1 2, 1 1))', 0), 'BuildingF')
	

	
INSERT INTO punkty_informacyjne (id, geometria, nazwa) VALUES
	(1, ST_GeomFromText('POINT(1 3.5)', 0), 'G'),
	(2, ST_GeomFromText('POINT(5.5 1.5)', 0), 'H'),
	(3, ST_GeomFromText('POINT(9.5 6)', 0), 'I'),
	(4, ST_GeomFromText('POINT(6.5 6)', 0), 'J'),
	(5, ST_GeomFromText('POINT(6 9.5)', 0), 'K')

INSERT INTO	drogi (id, geometria, nazwa) VALUES
	(1, ST_GeomFromText('LINESTRING(0.4 5, 12.4 4.5)', 0), 'RoadX'),
	(2, ST_GeomFromText('LINESTRING(7.5 0, 7.5 10.5)', 0), 'RoadY')
	

-- ZADANIA:

SELECT SUM(ST_Length(geometria)) FROM drogi;
SELECT st_asewkt(geometria) AS Geometry, st_area(geometria) AS Pole, st_perimeter(geometria) AS Obw FROM budynki 
	WHERE nazwa = 'BuildingA'
	
SELECT nazwa, ST_AREA(budynki.geometria) FROM budynki 
	ORDER BY budynki.nazwa
	
SELECT NAZWA, ST_PERIMETER(budynki.geometria) FROM budynki 
	ORDER BY ST_AREA(budynki.geometria) 
	DESC 
	LIMIT 2

SELECT ST_DISTANCE(a.geometria, b.geometria) FROM budynki a, punkty_informacyjne b 
	WHERE a.nazwa='BuildingC' and b.nazwa='G'
	
SELECT ST_AREA(geometria)

SELECT ST_AREA(c.geometria) - ST_AREA(ST_INTERSECTION(c.geometria, ST_BUFFER(b.geometria, 0.5))) FROM budynki c, budynki b 
	WHERE c.nazwa = 'BuildingC' AND b.nazwa = 'BuildingB'
	
SELECT budynki.nazwa FROM budynki, drogi 
	WHERE ST_Y(ST_CENTROID(budynki.geometria)) > ST_Y(ST_CENTROID(drogi.geometria)) AND drogi.nazwa = 'RoadX'
	
SELECT (ST_AREA(C.geometria) - ST_AREA(ST_INTERSECTION(C.geometria, 'POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))) AS FIRST ,(ST_AREA('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))') - ST_AREA(ST_INTERSECTION(C.geometria, 'POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))) AS SECOND 
	FROM budynki C 
		WHERE C.nazwa = 'BuildingC'