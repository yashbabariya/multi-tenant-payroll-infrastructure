module.exports = function (req, res, next) {
  const tenant = req.headers["x-tenant-id"];

  if (!tenant) {
    return res.status(400).send("Tenant ID missing");
  }

  req.tenant = tenant;
  next();
};