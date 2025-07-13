require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const sleepRoutes = require('./routes/sleepRoutes');

const app = express();
app.use(cors());
app.use(express.json());

mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log('✅ MongoDB connected for sleep tracker'))
  .catch(err => console.error('MongoDB connection error:', err));

app.use('/api/sleep', sleepRoutes);

const PORT = process.env.PORT || 5006;
app.listen(PORT, () => console.log(`🚀 Sleep backend running on port ${PORT}`));
