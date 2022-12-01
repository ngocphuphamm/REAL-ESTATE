const express = require("express");
const router = express.Router();
const adminRoute = require("./adminRoute");
const authRoute = require("./authRoute");
const userRoute = require("./userRoute");
const postRoute = require("./postRoute");
const siteRoute = require("./siteRoute");
const addressRoute = require("./addressRoute");
const validateToken = require("../middlewares/validateToken");
/* GET home page. */
router.use("/", siteRoute);
router.use("/address", addressRoute);
// GET auth routers
router.use("/auth", authRoute);
// GET user routes
router.use("/user", validateToken, userRoute);
// GET admin routes
router.use("/admin", adminRoute);
// GET post routes
router.use("/post", validateToken, postRoute);
module.exports = router;
