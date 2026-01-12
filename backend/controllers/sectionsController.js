const db = require('../db');

/**
 * Retrieve all sections. In research mode, only minimal fields (name and
 * danger_level) are returned along with a total count.
 */
exports.getAllSections = async (req, res, next) => {
  const mode = (req.query.mode || 'official').toLowerCase();
  try {
    const rows = await db.query(
      `SELECT s.name, s.caretaker_id, s.danger_level, s.access_restrictions,
              c.name AS caretaker_name, c.years_of_service, c.knows_secret
         FROM Section s
         LEFT JOIN Caretaker c ON s.caretaker_id = c.id`
    );
    if (mode === 'research') {
      const minimal = rows.map((row) => ({
        name: row.name,
        danger_level: row.danger_level,
      }));
      return res.json({
        success: true,
        data: { sections: minimal, total: rows.length },
        message: null,
        error: null,
      });
    }
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
 * Retrieve a single section by its name. Returns detailed information
 * including the number of burial plots in this section. Research mode
 * returns only the name, danger_level and plot count.
 */
exports.getSectionByName = async (req, res, next) => {
  const mode = (req.query.mode || 'official').toLowerCase();
  const sectionName = req.params.name;
  try {
    const rows = await db.query(
      `SELECT s.name, s.caretaker_id, s.danger_level, s.access_restrictions,
              c.name AS caretaker_name, c.years_of_service, c.knows_secret
         FROM Section s
         LEFT JOIN Caretaker c ON s.caretaker_id = c.id
        WHERE s.name = ?`,
      [sectionName]
    );
    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        data: null,
        message: 'Section not found',
        error: null,
      });
    }
    // Count burial plots in this section.
    const countRows = await db.query(
      'SELECT COUNT(*) AS count FROM Burial_Plot WHERE section_name = ?',
      [sectionName]
    );
    const plotCount = countRows[0].count;
    const section = rows[0];
    if (mode === 'research') {
      return res.json({
        success: true,
        data: {
          name: section.name,
          danger_level: section.danger_level,
          plots: plotCount,
        },
        message: null,
        error: null,
      });
    }
    return res.json({
      success: true,
      data: {
        name: section.name,
        caretaker_id: section.caretaker_id,
        caretaker_name: section.caretaker_name,
        years_of_service: section.years_of_service,
        knows_secret: section.knows_secret,
        danger_level: section.danger_level,
        access_restrictions: section.access_restrictions,
        plots: plotCount,
      },
      message: null,
      error: null,
    });
  } catch (err) {
    next(err);
  }
};
