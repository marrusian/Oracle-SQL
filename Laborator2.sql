-- VARCHAR2/CHAR -> NUMBER OR DATE
-- NUMBER -> VARCHAR2/CHAR
-- DATE -> VARCHAR2/CHAR

-- LENGTH(string)
-- SUBSTR(string, start_pos [,length]); By default, length == LENGTH(string)-(start_pos-1);
-- LTRIM(string ['chars']); By default, 'chars' == ' '
-- RTRIM(string ['chars']); Same as above
-- TRIM(LEADING | TRAILING | BOTH 'chars' FROM string)
-- LPAD(string, length [,'chars']); By default, 'chars' == ' '
-- RPAD(string, length [,'chars'])
-- REPLACE(string1, s;tring2 [,string3])
-- UPPER(string), LOWER(string)
-- INITCAP(string)
-- CONCAT(string1, string2)
-- INSTR(string, 'chars' [,start [,occurrence]]); By default, start == 1, occurence == 1
-- TRANSLATE(string, source, destination)

-- II.1) [Using '||']
SELECT first_name || ' ' || last_name || ' castiga ' || salary ||
       ' lunar, dar doreste ' || salary*3 AS "Salariu ideal"
FROM employees;

-- II.1) [Using CONCAT(.,.)]
SELECT CONCAT(first_name,
       CONCAT(' ',
       CONCAT(last_name,
       CONCAT(' castiga ',
       CONCAT(salary,
       CONCAT(' lunar, dar doreste ', salary*3)))))) AS "Salariu ideal"
FROM employees;

-- II.2) [Using 'LIKE']
SELECT INITCAP(first_name) AS "First Name",
       UPPER(last_name) AS "Last Name",
       LENGTH(last_name) AS "LN Length"
FROM employees
WHERE LOWER(TRIM(last_name)) LIKE 'j%' OR
      LOWER(TRIM(last_name)) LIKE 'm%' OR
      LOWER(TRIM(last_name)) LIKE '__a%'
ORDER BY 3 DESC;

-- II.2) [Using 'LIKE']
SELECT INITCAP(first_name) AS "First Name",
       UPPER(last_name) AS "Last Name",
       LENGTH(last_name) AS "LN Length"
FROM employees
WHERE SUBSTR(LOWER(TRIM(last_name)), 1, 1) = 'j' OR
      SUBSTR(LOWER(TRIM(last_name)), 1, 1) = 'm' OR
      SUBSTR(LOWER(TRIM(last_name)), 3, 1) = 'a'
ORDER BY 3 DESC;

-- II.3)
SELECT employee_id, last_name, department_id
FROM employees
WHERE INITCAP(TRIM(first_name)) = 'Steven';

-- II.4)
SELECT employee_id, last_name, LENGTH(last_name), INSTR(last_name, 'a')
FROM employees;

-- II.5)
SELECT *
FROM employees
WHERE MOD(TRUNC(SYSDATE - hire_date), 7) = 0;

-- II.6)
SELECT employee_id, last_name, salary,
       ROUND(salary*1.15, 2) AS "Salariu nou",
       ROUND((salary*1.15)/100, 2) AS "Numar sute"
FROM employees
WHERE MOD(salary, 1000) != 0;

-- II.7)
SELECT RPAD(last_name, LENGTH('Nume angajat')) AS "Nume angajat",
       RPAD(hire_date, LENGTH('Data angajarii')) AS "Data angajarii"
FROM employees
WHERE commission_pct IS NOT NULL;

-- II.8)
SELECT TO_CHAR(SYSDATE + 30, 'MON DDth, YYYY, HH24:MI:SS')
FROM dual;

-- II.9)
SELECT LAST_DAY(TO_DATE('01-DEC-' || TO_CHAR(SYSDATE, 'YYYY'))) - SYSDATE AS "Days left"
FROM dual;

-- II.10a)
SELECT TO_CHAR(SYSDATE + 12/24, 'dd-mm-yyyy, hh24:mi:ss')
FROM dual;

-- II.10b)
SELECT TO_CHAR(SYSDATE + (5/60)/24, 'dd-mm-yyyy, hh24:mi:ss')
FROM dual;

-- II.11)
SELECT last_name || ' ' || first_name AS "Nume complet",
       hire_date,
       NEXT_DAY(ADD_MONTHS(hire_date, 6) - 1, 'Monday') AS Negociere
FROM employees;

-- II.12)
SELECT last_name, ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) AS "Luni lucrate"
FROM employees
ORDER BY 2;

-- II.13)
--SELECT last_name, hire_date, TO_CHAR(hire_date, 'day') AS Zi
--FROM employees
--ORDER BY 3;

-- II.14)
SELECT last_name, NVL(TO_CHAR(commission_pct), 'Fara comision') AS Comision
FROM employees;

-- II.15)
SELECT last_name, salary, commission_pct
     -- ,salary * (1 + NVL(commission_pct, 0)) AS "Venit lunar"
FROM employees
WHERE (salary + salary*NVL(commission_pct, 0)) > 10000;
-- (salary * (1 + NVL(commission_pct, 0))) > 10000;

-- II.16)
SELECT last_name, job_id, salary,
       salary * DECODE(UPPER(TRIM(job_id)),
                       'IT_PROG', 1.20,
                       'SA_REP', 1.25,
                       'SA_MAN', 1.35, 1) AS "Salariu renecogiat"
FROM employees;

-- II.17)
SELECT last_name, department_id, department_name
FROM employees JOIN departments USING (department_id);

-- II.18)
SELECT DISTINCT job_title
FROM employees JOIN jobs USING (job_id)
WHERE department_id = 30;

-- II.19)
SELECT last_name, department_name, city
FROM employees JOIN departments USING (department_id)
               JOIN locations   USING (location_id)
WHERE commission_pct IS NOT NULL;

-- II.20)
SELECT last_name, department_name
FROM employees JOIN departments USING (department_id)
WHERE LOWER(last_name) LIKE '%a%';

-- II.21)
SELECT employee_id, last_name, job_id, department_name
FROM employees JOIN departments USING (department_id)
               JOIN locations   USING (location_id)
WHERE INITCAP(TRIM(city)) = 'Oxford';

-- II.22)
SELECT ang.employee_id Ang#,
       ang.last_name Angajat,
       man.employee_id Mgr#,
       man.last_name Manager
FROM employees ang JOIN employees man ON (man.employee_id = ang.manager_id);

-- II.23)
SELECT ang.employee_id Ang#,
       ang.last_name Angajat,
       man.employee_id Mgr#,
       man.last_name Manager
FROM employees ang LEFT JOIN employees man ON (man.employee_id = ang.manager_id);

-- II.24)
SELECT ang.last_name, ang.department_id, clg.* 
FROM employees ang JOIN employees clg ON (ang.department_id = clg.department_id)
ORDER BY 1; -- ???

-- II.25)
DESCRIBE jobs;
SELECT last_name, job_id, job_title, department_name, salary
FROM employees JOIN jobs        USING (job_id)
               JOIN departments USING (department_id);

-- II.26)
SELECT ang.last_name, ang.hire_date
FROM employees ang JOIN employees gates ON (INITCAP(TRIM(gates.last_name)) = 'Gates')
WHERE ang.hire_date > gates.hire_date;

-- II.27)
SELECT ang.last_name Angajat,
       ang.hire_date Data_ang,
       man.last_name Manager,
       man.hire_date Data_mgr
FROM employees ang JOIN employees man ON (ang.manager_id = man.employee_id)
WHERE ang.hire_date < man.hire_date;
