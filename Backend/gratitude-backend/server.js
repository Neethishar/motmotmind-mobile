const express = require('express');
const dotenv = require('dotenv');
const connectDB = require('./config/db');
const gratitudeRoutes = require('./routes/gratitudeRoutes');

dotenv.config();
connectDB();

const app = express();
app.use(express.json());

// ✅ Log incoming requests
app.use((req, res, next) => {
  console.log(`[${req.method}] ${req.originalUrl}`);
  next();
});

// ✅ Main API routes
app.use('/api/gratitude', gratitudeRoutes);

// ✅ 404 handler (must be last)
app.use((req, res) => {
  res.status(404).json({ error: 'Not found' });
});

// ✅ Start server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`✅ Server running on port ${PORT}`));
