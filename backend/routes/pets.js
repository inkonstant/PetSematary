const express = require('express');
const router = express.Router();
const petsController = require('../controllers/petsController');

// GET /api/pets
router.get('/', petsController.getAllPets);

// GET /api/pets/:id
router.get('/:id', petsController.getPetById);

// POST /api/pets
router.post('/', petsController.createPet);

// PUT /api/pets/:id
router.put('/:id', petsController.updatePet);

// DELETE /api/pets/:id
router.delete('/:id', petsController.deletePet);

module.exports = router;
