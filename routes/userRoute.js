const express = require("express");
const { authController } = require("../controllers");
const router = express.Router();

router.get("/:userID", authController.detail);
module.exports = router;
