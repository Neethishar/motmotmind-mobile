const mongoose = require('mongoose');

const readingSchema = new mongoose.Schema({
  userId: {
    type: String,
    required: true,
  },
  day: {
    type: Number,
    required: true,
  },
  dateCompleted: {
    type: Date,
    default: Date.now,
  }
});

module.exports = mongoose.model('Reading', readingSchema);
