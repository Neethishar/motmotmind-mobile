const express = require('express');
const app = express();
const PORT = 5002;

app.get('/api/meditation', (req, res) => {
  console.log('GET /api/meditation called');
  res.json({ message: 'Meditation API is working!' });
});

app.listen(PORT, () => {
  console.log(`🚀 Test server running on port ${PORT}`);
});

// Keep process alive (in case something exits)
setInterval(() => {}, 1000);
