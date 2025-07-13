// server.js (inside onboarding-backend)
const dotenv = require('dotenv');
dotenv.config(); // Load environment variables

const express = require('express');
const cors = require('cors');
const connectDB = require('./config/db');
const authRoutes = require('./routes/authRoutes');

const app = express();
const PORT = process.env.PORT || 5001;

// ✅ Middlewares
app.use(cors());
app.use(express.json());

// ✅ Logger middleware
app.use((req, res, next) => {
  console.log(`➡️ ${req.method} ${req.url}`);
  next();
});

// ✅ Health Check
app.get('/ping', (req, res) => {
  res.send('pong');
});

// ✅ Main Routes
app.use('/api/auth', authRoutes);

// ✅ Start Server
const startServer = async () => {
  console.log('🚀 Starting server...');
  try {
    await connectDB();
    app.listen(PORT, '0.0.0.0', () => {
      console.log(`✅ Server running at http://0.0.0.0:${PORT}`);
    });
  } catch (err) {
    console.error('🔥 Server failed to start:', err.message);
  }
};

startServer();
