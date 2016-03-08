-- I.3)
DESCRIBE employees;
DESCRIBE departments;
DESCRIBE jobs;
DESCRIBE job_history;
DESCRIBE locations
DESCRIBE countries;
DESCRIBE regions;

-- I.4)
SELECT * FROM employees;
SELECT * FROM departments;
-- etc

-- I.5)
SELECT employee_id, last_name, job_id, hire_date
FROM employees;

-- I.6)
SELECT job_id FROM employees;
SELECT DISTINCT job_id FROM employees;

-- I.7)
SELECT last_name || ', ' || job_id AS "Angajat si titlu"
FROM employees;

-- I.8)
SELECT employee_id    || ', ' ||
       first_name     || ', ' ||
       last_name      || ', ' ||
       email          || ', ' ||
       phone_number   || ', ' ||
       hire_date      || ', ' ||
       job_id         || ', ' ||
       salary         || ', ' ||
       commission_pct || ', ' ||
       manager_id     || ', ' ||
       department_id AS "Informatii Complete"
FROM employees;

-- I.9)
SELECT last_name, salary
FROM employees
WHERE salary > 2850
ORDER BY 2;

-- I.10)
SELECT last_name, department_id
FROM employees
WHERE employee_id = 104;

-- I.11)
SELECT last_name, salary
FROM employees
WHERE salary NOT BETWEEN 1500 AND 2850
ORDER BY 2;

-- I.12)
SELECT last_name, job_id, hire_date 
FROM employees
WHERE hire_date BETWEEN '20-FEB-1987' AND '01-MAY-1989'
ORDER BY 3;

-- I.13)
SELECT last_name, department_id
FROM employees
WHERE department_id IN (10, 30)
ORDER BY 1;

-- I.14)
SELECT last_name Angajat, salary AS "Salariu lunar"
FROM employees
WHERE salary > 3500 AND department_id IN (10, 30);

-- I.15)
--  'SYSDATE' returns the current date and time set for the
-- operating system on which the DATABASE resides
SELECT SYSDATE FROM dual;

-- 'CURRENT_DATE' returns the current date in the SESSION time zone
SELECT CURRENT_DATE FROM dual;

-- Refer to http://docs.oracle.com/cd/B28359_01/server.111/b28286/sql_elements004.htm#SQLRF00212
-- for a complete description of different format models.

SELECT TO_CHAR(SYSDATE, 'DD-MM-YYYY, HH24:MI:SS') FROM dual;
SELECT TO_CHAR(SYSDATE, 'MON DD, YYYY, HH24:MI:SS PM') FROM dual;

-- I.16) [1st Method]
SELECT last_name, salary
FROM employees
WHERE hire_date LIKE ('%87%');

-- I.16) [2nd Method]
SELECT last_name, salary
FROM employees
WHERE TO_CHAR(hire_date, 'YYYY') = '1987';
-- WHERE TO_CHAR(hire_date, 'YYYY') = 1987;

-- I.17)
SELECT last_name, job_id
FROM employees
WHERE manager_id IS NULL;

-- I.18)
SELECT last_name, salary, commission_pct
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY salary DESC, commission_pct DESC;

-- I.19)
SELECT last_name, salary, commission_pct
FROM employees
ORDER BY salary DESC, commission_pct DESC;

-- I.20)
SELECT last_name
FROM employees
WHERE LOWER(last_name) LIKE '__a%';

-- I.21)
SELECT last_name
FROM employees
WHERE LOWER(last_name) LIKE '%l%l%' OR department_id = 30 OR manager_id = 101;


-- I.22)
SELECT last_name, job_id, salary
FROM employees
WHERE (LOWER(job_id) LIKE '%clerk%' OR LOWER(job_id) LIKE '%rep%')
      AND salary NOT IN (1000, 2000, 3000);


-- I.23)
SELECT last_name, salary, commission_pct
FROM employees
WHERE salary > (salary * NVL(commission_pct, 1))*5;

