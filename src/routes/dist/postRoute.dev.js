"use strict";

var express = require('express');

var _require = require('../controllers'),
    postController = _require.postController;

var validateToken = require('../middlewares/validateToken');

var router = express.Router();

var upload = require('../middlewares/upload');

router.get('/', validateToken, postController.postView);
router.post('/', validateToken, upload.array('medias', 5), postController.uploadPost);
router.post('/bookmark', validateToken, postController.sendBookMark);
router.post('/:id/comment', validateToken, postController.addComment);
router.post('/:id/report', postController.sendReport);
router.get('/:id', postController.detail);
module.exports = router;