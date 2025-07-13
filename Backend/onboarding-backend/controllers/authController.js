// ✅ authController.js
const User = require('../models/User');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const sendEmail = require('../utils/sendEmail');

exports.signUp = async (req, res) => {
  try {
    const { name, email, password } = req.body;

    if (!/\S+@\S+\.\S+/.test(email)) {
      return res.status(400).json({ message: 'Invalid email format' });
    }

    const existing = await User.findOne({ email });
    if (existing) return res.status(400).json({ message: 'Email already exists' });

    const hashed = await bcrypt.hash(password, 10);
    const otp = Math.floor(1000 + Math.random() * 9000).toString();

    const user = new User({
      name,
      email,
      password: hashed,
      otp,
      otpExpiry: Date.now() + 10 * 60 * 1000
    });

    await user.save();

    console.log(`👉 Sending OTP ${otp} to ${email}`);
    await sendEmail(email, 'Your OTP Code', `Your OTP code is: ${otp}`);

    res.json({ message: 'Registered. Check email for OTP' });
  } catch (err) {
    console.error('❌ signUp error:', err);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.verifyOtp = async (req, res) => {
  try {
    const { email, otp } = req.body;
    const user = await User.findOne({ email });
    if (!user) return res.status(400).json({ message: 'Invalid email' });

    if (user.otp !== otp || Date.now() > user.otpExpiry) {
      return res.status(400).json({ message: 'Invalid or expired OTP' });
    }

    user.isVerified = true;
    user.otp = null;
    user.otpExpiry = null;
    await user.save();

    res.json({ message: 'Email verified successfully' });
  } catch (err) {
    console.error('❌ verifyOtp error:', err);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.resendOtp = async (req, res) => {
  try {
    const { email } = req.body;
    const user = await User.findOne({ email });
    if (!user) return res.status(400).json({ message: 'Invalid email' });

    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    user.otp = otp;
    user.otpExpiry = Date.now() + 10 * 60 * 1000;
    await user.save();

    console.log(`👉 Resending OTP ${otp} to ${email}`);
    await sendEmail(email, 'Your OTP Code', `Your new OTP code is: ${otp}`);

    res.json({ message: 'OTP resent' });
  } catch (err) {
    console.error('❌ resendOtp error:', err);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.signIn = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    if (!user) return res.status(400).json({ message: 'Invalid credentials' });
    if (!user.isVerified) return res.status(400).json({ message: 'Email not verified' });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(400).json({ message: 'Invalid credentials' });

    const token = jwt.sign(
      { userId: user._id },
      process.env.JWT_SECRET,
      { expiresIn: '1d' }
    );

    res.json({ message: 'Login successful', token });
  } catch (err) {
    console.error('❌ signIn error:', err);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

