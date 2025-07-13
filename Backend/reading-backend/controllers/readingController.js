const Reading = require('../models/Reading');

exports.addReadingLog = async (req, res) => {
  try {
    const { userId, day, completed } = req.body;
    const readingLog = new Reading({ userId, day, completed });
    await readingLog.save();
    res.status(201).json(readingLog);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getAllReadingLogs = async (req, res) => {
  try {
    const logs = await Reading.find();
    res.json(logs);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getUserReadingLogs = async (req, res) => {
  try {
    const { userId } = req.params;
    const logs = await Reading.find({ userId });
    res.json(logs);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
