require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const meditationRoutes = require('./routes/meditationRoutes');

const app = express();
const PORT = process.env.PORT || 5002;

console.log('Mongo URI:', process.env.MONGO_URI); // Debug Mongo URI

// Middleware
app.use(express.json());

// Health Check
app.get('/ping', (req, res) => res.send('pong'));

// Routes
app.use('/api/meditation', meditationRoutes);

// Catch-all for unknown routes (helps debugging)
app.use((req, res, next) => {
  res.status(404).json({ error: 'Route not found' });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('❌ Server error:', err);
  res.status(500).json({ error: 'Internal server error' });
});

// Connect DB and Start Server
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
}).then(() => {
  console.log('✅ MongoDB connected');
  // Listen without specifying host to bind to default interface(s)
  app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`);
  });
}).catch(err => {
  console.error('❌ MongoDB connection error:', err);
});
