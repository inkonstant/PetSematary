require('dotenv').config();

const app = require('./app');

// Use the PORT from environment variables or fall back to 3000.
const port = process.env.PORT || 3000;

// Start the HTTP server. When the server starts, log a message so the user
// knows everything is working correctly.
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
