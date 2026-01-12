const express = require('express');
const router = express.Router();

// Mount individual route modules. Each module defines handlers for a
// specific resource. See the respective files in the routes folder.
router.use('/health', require('./health'));
router.use('/pets', require('./pets'));
router.use('/sections', require('./sections'));
router.use('/rituals', require('./rituals'));
router.use('/resurrections', require('./resurrections'));
router.use('/research', require('./research'));

module.exports = router;
