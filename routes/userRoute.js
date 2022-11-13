const express = require("express");
const { postController, authController } = require("../controllers");
const router = express.Router();
const upload = require("../middlewares/Upload");

router.get("/post", postController.postView);
router.post("/post", upload.array("medias", 4), postController.uploadPost);
router.get("/:userID", authController.detail);
module.exports = router;
