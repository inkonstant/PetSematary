const express = require('express');
const router = express.Router();
const sectionsController = require('../controllers/sectionsController');

// GET /api/sections
router.get('/', sectionsController.getAllSections);

// GET /api/sections/:name
router.get('/:name', sectionsController.getSectionByName);

module.exports = router;
