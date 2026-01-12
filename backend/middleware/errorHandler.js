/**
 * Centralised error handling middleware. Express will pass any error
 * thrown in asynchronous route handlers to this function. It formats the
 * error into a consistent JSON response. Do not expose stack traces to
 * end users in production – here we log the error to the console and
 * return only the message.
 */
function errorHandler(err, req, res, next) {
  console.error(err);
  const status = err.status || 500;
  res.status(status).json({
    success: false,
    data: null,
    message: err.message || 'Internal Server Error',
    error: {
      name: err.name || 'Error',
    },
  });
}

module.exports = errorHandler;
