require('dotenv').config();
const express = require('express');
const connectDB = require('./config/db');
const detoxRoutes = require('./routes/detoxRoutes');

const app = express();
const PORT = process.env.PORT || 5007;

// Middleware
app.use(express.json());

// Connect to MongoDB
connectDB();

// Routes
app.use('/api/digital', detoxRoutes); // 👈 matches Flutter's baseUrl

// Start server
app.listen(PORT, () => {
  console.log(`✅ Digital Detox Server running on port ${PORT}`);
});
