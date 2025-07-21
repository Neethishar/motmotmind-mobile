const mongoose = require('mongoose');

const moodSchema = new mongoose.Schema({
  userId: { type: String, required: true },
  moodLabel: { type: String, required: true },
  moodIcon: { type: String, required: true },
  reason: { type: [String], required: true },
  day: { type: Number, required: true },
  note: { type: String },
  timestamp: { type: Date, required: true }, // ✅ New field
}, {
  timestamps: true,
});

module.exports = mongoose.model('Mood', moodSchema);
