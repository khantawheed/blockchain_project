const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const apiRoutes = require('./routes/api');

const app = express();

// Connect to MongoDB
mongoose.connect('mongodb://localhost/Mydatabase', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

// Middleware
app.use(bodyParser.json());

// API routes
app.use('/api', apiRoutes);

// Start the server
const port = process.env.PORT || 27017;
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});