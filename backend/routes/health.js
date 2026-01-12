const express = require('express');
const router = express.Router();

// Simple health check endpoint. Returns a static JSON object. Use this
// endpoint to confirm the server is running.
router.get('/', (req, res) => {
  res.json({
    success: true,
    data: null,
    message: 'API is healthy',
    error: null,
  });
});

module.exports = router;
