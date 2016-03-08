SELECT * FROM user_tables;

SELECT * FROM tab;

SELECT * FROM user_constraints;

SELECT * FROM user_cons_columns;

-- VIII.1a)
CREATE TABLE angajati_osa
(
    cod_ang  NUMBER(4),
    nume     VARCHAR2(20),
    prenume  VARCHAR2(20),
    email    CHAR(15),
    data_ang DATE,
    job      VARCHAR2(10),
    cod_sef  NUMBER(4),
    salariu  NUMBER(8,2),
    cod_dep  NUMBER(2)
);

DROP TABLE angajati_osa;

-- VIII.1b)
CREATE TABLE angajati_osa
(
    cod_ang  NUMBER(4) PRIMARY KEY,
    nume     VARCHAR2(20) NOT NULL,
    prenume  VARCHAR2(20),
    email    CHAR(15),
    data_ang DATE DEFAULT SYSDATE,
    job      VARCHAR2(10),
    cod_sef  NUMBER(4),
    salariu  NUMBER(8,2) NOT NULL,
    cod_dep  NUMBER(2)
);

DROP TABLE angajati_osa;

-- VIII.1c)
CREATE TABLE angajati_osa
(
    cod_ang  NUMBER(4),
    nume     VARCHAR2(20) NOT NULL,
    prenume  VARCHAR2(20),
    email    CHAR(15),
    data_ang DATE DEFAULT SYSDATE,
    job      VARCHAR2(10),
    cod_sef  NUMBER(4),
    salariu  NUMBER(8,2) NOT NULL,
    cod_dep  NUMBER(2),
    PRIMARY KEY(cod_ang)
);

DROP TABLE angajati_osa;

-- VIII.2)
INSERT INTO angajati_osa(cod_ang, nume, prenume, job, salariu, cod_dep)
VALUES (100, 'Nume1', 'Prenume1', 'Director', 20000, 10);

INSERT INTO angajati_osa
VALUES (101, 'Nume2', 'Prenume2', 'Nume2', TO_DATE('02-FEB-2004'), 'Inginer', 100, 10000, 10);

INSERT INTO angajati_osa
VALUES (102, 'Nume3', 'Prenume3', 'Nume3', TO_DATE('05-JUN-2000'), 'Analist', 101, 50000, 20);

INSERT INTO angajati_osa(cod_ang, nume, prenume, job, cod_sef, salariu, cod_dep)
VALUES (103, 'Nume4', 'Prenume4', 'Inginer', 100, 9000, 20);

INSERT INTO angajati_osa
VALUES (104, 'Nume5', 'Prenume5', 'Nume5', NULL, 'Analist', 101, 3000, 30);

COMMIT;

-- VIII.3) [Sunt copiate doar costrangerile de tip NOT NULL]
CREATE TABLE angajati10_osa AS (SELECT * FROM angajati_osa);
DESC angajati10_osa;

-- VIII.4)
ALTER TABLE angajati_osa
ADD comision NUMBER(4,2);

-- VIII.5) [SQL Error: ORA-01440: column to be modified must be empty to decrease precision or scale]
ALTER TABLE angajati_osa
MODIFY salariu NUMBER(6,2);

-- VIII.6)
ALTER TABLE angajati_osa
MODIFY salariu DEFAULT 2000;

-- VIII.7)
ALTER TABLE angajati_osa
MODIFY (comision NUMBER(2,2), salariu NUMBER (10,2));

-- VIII.8)
UPDATE angajati_osa
SET comision = 0.1
WHERE SUBSTR(UPPER(TRIM(job)), 1, 1) = 'A';
-- WHERE UPPER(TRIM(job)) LIKE 'A%';

-- VIII.9)
ALTER TABLE angajati_osa
MODIFY email VARCHAR2(20);

-- VIII.10)
ALTER TABLE angajati_osa
ADD nr_telefon VARCHAR(10) DEFAULT 0213231232;

-- VIII.11)
SELECT * FROM angajati_osa;

ALTER TABLE angajati_osa
DROP COLUMN nr_telefon;

-- VIII.12)
RENAME angajati_osa TO angajati3_osa;

-- VIII.13)
SELECT * FROM tab;
RENAME angajati3_osa TO angajati_osa;

-- VIII.14)
TRUNCATE TABLE angajati10_osa;

-- VIII.15)
CREATE TABLE departamente_osa
(
    cod_dep      NUMBER(2),
    nume         VARCHAR2(15) NOT NULL,
    cod_director NUMBER(4)
);
DESC departamente_osa;

-- VIII.16)
INSERT INTO departamente_osa
VALUES (10, 'Administrativ', 100);

INSERT INTO departamente_osa
VALUES (20, 'Proiectare', 101);

INSERT INTO departamente_osa
VALUES (30, 'Programare', NULL);

COMMIT;

-- VIII.17)
ALTER TABLE departamente_osa
ADD CONSTRAINT pk_cod_dep_osa PRIMARY KEY (cod_dep);

-- VIII.18a)
ALTER TABLE angajati_osa
ADD CONSTRAINT fk_cod_dep_osa FOREIGN KEY (cod_dep) REFERENCES departamente_osa (cod_dep);

-- VIII.18b)
DROP TABLE angajati_osa;

CREATE TABLE angajati_osa
(
    cod_ang  NUMBER(4) CONSTRAINT pk_cod_ang_osa PRIMARY KEY,
    nume     VARCHAR2(20) NOT NULL,
    prenume  VARCHAR2(20),
    email    CHAR(15),
    data_ang DATE DEFAULT SYSDATE,
    job      VARCHAR2(10),
    cod_sef  NUMBER(4) CONSTRAINT fk_cod_sef_osa REFERENCES angajati_osa (cod_ang),
    salariu  NUMBER(8,2) NOT NULL,
    cod_dep  NUMBER(2) CONSTRAINT fk_cod_dep_osa REFERENCES departamente_osa (cod_dep),
                       CONSTRAINT ck_cod_dep CHECK (cod_dep > 0),
    comision NUMBER(2,2),
    CONSTRAINT ck_sal_com CHECK (salariu>comision*100),
    CONSTRAINT uq_num_prenum UNIQUE (nume, prenume)
);

-- VIII.19)
DROP TABLE angajati_osa;

CREATE TABLE angajati_osa
(
    cod_ang  NUMBER(4),
    nume     VARCHAR2(20) NOT NULL,
    prenume  VARCHAR2(20),
    email    CHAR(15),
    data_ang DATE DEFAULT SYSDATE,
    job      VARCHAR2(10),
    cod_sef  NUMBER(4),
    salariu  NUMBER(8,2) NOT NULL,
    cod_dep  NUMBER(2),
    comision NUMBER(2,2),
    CONSTRAINT pk_cod_ang_osa PRIMARY KEY (cod_ang),
    CONSTRAINT fk_cod_sef_osa FOREIGN KEY (cod_sef) REFERENCES angajati_osa (cod_ang),
    CONSTRAINT fk_cod_dep_osa FOREIGN KEY (cod_dep) REFERENCES departamente_osa (cod_dep),
    CONSTRAINT ck_cod_dep CHECK (cod_dep > 0),
    CONSTRAINT ck_sal_com CHECK (salariu>comision*100),
    CONSTRAINT uq_num_prenum UNIQUE (nume, prenume)
);

-- VIII.20)
@"/home/marru/Desktop/l8p2.sql"

-- VIII.21) [SQL Error: ORA-02449: unique/primary keys in table referenced by foreign keys]
DROP TABLE departamente_osa;

-- VIII.22)
DESC user_tables;
SELECT * FROM user_tables;

DESC tab;
SELECT * FROM tab;

DESC user_constraints;
SELECT * FROM user_constraints;

DESC user_cons_columns;
SELECT * FROM user_cons_columns;

-- VIII.23a)
SELECT constraint_name, constraint_type, table_name
FROM user_constraints
WHERE lower(table_name) IN ('angajati_osa', 'departamente_osa')
ORDER BY 3, 2 DESC, 1;

-- VIII.23b)
SELECT table_name, constraint_name, column_name
FROM user_cons_columns
WHERE lower(table_name) IN ('angajati_osa', 'departamente_osa')
ORDER BY 1, 2, 3;

-- VIII.24) [SQL Error: ORA-02293: cannot validate (GRUPA41.SYS_C0086382) - check constraint violated]
ALTER TABLE angajati_osa
ADD CHECK (email IS NOT NULL);

-- VIII.25) [Nu, nu se poate, deoarece nu exista niciun departament avand codul 50]
-- [SQL Error: ORA-02291: integrity constraint (GRUPA41.FK_COD_DEP_OSA) violated - parent key not found]
INSERT INTO angajati_osa (cod_ang, nume, salariu, cod_dep)
VALUES (105, 'Nume6', 5000, 50);

-- VIII.26)
INSERT INTO departamente_osa
VALUES (60, 'Analiza', NULL);

COMMIT;

-- VIII.27) [SQL Error: ORA-02292: integrity constraint (GRUPA41.FK_COD_DEP_OSA) violated - child record found]
DELETE FROM departamente_osa
WHERE cod_dep = 20;

-- VIII.28)
DELETE FROM departamente_osa
WHERE cod_dep = 60;

ROLLBACK;

-- VIII.29) [SQL Error: ORA-02291: integrity constraint (GRUPA41.FK_COD_SEF_OSA) violated - parent key not found]
INSERT INTO angajati_osa (cod_ang, nume, cod_sef, salariu)
VALUES (105, 'Nume6', 114, 5000);

-- VIII.30) [Reiese ca, mai intai, trebuie sa inseram 'cheile parinte']
INSERT INTO angajati_osa (cod_ang, nume, salariu)
VALUES (114, 'Sef114', 10000);

COMMIT;

INSERT INTO angajati_osa (cod_ang, nume, cod_sef, salariu)
VALUES (105, 'Nume6', 114, 5000);

COMMIT;

-- VIII.31)
ALTER TABLE angajati_osa
DROP CONSTRAINT fk_cod_dep_osa;

ALTER TABLE angajati_osa
ADD CONSTRAINT fk_cod_dep_osa FOREIGN KEY (cod_dep) REFERENCES departamente_osa (cod_dep) ON DELETE CASCADE;

-- VIII.32) [Sunt stersi toti angajatii anexati departamentului cu codul 20 (i.e., ON DELETE CASCADE)]
DELETE FROM departamente_osa
WHERE cod_dep = 20;

ROLLBACK;

-- VIII.33)
ALTER TABLE departamente_osa
ADD CONSTRAINT fk_cod_dir FOREIGN KEY (cod_director) REFERENCES angajati_osa (cod_ang) ON DELETE SET NULL;

-- VIII.34) [Dupa stergerea angajatului cu codul 102, departamentul cu codul 30 ramane fara director (i.e., ON DELETE SET NULL)]
UPDATE departamente_osa
SET cod_director = 102
WHERE cod_dep = 30;

DELETE FROM angajati_osa
WHERE cod_ang = 102;

ROLLBACK;

-- SQL Error: ORA-02292: integrity constraint (GRUPA41.FK_COD_SEF_OSA) violated - child record found
--   Nu este posibila stergerea angajatului cu codul 101, deoarece constrangerea de cheie externa nu
-- are o conditie de tipul 'ON DELETE ...'
DELETE FROM angajati_osa
WHERE cod_ang = 101;

-- VIII.35)
-- SQL Error: ORA-02293: cannot validate (GRUPA41.SYS_C0086406) - check constraint violated
ALTER TABLE angajati_osa
ADD CHECK (salariu<30000);

--UPDATE angajati_osa
--SET salariu = salariu/2
--WHERE salariu >= 30000;

--COMMIT;

ALTER TABLE angajati_osa
ADD CHECK (salariu<30000);

-- VIII.36) [SQL Error: ORA-02290: check constraint (GRUPA41.SYS_C0086407) violated]
UPDATE angajati_osa
SET salariu = 35000
WHERE cod_ang = 100;

-- VIII.37) [SQL Error: ORA-02293: cannot validate (GRUPA41.SYS_C0086407) - check constraint violated]
ALTER TABLE angajati_osa
MODIFY CONSTRAINT SYS_C0086407 DISABLE;
-- DISABLE CONSTRAINT SYS_C0086407;

UPDATE angajati_osa
SET salariu = 35000
WHERE cod_ang = 100;

ALTER TABLE angajati_osa
MODIFY CONSTRAINT SYS_C0086407 ENABLE;
-- ENABLE CONSTRAINT SYS_C0086407;
