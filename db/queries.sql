
-------------------------------
-- Retrieve all departments --
-------------------------------
CREATE OR REPLACE FUNCTION get_departments()
RETURNS TABLE (
  id INT,
  name VARCHAR
) AS $$
BEGIN
  RETURN QUERY
    SELECT id, name
    FROM department;
END;
$$ LANGUAGE plpgsql;

-------------------------
-- Retrieve all roles --
-------------------------
CREATE OR REPLACE FUNCTION get_roles()
RETURNS TABLE (
  id INT,
  title VARCHAR,
  salary NUMERIC,
  department VARCHAR
) AS $$
BEGIN
  RETURN QUERY
    SELECT r.id, r.title, r.salary, d.name
    FROM role r
    JOIN department d ON r.department_id = d.id;
END;
$$ LANGUAGE plpgsql;

----------------------------
-- Retrieve all employees --
----------------------------
CREATE OR REPLACE FUNCTION get_employees()
RETURNS TABLE (
  id INT,
  first_name VARCHAR,
  last_name VARCHAR,
  title VARCHAR,
  department VARCHAR,
  salary NUMERIC,
  manager VARCHAR
) AS $$
BEGIN
  RETURN QUERY
    SELECT e.id, e.first_name, e.last_name, r.title, d.name, r.salary,
           COALESCE(m.first_name || ' ' || m.last_name, '') AS manager
    FROM employee e
    JOIN role r ON e.role_id = r.id
    JOIN department d ON r.department_id = d.id
    LEFT JOIN employee m ON e.manager_id = m.id;
END;
$$ LANGUAGE plpgsql;

--------------------------------
-- Add a new department --
--------------------------------
CREATE OR REPLACE FUNCTION add_department(p_name TEXT)
RETURNS VOID AS $$
BEGIN
  INSERT INTO department (name) VALUES (p_name);
END;
$$ LANGUAGE plpgsql;

-------------------------------
-- Add a new role --
-------------------------------
CREATE OR REPLACE FUNCTION add_role(p_title TEXT, p_salary NUMERIC, p_department_id INT)
RETURNS VOID AS $$
BEGIN
  INSERT INTO role (title, salary, department_id) VALUES (p_title, p_salary, p_department_id);
END;
$$ LANGUAGE plpgsql;

-------------------------------
-- Add a new employee --
-------------------------------
CREATE OR REPLACE FUNCTION add_employee(
  p_first_name TEXT,
  p_last_name TEXT,
  p_role_id INT,
  p_manager_id INT DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  INSERT INTO employee (first_name, last_name, role_id, manager_id)
  VALUES (p_first_name, p_last_name, p_role_id, p_manager_id);
END;
$$ LANGUAGE plpgsql;

-----------------------------------------
-- Update an employee's role --
-----------------------------------------
CREATE OR REPLACE FUNCTION update_employee_role(p_employee_id INT, p_role_id INT)
RETURNS VOID AS $$
BEGIN
  UPDATE employee
  SET role_id = p_role_id
  WHERE id = p_employee_id;
END;
$$ LANGUAGE plpgsql;

-------------------------------------------
-- Update an employee's manager --
-------------------------------------------
CREATE OR REPLACE FUNCTION update_employee_manager(p_employee_id INT, p_manager_id INT DEFAULT NULL)
RETURNS VOID AS $$
BEGIN
  UPDATE employee
  SET manager_id = p_manager_id
  WHERE id = p_employee_id;
END;
$$ LANGUAGE plpgsql;

-----------------------------------------
-- Get employees by a specific manager --
-----------------------------------------
CREATE OR REPLACE FUNCTION get_employees_by_manager(p_manager_id INT)
RETURNS TABLE (
  id INT,
  first_name VARCHAR,
  last_name VARCHAR,
  title VARCHAR
) AS $$
BEGIN
  RETURN QUERY
    SELECT e.id, e.first_name, e.last_name, r.title
    FROM employee e
    JOIN role r ON e.role_id = r.id
    WHERE e.manager_id = p_manager_id;
END;
$$ LANGUAGE plpgsql;

----------------------------------------------
-- Get employees by department --
----------------------------------------------
CREATE OR REPLACE FUNCTION get_employees_by_department(p_department_id INT)
RETURNS TABLE (
  id INT,
  first_name VARCHAR,
  last_name VARCHAR,
  title VARCHAR
) AS $$
BEGIN
  RETURN QUERY
    SELECT e.id, e.first_name, e.last_name, r.title
    FROM employee e
    JOIN role r ON e.role_id = r.id
    WHERE r.department_id = p_department_id;
END;
$$ LANGUAGE plpgsql;

-----------------------------------------
-- Delete a department by its ID --
-----------------------------------------
CREATE OR REPLACE FUNCTION delete_department(p_department_id INT)
RETURNS VOID AS $$
BEGIN
  DELETE FROM department WHERE id = p_department_id;
END;
$$ LANGUAGE plpgsql;

-----------------------------
-- Delete a role by its ID --
-----------------------------
CREATE OR REPLACE FUNCTION delete_role(p_role_id INT)
RETURNS VOID AS $$
BEGIN
  DELETE FROM role WHERE id = p_role_id;
END;
$$ LANGUAGE plpgsql;

-------------------------------
-- Delete an employee by its ID --
-------------------------------
CREATE OR REPLACE FUNCTION delete_employee(p_employee_id INT)
RETURNS VOID AS $$
BEGIN
  DELETE FROM employee WHERE id = p_employee_id;
END;
$$ LANGUAGE plpgsql;

---------------------------------------------------------------
-- Get the total utilized budget for a specific department --
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_department_budget(p_department_id INT)
RETURNS NUMERIC AS $$
DECLARE
  total_budget NUMERIC;
BEGIN
  SELECT SUM(r.salary) INTO total_budget
  FROM employee e
  JOIN role r ON e.role_id = r.id
  WHERE r.department_id = p_department_id;
  RETURN total_budget;
END;
$$ LANGUAGE plpgsql;
