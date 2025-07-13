const mongoose = require('mongoose');

const drinkWaterLogSchema = new mongoose.Schema({
  userId: {
    type: String,  // Ideally replace with ObjectId if using real User collection
    required: true,
  },
  date: {
    type: String, // e.g. "2025-07-05"
    required: true,
  },
  entries: [
    {
      amount: String, // e.g. "250 ml"
      time: String,   // e.g. "8 am"
      checked: Boolean
    }
  ]
}, { timestamps: true });

module.exports = mongoose.model('DrinkWaterLog', drinkWaterLogSchema);
