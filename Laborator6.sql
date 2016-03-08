-- VI.1) [2x 'NOT EXISTS']
SELECT * FROM employees
WHERE employee_id IN (SELECT employee_id FROM works_on a
                      WHERE NOT EXISTS (SELECT 'x' FROM project p
                                        WHERE MONTHS_BETWEEN(start_date, TO_DATE('01-JAN-2006')) < 7
                                        AND NOT EXISTS (SELECT 'x' FROM works_on b
                                                        WHERE b.project_id = p.project_id
                                                          AND b.employee_id = a.employee_id)));

-- VI.1) [COUNT()]
SELECT * FROM employees
WHERE employee_id IN (SELECT employee_id FROM works_on
                      WHERE project_id IN (SELECT project_id FROM project
                                           WHERE MONTHS_BETWEEN(start_date, TO_DATE('01-JAN-2006')) < 7)
                      GROUP BY employee_id
                      HAVING COUNT(project_id) = (SELECT COUNT(*) FROM project
                                                  WHERE MONTHS_BETWEEN(start_date, TO_DATE('01-JAN-2006')) < 7));

-- VI.1) [MINUS]
SELECT * FROM employees
WHERE employee_id IN (SELECT employee_id FROM works_on
                        MINUS
                      (SELECT employee_id 
                       FROM (SELECT employee_id, project_id 
                             FROM (SELECT DISTINCT employee_id FROM works_on) CROSS JOIN
                                  (SELECT project_id FROM project WHERE MONTHS_BETWEEN(start_date, TO_DATE('01-JAN-2006')) < 7)
                               MINUS
                            (SELECT employee_id, project_id FROM works_on))));
                            
-- VI.1) [INCLUSION]
SELECT * FROM employees
WHERE employee_id IN (SELECT employee_id FROM works_on a
                      WHERE NOT EXISTS (SELECT project_id FROM project
                                        WHERE MONTHS_BETWEEN(start_date, TO_DATE('01-JAN-2006')) < 7
                                          MINUS
                                        SELECT p.project_id FROM works_on b CROSS JOIN project p
                                        WHERE b.project_id = p.project_id
                                        AND b.employee_id = a.employee_id));

-- VI.2) [2x 'NOT EXISTS']
SELECT * FROM project p
WHERE NOT EXISTS (SELECT 'x' FROM job_history jh
                  GROUP BY employee_id
                  HAVING COUNT(*) = 2
                     AND NOT EXISTS (SELECT 'x' FROM works_on b
                                     WHERE b.project_id = p.project_id
                                       AND b.employee_id = jh.employee_id));

-- VI.2) [COUNT()]
SELECT * FROM project
WHERE project_id IN (SELECT project_id FROM works_on
                     WHERE employee_id IN (SELECT employee_id FROM job_history
                                           GROUP BY employee_id
                                           HAVING COUNT(*) = 2)
                     GROUP BY project_id
                     HAVING COUNT(employee_id) = (SELECT COUNT(COUNT(*)) FROM job_history
                                                  GROUP BY employee_id
                                                  HAVING COUNT(*) = 2));

-- VI.2) [MINUS]
SELECT * FROM project
WHERE project_id IN (SELECT project_id FROM works_on
                       MINUS
                     SELECT project_id FROM (SELECT employee_id, project_id
                                             FROM (SELECT DISTINCT employee_id FROM works_on
                                                   WHERE employee_id IN (SELECT employee_id FROM job_history
                                                                         GROUP BY employee_id
                                                                         HAVING COUNT(*) = 2))
                                                   CROSS JOIN
                                                   (SELECT project_id FROM project)
                                               MINUS
                                            (SELECT employee_id, project_id FROM works_on)));                                             

-- VI.2) [INCLUSION]
SELECT * FROM project p
WHERE NOT EXISTS (SELECT DISTINCT employee_id FROM works_on
                  WHERE employee_id IN (SELECT employee_id FROM job_history
                                        GROUP BY employee_id
                                        HAVING COUNT(*) = 2)
                    MINUS
                 (SELECT employee_id FROM works_on b CROSS JOIN project
                  WHERE b.project_id = p.project_id));

-- VI.3)
SELECT COUNT(*) AS "Nr. Angajati"
FROM employees e
WHERE (SELECT COUNT(*) FROM job_history WHERE employee_id = e.employee_id) >= 2;

-- VI.4)
SELECT country_id, NVL(COUNT(employee_id), 0) "Nr. Angajati"
FROM countries LEFT JOIN locations USING (country_id)
               LEFT JOIN departments USING (location_id)
               LEFT JOIN employees USING (department_id)
GROUP BY country_id;

-- VI.5)
SELECT employee_id, last_name
FROM employees
WHERE employee_id IN (SELECT employee_id FROM works_on
                      WHERE project_id IN (SELECT project_id FROM project WHERE deadline < delivery_date)
                      GROUP BY employee_id
                      HAVING COUNT(*) >= 2);

-- VI.6)
SELECT employee_id, NVL(project_id, 0)
FROM works_on RIGHT JOIN employees USING (employee_id);

-- VI.7)
SELECT *
FROM employees
WHERE department_id IN (SELECT DISTINCT department_id
                        FROM employees, project
                        WHERE employee_id = project_manager);

-- VI.8)
SELECT *
FROM employees
WHERE department_id NOT IN (SELECT DISTINCT department_id
                            FROM employees, project
                            WHERE employee_id = project_manager);

-- VI.9)
SELECT department_id, department_name
FROM departments LEFT JOIN employees USING (department_id)
GROUP BY department_id, department_name
HAVING NVL(AVG(salary), 0) > &p;

-- VI.10)
SELECT employee_id, last_name, first_name, salary,
       (SELECT COUNT(*) FROM works_on WHERE employee_id = e.employee_id) AS "Nr. Proiecte"
FROM employees e
WHERE employee_id IN (SELECT project_manager
                      FROM employees CROSS JOIN project
                      WHERE employee_id = project_manager
                      GROUP BY project_manager
                      HAVING COUNT(project_id) = 2);

-- VI.11)
SELECT *
FROM employees
WHERE employee_id IN (SELECT DISTINCT employee_id FROM works_on JOIN project USING (project_id)
                      WHERE project_manager = 102)
AND employee_id NOT IN  (SELECT DISTINCT employee_id FROM works_on JOIN project USING (project_id)
                         WHERE project_manager != 102);

-- VI.12a)
SELECT last_name
FROM employees e
WHERE NOT EXISTS (SELECT project_id FROM works_on
                  WHERE employee_id = 200
                    MINUS
                  SELECT project_id FROM works_on
                  WHERE employee_id = e.employee_id);

-- VI.12b)
SELECT last_name
FROM employees e
WHERE NOT EXISTS (SELECT project_id FROM works_on
                  WHERE employee_id = e.employee_id
                    MINUS
                  SELECT project_id FROM works_on
                  WHERE employee_id = 200);

-- VI.13)
SELECT *
FROM employees e
WHERE NOT EXISTS (SELECT project_id FROM works_on
                  WHERE employee_id = 200
                    MINUS
                  SELECT project_id FROM works_on
                  WHERE employee_id = e.employee_id)
  AND NOT EXISTS (SELECT project_id FROM works_on
                  WHERE employee_id = e.employee_id
                    MINUS
                  SELECT project_id FROM works_on
                  WHERE employee_id = 200);

-- VI.14a)
DESC job_grades;
SELECT * FROM job_grades;

-- VI.14b)
SELECT last_name, salary, grade_level
FROM employees CROSS JOIN job_grades
WHERE salary BETWEEN lowest_sal AND highest_sal;

-- VI.15)
SELECT employee_id, last_name, salary, department_id
FROM employees WHERE employee_id = &p_cod;

DEFINE p_cod;
SELECT employee_id, last_name, salary, department_id
FROM employees WHERE employee_id = &p_cod;
UNDEFINE p_cod;

DEFINE p_cod = 100;
SELECT employee_id, last_name, salary, department_id
FROM employees WHERE employee_id = &&p_cod;
UNDEFINE p_cod;

ACCEPT p_cod PROMPT 'cod= ';
SELECT employee_id, last_name, salary, department_id
FROM employees WHERE employee_id = &p_cod;
UNDEFINE p_cod;

-- VI.16)
SELECT last_name, department_id,
       TO_CHAR(12*salary, '$999,999') AS "Salariu Anual"
FROM employees
WHERE UPPER(TRIM(job_id)) = UPPER(TRIM('&job'));

-- VI.17)
SELECT last_name, department_id,
       TO_CHAR(12*salary, '$999,999') AS "Salariu Anual"
FROM employees
WHERE hire_date > TO_DATE('&data', 'dd-mm-yyyy');

-- VI.18)
SELECT &&coloana
FROM &tabel
WHERE &cond_1
ORDER BY &&coloana;
UNDEFINE coloana;

-- VI.19)
ACCEPT data_1 PROMPT 'Introduceti prima data calendaristica:';
ACCEPT data_2 PROMPT 'Introduceti a doua data calendaristica:'
SELECT last_name || ', ' || job_id AS Angajati, hire_date
FROM employees
WHERE hire_date BETWEEN TO_DATE('&&data_1', 'MM/DD/YYYY') AND TO_DATE('&&data_2', 'MM/DD/YYYY');
UNDEFINE data_1;
UNDEFINE data_2;

-- VI.20)
SELECT last_name, job_id, salary, department_name
FROM employees RIGHT JOIN departments USING (department_id)
               RIGHT JOIN locations USING (location_id)
WHERE INITCAP(TRIM(city)) = INITCAP(TRIM('&city'));

-- VI.21a)
SELECT TO_DATE('&&data_1', 'MM/DD/YYYY') + (ROWNUM-1)
FROM dual
CONNECT BY TO_DATE('&data_1', 'MM/DD/YYYY') + (ROWNUM-1) < TO_DATE('&data_2', 'MM/DD/YYYY');
UNDEFINE data_1;

-- VI.21b)
SELECT Zi
FROM (SELECT TO_DATE('&&data1', 'MM/DD/YYYY') + (ROWNUM-1) AS Zi
      FROM dual
      CONNECT BY TO_DATE('&data1', 'MM/DD/YYYY') + (ROWNUM-1) < TO_DATE('&data2', 'MM/DD/YYYY'))
WHERE TO_CHAR(Zi, 'd') NOT IN ('1', '7');
UNDEFINE data1;
