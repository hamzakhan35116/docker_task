const express = require('express');
const mongoose = require('mongoose');
require('dotenv').config();

const app = express();
const port = 3000;

// Connect to MongoDB
mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => {
    console.log('Connected to MongoDB');
  })
  .catch(err => {
    console.error('MongoDB connection error:', err);
  });

app.get('/', (req, res) => {
  const mongoStatus = mongoose.connection.readyState === 1 ? 'Not Connected' : 'Connected';
  res.send(`Hello from Node.js app! MongoDB Status: ${mongoStatus}`);
});

app.listen(port, () => {
  console.log(`App is running on port ${port}`);
});
