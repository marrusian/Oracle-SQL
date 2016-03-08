-- III.1) [Utilizand 'LIKE']
SELECT ang.last_name,
      TO_CHAR(ang.hire_date, 'MONTH') AS "Luna angajarii",
      TO_CHAR(ang.hire_date, 'YYYY') AS "Anul angajarii"
FROM employees ang JOIN employees gates ON (ang.department_id = gates.department_id)
WHERE LOWER(ang.last_name) LIKE '%a%' AND INITCAP(TRIM(gates.last_name)) = 'Gates'
      AND ang.employee_id != gates.employee_id;

-- III.1) [Utilizand 'INSTR']
SELECT ang.last_name,
      TO_CHAR(ang.hire_date, 'MONTH') AS "Luna angajarii",
      TO_CHAR(ang.hire_date, 'YYYY') AS "Anul angajarii"
FROM employees ang JOIN employees gates ON (ang.department_id = gates.department_id)
WHERE INSTR(LOWER(ang.last_name), 'a') != 0 AND INITCAP(TRIM(gates.last_name)) = 'Gates'
      AND ang.employee_id != gates.employee_id;

-- III.2)
SELECT ang.employee_id, ang.last_name, d.department_id, d.department_name
FROM employees ang JOIN employees tclg ON (ang.department_id = tclg.department_id)
                   JOIN departments d ON (ang.department_id = d.department_id)
WHERE LOWER(tclg.last_name) LIKE '%t%'
ORDER BY last_name;

-- III.3)
SELECT ang.last_name, ang.salary, job_title, city, country_id
FROM employees ang JOIN employees king ON (ang.manager_id = king.employee_id)
                   JOIN jobs j ON (ang.job_id = j.job_id)
                   LEFT JOIN departments d ON (ang.department_id = d.department_id)
                   LEFT JOIN locations l USING (location_id)
WHERE INITCAP(TRIM(king.last_name)) = 'King';

-- III.4)
SELECT d.department_id, d.department_name, last_name, job_id, TO_CHAR(salary, '$99,999.00')
FROM departments d LEFT JOIN employees e ON (e.department_id = d.department_id)
WHERE LOWER(department_name) LIKE '%ti%'
ORDER BY department_name, last_name;

-- III.5)
SELECT ang.last_name, ang.department_id, d.department_name, city, job_id
FROM employees ang JOIN departments d ON (ang.department_id = d.department_id)
                   JOIN locations USING (location_id)
WHERE INITCAP(TRIM(city)) = 'Oxford';

-- III.6)
SELECT DISTINCT ang.employee_id, ang.last_name, ang.salary
FROM employees ang JOIN employees tclg ON (ang.department_id = tclg.department_id)
                   JOIN jobs j ON (ang.job_id = j.job_id)
WHERE ang.salary > (min_salary + max_salary)/2 AND LOWER(tclg.last_name) LIKE '%t%';

-- III.7)
SELECT last_name, department_name
FROM employees LEFT JOIN departments USING (department_id);

-- III.8)
SELECT department_name, last_name
FROM departments LEFT JOIN employees USING (department_id);

-- III.9)
-- [Method I] FULL OUTER JOIN
-- [Method II] LEFT/RIGHT JOIN UNION RIGHT/LEFT JOIN

-- III.10)
SELECT department_id
FROM departments
WHERE LOWER(department_name) LIKE '%re%'
  UNION
SELECT department_id
FROM employees
WHERE UPPER(TRIM(job_id)) = 'SA_REP';

-- III.11)
SELECT department_id
FROM departments
WHERE LOWER(department_name) LIKE '%re%'
  UNION ALL
SELECT department_id
FROM employees
WHERE UPPER(TRIM(job_id)) = 'SA_REP';

-- III.12) [Using 'MINUS']
SELECT department_id
FROM departments
  MINUS
SELECT department_id
FROM employees;

-- III.12) [Using 'JOIN']
SELECT dep.department_id
FROM departments dep LEFT JOIN employees ang ON (dep.department_id = ang.department_id)
WHERE ang.department_id IS NULL
ORDER BY 1;

-- III.13)
SELECT department_id
FROM departments
WHERE LOWER(department_name) LIKE '%re%'
  INTERSECT
SELECT department_id
FROM employees
WHERE UPPER(TRIM(job_id)) = 'HR_REP';

-- III.14) [???]
SELECT employee_id, job_id, last_name
FROM employees
WHERE salary > 3000
  UNION
SELECT employee_id, job_id, last_name
FROM employees JOIN jobs USING (job_id)
WHERE salary = (max_salary + min_salary)/2;

-- III.15)
SELECT last_name, hire_date
FROM employees
WHERE hire_date > (SELECT hire_date FROM employees WHERE INITCAP(TRIM(last_name)) = 'Gates');

-- III.16)
SELECT last_name, salary
FROM employees
WHERE department_id = (SELECT department_id FROM employees WHERE INITCAP(TRIM(last_name)) = 'Gates')
      AND INITCAP(TRIM(last_name)) != 'Gates';

-- III.17)
SELECT last_name, salary
FROM employees
WHERE manager_id = (SELECT employee_id FROM employees WHERE manager_id IS NULL);

-- III.18)
SELECT last_name, department_id, salary
FROM employees
WHERE (department_id, salary) IN (SELECT department_id, salary FROM employees WHERE commission_pct IS NOT NULL);

-- III.19) [???]
SELECT employee_id, last_name, salary
FROM employees ang
WHERE salary > (SELECT (max_salary + min_salary)/2 FROM jobs WHERE ang.job_id = job_id)
      AND department_id IN (SELECT department_id FROM employees WHERE LOWER(last_name) LIKE '%t%');
      
-- III.20)
SELECT *
FROM employees
WHERE salary >ALL (SELECT salary FROM employees WHERE UPPER(job_id) LIKE '%CLERK%')
ORDER BY salary DESC;

-- III.21)
SELECT last_name, department_name, salary
FROM employees ang JOIN departments dep ON (dep.department_id = ang.department_id)
WHERE commission_pct IS NULL AND ang.manager_id IN (SELECT manager_id FROM employees WHERE commission_pct IS NOT NULL);

-- III.22)
SELECT last_name, department_id, salary, job_id
FROM employees
WHERE (salary, commission_pct) IN (SELECT salary, commission_pct
                                   FROM employees JOIN departments USING (department_id)
                                                  JOIN locations USING (location_id)
                                   WHERE INITCAP(TRIM(city)) = 'Oxford');

-- III.23)
SELECT last_name, department_id, job_id
FROM employees
WHERE department_id IN (SELECT department_id
                        FROM departments JOIN locations USING (location_id)
                        WHERE INITCAP(TRIM(city)) = 'Toronto');
