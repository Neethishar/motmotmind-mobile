const mongoose = require('mongoose');

const sleepSchema = new mongoose.Schema({
  userId: { type: String, required: true },
  date: { type: String, required: true }, // Format: YYYY-MM-DD
});

module.exports = mongoose.model('Sleep', sleepSchema);
