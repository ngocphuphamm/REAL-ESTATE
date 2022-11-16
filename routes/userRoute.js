const express = require("express");
const { userController } = require("../controllers");
const router = express.Router();

router.get("/post", (req, res) => res.json({ message: "Chưa có view nha" }));
router.get("/:userID/bookmark", userController.bookmark);
router.get("/:userID", userController.detail);

module.exports = router;
