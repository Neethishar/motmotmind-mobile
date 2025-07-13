const mongoose = require('mongoose');

const meditationSchema = new mongoose.Schema({
  userId: {
    type: String,
    required: true,
  },
  duration: {
    type: Number,
    required: true,
  },
  startTime: {
    type: Date,
    required: true,
  },
  endTime: {
    type: Date,
    required: true,
  }
}, { timestamps: true });

module.exports = mongoose.model('Meditation', meditationSchema);
