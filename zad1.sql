--pkt 1
CREATE DATABASE s304206;
--pkt 2
CREATE SCHEMA firma;
--pkt 3
CREATE ROLE ksiegowosc;
GRANT CONNECT ON DATABASE s304206 TO ksiegowosc;
GRANT USAGE ON SCHEMA firma TO ksiegowosc;
ALTER DEFAULT PRIVILEGES IN SCHEMA firma GRANT SELECT ON TABLES TO ksiegowosc;
--pkt 4 a
CREATE TABLE firma.pracownicy
(
id_pracownika SMALLINT NOT NULL,
imie VARCHAR(20), 
nazwisko VARCHAR(35), 
adres VARCHAR(50), 
telefon VARCHAR(9)
);

CREATE TABLE firma.godziny
(
	id_godziny SMALLINT NOT NULL,
	data DATE,
	liczba_godzin SMALLINT,
	id_pracownika SMALLINT NOT NULL
);
	
CREATE TABLE firma.pensja_stanowisko
(
	id_pensji SMALLINT NOT NULL,
	stanowisko VARCHAR(50),
	kwota SMALLINT
);

CREATE TABLE firma.premia
(
	id_premii SMALLINT NOT NULL,
	rodzaj VARCHAR(50),
	kwota SMALLINT
);
	
CREATE TABLE firma.wynagrodzenie
(
	id_wynagrodzenia SMALLINT NOT NULL,
	data DATE,
	id_pracownika SMALLINT NOT NULL,
	id_godziny SMALLINT NOT NULL,
	id_pensji SMALLINT NOT NULL,
	id_premii SMALLINT NOT NULL
);

--b
ALTER TABLE firma.pracownicy ADD PRIMARY KEY (id_pracownika);
ALTER TABLE firma.godziny ADD PRIMARY KEY (id_godziny);
ALTER TABLE firma.pensja_stanowisko ADD PRIMARY KEY (id_pensji);
ALTER TABLE firma.premia ADD PRIMARY KEY (id_premii);
ALTER TABLE firma.wynagrodzenie ADD PRIMARY KEY (id_wynagrodzenia);

--c + f
ALTER TABLE firma.godziny ADD CONSTRAINT godziny_pracownicy FOREIGN KEY (id_pracownika) REFERENCES firma.pracownicy (id_pracownika);
ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT wynagrodzenie_pracownicy FOREIGN KEY (id_pracownika) REFERENCES firma.pracownicy (id_pracownika);
ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT wynagrodzenie_godziny FOREIGN KEY (id_godziny) REFERENCES firma.godziny (id_godziny);
ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT wynagrodzenie_pensja FOREIGN KEY (id_pensji) REFERENCES firma.pensja_stanowisko (id_pensji);
ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT wynagrodzenie_premia FOREIGN KEY (id_premii) REFERENCES firma.premia (id_premii);

--d
CREATE INDEX ON firma.pracownicy USING BTREE (imie);
CREATE INDEX ON firma.godziny USING BTREE (liczba_godzin);
CREATE INDEX ON firma.pensja_stanowisko USING BTREE (kwota);
CREATE INDEX ON firma.premia USING BTREE (kwota);
CREATE INDEX ON firma.wynagrodzenie USING BTREE (data);

--e
COMMENT ON TABLE firma.pracownicy IS 'To jest tabela pracownicy';
COMMENT ON TABLE firma.godziny IS 'To jest tabela godziny';
COMMENT ON TABLE firma.pensja_stanowisko IS 'To jest tabela pensja_stanowisko';
COMMENT ON TABLE firma.premia IS 'To jest tabela premia';
COMMENT ON TABLE firma.wynagrodzenie IS 'To jest tabela wynagrodzenie';

--pkt 5
INSERT INTO firma.pracownicy
(id_pracownika, imie, nazwisko, adres, telefon)
VALUES(1, 'Gabriela', 'Kycynowicz', 'ul. DONimirskiego AntONiego 86 81-273 Gdynia', '896236122');
INSERT INTO firma.pracownicy
(id_pracownika, imie, nazwisko, adres, telefon)
VALUES(2, 'Jacek', 'Bak', 'ul. JASminowa 127 02-717 Warszawa', '829411591');
INSERT INTO firma.pracownicy
(id_pracownika, imie, nazwisko, adres, telefon)
VALUES(3, 'Marek', 'WAS', 'Al. Jana Pawła II 41 00-145 Warszawa', NULL);
INSERT INTO firma.pracownicy
(id_pracownika, imie, nazwisko, adres, telefon)
VALUES(4, 'Adam', 'Kosowski', NULL, '979004691');
INSERT INTO firma.pracownicy
(id_pracownika, imie, nazwisko, adres, telefon)
VALUES(5, 'Jakub', 'Rataj', 'ul. Ogińskiego Michała 137 92-608 Łódź', '594128830');
INSERT INTO firma.pracownicy
(id_pracownika, imie, nazwisko, adres, telefon)
VALUES(6, 'Natalia', 'Milos', 'ul. ŁukASińskiego Waleriana 81 20-454 Lublin', NULL);
INSERT INTO firma.pracownicy
(id_pracownika, imie, nazwisko, adres, telefon)
VALUES(7, 'Mikolaj', 'Pollek', NULL, '493444694');
INSERT INTO firma.pracownicy
(id_pracownika, imie, nazwisko, adres, telefon)
VALUES(8, 'Mariusz', 'Gudzianowski', 'ul. Niska 117 81-646 Gdynia', '936836205');
INSERT INTO firma.pracownicy
(id_pracownika, imie, nazwisko, adres, telefon)
VALUES(9, 'Iga', 'Heglarz', 'ul. Podgórska 96 31-061 Kraków', '512035818');
INSERT INTO firma.pracownicy
(id_pracownika, imie, nazwisko, adres, telefon)
VALUES(10, 'AleksANDra', 'Bukowska', 'ul. Widłakowa 121 54-530 Wrocław', '673976457');

INSERT INTO firma.godziny
(id_godziny, "data", liczba_godzin, id_pracownika)
VALUES(1, '2020-03-01', 8, 1);
INSERT INTO firma.godziny
(id_godziny, "data", liczba_godzin, id_pracownika)
VALUES(2, '2020-03-01', 10, 2);
INSERT INTO firma.godziny
(id_godziny, "data", liczba_godzin, id_pracownika)
VALUES(3, '2020-03-01', 8, 3);
INSERT INTO firma.godziny
(id_godziny, "data", liczba_godzin, id_pracownika)
VALUES(4, '2020-03-01', 8, 4);
INSERT INTO firma.godziny
(id_godziny, "data", liczba_godzin, id_pracownika)
VALUES(5, '2020-03-01', 6, 5);
INSERT INTO firma.godziny
(id_godziny, "data", liczba_godzin, id_pracownika)
VALUES(6, '2020-03-01', 12, 6);
INSERT INTO firma.godziny
(id_godziny, "data", liczba_godzin, id_pracownika)
VALUES(7, '2020-03-01', 8, 7);
INSERT INTO firma.godziny
(id_godziny, "data", liczba_godzin, id_pracownika)
VALUES(8, '2020-03-01', 8, 8);
INSERT INTO firma.godziny
(id_godziny, "data", liczba_godzin, id_pracownika)
VALUES(9, '2020-03-01', 4, 9);
INSERT INTO firma.godziny
(id_godziny, "data", liczba_godzin, id_pracownika)
VALUES(10, '2020-03-01', 3, 10);

INSERT INTO firma.pensja_stanowisko
(id_pensji,stanowisko,kwota)
VALUES(1, 'firma',3500);
INSERT INTO firma.pensja_stanowisko
(id_pensji,stanowisko,kwota)
VALUES(2,'Sekretariat',3600);
INSERT INTO firma.pensja_stanowisko
(id_pensji,stanowisko,kwota)
VALUES(3,'Kierownik',3000);
INSERT INTO firma.pensja_stanowisko
(id_pensji,stanowisko,kwota)
VALUES(4,'Administracja',4200);
INSERT INTO firma.pensja_stanowisko
(id_pensji,stanowisko,kwota)
VALUES(5,'Zarzadzanie',6000);
INSERT INTO firma.pensja_stanowisko
(id_pensji,stanowisko,kwota)
VALUES(6,'Projektowanie',2800);
INSERT INTO firma.pensja_stanowisko
(id_pensji,stanowisko,kwota)
VALUES(7,'Ubezpieczenia',3800);
INSERT INTO firma.pensja_stanowisko
(id_pensji,stanowisko,kwota)
VALUES(8,'Kucharka',3000);
INSERT INTO firma.pensja_stanowisko
(id_pensji,stanowisko,kwota)
VALUES(9,'Kierowca',3200);
INSERT INTO firma.pensja_stanowisko
(id_pensji,stanowisko,kwota)
VALUES(10,'Kustosz',3500);

INSERT INTO firma.premia
(id_premii,rodzaj,kwota)
VALUES(1,'premia zdrowotna',300);
INSERT INTO firma.premia
(id_premii,rodzaj,kwota)
VALUES(2,'premia rodzinna',200);
INSERT INTO firma.premia
(id_premii,rodzaj,kwota)
VALUES(3,'premia swiateczna',500);
INSERT INTO firma.premia
(id_premii,rodzaj,kwota)
VALUES(4,'premia za dodatkowe godziny',800);
INSERT INTO firma.premia
(id_premii,rodzaj,kwota)
VALUES(5,'premia managerska',400);
INSERT INTO firma.premia
(id_premii,rodzaj,kwota)
VALUES(6,'premia zwycieska',200);
INSERT INTO firma.premia
(id_premii,rodzaj,kwota)
VALUES(7,'premia motywacyjna',900);
INSERT INTO firma.premia
(id_premii,rodzaj,kwota)
VALUES(8,'premia startowa',400);
INSERT INTO firma.premia
(id_premii,rodzaj,kwota)
VALUES(9,'premia koncowa',550);
INSERT INTO firma.premia
(id_premii,rodzaj,kwota)
VALUES(10,'premia roczna',150);

INSERT INTO firma.wynagrodzenie
(id_wynagrodzenia,"data",id_pracownika,id_godziny,id_pensji,id_premii)
VALUES(1,'2020-03-01',1,1,1,1);
INSERT INTO firma.wynagrodzenie
(id_wynagrodzenia,"data",id_pracownika,id_godziny,id_pensji,id_premii)
VALUES(2,'2020-03-01',2,2,2,1);
INSERT INTO firma.wynagrodzenie
(id_wynagrodzenia,"data",id_pracownika,id_godziny,id_pensji,id_premii)
VALUES(3,'2020-03-01',3,3,3,2);
INSERT INTO firma.wynagrodzenie
(id_wynagrodzenia,"data",id_pracownika,id_godziny,id_pensji,id_premii)
VALUES(4,'2020-03-01',4,4,4,3);
INSERT INTO firma.wynagrodzenie
(id_wynagrodzenia,"data",id_pracownika,id_godziny,id_pensji,id_premii)
VALUES(5,'2020-03-01',5,5,2,4);
INSERT INTO firma.wynagrodzenie
(id_wynagrodzenia,"data",id_pracownika,id_godziny,id_pensji,id_premii)
VALUES(6,'2020-03-01',6,6,3,5);
INSERT INTO firma.wynagrodzenie
(id_wynagrodzenia,"data",id_pracownika,id_godziny,id_pensji,id_premii)
VALUES(7,'2020-03-01',7,7,7,7);
INSERT INTO firma.wynagrodzenie
(id_wynagrodzenia,"data",id_pracownika,id_godziny,id_pensji,id_premii)
VALUES(8,'2020-03-01',8,8,3,6);
INSERT INTO firma.wynagrodzenie
(id_wynagrodzenia,"data",id_pracownika,id_godziny,id_pensji,id_premii)
VALUES(9,'2020-03-01',9,9,9,8);
INSERT INTO firma.wynagrodzenie
(id_wynagrodzenia,"data",id_pracownika,id_godziny,id_pensji,id_premii)
VALUES(10,'2020-03-01',10,10,10,9);

--a
ALTER TABLE firma.godziny ADD COLUMN miesiac SMALLINT;
UPDATE firma.godziny SET miesiac=date_part('mONth', data);
ALTER TABLE firma.godziny ADD COLUMN "nr tygodnia" SMALLINT;
UPDATE firma.godziny SET "nr tygodnia"=date_part('week', data);

--b
ALTER TABLE firma.wynagrodzenie 
	ALTER COLUMN data TYPE VARCHAR(25);

--c
UPDATE firma.premia SET kwota = 0 WHERE rodzaj='brak';

--pkt 6 a
SELECT id_pracownika, nazwisko FROM firma.pracownicy;
--b
SELECT pracownicy.id_pracownika FROM firma.pracownicy
	JOIN firma.wynagrodzenie ON firma.wynagrodzenie.id_pracownika = firma.pracownicy.id_pracownika
	JOIN firma.pensja_stanowisko ON firma.pensja_stanowisko.id_pensji = firma.wynagrodzenie.id_pensji
	WHERE kwota>1000;
--c
SELECT id_pracownika AS "pracownicy bez premii i wieksze od 2000" FROM firma.wynagrodzenie
	JOIN firma.premia ON firma.premia.id_premii = firma.wynagrodzenie.id_premii
	JOIN firma.pensja_stanowisko ON firma.pensja_stanowisko.id_pensji = firma.wynagrodzenie.id_pensji
	WHERE rodzaj = 'brak' AND pensja_stanowisko.kwota>2000;
--d
SELECT imie, nazwisko FROM firma.pracownicy WHERE imie LIKE 'J%';
--e
SELECT imie, nazwisko FROM firma.pracownicy WHERE (nazwisko LIKE '%n%' OR nazwisko LIKE 'N%' OR nazwisko LIKE '%n') AND imie LIKE '%a';
--f
SELECT imie, nazwisko,(20*liczba_godzin)-160 AS nadgodziny FROM firma.pracownicy
JOIN firma.wynagrodzenie ON firma.wynagrodzenie.id_pracownika=firma.pracownicy.id_pracownika
JOIN firma.godziny ON firma.godziny.id_godziny=firma.wynagrodzenie.id_godziny
WHERE (20*liczba_godzin)-160>0;
--g
SELECT imie, nazwisko FROM firma.pracownicy
JOIN firma.wynagrodzenie ON firma.wynagrodzenie.id_pracownika=firma.pracownicy.id_pracownika
JOIN firma.pensja_stanowisko ON firma.pensja_stanowisko.id_pensji=firma.wynagrodzenie.id_pensji
WHERE kwota between 1500 AND 3000;
--h
SELECT imie, nazwisko FROM firma.pracownicy
JOIN firma.wynagrodzenie ON firma.wynagrodzenie.id_pracownika=firma.pracownicy.id_pracownika
JOIN firma.godziny ON firma.godziny.id_godziny=firma.wynagrodzenie.id_godziny
JOIN firma.premia ON firma.premia.id_premii=firma.wynagrodzenie.id_premii
WHERE (20*liczba_godzin)-160>0 AND premia.kwota = 0;

--pkt 7 a
SELECT imie,nazwisko,kwota FROM firma.pracownicy 
JOIN firma.wynagrodzenie ON firma.wynagrodzenie.id_pracownika=firma.pracownicy.id_pracownika
JOIN firma.pensja_stanowisko ON firma.pensja_stanowisko.id_pensji=firma.wynagrodzenie.id_pensji
ORDER BY kwota;

--b
SELECT imie, nazwisko, (pensja_stanowisko.kwota + premia.kwota) AS "pensja + premia" FROM firma.pracownicy 
JOIN firma.wynagrodzenie ON firma.wynagrodzenie.id_pracownika=firma.pracownicy.id_pracownika
JOIN firma.pensja_stanowisko ON firma.pensja_stanowisko.id_pensji=firma.wynagrodzenie.id_pensji
JOIN firma.premia ON firma.premia.id_premii=firma.wynagrodzenie.id_premii
ORDER BY pensja_stanowisko.kwota + premia.kwota DESC;

--c
SELECT stanowisko, count(stanowisko) AS ilosc FROM firma.pensja_stanowisko 
JOIN firma.wynagrodzenie ON firma.pensja_stanowisko.id_pensji=firma.wynagrodzenie.id_pensji
JOIN firma.pracownicy ON firma.pracownicy.id_pracownika = firma.wynagrodzenie.id_pracownika
GROUP BY stanowisko;

--d
SELECT AVG(kwota) AS srednia, MIN(kwota), MAX(kwota) FROM firma.pensja_stanowisko
WHERE stanowisko LIKE 'Kierownik';

--e
SELECT sum(kwota) FROM firma.pensja_stanowisko
JOIN firma.wynagrodzenie ON firma.pensja_stanowisko.id_pensji=firma.wynagrodzenie.id_pensji
JOIN firma.pracownicy ON firma.pracownicy.id_pracownika = firma.wynagrodzenie.id_pracownika;

--f
SELECT stanowisko, SUM(kwota) FROM firma.pensja_stanowisko
JOIN firma.wynagrodzenie ON firma.pensja_stanowisko.id_pensji=firma.wynagrodzenie.id_pensji
JOIN firma.pracownicy ON firma.pracownicy.id_pracownika = firma.wynagrodzenie.id_pracownika
GROUP BY stanowisko;

--g
SELECT stanowisko, COUNT(rodzaj) FROM firma.premia
JOIN firma.wynagrodzenie ON firma.premia.id_premii=firma.wynagrodzenie.id_premii
JOIN firma.pensja_stanowisko ON firma.pensja_stanowisko.id_pensji=firma.wynagrodzenie.id_pensji
JOIN firma.pracownicy ON firma.pracownicy.id_pracownika = firma.wynagrodzenie.id_pracownika
GROUP BY stanowisko;

--h
DELETE FROM firma.pracownicy WHERE id_pracownika IN
(SELECT id_pracownika FROM firma.wynagrodzenie
JOIN firma.pensja_stanowisko ON firma.pensja_stanowisko.id_pensji=firma.wynagrodzenie.id_pensji
WHERE kwota<1200
);

--pkt 8 a
ALTER TABLE firma.pracownicy
ALTER COLUMN telefon TYPE VARCHAR(16); 
UPDATE firma.pracownicy SET telefon = '(+48)' || telefon;

--b
UPDATE firma.pracownicy SET telefon = substring(telefon,1,8) || '-' || substring(telefon,9,3) || '-' || substring(telefon,12,3);

--c
SELECT UPPER(nazwisko) FROM firma.pracownicy ORDER BY char_length(nazwisko) DESC LIMIT 1;

--d
SELECT pracownicy.*, md5(kwota::text) AS kwota FROM firma.pracownicy
JOIN firma.wynagrodzenie ON firma.wynagrodzenie.id_pracownika=firma.pracownicy.id_pracownika
JOIN firma.pensja_stanowisko ON firma.pensja_stanowisko.id_pensji=firma.wynagrodzenie.id_pensji
 
--pkt 9
SELECT 'Pracownik ' || firma.pracownicy.imie || ' ' || firma.pracownicy.nazwisko || ' w dniu ' 
|| firma.wynagrodzenie.data::date || ' otrzymal pensje calkowita na kwote ' || firma.pensja_stanowisko.kwota + firma.premia.kwota 
|| 'zl, gdzie wynagrodzenie zasadnicze wynosilo: ' || firma.pensja_stanowisko.kwota || 'zl, premia: ' || firma.premia.kwota 
|| 'zl, nadgodziny: 0 zl.' AS RapORt FROM firma.pracownicy 
JOIN firma.wynagrodzenie ON firma.wynagrodzenie.id_pracownika = firma.pracownicy.id_pracownika 
JOIN firma.pensja_stanowisko ON firma.pensja_stanowisko.id_pensji = firma.wynagrodzenie.id_pensji 
JOIN firma.premia ON firma.premia.id_premii =firma.wynagrodzenie.id_premii 
WHERE imie = 'Jan' AND nazwisko = 'Nowak';