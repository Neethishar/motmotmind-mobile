const DigitalDetox = require('../models/DigitalDetox');

// POST /api/digital
exports.saveDetox = async (req, res) => {
  try {
    const { userId, duration, goal, startTime, endTime } = req.body;

    if (!userId || !duration || !goal || !startTime || !endTime) {
      return res.status(400).json({ message: "All fields are required" });
    }

    // Get day count for the user
    const day = (await DigitalDetox.countDocuments({ userId })) + 1;

    const entry = new DigitalDetox({
      userId,
      day,
      duration,
      goal,
      startTime,
      endTime,
    });

    await entry.save();
    res.status(201).json({ message: "Detox saved successfully", entry });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
};

// GET /api/digital/:userId
exports.getDetoxData = async (req, res) => {
  try {
    const { userId } = req.params;
    const data = await DigitalDetox.find({ userId }).sort({ day: 1 });
    res.json(data);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
};
