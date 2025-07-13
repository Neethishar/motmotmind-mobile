const Sleep = require('../models/Sleep');
const moment = require('moment');

exports.saveSleep = async (req, res) => {
  const userId = req.user.id;
  const today = moment().format('YYYY-MM-DD');

  const existing = await Sleep.findOne({ userId, date: today });
  if (existing) {
    return res.status(200).json({ success: false, message: 'Already marked today' });
  }

  const newEntry = new Sleep({ userId, date: today });
  await newEntry.save();

  res.status(200).json({ success: true });
};

exports.getCompletedDays = async (req, res) => {
  const userId = req.user.id;
  const count = await Sleep.countDocuments({ userId });
  res.status(200).json({ completedDays: count });
};
