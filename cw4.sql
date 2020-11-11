--Zad1
CREATE TABLE obiekty
(
	nazwa varchar(7),
	geom geometry
);

INSERT INTO obiekty VALUES ('obiekt1',ST_GeomFROMText('MULTICURVE((0 1,1 1),CIRCULARSTRING(1 1,2 0,3 1,4 2,5 1),(5 1,6 1))',0));
INSERT INTO obiekty VALUES ('obiekt2',st_geomFROMtext('CURVEPOLYGON(COMPOUNDCURVE((10 2,10 6,14 6),CIRCULARSTRING(14 6,16 4,14 2),
CIRCULARSTRING(14 2,12 0,10 2)),CIRCULARSTRING(11 2,12 3,13 2,12 1,11 2)) ',0));
INSERT INTO obiekty VALUES ('obiekt3',st_geomFROMtext('POLYGON((7 15,10 17,12 13,7 15))',0));
INSERT INTO obiekty VALUES ('obiekt4',st_geomFROMtext('LINESTRING(20 20,25 25,27 24,25 22,26 21,22 19,20.5 19.5)',0));
INSERT INTO obiekty VALUES ('obiekt5',st_geomFROMtext('MULTIPOINT(30 30 59,38 32 234)',0));
INSERT INTO obiekty VALUES ('obiekt6',st_geomFROMtext('GEOMETRYCOLLECTION(POINT(4 2),LINESTRING(1 1,3 2))',0));

--zad2
SELECT st_area(st_buffer(st_shortestline(a.geom,b.geom),5)) FROM obiekty a,obiekty b WHERE a.nazwa='obiekt3' AND b.nazwa='obiekt4';

--zad3
UPDATE obiekty SET geom = (SELECT ST_MakePolygon(ST_LineMerge(ST_Union((geom),'LINESTRING(20.5 19.5,20 20)'))) 
FROM obiekty WHERE nazwa='obiekt4') WHERE nazwa = 'obiekt4';

--zad4
INSERT INTO obiekty (nazwa, geom) VALUES ('obiekt7', (SELECT ST_Union(a.geom,b.geom) FROM obiekty a,obiekty b 
WHERE a.nazwa='obiekt3'AND b.nazwa='obiekt4'));

--zad5
SELECT SUM(ST_Area(St_buffer((geom),5))) FROM obiekty WHERE ST_HasArc(geom) = 'false';