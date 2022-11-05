const express = require("express");
const router = express.Router();
const adminRoute = require("./adminRoute");
const authRoute = require("./authRoute");
const userRoute = require("./userRoute");
const { homeController } = require("../controllers");
/* GET home page. */
router.get("/", homeController.getHome);
// GET auth routers
router.use("/auth", authRoute);
// GET user routes
router.use("/user", userRoute);
// GET admin routes
router.use("/admin", adminRoute);

module.exports = router;
