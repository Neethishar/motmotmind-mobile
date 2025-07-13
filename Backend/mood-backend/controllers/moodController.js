const Mood = require('../models/Mood');

// POST /api/mood
const saveMood = async (req, res) => {
  const { userId, moodLabel, moodIcon, reason, day, note } = req.body;

  try {
    const newMood = new Mood({
      userId,
      moodLabel,
      moodIcon,
      reason,
      day,
      note
    });

    await newMood.save();
    res.status(201).json({ message: 'Mood saved successfully!' });
  } catch (error) {
    console.error('❌ Error saving mood:', error);
    res.status(500).json({ message: 'Server Error', error });
  }
};

module.exports = { saveMood };
