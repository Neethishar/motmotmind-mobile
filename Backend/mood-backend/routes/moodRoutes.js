const express = require('express');
const { saveMood } = require('../controllers/moodController');

const router = express.Router();

router.post('/', saveMood);

module.exports = router;
