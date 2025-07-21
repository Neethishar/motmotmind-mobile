// /routes/moodRoutes.js
const express = require('express');
const { saveMood } = require('../controllers/moodController');

const router = express.Router();

// POST /api/mood/
router.post('/', saveMood);

module.exports = router;
