// Normalize MySQL BIT fields (returned as Buffer/object) into booleans
function normalizeBit(v) {
  if (v === null || v === undefined) return false;
  if (typeof v === 'object') return v[0] === 1;
  return Boolean(v);
}

module.exports = {
  normalizeBit,
};
