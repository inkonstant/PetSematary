const db = require('../db');
const { normalizeBit } = require('../utils/dbUtils');

/**
 * Retrieve all rituals. In redacted mode, chant is replaced with
 * '[REDACTED]' when the ritual is forbidden or its success_rate is below
 * 30. In research mode, only names and success rates are returned
 * along with a total count.
 */
exports.getAllRituals = async (req, res, next) => {
  const mode = (req.query.mode || 'official').toLowerCase();
  try {
    const rows = await db.query('SELECT * FROM Ritual');
    if (mode === 'research') {
      const minimal = rows.map((r) => ({
        name: r.name,
        success_rate: parseFloat(r.success_rate),
      }));
      return res.json({
        success: true,
        data: { rituals: minimal, total: rows.length },
        message: null,
        error: null,
      });
    }
    if (mode === 'redacted') {
      const redacted = rows.map((r) => {
        const successRate = parseFloat(r.success_rate);
        if (normalizeBit(r.forbidden)) {
          return { ...r,success_rate: parseFloat(r.success_rate), name: '[REDACTED]', required_items: '[REDACTED]', chant: '[REDACTED]', origin_legend: '[REDACTED]', success_rate: '[REDACTED]', forbidden: '[REDACTED]' };
        }
        return { ...r, forbidden: normalizeBit(r.forbidden) };
      });
      return res.json({
        success: true,
        data: redacted,
        message: null,
        error: null,
      });
    }
    // official
    if (mode === 'official') {
      const data = rows.map((row) => ({
        name: row.name,
        required_items: row.required_items,
        chant: row.chant,
        origin_legend: row.origin_legend,
        success_rate: row.success_rate,
        forbidden: normalizeBit(row.forbidden),
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
