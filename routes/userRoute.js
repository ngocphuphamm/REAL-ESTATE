const express = require("express");
const { postController } = require("../controllers");
const router = express.Router();
const upload = require("../middlewares/Upload");

router.get("/post", postController.postView);
router.post("/post", upload.array("medias", 4), postController.uploadPost);
module.exports = router;
