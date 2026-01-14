const db = require('../db');

/**
 * Retrieve all resurrection events. Includes names of the pet, the performing
 * owner and the ritual for convenience. In redacted mode, the weather
 * description is replaced with '[REDACTED]' when the moon_phase is 'Full Moon'.
 * In research mode, only minimal fields (id, pet_id, ritual_name, date) are
 * returned along with a total count.
 */
exports.getAllResurrections = async (req, res, next) => {
  const mode = (req.query.mode || 'official').toLowerCase();
  try {
    const rows = await db.query(
      `SELECT re.id,
              re.pet_id,
              p.name AS pet_name,
              o.id AS performed_by,
              o.name AS performer_name,
              re.ritual_name,
              re.date,
              re.time,
              re.moon_phase,
              re.weather
        FROM Resurrection_Event re
        LEFT JOIN Pet p ON re.pet_id = p.id
        LEFT JOIN Owner o ON p.owner_id = o.id`
    );
    if (mode === 'research') {
      const minimal = rows.map((row) => ({
        id: row.id,
        pet_id: row.pet_id,
        ritual_name: row.ritual_name,
        date: row.date,
      }));
      return res.json({
        success: true,
        data: { events: minimal, total: rows.length },
        message: null,
        error: null,
      });
    }
    if (mode === 'redacted') {
      const redacted = rows.map((row) => {
        // let ritual = row.ritual_name;
        // if (row.moon_phase === 'Full Moon') {
        //   ritual = '[REDACTED]';
        // }
        let ritual = '[REDACTED]';
        let performer_name = '[REDACTED]';
        return {
          id: row.id,
          pet_id: row.pet_id,
          pet_name: row.pet_name,
          performed_by: row.performed_by,
          performer_name: performer_name,
          ritual_name: ritual,
          date: row.date,
          time: row.time,
          moon_phase: row.moon_phase,
          weather: row.weather,
        };
      });
      return res.json({
        success: true,
        data: redacted,
        message: null,
        error: null,
      });
    }
    // official
    return res.json({
      success: true,
      data: rows,
      message: null,
      error: null,
    });
  } catch (err) {
    next(err);
  }
};

/**
 * Create a new resurrection event. Validates foreign key references and
 * updates the pet's resurrection_status to 1. Expects JSON body with
 * pet_id, performed_by (owner_id), ritual_name, date (YYYY‑MM‑DD), time
 * (HH:MM), moon_phase and weather.
 */
exports.createResurrection = async (req, res, next) => {
  const body = req.body || {};
  const requiredFields = [
    'pet_id',
    'performed_by',
    'ritual_name',
    'date',
    'time',
    'moon_phase',
    'weather',
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
    // Validate pet exists
    const petRows = await db.query('SELECT id, resurrection_status FROM Pet WHERE id = ?', [body.pet_id]);
    if (petRows.length === 0) {
      return res.status(400).json({
        success: false,
        data: null,
        message: 'Invalid pet_id',
        error: null,
      });
    }
    // Validate owner exists
    const ownerRows = await db.query('SELECT id FROM Owner WHERE id = ?', [body.performed_by]);
    if (ownerRows.length === 0) {
      return res.status(400).json({
        success: false,
        data: null,
        message: 'Invalid performed_by (owner) id',
        error: null,
      });
    }
    // Validate ritual exists
    const ritualRows = await db.query('SELECT name FROM Ritual WHERE name = ?', [body.ritual_name]);
    if (ritualRows.length === 0) {
      return res.status(400).json({
        success: false,
        data: null,
        message: 'Invalid ritual_name',
        error: null,
      });
    }
    // Insert resurrection event
    const result = await db.query(
      `INSERT INTO Resurrection_Event (pet_id, performed_by, ritual_name, date, time, moon_phase, weather)
         VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [
        body.pet_id,
        body.performed_by,
        body.ritual_name,
        body.date,
        body.time,
        body.moon_phase,
        body.weather,
      ]
    );
    // Update pet's resurrection status if not already resurrected
    if (petRows[0].resurrection_status === 0) {
      await db.query('UPDATE Pet SET resurrection_status = 1 WHERE id = ?', [body.pet_id]);
    }
    return res.status(201).json({
      success: true,
      data: { id: result.insertId },
      message: 'Resurrection event created successfully',
      error: null,
    });
  } catch (err) {
    next(err);
  }
};
