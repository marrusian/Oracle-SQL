-- Comenzile SQL care alcatuiesc LMD (Limbajul de Manipulare al Datelor) sunt:
--   SELECT, INSERT, UPDATE, MERGE, DELETE

--  "Tranzactia" este o unitate logica de lucru, constituita dintr-o secventa de comenzi
-- care trebuie executate atomic pentru a mentinte consistenta bazei de date;

--   Server-ul Oracle asigura consistenta datelor pe baza tranzactiilor, inclusiv in
-- eventualitatea unei anomalii a unui proces sau a sistemului.

-- Comenzile SQL care alcatuiesc LCD (Limbajul de Control al Datelor) sunt:
--   ROLLBACK, COMMIT,
--   SAVEPOINT (non-ANSI compliant; permite impartirea unei tranzactii in subtranzactii)

-- O comanda LDD (CREATE, ALTER, DROP) determina un 'COMMIT' implicit!
---------------------------------------------------------------------------------------------

-- INSERT INTO nume_tabel [alias] [(nume_coloana[, nume_coloana...])
-- {VALUES ( {expr | DEFAULT}[, {expr | DEFAULT} ...]) | subcerere}

-- INSERT ALL INTO... [INTO...]
--    subcerere;

--  INSERT[ALL | FIRST]
--  WHEN conditie THEN INTO ...
-- [WHEN conditie THEN INTO...
-- [ELSE INTO ...]]
--    subcerere;

-- VII.1)
CREATE TABLE emp_osa AS SELECT * FROM employees;
CREATE TABLE dep_osa AS SELECT * FROM departments;

-- VII.2)
DESC employees;
DESC emp_osa;

DESC departments;
DESC dep_osa;

-- VII.3)
SELECT * FROM emp_osa;
SELECT * FROM dep_osa;

-- VII.4)
ALTER TABLE emp_osa
ADD CONSTRAINT pk_emp_osa PRIMARY KEY (employee_id);

ALTER TABLE dep_osa
ADD CONSTRAINT pk_dep_osa PRIMARY KEY (department_id);

ALTER TABLE emp_osa
ADD CONSTRAINT fk_emp_dep_osa FOREIGN KEY (department_id) REFERENCES dep_osa (department_id);

DESC dep_osa;

-- VII.5a) [Incorrect - SQL Error: ORA-00947: not enough values]
INSERT INTO dep_osa
VALUES (300, 'Programare');

-- VII.5b) [Correct]
INSERT INTO dep_osa (department_id, department_name)
VALUES (300, 'Programare');
ROLLBACK;

-- VII.5c) [Incorect - SQL Error: ORA-01722: invalid number]
INSERT INTO dep_osa (department_name, department_id)
VALUES (300, 'Programare');

-- VII.5d) [Correct]
INSERT INTO dep_osa (department_id, department_name, location_id)
VALUES (300, 'Programare', NULL);
ROLLBACK;

-- VII.5e) [Incorrect - SQL Error: ORA-01400: cannot insert NULL into ("GRUPA41"."DEP_OSA"."DEPARTMENT_ID")]
INSERT INTO dep_osa (department_name, location_id)
VALUES ('Programare', NULL);

-- VII.6)
INSERT INTO emp_osa
VALUES (250, NULL, 'nume250', 'email250', NULL, SYSDATE, 'job1', NULL, NULL, NULL, 300);
COMMIT;

-- VII.7)
INSERT INTO emp_osa (employee_id, last_name, email, hire_date, job_id, department_id)
VALUES (260, 'nume260', 'email260', SYSDATE, 'job260', 300);
COMMIT;

-- VII.8)
INSERT INTO (SELECT employee_id, last_name, email, job_id, hire_date  FROM emp_osa)
VALUES ((SELECT MAX(employee_id)+1 FROM emp_osa), 'nume_nou', 'email_nou', 'job_nou', SYSDATE);
COMMIT;

-- VII.9)
CREATE TABLE emp1_osa AS SELECT * FROM employees WHERE 1=2;
INSERT INTO emp1_osa
SELECT * FROM employees WHERE commission_pct > 0.25;
COMMIT;

-- VII.10)
INSERT INTO emp_osa
VALUES (0, USER, USER, 'TOTAL', NULL, SYSDATE, 'TOTAL',
       (SELECT SUM(SALARY) FROM emp_osa),
       (SELECT AVG(commission_pct) FROM emp_osa),
       NULL, NULL);
COMMIT;

-- VII.11)
-- Script --
INSERT INTO emp_osa (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES (&emp_id, '&&fnm', '&&lnm', SUBSTR('&&fnm', 1, 1) || SUBSTR('&&lnm', 1, 7), SYSDATE, 'IT_PROG'); 
UNDEFINE fnm;
UNDEFINE lnm;

@"/home/marru/Desktop/l7p11.sql"

-- VII.12)
CREATE TABLE emp1_osa AS (SELECT * FROM employees WHERE 1=2);
CREATE TABLE emp2_osa AS (SELECT * FROM employees WHERE 1=2);
CREATE TABLE emp3_osa AS (SELECT * FROM employees WHERE 1=2);

INSERT ALL -- FIRST [nu conteaza in acest caz]
  WHEN salary < 5000 THEN INTO emp1_osa
  WHEN salary BETWEEN 5000 AND 10000 THEN INTO emp2_osa
  ELSE INTO emp3_osa
  SELECT * FROM employees;
COMMIT;

DELETE FROM emp1_osa;
DELETE FROM emp2_osa;
DELETE FROM emp3_osa;

-- VII.13)
CREATE TABLE emp0_osa AS (SELECT * FROM employees WHERE 1=2);

INSERT FIRST
  WHEN department_id = 80 THEN INTO emp0_osa
  WHEN salary < 5000 THEN INTO emp1_osa
  WHEN salary BETWEEN 5000 AND 10000 THEN INTO emp2_osa
  ELSE INTO emp3_osa
  SELECT * FROM employees;
COMMIT;

-- UPDATE nume_tabel [alias]
-- SET col1 = expr1[, col2=expr2]
-- [WHERE conditie];

-- UPDATE nume_tabel [alias]
-- SET (col1, col2, ...) = (subcerere)
-- [WHERE conditie];

-- VII.14)
UPDATE emp_osa
SET salary = salary*1.05;

SELECT * FROM emp_osa;
ROLLBACK;

-- VII.15)
UPDATE emp_osa
SET job_id = 'SA_REP'
WHERE department_id = 80 AND commission_pct IS NOT NULL;

SELECT * FROM emp_osa;
ROLLBACK;

-- VII.16) [Raspuns: Nu se poate, deoarece trebuie sa accesam tabele diferite]
UPDATE dep_osa
SET manager_id = (SELECT employee_id FROM emp_osa
                  WHERE UPPER(TRIM(first_name) || ' ' || TRIM(last_name)) = 'DOUGLAS GRANT')
WHERE department_id = 20;

UPDATE emp_osa
SET salary = salary+1000
WHERE UPPER(TRIM(first_name) || ' ' || TRIM(last_name)) = 'DOUGLAS GRANT';

ROLLBACK;

-- VII.17)
UPDATE emp_osa e
SET (salary, commission_pct) = (SELECT salary, commission_pct FROM emp_osa
                                WHERE employee_id = e.manager_id)
WHERE salary*(NVL(commission_pct, 0)+1) = (SELECT MIN(salary*(NVL(commission_pct, 0)+1)) FROM emp_osa);

ROLLBACK;

-- VII.18)
UPDATE emp_osa e
SET email = SUBSTR(last_name, 1, 1) || NVL(first_name, '.')
WHERE salary = (SELECT MAX(salary) FROM emp_osa WHERE department_id = e.department_id);

SELECT email
FROM emp_osa;

ROLLBACK;

-- VII.19)
UPDATE emp_osa e
SET salary = (SELECT AVG(salary) FROM emp_osa)
WHERE hire_date = (SELECT MIN(hire_date) FROM emp_osa WHERE department_id = e.department_id);

ROLLBACK;

-- VII.20)
UPDATE emp_osa
SET (job_id, department_id) = (SELECT job_id, department_id FROM emp_osa WHERE employee_id = 205)
WHERE employee_id = 114;

ROLLBACK;

-- VII.21)
-- SCRIPT --
ACCEPT dep_id PROMPT 'Introduceti codul departamentului: ';
SELECT * FROM dep_osa WHERE department_id = &dep_id;

UPDATE dep_osa
SET (department_name, manager_id, location_id) = (SELECT '&dep_nm', &mng_id, &loc_id FROM dual)
WHERE department_id = &dep_id;

UNDEFINE dep_id;

-- ROLLBACK;

-- DELETE FROM nume_tabel [alias]
-- [WHERE conditie];

-- VII.22) [SQL Error: ORA-02292: integrity constraint (GRUPA41.FK_EMP_DEP_OSA) violated - child record found]
-- Deci se pot sterge doar departamentele in care nu lucreaza niciun angajat
DELETE FROM dep_osa;

-- VII.23)
DELETE FROM emp_osa
WHERE commission_pct IS NULL;

ROLLBACK;

-- VII.24)
DELETE FROM dep_osa e
WHERE (SELECT COUNT(*)
       FROM dep_osa JOIN emp_osa USING (department_id)
       WHERE department_id = e.department_id) = 0;

ROLLBACK;

-- VII.25)
-- SCRIPT --
ACCEPT emp_id PROMPT 'Introduceti codul angajatului: ';
SELECT * FROM emp_id WHERE employee_id = &emp_id;

DELETE FROM emp_osa
WHERE employee_id = &emp_id;

UNDEFINE emp_id;

-- ROLLBACK;

-- VII.26)
@"/home/marru/Desktop/l7p11.sql";

-- VII.27)
SAVEPOINT l7p26_insert;

-- VII.28)
DELETE FROM emp_osa;
SELECT * FROM emp_osa;

-- VII.29)
ROLLBACK TO l7p26_insert;

-- VII.30)
SELECT * FROM emp_osa;
COMMIT;

-- VII.31)
DELETE FROM emp_osa
WHERE commission_pct IS NOT NULL;

MERGE INTO emp_osa eos
USING employees emp
ON (eos.employee_id = emp.employee_id)
WHEN MATCHED THEN
  UPDATE SET commission_pct = emp.commission_pct
WHEN NOT MATCHED THEN
  INSERT (employee_id, first_name, last_name, email, phone_number,
          hire_date, job_id, salary, commission_pct, manager_id, department_id)
  VALUES (emp.employee_id, emp.first_name, emp.last_name, emp.email, emp.phone_number,
          emp.hire_date, emp.job_id, emp.salary, emp.commission_pct, emp.manager_id,
          emp.department_id);

ROLLBACK;