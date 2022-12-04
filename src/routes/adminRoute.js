const express = require('express');
const AdminController = require('../controllers/AdminController');
const router = express.Router();

router.get('/user', AdminController.user);
router.post('/user', AdminController.blockUser);
router.get('/post', AdminController.post);
router.post('/post', AdminController.blockPost);

module.exports = router;
