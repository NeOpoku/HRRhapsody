-- Insert Departments
INSERT INTO department (name) VALUES
  ('Engineering'),
  ('Sales'),
  ('Finance'),
  ('Human Resources');

-- Insert Roles
INSERT INTO role (title, salary, department_id) VALUES
  ('Software Engineer', 90000, (SELECT id FROM department WHERE name = 'Engineering')),
  ('Senior Software Engineer', 120000, (SELECT id FROM department WHERE name = 'Engineering')),
  ('Sales Representative', 60000, (SELECT id FROM department WHERE name = 'Sales')),
  ('Sales Manager', 80000, (SELECT id FROM department WHERE name = 'Sales')),
  ('Accountant', 70000, (SELECT id FROM department WHERE name = 'Finance')),
  ('Financial Analyst', 75000, (SELECT id FROM department WHERE name = 'Finance')),
  ('HR Specialist', 65000, (SELECT id FROM department WHERE name = 'Human Resources'));

-- Insert Employees
INSERT INTO employee (first_name, last_name, role_id, manager_id) VALUES
  ('Alice', 'Smith', (SELECT id FROM role WHERE title = 'Senior Software Engineer'), NULL),
  ('Bob', 'Jones', (SELECT id FROM role WHERE title = 'Software Engineer'), 1),
  ('Charlie', 'Brown', (SELECT id FROM role WHERE title = 'Sales Manager'), NULL),
  ('Dana', 'White', (SELECT id FROM role WHERE title = 'Sales Representative'), 3),
  ('Evan', 'Taylor', (SELECT id FROM role WHERE title = 'Accountant'), NULL),
  ('Samuel', 'Opoku', (SELECT id FROM role WHERE title = 'Financial Analyst'), 5),
  ('Grace', 'Wilson', (SELECT id FROM role WHERE title = 'HR Specialist'), NULL);