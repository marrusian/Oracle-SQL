-- V.1a)
SELECT department_name, job_title, ROUND(AVG(salary), 2) AS "Salariu Mediu"
FROM employees JOIN departments USING (department_id)
               JOIN jobs USING (job_id)
GROUP BY ROLLUP(department_name, job_title);

-- V.1b)
SELECT department_name, job_title, ROUND(AVG(salary), 2) AS "Salariu Mediu",
       GROUPING(department_name) || '      ' || GROUPING(job_title) Grupari
FROM employees JOIN departments USING (department_id)
               JOIN jobs USING (job_id)
GROUP BY ROLLUP(department_name, job_title);

-- V.2a)
SELECT department_name, job_title, ROUND(AVG(salary), 2) AS "Salariu Mediu"
FROM employees JOIN departments USING (department_id)
               JOIN jobs USING (job_id)
GROUP BY CUBE(department_name, job_title);
-- ORDER BY 1, 2, 3 DESC;

-- V.2b)
SELECT department_name, job_title, ROUND(AVG(salary), 2) AS "Salariu Mediu",
       CASE
         WHEN GROUPING(department_name) = 0 AND GROUPING(job_title) = 0 THEN 'Dep/Job'
         WHEN GROUPING(department_name) = 0 THEN 'Dep'
         WHEN GROUPING(job_title) = 0 THEN 'Job'
         ELSE 'N/A'
       END Grupare
FROM employees JOIN departments USING (department_id)
               JOIN jobs USING (job_id)
GROUP BY CUBE(department_name, job_title);
-- ORDER BY 1, 2, 3 DESC;

-- V.3)
SELECT department_name, job_title, e.manager_id,
      MAX(salary) AS "Salariul Maxim",
      SUM(salary) AS "Salariul Total"
FROM employees e JOIN departments d USING (department_id)
                 JOIN jobs USING (job_id)
GROUP BY GROUPING SETS ( (department_name, job_title), (job_title, e.manager_id), () )
ORDER BY 1, 2, 3, 4, 5 DESC;

-- V.4)
SELECT MAX(salary)
FROM employees
HAVING MAX(salary) > 15000;
FROM employees
HAVING MAX(salary) > 15000;

-- V.5a)
SELECT *
FROM employees e
WHERE salary > (SELECT AVG(salary) FROM employees
                WHERE department_id = e.department_id
                GROUP BY department_id);

-- V.5b) [Subcereri sincronizate in clauza 'SELECT']
SELECT e.*,
      (SELECT department_name FROM departments WHERE department_id = e.department_id) AS "Nume departament",
      (SELECT ROUND(AVG(salary), 2) FROM employees WHERE department_id = e.department_id) AS "Salariu Mediu",
      (SELECT COUNT(*) FROM employees WHERE department_id = e.department_id) AS "Nr. Angajati"
FROM employees e
WHERE salary > (SELECT AVG(salary) FROM employees
                WHERE department_id = e.department_id
                GROUP BY department_id);

-- V.5b) [Subcerere nesincronizata in clauza 'FROM']
SELECT e.*, dep.department_name, ROUND(dep."Salariu Mediu", 2), dep."Nr. Angajati"
FROM employees e, (SELECT department_id, department_name,
                          AVG(salary) AS "Salariu Mediu",
                          COUNT(*) AS "Nr. Angajati"
                   FROM employees JOIN departments USING (department_id)
                   GROUP BY department_id, department_name) dep
WHERE salary > "Salariu Mediu" AND e.department_id = dep.department_id;

-- V.6) [Utilizand functia 'MAX']
SELECT last_name, salary
FROM employees
WHERE salary > (SELECT MAX(AVG(salary)) FROM employees GROUP BY department_id);

-- V.6) [Utilizand operatorul 'ALL']
SELECT last_name, salary
FROM employees
WHERE salary >ALL (SELECT AVG(salary) FROM employees GROUP BY department_id);

-- V.7) [Subcerere sincronizata]
SELECT department_id, last_name, salary
FROM employees e
WHERE salary = (SELECT MIN(salary) FROM employees WHERE department_id = e.department_id);

-- V.7) [Subcerere in clauza 'FROM'] [???]
SELECT department_id, last_name, salary
FROM (SELECT * FROM employees e
      WHERE salary = (SELECT MIN(salary) FROM employees WHERE department_id = e.department_id));

-- V.7) [Subcerere nesincronizata]
SELECT department_id, last_name, salary
FROM employees e
WHERE salary <=ALL (SELECT MIN(salary) FROM employees GROUP BY department_id);

-- V.8)
SELECT last_name
FROM departments d JOIN employees e ON (e.department_id = d.department_id)
WHERE hire_date = (SELECT MIN(hire_date) FROM employees WHERE department_id = d.department_id)
ORDER BY department_name;

-- V.9) [EXISTS]
SELECT last_name
FROM employees e
WHERE EXISTS (SELECT 1
              FROM employees
              WHERE department_id = e.department_id AND salary = (SELECT MAX(salary)
                                                                  FROM employees
                                                                  WHERE department_id = 30));
-- V.9) [IN]                                 
SELECT last_name
FROM employees
WHERE department_id IN (SELECT department_id
                        FROM employees
                        WHERE salary = (SELECT MAX(salary) FROM employees WHERE department_id = 30));

-- V.10) [ROWNUM/WITH]
WITH ord_desc_emp_sal AS (SELECT * FROM employees ORDER BY salary DESC)
SELECT last_name, salary
FROM ord_desc_emp_sal
WHERE ROWNUM < 4;

-- V.10) [COUNT()]
SELECT last_name, salary
FROM employees e
WHERE (SELECT COUNT(*) FROM employees WHERE salary > e.salary) < 3;

-- V.11)
SELECT employee_id, last_name, first_name
FROM employees e
WHERE (SELECT COUNT(*) FROM employees WHERE manager_id = e.employee_id) >= 2;

-- V.12) [EXISTS]
SELECT *
FROM locations l
WHERE EXISTS (SELECT 1 FROM departments WHERE location_id = l.location_id);

-- V.12) [IN]
SELECT *
FROM locations l
WHERE location_id IN (SELECT location_id FROM departments GROUP BY location_id);

-- V.13)
SELECT *
FROM departments d
WHERE NOT EXISTS (SELECT 1 FROM employees WHERE department_id = d.department_id);

-- V.14a)
SELECT employee_id, last_name, hire_date, salary, manager_id
FROM employees
WHERE manager_id = (SELECT employee_id FROM employees WHERE UPPER(TRIM(last_name)) = 'DE HAAN');

-- V.14b)
SELECT employee_id, last_name, hire_date, salary, manager_id, LEVEL
FROM employees
START WITH UPPER(TRIM(last_name)) = 'DE HAAN'
CONNECT BY PRIOR employee_id = manager_id;

-- V.15)
SELECT *
FROM employees
START WITH employee_id = 114
CONNECT BY PRIOR employee_id = manager_id;

-- V.16)
SELECT employee_id, manager_id, last_name, LEVEL
FROM employees
WHERE LEVEL = 3
START WITH UPPER(TRIM(last_name)) = 'DE HAAN'
CONNECT BY PRIOR employee_id = manager_id;

-- V.17)
SELECT employee_id, manager_id, last_name, LEVEL
FROM employees
CONNECT BY employee_id = PRIOR manager_id;

-- V.18)
SELECT employee_id, last_name, salary, manager_id, LEVEL
FROM employees
START WITH salary = (SELECT MAX(salary) FROM employees)
CONNECT BY PRIOR employee_id = manager_id AND salary > 5000;

-- V.19)
WITH dep_sum AS (SELECT department_id, SUM(salary) suma FROM employees GROUP BY department_id),
     avg_sal AS (SELECT AVG(suma) medie FROM dep_sum)
SELECT department_name, suma
FROM departments JOIN dep_sum USING (department_id)
WHERE suma > (SELECT * FROM avg_sal)
ORDER BY 2;

-- V.20)
WITH sub_dir_king AS (SELECT * FROM employees
                      WHERE manager_id = (SELECT employee_id FROM employees WHERE manager_id IS NULL)),
     oldest_subs AS (SELECT * FROM sub_dir_king 
                     WHERE hire_date = (SELECT MIN(hire_date) FROM sub_dir_king))
SELECT employee_id, first_name || ' ' || last_name AS "Full Name",
       job_id, hire_date
FROM employees
WHERE TO_CHAR(hire_date, 'YYYY') != 1970
START WITH employee_id IN (SELECT employee_id FROM oldest_subs)
CONNECT BY PRIOR employee_id = manager_id;

-- V.21)
WITH ord_desc_emp_salary AS (SELECT * FROM employees ORDER BY salary DESC)
SELECT *
FROM ord_desc_emp_salary
WHERE ROWNUM <= 10;

-- V.22)
WITH ord_asc_jobs_avgsal AS (SELECT job_id, AVG(salary) FROM employees GROUP BY job_id ORDER BY 2)
SELECT *
FROM ord_asc_jobs_avgsal
WHERE ROWNUM < 4;

-- V.23)
SELECT 'Departamentul ' || department_name || ' este condus de ' ||
        NVL(TO_CHAR(d.manager_id), 'nimeni') || ' si ' ||
        CASE (SELECT COUNT(*) FROM employees WHERE department_id = d.department_id)
          WHEN 0 THEN 'nu are salariati'
          ELSE 'are numarul de salariati ' || (SELECT COUNT(*) FROM employees WHERE department_id = d.department_id)
        END "Informatii Departamente"
FROM departments d;

-- V.24)
SELECT last_name, first_name, NULLIF(LENGTH(last_name), LENGTH(first_name))
FROM employees;

-- V.25)
SELECT last_name, hire_date, salary,
       salary * CASE TO_CHAR(hire_date, 'YYYY')
                  WHEN '1989' THEN 1.20
                  WHEN '1990' THEN 1.15
                  WHEN '1991' THEN 1.10
                  ELSE 1
                END AS "Salariu Marit"
FROM employees;

-- V.26) [???]
SELECT job_id,
       CASE
          WHEN UPPER(TRIM(SUBSTR(job_id, 1, 1))) = 'S'
           THEN (SELECT SUM(salary) FROM employees WHERE job_id = j.job_id)
          WHEN (SELECT MAX(salary) FROM employees WHERE job_id = j.job_id)
               = (SELECT MAX(MAX(salary)) FROM employees GROUP BY job_id)
           THEN (SELECT AVG(salary) FROM employees WHERE job_id = j.job_id)
          ELSE (SELECT MIN(salary) FROM employees WHERE job_id = j.job_id)
       END AS "Joburi"
FROM jobs j;