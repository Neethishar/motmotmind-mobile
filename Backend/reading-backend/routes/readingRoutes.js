const express = require('express');
const router = express.Router();
const readingController = require('../controllers/readingController');

// POST /api/reading -> Add new reading log
router.post('/', readingController.addReadingLog);

// GET /api/reading -> Get all reading logs
router.get('/', readingController.getAllReadingLogs);

// GET /api/reading/:userId -> Get reading logs by user
router.get('/:userId', readingController.getUserReadingLogs);

module.exports = router;
