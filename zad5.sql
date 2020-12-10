CREATE EXTENSION postgis;
CREATE EXTENSION postgis_raster;
-- in cmd
--cd D:\Programy\PostgreSQL\bin
--raster2pgsql.exe -s 3763 -N -32767 -t 100x100 -I -C -M -d D:\Pulpit\Studia\Semestr V\Bazy danych przestrzennych\cw5\srtm_1arc_v3.tif rasters.dem > D:\Pulpit\Studia\Semestr V\Bazy danych przestrzennych\cw5\dem.sql
--raster2pgsql.exe -s 3763 -N -32767 -t 100x100 -I -C -M -d D:\Pulpit\Studia\Semestr V\Bazy danych przestrzennych\cw5\srtm_1arc_v3.tif rasters.dem | psql -d postgis_raster -h localhost -U postgres -p 5432
--raster2pgsql.exe -s 3763 -N -32767 -t 128x128 -I -C -M -d D:\Pulpit\Studia\Semestr V\Bazy danych przestrzennych\cw5\Landsat8_L1TP_RGBN.TIF rasters.landsat8 | psql -d postgis_raster -h localhost -U postgres -p 5432

--zad1
CREATE TABLE schema_jwojcik.intersects AS SELECT a.rast, b.municipality FROM rasters.dem AS a, vectors.porto_parishes AS b WHERE ST_Intersects(a.rast, b.geom) AND b.municipality ilike 'porto';
ALTER TABLE schema_jwojcik.intersects ADD COLUMN rid SERIAL PRIMARY KEY;
CREATE INDEX idx_intersects_rast_gist ON schema_jwojcik.intersects USING gist (ST_ConvexHull(rast));

--zad2
CREATE TABLE schema_jwojcik.clip AS SELECT ST_Clip(a.rast, b.geom, true), b.municipality FROM rasters.dem AS a, vectors.porto_parishes AS b WHERE ST_Intersects(a.rast, b.geom) AND b.municipality like 'PORTO';

--zad3
CREATE TABLE schema_jwojcik.union AS SELECT ST_Union(ST_Clip(a.rast, b.geom, true))FROM rasters.dem AS a, vectors.porto_parishes AS b WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast);

--zad4
--pkt1
CREATE TABLE schema_jwojcik.porto_parishes AS WITH r AS (SELECT rast FROM rasters.dem LIMIT 1)SELECT ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767) AS rast FROM vectors.porto_parishes AS a, r WHERE a.municipality ilike 'porto';

--pkt2
DROP TABLE schema_jwojcik.porto_parishes; --> drop table porto_parishes first
CREATE TABLE schema_jwojcik.porto_parishes AS WITH r AS (SELECT rast FROM rasters.dem LIMIT 1)SELECT st_union(ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767)) AS rast FROM vectors.porto_parishes AS a, r WHERE a.municipality ilike 'porto';

--pkt3
DROP TABLE schema_jwojcik.porto_parishes; --> drop table porto_parishes first
CREATE TABLE schema_jwojcik.porto_parishes AS WITH r AS (SELECT rast FROM rasters.dem LIMIT 1)SELECT st_tile(st_union(ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767)),128,128,true,-32767) AS rast FROM vectors.porto_parishes AS a, r WHERE a.municipality ilike 'porto';

--zad5
--pkt1
create table schema_jwojcik.intersection as SELECT a.rid,(ST_Intersection(b.geom,a.rast)).geom,(ST_Intersection(b.geom,a.rast)).val FROM rasters.landsat8 AS a, vectors.porto_parishes AS b WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);

--pkt2
CREATE TABLE schema_jwojcik.dumppolygons AS SELECT a.rid,(ST_DumpAsPolygons(ST_Clip(a.rast,b.geom))).geom,(ST_DumpAsPolygons(ST_Clip(a.rast,b.geom))).val FROM rasters.landsat8 AS a, vectors.porto_parishes AS b WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);

--zad6
--pkt1
CREATE TABLE schema_jwojcik.landsat_nir AS SELECT rid, ST_Band(rast,4) AS rast FROM rasters.landsat8;

--pkt2
CREATE TABLE schema_jwojcik.paranhos_dem AS SELECT a.rid,ST_Clip(a.rast, b.geom,true) as rast FROM rasters.dem AS a, vectors.porto_parishes AS b WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);

--pkt3
CREATE TABLE schema_jwojcik.paranhos_slope AS SELECT a.rid,ST_Slope(a.rast,1,'32BF','PERCENTAGE') as rast FROM schema_jwojcik.paranhos_dem AS a;

--pkt4
CREATE TABLE schema_jwojcik.paranhos_slope_reclass AS SELECT a.rid,ST_Reclass(a.rast,1,']0-15]:1, (15-30]:2, (30-9999:3', '32BF',0) FROM schema_jwojcik.paranhos_slope AS a;

--pkt5
SELECT st_summarystats(a.rast) AS stats FROM schema_jwojcik.paranhos_dem AS a;

--pkt6
SELECT st_summarystats(ST_Union(a.rast))FROM schema_jwojcik.paranhos_dem AS a;

--pkt7
WITH t AS (SELECT st_summarystats(ST_Union(a.rast)) AS stats FROM schema_jwojcik.paranhos_dem AS a) SELECT (stats).min,(stats).max,(stats).mean FROM t;

--pkt8
WITH t AS (SELECT b.parish AS parish, st_summarystats(ST_Union(ST_Clip(a.rast, b.geom,true))) AS stats FROM rasters.dem AS a, vectors.porto_parishes AS b WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast) group by b.parish)
SELECT parish,(stats).min,(stats).max,(stats).mean FROM t;

--pkt9
SELECT b.name,st_value(a.rast,(ST_Dump(b.geom)).geom) FROM rasters.dem a, vectors.places AS b WHERE ST_Intersects(a.rast,b.geom) ORDER BY b.name;

--pkt10
create table schema_jwojcik.tpi30 as select ST_TPI(a.rast,1) as rast from rasters.dem a;
CREATE INDEX idx_tpi30_rast_gist ON schema_jwojcik.tpi30 USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('schema_jwojcik'::name, 'tpi30'::name,'rast'::name);

--pkt10 other
create table schema_jwojcik.tpi30_porto as SELECT ST_TPI(a.rast,1) as rast FROM rasters.dem AS a, vectors.porto_parishes AS b WHERE ST_Intersects(a.rast, b.geom) AND b.municipality ilike 'porto';
CREATE INDEX idx_tpi30_porto_rast_gist ON schema_jwojcik.tpi30_porto USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('schema_jwojcik'::name, 'tpi30_porto'::name,'rast'::name);


--zad7
--pkt1
CREATE TABLE schema_jwojcik.porto_ndvi AS WITH r AS (SELECT a.rid,ST_Clip(a.rast, b.geom,true) AS rast FROM rasters.landsat8 AS a, vectors.porto_parishes AS b WHERE b.municipality ilike 'porto'and ST_Intersects(b.geom,a.rast)) SELECT r.rid,ST_MapAlgebra(r.rast, 1,r.rast, 4,'([rast2.val] -[rast1.val]) / ([rast2.val] + [rast1.val])::float','32BF') AS rast FROM r;
CREATE INDEX idx_porto_ndvi_rast_gist ON schema_jwojcik.porto_ndvi USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('schema_jwojcik'::name, 'porto_ndvi'::name,'rast'::name);
--pkt2
create or replace function schema_jwojcik.ndvi( value double precision [] [] [],   pos integer [][],  VARIADIC userargs text [] ) RETURNS double precision AS $$ BEGIN  --RAISE NOTICE 'Pixel Value: %', value [1][1][1];-->For debug purposes  
RETURN (value [2][1][1] - value [1][1][1])/(value [2][1][1]+value [1][1][1]); --> NDVI calculation! 
END; $$ LANGUAGE 'plpgsql' IMMUTABLE COST 1000; 

CREATE TABLE schema_jwojcik.porto_ndvi2 AS WITH r AS (SELECT a.rid,ST_Clip(a.rast, b.geom,true) AS rast FROM rasters.landsat8 AS a, vectors.porto_parishes AS b WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast)) SELECT r.rid,ST_MapAlgebra(r.rast, ARRAY[1,4],'schema_jwojcik.ndvi(double precision[], integer[],text[])'::regprocedure, --> This is the function!
'32BF'::text) AS rast FROM r;

CREATE INDEX idx_porto_ndvi2_rast_gist ON schema_jwojcik.porto_ndvi2 USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('schema_jwojcik'::name, 'porto_ndvi2'::name,'rast'::name);

--zad8
--pkt1
SELECT ST_AsTiff(ST_Union(rast)) FROM schema_jwojcik.porto_ndvi;

--pkt2
SELECT ST_AsGDALRaster(ST_Union(rast), 'GTiff',  ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9']) FROM schema_jwojcik.porto_ndvi;
SELECT ST_GDALDrivers();

--pkt3
CREATE TABLE tmp_out AS
SELECT lo_from_bytea(0,ST_AsGDALRaster(ST_Union(rast), 'GTiff',  ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])) AS loid FROM schema_jwojcik.porto_ndvi;
----------------------------------------------
SELECT lo_export(loid, 'D:\Pulpit\Studia\Semestr V\Bazy danych przestrzennych\cw5\myraster.tiff') --> Save the file in a place where the user postgres have access. In windows a flash drive usualy works fine.
FROM tmp_out;
----------------------------------------------
SELECT lo_unlink(loid) FROM tmp_out; --> Delete the large object.

--pkt4
gdal_translate -co COMPRESS=DEFLATE -co PREDICTOR=2 -co ZLEVEL=9 PG:"host=localhost port=5432 dbname=postgis_raster user=postgres password=postgis schema=schema_jwojcik table=porto_ndvi mode=2" porto_ndvi.tiff

--zad9
--pkt1
MAP
	NAME 'map'
	SIZE 800 650
	STATUS ON
	EXTENT -58968 145487 30916 206234
	UNITS METERS
	WEB
		METADATA
		'wms_title' 'Terrain wms'
		'wms_srs' 'EPSG:3763 EPSG:4326 EPSG:3857'
		'wms_enable_request' '*'
		'wms_onlineresource' 
'http://54.37.13.53/mapservices/srtm'
		END
	END
	PROJECTION
		'init=epsg:3763'
	END
	LAYER
		NAME srtm
		TYPE raster
		STATUS OFF
		DATA "PG:host=localhost port=5432 dbname='postgis_raster' user='sasig' password='postgis' schema='rasters' table='dem' mode='2'"
		PROCESSING "SCALE=AUTO"
		PROCESSING "NODATA=-32767"
		OFFSITE 0 0 0
		METADATA
			'wms_title' 'srtm'
		END
	END
END