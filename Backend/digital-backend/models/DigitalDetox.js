const mongoose = require('mongoose');

const detoxSchema = new mongoose.Schema({
  userId: {
    type: String,
    required: true
  },
  day: {
    type: Number,
    required: true
  },
  date: {
    type: Date,
    default: Date.now
  },
  duration: {
    type: String,
    required: true
  },
  goal: {
    type: String,
    required: true
  }
});

module.exports = mongoose.model('DigitalDetox', detoxSchema);
