const express = require('express');
const router = express.Router();
const resurrectionsController = require('../controllers/resurrectionsController');

// GET /api/resurrections
router.get('/', resurrectionsController.getAllResurrections);

// POST /api/resurrections
router.post('/', resurrectionsController.createResurrection);

module.exports = router;
