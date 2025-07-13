const express = require('express');
const { signUp, verifyOtp, signIn, resendOtp } = require('../controllers/authController');

const router = express.Router();

router.post('/signup', signUp);
router.post('/verify-otp', verifyOtp);
router.post('/signin', signIn);
router.post('/resend-otp', resendOtp);

module.exports = router;
