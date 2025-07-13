const DrinkWaterLog = require('../models/DrinkWaterLog');

// Save or update log
exports.saveLog = async (req, res) => {
  const { userId, date, entries } = req.body;

  if (!userId || !date || !entries) {
    return res.status(400).json({ message: "Missing required fields" });
  }

  try {
    const existingLog = await DrinkWaterLog.findOne({ userId, date });
    if (existingLog) {
      existingLog.entries = entries;
      await existingLog.save();
      return res.json({ message: "✅ Log updated", log: existingLog });
    } else {
      const newLog = await DrinkWaterLog.create({ userId, date, entries });
      return res.json({ message: "✅ Log saved", log: newLog });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "❌ Server error" });
  }
};

// Get logs for a user
exports.getLogs = async (req, res) => {
  const { userId } = req.params;
  try {
    const logs = await DrinkWaterLog.find({ userId }).sort({ date: 1 });
    res.json(logs);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "❌ Server error" });
  }
};

// Get summary (e.g. count of completed days)
exports.getSummary = async (req, res) => {
  const { userId } = req.params;
  try {
    const logs = await DrinkWaterLog.find({ userId });
    const completedDays = logs.filter(log =>
      log.entries.every(entry => entry.checked)
    ).length;
    res.json({ totalDays: logs.length, completedDays });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "❌ Server error" });
  }
};
