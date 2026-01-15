const mysql = require('mysql2/promise');

// Create a pool of MySQL connections. Using a pool instead of a single
// connection helps reuse connections between requests and improves
// performance under load. The configuration values come from environment
// variables defined in the .env file. The mysql2 library offers a promise
// wrapper out of the box, which simplifies async/await usage:contentReference[oaicite:1]{index=1}.
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT), // 🔥 ΤΟ ΚΡΙΣΙΜΟ

  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,

  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  connectTimeout: 10000,
});

/**
 * Execute a SQL query with optional parameters. This helper function
 * abstracts away the pool.execute call and returns only the rows.
 *
 * @param {string} sql SQL statement to execute
 * @param {Array<any>} [params] Parameters to bind into the SQL statement
 * @returns {Promise<Array<any>>} The rows returned by the query
 */
async function query(sql, params = []) {
  const [rows] = await pool.execute(sql, params);
  return rows;
}

module.exports = {
  query,
  pool,
};
