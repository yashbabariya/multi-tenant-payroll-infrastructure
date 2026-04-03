const express = require("express");
const db = require("./db");
const tenantMiddleware = require("./middleware");

const app = express();
app.use(express.json());
app.use(tenantMiddleware);

// Sample API
app.get("/payroll", async (req, res) => {
  const tenant = req.tenant;

  try {
    const result = await db.query(
      `SET search_path TO ${tenant}; SELECT * FROM payroll;`
    );

    res.json(result.rows);
  } catch (err) {
    res.status(500).send("Error fetching data");
  }
});

app.listen(3000, () => console.log("App running on port 3000"));