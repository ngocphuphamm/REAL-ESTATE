const express = require("express");
const { postController } = require("../controllers");
const router = express.Router();
const upload = require("../middlewares/Upload");

router.get("/", postController.postView);
router.post("/", upload.array("medias", 4), postController.uploadPost);
router.post("/bookmark", postController.sendBookMark);
router.get("/:id", postController.detail);
module.exports = router;
