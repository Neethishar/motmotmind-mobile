const express = require('express');
const router = express.Router();
const { createMeditation, getMeditations } = require('../controllers/meditationController');

router.post('/', createMeditation);
router.get('/', getMeditations);

module.exports = router;
