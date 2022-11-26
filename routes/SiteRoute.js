const express = require("express");
const { siteController } = require("../controllers");
const router = express.Router();

router.get("/", siteController.home);
router.get("/search", siteController.search);
router.get("/error", siteController.error);
module.exports = router;
