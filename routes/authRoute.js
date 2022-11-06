const express = require("express");
const { authController } = require("../controllers");
const router = express.Router();

router.get("/login", authController.loginView);
router.post("/login", authController.login);
router.get("/register", authController.registerView);
router.post("/register", authController.register);
module.exports = router;
