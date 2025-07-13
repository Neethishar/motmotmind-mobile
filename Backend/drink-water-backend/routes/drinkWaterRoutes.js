const express = require('express');
const router = express.Router();
const controller = require('../controllers/drinkWaterController');

router.post('/save', controller.saveLog);
router.get('/logs/:userId', controller.getLogs);
router.get('/summary/:userId', controller.getSummary);

module.exports = router;
