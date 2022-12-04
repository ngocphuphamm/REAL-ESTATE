const express = require('express');
const { userController } = require('../controllers');
const router = express.Router();

router.post('/:userID', userController.edit);
router.get('/:userID', userController.detail);
router.get('/:userID/myPost', userController.myPost);
router.post('/:userID/myPost', userController.updateRentedPost);
router.get('/:userID/bookmark', userController.bookmark);
router.get('/detailApi/:userID', userController.detailApi);

module.exports = router;
