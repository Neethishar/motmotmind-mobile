const express = require('express');
const router = express.Router();
const controller = require('../controllers/gratitudeController');

router.post('/', controller.createGratitude);
router.get('/:userId', controller.getGratitudeHistory);

module.exports = router;
