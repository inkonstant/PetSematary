const express = require('express');
const cors = require('cors');

const routes = require('./routes');
const errorHandler = require('./middleware/errorHandler');

// Create a new Express application instance.
const app = express();

// Enable CORS for all origins. This makes it possible for the frontend
// running on a different origin (e.g. a file on disk) to call the API.
app.use(cors({
  origin: process.env.CORS_ORIGIN,
  credentials: true
}));

// Built‑in middleware to parse JSON bodies and URL‑encoded data.
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Mount our API routes under the /api prefix. See the routes folder for
// individual route definitions.
app.use('/api', routes);

// Catch‑all route for unknown endpoints. If a user hits an undefined
// endpoint, respond with a 404 message.
app.use((req, res) => {
  res.status(404).json({
    success: false,
    data: null,
    message: 'Endpoint not found',
    error: null,
  });
});

// Central error handler. Any errors thrown in route handlers will be caught
// here. See middleware/errorHandler.js for implementation details.
app.use(errorHandler);

module.exports = app;
