const express = require("express");
const router = express.Router();
const adminRoute = require("./adminRoute");
const authRoute = require("./authRoute");
const userRoute = require("./userRoute");
const postRoute = require("./postRoute");
const addressRoute = require("./addressRoute");
const { homeController } = require("../controllers");
const validateToken = require("../middlewares/ValidateToken");
/* GET home page. */
router.get("/", homeController.getHome);

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
