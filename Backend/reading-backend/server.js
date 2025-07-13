require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const connectDB = require('./config/db');

const app = express();
const PORT = process.env.PORT || 5001;

// Connect DB
connectDB();

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Routes
app.use('/api/reading', require('./routes/readingRoutes'));

// Test endpoint
app.get('/', (req, res) => {
  res.send('Reading Habit Tracker API running!');
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
