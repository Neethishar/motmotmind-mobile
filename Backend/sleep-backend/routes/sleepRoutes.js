const express = require('express');
const router = express.Router();
const validateToken = require('../middleware/validateToken');
const { saveSleep, getCompletedDays } = require('../controllers/sleepController');

router.post('/', validateToken, saveSleep);
router.get('/completed-days', validateToken, getCompletedDays);

module.exports = router;
