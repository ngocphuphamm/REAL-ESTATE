const express = require("express");
const router = express.Router();
const adminRoute = require("./adminRoute");
const { homeController } = require("../controllers");
/* GET home page. */
router.get("/", homeController.getHome);

// GET admin routes
router.get("/admin", adminRoute);

module.exports = router;
