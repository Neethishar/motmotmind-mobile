// /server.js
require('dotenv').config(); // 🔼 Always at top

const express = require('express');
const mongoose = require('mongoose');
const moodRoutes = require('./routes/moodRoutes');

const app = express();
const PORT = process.env.PORT || 5001;

// Middleware
app.use(express.json());

// Routes
app.use('/api/mood', moodRoutes); // Base path: /api/mood

// DB Connection
mongoose.connect(process.env.MONGO_URI)
  .then(() => {
    console.log('✅ MongoDB connected');
    app.listen(PORT, '0.0.0.0', () =>
      console.log(`🚀 Server running on http://localhost:${PORT}`)
    );
  })
  .catch((err) => console.error('❌ MongoDB connection error:', err));
