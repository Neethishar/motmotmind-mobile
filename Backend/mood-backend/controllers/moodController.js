const Mood = require('../models/Mood');

// POST /api/mood
const saveMood = async (req, res) => {
  const { userId, moodLabel, moodIcon, reason, day, note, timestamp } = req.body;

  if (!timestamp) {
    return res.status(400).json({ message: "Timestamp is required" });
  }

  try {
    const newMood = new Mood({
      userId,
      moodLabel,
      moodIcon,
      reason,
      day,
      note,
      timestamp: new Date(timestamp) // ✅ Store ISO date string as Date
    });

    await newMood.save();
    res.status(201).json({ message: 'Mood saved successfully!' });
  } catch (error) {
    console.error('❌ Error saving mood:', error);
    res.status(500).json({ message: 'Server Error', error });
  }
};

module.exports = { saveMood };
