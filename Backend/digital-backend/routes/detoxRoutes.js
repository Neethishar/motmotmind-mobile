const express = require('express');
const router = express.Router();
const { saveDetox, getDetoxData } = require('../controllers/detoxController');

router.post('/', saveDetox);
router.get('/:userId', getDetoxData);

module.exports = router;
