const db = require('../db');
const { normalizeBit } = require('../utils/dbUtils');

/**
 * Fetch all pets from the database and apply mode specific transformations.
 *
 * Mode behaviour:
 * - official: return full records, including owner details.
 * - redacted: owner mental_state is replaced with '[REDACTED]' when any of
 *   their pets have resurrection_status = 1.
 * - research: return minimal fields (id, name, species, resurrection_status)
 *   and include a total count. This minimises disclosure while still
 *   conveying aggregated information.
 */
exports.getAllPets = async (req, res, next) => {
  const mode = (req.query.mode || 'official').toLowerCase();
  try {
    // Fetch all pets with their owner information. Joining on Owner allows us
    // to expose owner_name and mental_state in a single query.
    const rows = await db.query(
      `SELECT p.id, p.name, p.owner_id, p.section_name, p.plot_number, p.species, p.date_of_birth,
              p.date_of_death, p.cause_of_death, p.resurrection_status,
              p.temperament, p.appearance_changes,
              o.name AS owner_name, o.mental_state
         FROM Pet p
         LEFT JOIN Owner o ON p.owner_id = o.id`
    );

    // Research mode: return minimal fields plus totals. We intentionally
    // minimise disclosure here to align with the specification. The total
    // number of pets is included in the response data for context.
    if (mode === 'research') {
      const minimal = rows.map((row) => ({
        id: row.id,
        name: row.name,
        species: row.species,
        resurrection_status: normalizeBit(row.resurrection_status),
      }));
      return res.json({
        success: true,
        data: { pets: minimal, total: rows.length },
        message: null,
        error: null,
      });
    }

    // Official mode
    if (mode === 'official') {
      const data = rows.map((row) => {
        return {
          id: row.id,
          name: row.name,
          owner_id: row.owner_id,
          owner_name: row.owner_name,
          mental_state: row.mental_state,
          section_name: row.section_name,
          plot_number: row.plot_number,
          species: row.species,
          date_of_birth: row.date_of_birth,
          date_of_death: row.date_of_death,
          cause_of_death: row.cause_of_death,

          resurrection_status: normalizeBit(row.resurrection_status),

          temperament: row.temperament,
          appearance_changes: row.appearance_changes,
        };
      });

      return res.json({
        success: true,
        data,
        message: null,
        error: null,
      });
    }

    // Redacted mode
    if (mode === 'redacted') {
      const data = rows.map((row) => ({
        id: row.id,
        name: row.name,
        owner_id: row.owner_id,
        owner_name: row.owner_name,

        // CENSORED FIELDS
        mental_state: '[REDACTED]',
        cause_of_death: '[REDACTED]',
        temperament: '[REDACTED]',
        appearance_changes: '[REDACTED]',
        date_of_death: '[REDACTED]',
        resurrection_status: '[REDACTED]',

        // SAFE STRUCTURAL INFO
        section_name: row.section_name,
        plot_number: row.plot_number,
        species: row.species,
        date_of_birth: row.date_of_birth,
      }));

      return res.json({
        success: true,
        data,
        message: null,
        error: null,
      });
    }
  } catch (err) {
    next(err);
  }
};

/**
 * Fetch a single pet by its ID. Behaviour follows the same mode semantics as
 * getAllPets.
 */
exports.getPetById = async (req, res, next) => {
  const mode = (req.query.mode || 'official').toLowerCase();
  const petId = parseInt(req.params.id, 10);
  if (isNaN(petId)) {
    return res.status(400).json({
      success: false,
      data: null,
      message: 'Invalid pet ID',
      error: null,
    });
  }
  try {
    // Fetch the pet with its owner and burial plot. We include section_name
    // for potential future use, though it is not displayed in this endpoint.
    const rows = await db.query(
      `SELECT p.id, p.name, p.owner_id, p.section_name, p.plot_number, p.species,
              p.date_of_birth, p.date_of_death, p.cause_of_death,
              p.resurrection_status, p.temperament, p.appearance_changes,
              o.name AS owner_name, o.mental_state
         FROM Pet p
         LEFT JOIN Owner o ON p.owner_id = o.id
        WHERE p.id = ?`,
      [petId]
    );
    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        data: null,
        message: 'Pet not found',
        error: null,
      });
    }
    const pet = rows[0];

    if (mode === 'research') {
      return res.json({
        success: true,
        data: {
          id: pet.id,
          name: pet.name,
          species: pet.species,
          resurrection_status: normalizeBit(pet.resurrection_status),
        },
        message: null,
        error: null,
      });
    }

    if (mode === 'redacted') {
      return res.json({
        success: true,
        data: {
          name: pet.name,
          owner_name: pet.owner_name,
          species: pet.species,

          // Aggressively redacted fields
          mental_state: '[REDACTED]',

          // Optionally redact death date
          date_of_birth: pet.date_of_birth,
          date_of_death: '[REDACTED]',
          cause_of_death: '[REDACTED]',

          // Safe structural info
          section_name: pet.section_name,
          plot_number: pet.plot_number,
          temperament: '[REDACTED]',
          appearance_changes: '[REDACTED]',
          resurrection_status: '[REDACTED]',

        },
        message: null,
        error: null,
      });
    }
    // official
    return res.json({
      success: true,
      data: {
        name: pet.name,
        owner_name: pet.owner_name,
        mental_state: pet.mental_state,
        section_name: pet.section_name,
        plot_number: pet.plot_number,
        species: pet.species,
        date_of_birth: pet.date_of_birth,
        date_of_death: pet.date_of_death,
        cause_of_death: pet.cause_of_death,
        resurrection_status: normalizeBit(pet.resurrection_status),
        temperament: pet.temperament,
        appearance_changes: pet.appearance_changes,
      },
      message: null,
      error: null,
    });
  } catch (err) {
    next(err);
  }
};

/**
 * Create a new pet. Validates required fields and inserts a record into the
 * database. Returns the created pet ID.
 */
exports.createPet = async (req, res, next) => {
  const body = req.body || {};
  const requiredFields = [
    'name',
    'owner_id',
    'section_name',
    'plot_number',
    'species',
    'date_of_birth',
    'date_of_death',
  ];
  const missing = requiredFields.filter((f) => !body[f]);
  if (missing.length > 0) {
    return res.status(400).json({
      success: false,
      data: null,
      message: `Missing required fields: ${missing.join(', ')}`,
      error: null,
    });
  }
  try {
    const result = await db.query(
      `INSERT INTO Pet (name, owner_id, section_name, plot_number, species, date_of_birth, date_of_death,
                        cause_of_death, resurrection_status, temperament, appearance_changes)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        body.name,
        body.owner_id,
        body.section_name,
        body.plot_number,
        body.species,
        body.date_of_birth,
        body.date_of_death,
        body.cause_of_death || null,
        body.resurrection_status ? 1 : 0,
        body.temperament || null,
        body.appearance_changes || null,
      ]
    );
    return res.status(201).json({
      success: true,
      data: { id: result.insertId },
      message: 'Pet created successfully',
      error: null,
    });
  } catch (err) {
    next(err);
  }
};

/**
 * Update an existing pet. Only fields present in the request body will be
 * updated. This allows partial updates without overwriting other columns.
 */
exports.updatePet = async (req, res, next) => {
  const petId = parseInt(req.params.id, 10);
  if (isNaN(petId)) {
    return res.status(400).json({
      success: false,
      data: null,
      message: 'Invalid pet ID',
      error: null,
    });
  }
  const body = req.body || {};
  const allowedFields = [
    'name',
    'owner_id',
    'section_name',
    'plot_number',
    'species',
    'date_of_birth',
    'date_of_death',
    'cause_of_death',
    'resurrection_status',
    'temperament',
    'appearance_changes',
  ];
  const setClauses = [];
  const values = [];
  allowedFields.forEach((field) => {
    if (Object.prototype.hasOwnProperty.call(body, field)) {
      setClauses.push(`${field} = ?`);
      if (field === 'resurrection_status') {
        values.push(body[field] ? 1 : 0);
      } else {
        values.push(body[field]);
      }
    }
  });
  if (setClauses.length === 0) {
    return res.status(400).json({
      success: false,
      data: null,
      message: 'No fields provided for update',
      error: null,
    });
  }
  values.push(petId);
  try {
    const sql = `UPDATE Pet SET ${setClauses.join(', ')} WHERE id = ?`;
    await db.query(sql, values);
    return res.json({
      success: true,
      data: null,
      message: 'Pet updated successfully',
      error: null,
    });
  } catch (err) {
    next(err);
  }
};

/**
 * Delete a pet by its ID. If the pet does not exist, return a 404.
 */
exports.deletePet = async (req, res, next) => {
  const petId = parseInt(req.params.id, 10);
  if (isNaN(petId)) {
    return res.status(400).json({
      success: false,
      data: null,
      message: 'Invalid pet ID',
      error: null,
    });
  }
  try {
    const result = await db.query('DELETE FROM Pet WHERE id = ?', [petId]);
    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        data: null,
        message: 'Pet not found',
        error: null,
      });
    }
    return res.json({
      success: true,
      data: null,
      message: 'Pet deleted successfully',
      error: null,
    });
  } catch (err) {
    next(err);
  }
};
