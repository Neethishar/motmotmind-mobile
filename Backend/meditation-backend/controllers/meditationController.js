const Meditation = require('../models/Meditation');

exports.createMeditation = async (req, res) => {
  try {
    const { userId, duration, startTime, endTime } = req.body;
    const meditation = new Meditation({ userId, duration, startTime, endTime });
    await meditation.save();
    res.status(201).json({ message: 'Meditation saved', data: meditation });
  } catch (err) {
    res.status(500).json({ message: 'Error saving meditation', error: err.message });
  }
};

exports.getMeditations = async (req, res) => {
  try {
    const { userId } = req.query;
    const query = userId ? { userId } : {};
    const meditations = await Meditation.find(query).sort({ createdAt: -1 });
    res.json({ data: meditations });
  } catch (err) {
    res.status(500).json({ message: 'Error fetching meditations', error: err.message });
  }
};
