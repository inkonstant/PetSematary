const express = require('express');
const router = express.Router();
const researchController = require('../controllers/researchController');

// Research overview: counts of pets, resurrected pets, events, forbidden rituals, high‑risk sections
router.get('/overview', researchController.getOverview);

// Sections risk: group by danger_level and count events
router.get('/sections-risk', researchController.getSectionsRisk);

// Ritual performance: usage statistics and corruption flag
router.get('/ritual-performance', researchController.getRitualPerformance);

module.exports = router;
