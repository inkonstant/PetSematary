const db = require('../db');

/**
 * Return high level counts for the dashboard. Counts include total pets,
 * resurrected pets, total resurrection events, number of forbidden rituals
 * and the number of sections considered high risk (danger_level = 'high' or
 * 'cursed').
 */
exports.getOverview = async (req, res, next) => {
  try {
    const [petsCountRow] = await db.query('SELECT COUNT(*) AS count FROM Pet');
    const [resurrectedCountRow] = await db.query(
      'SELECT COUNT(*) AS count FROM Pet WHERE resurrection_status = 1'
    );
    const [eventsCountRow] = await db.query('SELECT COUNT(*) AS count FROM Resurrection_Event');
    const [forbiddenCountRow] = await db.query('SELECT COUNT(*) AS count FROM Ritual WHERE forbidden = 1');
    const [highRiskCountRow] = await db.query(
      "SELECT COUNT(*) AS count FROM Section WHERE danger_level IN ('high', 'cursed')"
    );
    const data = {
      totalPets: petsCountRow.count,
      resurrectedPets: resurrectedCountRow.count,
      totalEvents: eventsCountRow.count,
      forbiddenRituals: forbiddenCountRow.count,
      highRiskSections: highRiskCountRow.count,
    };
    return res.json({
      success: true,
      data,
      message: null,
      error: null,
    });
  } catch (err) {
    next(err);
  }
};

/**
 * Return a list of sections grouped by danger_level with a count of
 * resurrection events associated with each level. Events are joined through
 * Burial_Plot and Pet tables.
 */
exports.getSectionsRisk = async (req, res, next) => {
  try {
    const rows = await db.query(
      `SELECT s.danger_level,
              COUNT(re.id) AS events_count
         FROM Section s
         LEFT JOIN Burial_Plot bp ON s.name = bp.section_name
         LEFT JOIN Pet p ON bp.id = p.burial_plot_id
         LEFT JOIN Resurrection_Event re ON p.id = re.pet_id
        GROUP BY s.danger_level`
    );
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
 * Return performance statistics for each ritual. For every ritual, compute
 * how many times it has been used (usage_count), its average success_rate (from
 * the Ritual table) and whether it is considered "corrupted". A ritual is
 * flagged as corrupted if either of the following conditions is true:
 *  - success_rate < 30 and usage_count >= 3
 *  - success_rate < 50 and usage_count >= 1
 */
exports.getRitualPerformance = async (req, res, next) => {
  try {
    const rows = await db.query(
      `SELECT r.name, r.success_rate, COUNT(re.id) AS usage_count
         FROM Ritual r
         LEFT JOIN Resurrection_Event re ON r.name = re.ritual_name
        GROUP BY r.name, r.success_rate`
    );
    const data = rows.map((row) => {
      const successRate = parseFloat(row.success_rate);
      const usage_count = parseInt(row.usage_count, 10);
      const corrupted =
        (successRate < 30 && usage_count >= 3) || (successRate < 50 && usage_count >= 1);
      return {
        name: row.name,
        success_rate: successRate,
        usage_count,
        corrupted,
      };
    });
    return res.json({
      success: true,
      data,
      message: null,
      error: null,
    });
  } catch (err) {
    next(err);
  }
};
