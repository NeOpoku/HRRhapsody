import pool from './connection.js';

//function to getDepartments

export const getDepartments = async () => {
    const results = await pool.query('SELECT * FROM department');
    return results.rows;
}


//function to getRoles

export const getRoles = async () => {
    const results = await pool.query(`
        SELECT role.id, role.title, department.name AS department, role.salary 
        FROM role 
        JOIN department ON role.department_id = department.id
    `);
    return results.rows;
};



//function to getEmployees
//select employee data, join with role and dept
export const getEmployees = async () => {
    const results = await pool.query(`SELECT employee.id, employee.first_name, employee.last_name, role.title, 
        department.name AS department, role.salary, 
        CONCAT(manager.first_name, ' ', manager.last_name) AS manager 
FROM employee 
 JOIN role ON employee.role_id = role.id 
 JOIN department ON role.department_id = department.id 
 LEFT JOIN employee manager ON employee.manager_id = manager.id`);
    return results.rows;
};


//function to addDeparments

export const addDepartment = async (name) => {
    try {
        // Checking for duplicate departments before added

        const checkQuery = 'SELECT * FROM department WHERE name = $1';
        const checkResult = await pool.query(checkQuery, [name]);

        if (checkResult.rows.length > 0) {
            console.log(`The department '${name}' already exists.`);
            return null;
        }

        // Insert the new department

        const results = await pool.query(
            'INSERT INTO department (name) VALUES ($1) RETURNING *',
            [name]
        );
        return results.rows[0];
    } catch (err) {
        console.error('Error adding department:', err);
        throw err;
    }
};

//function to addRole

export const addRole = async (title, salary, department_id) => {
    const results = await pool.query(
        'INSERT INTO role (title, salary, department_id) VALUES ($1, $2, $3) RETURNING *',
        [title, salary, department_id]
    );
    return results.rows[0];
};



//function to addEmployee

export const addEmployee = async (first_name, last_name, role_id, manager_id = null) => {
    const results = await pool.query(
        'INSERT INTO employee (first_name, last_name, role_id, manager_id) VALUES ($1, $2, $3, $4) RETURNING *',
        [first_name, last_name, role_id, manager_id]
    );
    return results.rows[0];
};

//function to updateEmployeeRole

export const updateEmployeeRole = async (role_id, employee_id) => {
    const results = await pool.query(
        'UPDATE employee SET role_id = $1 WHERE id = $2 RETURNING *',
        [role_id, employee_id]
    );
    return results.rows[0];
};