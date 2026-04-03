const { Pool } = require("pg");

const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: "payrolldb",
  ssl: { rejectUnauthorized: false }
});

module.exports = {
  query: (text) => pool.query(text),
};