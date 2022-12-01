const express = require("express");
const { postController } = require("../controllers");
const router = express.Router();
const upload = require("../middlewares/upload");

router.get("/", postController.postView);
router.post("/", upload.array("medias", 4), postController.uploadPost);
router.post("/bookmark", postController.sendBookMark);
router.post("/:id/comment", postController.addComment);
router.post("/:id/report", postController.sendReport);
router.get("/:id", postController.detail);
module.exports = router;
