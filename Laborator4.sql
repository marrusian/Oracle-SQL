-- IV.1a)
-- Cu exceptia functiei agregat COUNT(*), toate celelalte functii grup ignora valorile NULL.

-- IV.1b)
--   Conditiile din clauza WHERE sunt aplicate fiecarei linii returnate in parte, in timp ce conditiile din clauza HAVING
-- actioneaza pe grupul (grupurile) de linii returnat (returnate).

-- IV.2)
SELECT MAX(salary) Maxim,
       MIN(salary) Minim,
       SUM(salary) Suma,
       ROUND(AVG(salary), 2) Media
FROM employees;

-- IV.3)
SELECT job_id, MIN(salary), MAX(salary), SUM(salary), ROUND(AVG(salary), 2)
FROM employees
GROUP BY job_id
ORDER BY 5;

-- IV.4)
SELECT job_id, COUNT(*)
FROM employees
GROUP BY job_id
ORDER BY 1;

-- IV.5)
SELECT COUNT(COUNT(*)) AS "Nr. manageri"
FROM employees
GROUP BY manager_id;

-- IV.6)
SELECT MAX(salary) - MIN(salary) AS "Diferenta MAX/MIN"
FROM employees;

-- IV.7)
SELECT department_name AS "Nume departament",
       NVL(city, 'N/A') AS "Locatie departament",
       COUNT(employee_id) AS "Numar angajati",
       NVL(ROUND(SUM(salary)/COUNT(*), 2), 0) AS "Salariu mediu"
FROM departments LEFT JOIN employees USING (department_id)
                 LEFT JOIN locations USING (location_id)
GROUP BY department_id, department_name, city;

-- IV.8)
SELECT employee_id, last_name
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;

-- IV.9)
SELECT manager_id, MIN(salary)
FROM employees
GROUP BY manager_id
HAVING manager_id IS NOT NULL AND MIN(salary) >= 1000
ORDER BY 2 DESC;

-- IV.10)
SELECT department_id, department_name, MAX(salary)
FROM employees JOIN departments USING (department_id)
GROUP BY department_id, department_name
HAVING MAX(salary) > 3000
ORDER BY 3 DESC;

-- IV.11)
SELECT MIN(AVG(salary))
FROM employees
GROUP BY job_id;

-- IV.12)
SELECT department_id, department_name, NVL(SUM(salary), 0) AS "Suma Salarii"
FROM departments LEFT JOIN employees USING (department_id)
GROUP BY department_id, department_name;

-- IV.13)
SELECT MAX(AVG(salary))
FROM employees
GROUP BY job_id;

-- IV.14)
SELECT job_id, job_title, AVG(salary)
FROM jobs JOIN employees USING (job_id)
GROUP BY job_id, job_title
HAVING AVG(salary) = (SELECT MIN(AVG(salary)) FROM employees GROUP BY job_id);

-- IV.15)
SELECT AVG(salary)
FROM employees
HAVING AVG(salary) > 2500;

-- IV.16)
SELECT department_id, job_id, SUM(salary)
FROM employees
GROUP BY department_id, job_id
ORDER BY 1, 2;

-- IV.17)
SELECT department_name, MIN(salary)
FROM employees JOIN departments USING (department_id)
GROUP BY department_id, department_name
HAVING AVG(salary) = (SELECT MAX(AVG(salary)) FROM employees GROUP BY department_id);

-- IV.18a)
SELECT department_id, department_name, COUNT(*) AS "Numar angajati"
FROM employees JOIN departments USING (department_id)
GROUP BY department_id, department_name
HAVING COUNT(*) < 4;

-- IV.18b)
SELECT department_id, department_name, COUNT(*) AS "Numar angajati"
FROM employees JOIN departments USING (department_id)
GROUP BY department_id, department_name
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM employees GROUP BY department_id);

-- IV.19)
SELECT *
FROM employees
WHERE TO_CHAR(hire_date, 'dd') = (SELECT TO_CHAR(hire_date, 'dd')
                                  FROM employees
                                  GROUP BY TO_CHAR(hire_date, 'dd')
                                  HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM employees GROUP BY TO_CHAR(hire_date, 'dd')));

-- IV.20)
SELECT COUNT(COUNT(*))
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 15;

-- IV.21)
SELECT department_id, SUM(salary)
FROM employees
WHERE department_id != 30
GROUP BY department_id
HAVING COUNT(*) > 10
ORDER BY 1, 2;

-- IV.22)
SELECT ang_grp.department_id, department_name,
       NVL(COUNT(ang_grp.employee_id), 0) AS "Numar angajati",
       NVL(ROUND(AVG(ang_grp.salary), 2), 0) AS "Salariu mediu",
       ang_dep.last_name, ang_dep.salary, ang_dep.job_id
FROM employees ang_grp RIGHT JOIN departments d ON (ang_grp.department_id = d.department_id)
                       LEFT JOIN employees ang_dep ON (ang_grp.department_id = ang_dep.department_id)
GROUP BY ang_grp.department_id, department_name, ang_dep.last_name, ang_dep.salary, ang_dep.job_id
ORDER BY 1, 2;

-- IV.23)
SELECT city, department_name, job_id, SUM(salary) AS "Salariu total"
FROM employees JOIN departments USING (department_id)
               JOIN locations USING (location_id)
WHERE department_id > 80
GROUP BY department_id, department_name, job_id, city
ORDER BY 2, 3, 1;

-- IV.24)
SELECT *
FROM employees
WHERE employee_id IN (SELECT employee_id
                      FROM job_history
                      GROUP BY employee_id
                      HAVING COUNT(*) >= 2);

-- IV.25)
SELECT SUM(commission_pct)/COUNT(*) AS "Comision mediu/firma"
FROM employees;

-- IV.27)
SELECT job_id job,
       (SELECT SUM(salary) FROM employees WHERE job_id = e.job_id AND department_id = 30) Dep30,
       (SELECT SUM(salary) FROM employees WHERE job_id = e.job_id AND department_id = 50) Dep50,
       (SELECT SUM(salary) FROM employees WHERE job_id = e.job_id AND department_id = 80) Dep80,
       (SELECT SUM(salary) FROM employees WHERE job_id = e.job_id) Total
FROM employees e
GROUP BY job_id;

-- IV.28)
SELECT DISTINCT (SELECT COUNT(*) FROM employees) AS Total,
                (SELECT COUNT(*) FROM employees WHERE TO_CHAR(hire_date, 'yyyy') = '1997') AS "1997",
                (SELECT COUNT(*) FROM employees WHERE TO_CHAR(hire_date, 'yyyy') = '1998') AS "1998",
                (SELECT COUNT(*) FROM employees WHERE TO_CHAR(hire_date, 'yyyy') = '1999') AS "1999",
                (SELECT COUNT(*) FROM employees WHERE TO_CHAR(hire_date, 'yyyy') = '2000') AS "2000"
FROM employees;

-- IV.29) [ROLLUP]
SELECT department_id, TO_CHAR(hire_date, 'YYYY'), SUM(salary)
FROM employees
WHERE department_id < 50
GROUP BY ROLLUP(department_id, TO_CHAR(hire_date, 'YYYY'));

-- IV.29) [CUBE]
SELECT department_id, TO_CHAR(hire_date, 'YYYY'), SUM(salary)
FROM employees
WHERE department_id < 50
GROUP BY CUBE(department_id, TO_CHAR(hire_date, 'YYYY'));
-- ORDER BY 1, 2, 3 DESC;

-- IV.30)
SELECT department_id, department_name,
       suma AS "Suma Salarii"
FROM (SELECT department_id, department_name, SUM(salary) suma
      FROM employees JOIN departments USING (department_id)
      GROUP BY department_id, department_name);

-- IV.31) [???]
SELECT *
FROM (SELECT last_name, salary, department_id,
             (SELECT ROUND(AVG(salary), 2) FROM employees where department_id = e.department_id) AS "Salariu Mediu"
      FROM employees e);

-- IV.32) [???]
SELECT *
FROM (SELECT last_name, salary, department_id,
             (SELECT ROUND(AVG(salary), 2) FROM employees where department_id = e.department_id) AS "Salariu Mediu",
             (SELECT COUNT(*) FROM employees WHERE department_id = e.department_id) AS "Nr. Angajati"              
      FROM employees e);

-- IV.33)
SELECT *
FROM (SELECT department_name, last_name, salary
      FROM employees e JOIN departments d ON (e.department_id = d.department_id)
      WHERE salary = (SELECT MIN(salary) FROM employees WHERE department_id = e.department_id));

-- IV.34)
SELECT *
FROM (SELECT department_id, department_name,
      NVL(COUNT(employee_id), 0) AS "Nr. Angajati",
      NVL(ROUND(AVG(salary), 2), 0) AS "Salariu mediu"
      FROM employees RIGHT JOIN departments USING (department_id)
      GROUP BY department_id, department_name)
        LEFT JOIN
     (SELECT department_id, last_name, salary, job_id
      FROM employees) USING (department_id);