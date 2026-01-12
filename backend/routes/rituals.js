const express = require('express');
const router = express.Router();
const ritualsController = require('../controllers/ritualsController');

// GET /api/rituals
router.get('/', ritualsController.getAllRituals);

module.exports = router;
