const express = require("express");
const { postController } = require("../controllers");
const router = express.Router();

router.get("/post", postController.postView);
router.post("/post", postController.uploadPost);
module.exports = router;
