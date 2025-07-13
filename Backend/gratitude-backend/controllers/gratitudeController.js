const Gratitude = require('../models/Gratitude');

exports.createGratitude = async (req, res) => {
  try {
    const { userId, text } = req.body;
    if (!userId || !text) {
      return res.status(400).json({ error: 'userId and text are required' });
    }

    const entry = new Gratitude({ userId, text });
    await entry.save();

    res.status(201).json({ message: 'Gratitude saved!', data: entry });
  } catch (err) {
    res.status(500).json({ error: 'Failed to save gratitude', details: err.message });
  }
};

exports.getGratitudeHistory = async (req, res) => {
  try {
    const { userId } = req.params;
    const history = await Gratitude.find({ userId }).sort({ date: -1 });
    res.status(200).json(history);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch history', details: err.message });
  }
};
