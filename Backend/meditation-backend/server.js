require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const meditationRoutes = require('./routes/meditationRoutes');

const app = express();
const PORT = process.env.PORT || 5002; // Ensure different port from onboarding

// Middleware
app.use(express.json());

// Health Check
app.get('/ping', (req, res) => res.send('pong'));

// Routes
app.use('/api/meditation', meditationRoutes);

// Connect DB and Start Server
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
}).then(() => {
  console.log('✅ MongoDB connected');
  app.listen(PORT, '0.0.0.0', () => console.log(`🚀 Server running on port ${PORT}`));
}).catch(err => {
  console.error('❌ MongoDB error:', err);
});
