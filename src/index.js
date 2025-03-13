// Load environment variables from .env
import dotenv from 'dotenv';
dotenv.config();

import { Pool } from 'pg';

//import functions from queries file//
import { getDepartments, getRoles, getEmployees, addDepartment, addRole, addEmployee, updateEmployeeRole } from './queries.js';

 // index.js
// Import and require Pool (node-postgres)


// Create a connection pool with your PostgreSQL 17 credentials
const pool = new Pool({
  user: process.env.DB_USER,      // Your PostgreSQL username
  host: process.env.DB_HOST,      // Host (e.g., 'localhost')
  database: process.env.DB_DATABASE,  // Your database name
  password: process.env.DB_PASSWORD,  // Your database password
  port: process.env.DB_PORT,      // PostgreSQL port, usually 5432
});

// Test the connection with a simple query
async function testConnection() {
  try {
    const res = await pool.query('SELECT NOW()');
    console.log("Connected to PostgreSQL 17! Current time:", res.rows[0]);
  } catch (err) {
    console.error("Error connecting to PostgreSQL 17:", err);
  }
}

// Kick off the connection test
testConnection();


//import inquirer for prompts//
import inquirer from 'inquirer';

//create main menu//

const mainMenu = async () => {
    const answers = await inquirer.prompt([
        {
            type: 'list',
            name: 'action',
            message: 'What would you like to do?',
            choices: [
                'View all departments',
                'View all roles',
                'View all employees',
                'Add a department',
                'Add a role',
                'Add an employee',
                'Update an employee role',
                'Exit'
            ],
        },
    ]);


    //create switch statement//

    switch (answers.action) {
        case 'View all departments':
            const departments = await getDepartments();
            console.log("You selected 'View all departments'");
            console.table(departments);
            break;

        case 'View all roles':
            const roles = await getRoles();
            console.log("You selected 'View all roles'");
            console.table(roles);
            break;

        case 'View all employees':
            const employees = await getEmployees();
            console.log("You selected 'View all employees'");
            console.table(employees);
            break;

        case 'Add a department':
            const departmentAnswer = await inquirer.prompt([
                {
                    type: 'input',
                    name: 'name',
                    message: 'Enter the name of the new department:',
                },
            ]);

            try {
                const newDepartment = await addDepartment(departmentAnswer.name);
                if (newDepartment) {
                    console.log(`Added new department: ${newDepartment.name}`);
                } else {
                    console.log('Department was not added because it already exists.');
                }
            } catch (err) {
                console.error('Error adding department:', err);
            }
            break;

        case 'Add a role':
            const roleAnswers = await inquirer.prompt([
                {
                    type: 'input',
                    name: 'title',
                    message: 'Enter the title of the new role:',
                },
                {
                    type: 'input',
                    name: 'salary',
                    message: 'Enter the salary for this role:',
                },
                {
                    type: 'input',
                    name: 'department_id',
                    message: 'Enter the department ID for this role:',
                },
            ]);
            const newRole = await addRole(roleAnswers.title, roleAnswers.salary, roleAnswers.department_id);
            console.log(`Added new role: ${newRole.title}`);
            break;

        case 'Add an employee':
            const employeeAnswers = await inquirer.prompt([
                {
                    type: 'input',
                    name: 'first_name',
                    message: 'Enter the first name of the new employee:',
                },
                {
                    type: 'input',
                    name: 'last_name',
                    message: 'Enter the last name of the new employee:',
                },
                {
                    type: 'input',
                    name: 'role_id',
                    message: 'Enter the role ID for this employee:',
                },
                {
                    type: 'input',
                    name: 'manager_id',
                    message: 'Enter the manager ID for this employee (optional):',
                },
            ]);
            const newEmployee = await addEmployee(employeeAnswers.first_name, employeeAnswers.last_name, employeeAnswers.role_id, employeeAnswers.manager_id || null);
            console.log(`Added new employee: ${newEmployee.first_name} ${newEmployee.last_name}`);
            break;

        case 'Update an employee role':
            const updateAnswers = await inquirer.prompt([
                {
                    type: 'input',
                    name: 'employee_id',
                    message: 'Enter the ID of the employee you want to update:',
                },
                {
                    type: 'input',
                    name: 'role_id',
                    message: 'Enter the new role ID for this employee:',
                },
            ]);
            const editEmployee = await updateEmployeeRole(updateAnswers.role_id, updateAnswers.employee_id);
            console.log(`Updated employee role for ID: ${updateAnswers.employee_id}`);
            break;

        case 'Exit':
            console.log("Now exiting...");
            process.exit();
        default:
            console.log("Unknown action, try again.");
            await mainMenu();
    }

    await mainMenu();
};

mainMenu();