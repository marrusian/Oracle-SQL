INSERT INTO angajati_osa(cod_ang, nume, prenume, job, salariu, cod_dep)
VALUES (100, 'Nume1', 'Prenume1', 'Director', 20000, 10);

INSERT INTO angajati_osa
VALUES (101, 'Nume2', 'Prenume2', 'Nume2', TO_DATE('02-FEB-2004'), 'Inginer', 100, 10000, 10, NULL);

INSERT INTO angajati_osa
VALUES (102, 'Nume3', 'Prenume3', 'Nume3', TO_DATE('05-JUN-2000'), 'Analist', 101, 50000, 20, 0.1);

INSERT INTO angajati_osa(cod_ang, nume, prenume, job, cod_sef, salariu, cod_dep)
VALUES (103, 'Nume4', 'Prenume4', 'Inginer', 100, 9000, 20);

INSERT INTO angajati_osa
VALUES (104, 'Nume5', 'Prenume5', 'Nume5', NULL, 'Analist', 101, 3000, 30, 0.1);