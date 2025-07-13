const mongoose = require('mongoose');

const gratitudeSchema = new mongoose.Schema({
  userId: { type: String, required: true },
  text: { type: String, required: true },
  date: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Gratitude', gratitudeSchema);
