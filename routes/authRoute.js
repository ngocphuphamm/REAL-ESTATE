const express = require("express");
const { authController } = require("../controllers");
const router = express.Router();

router.get("/login", authController.loginView);
router.get("/register", authController.registerView);
router.post("/register", authController.register);
module.exports = router;
