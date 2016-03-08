INSERT INTO emp_osa (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES (&emp_id, '&&fnm', '&&lnm', SUBSTR('&&fnm', 1, 1) || SUBSTR('&&lnm', 1, 7), SYSDATE, 'IT_PROG');
UNDEFINE fnm;
UNDEFINE lnm;