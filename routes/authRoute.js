const express = require("express");
const { authController } = require("../controllers");
const router = express.Router();
const userRoute = require("./UserRoute");
const validateToken = require("../middlewares/ValidateToken");
router.use("/user", validateToken, userRoute);
router.get("/login", authController.loginView);
router.post("/login", authController.login);
router.get("/register", authController.registerView);
router.post("/register", authController.register);
router.get("/logout", authController.logout);

module.exports = router;
