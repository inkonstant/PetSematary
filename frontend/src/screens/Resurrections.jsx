import React, { useEffect, useState } from 'react';
import { motion } from 'framer-motion';
import { getResurrections, getPets, getRituals, createResurrection } from '../api/client.js';
import { useReality } from '../context/RealityContext.jsx';

export default function Resurrections() {
  const { mode } = useReality();
  const [events, setEvents] = useState([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [formData, setFormData] = useState({
    pet_id: '', performed_by: '', ritual_name: '', date: '', time: '', moon_phase: 'New Moon', weather: '',
  });
  const [petsList, setPetsList] = useState([]);
  const [ownersList, setOwnersList] = useState([]);
  const [ritualsList, setRitualsList] = useState([]);
  const [formError, setFormError] = useState(null);
  const [successMsg, setSuccessMsg] = useState(null);

  useEffect(() => {
    let isMounted = true;
    async function fetchEvents() {
      try {
        setLoading(true);
        const res = await getResurrections(mode);
        if (!res.success) throw new Error(res.message || 'Error fetching events');
        if (isMounted) {
          if (mode === 'research') {
            setEvents(res.data.events || []);
            setTotal(res.data.total || 0);
          } else {
            setEvents(res.data || []);
            setTotal(res.data.length || 0);
          }
        }
      } catch (err) { if (isMounted) setError('Failed to load resurrection events');
      } finally { if (isMounted) setLoading(false); }
    }
    fetchEvents();
    return () => { isMounted = false; };
  }, [mode]);

  useEffect(() => {
    if (mode === 'research') return;
    let isMounted = true;
    async function fetchLists() {
      try {
        const petsRes = await getPets('official');
        const ritualsRes = await getRituals('official');
        if (petsRes.success && ritualsRes.success) {
          const pets = Array.isArray(petsRes.data) ? petsRes.data : petsRes.data.pets;
          const rituals = Array.isArray(ritualsRes.data) ? ritualsRes.data : ritualsRes.data.rituals;
          const ownersMap = new Map();
          pets.forEach((p) => { if (!ownersMap.has(p.owner_id)) ownersMap.set(p.owner_id, p.owner_name); });
          if (isMounted) {
            setPetsList(pets);
            setRitualsList(rituals);
            setOwnersList(Array.from(ownersMap.entries()));
          }
        }
      } catch (err) {}
    }
    fetchLists();
    return () => { isMounted = false; };
  }, [mode]);

  async function handleSubmit(e) {
    e.preventDefault();
    setFormError(null);
    setSuccessMsg(null);
    const required = ['pet_id', 'performed_by', 'ritual_name', 'date', 'time', 'moon_phase', 'weather'];
    const missing = required.filter((f) => !formData[f]);
    if (missing.length > 0) { setFormError(`Missing: ${missing.join(', ')}`); return; }
    try {
      const data = await createResurrection({
        pet_id: parseInt(formData.pet_id, 10),
        performed_by: parseInt(formData.performed_by, 10),
        ritual_name: formData.ritual_name,
        date: formData.date,
        time: formData.time,
        moon_phase: formData.moon_phase,
        weather: formData.weather,
      });
      if (data.success) {
        setSuccessMsg('Resurrection event created successfully');
        const res = await getResurrections(mode);
        if (res.success) setEvents(res.data || res.data.events || []);
        setFormData({ pet_id: '', performed_by: '', ritual_name: '', date: '', time: '', moon_phase: 'New Moon', weather: '', });
      } else { setFormError(data.message || 'Failed to create resurrection'); }
    } catch (err) { setFormError('Error creating resurrection'); }
  }

  if (loading) return <p className={mode === 'research' ? 'terminal-prompt' : ''}>Loading...</p>;
  if (error) return <p className={mode === 'research' ? 'terminal-prompt' : ''}>{error}</p>;

  return (
    <div>
      <motion.h2
        initial={{ opacity: 0, x: -20 }}
        animate={{ opacity: 1, x: 0 }}
        transition={{ duration: 0.5 }}
      >
        {mode === 'research' ? '> EVENT_LOGS_DECRYPTED' : 'Resurrections'}
      </motion.h2>

      {mode === 'research' ? (
        <div className="terminal-container">
          <div className="terminal-header">
            <div className="terminal-title">CONSOLE // EVENT_DATABASE</div>
            <div className="terminal-controls"><span className="t-dot red"></span><span className="t-dot yellow"></span><span className="t-dot green"></span></div>
          </div>
          <div className="terminal-content">
            <p className="terminal-stats">MODE: READ_ONLY</p>
            <p className="terminal-stats">LOG_ENTRIES: {total}</p>
            <table className="terminal-table">
              <thead><tr><th>[ID]</th><th>[PET_ID]</th><th>[RITUAL]</th><th>[DATE]</th></tr></thead>
              <tbody>
                {events.map((ev) => (
                  <tr key={ev.id}><td>{ev.id}</td><td>{ev.pet_id}</td><td>{ev.ritual_name}</td><td>{ev.date}</td></tr>
                ))}
              </tbody>
            </table>
            <div className="terminal-prompt">researcher@petsematary:~$ <span className="blink-cursor">_</span></div>
          </div>
        </div>
      ) : (
        <div>
          <table>
            <thead><tr><th>Pet</th><th>Performed By</th><th>Ritual</th><th>Date</th><th>Time</th><th>Moon Phase</th><th>Weather</th></tr></thead>
            <tbody>
              {events.map((ev) => {
                const performer_name = ev.performer_name === '[REDACTED]' ? <span className="redacted">[REDACTED]</span> : ev.performer_name;
                const ritual_name = ev.ritual_name === '[REDACTED]' ? <span className="redacted">[REDACTED]</span> : ev.ritual_name;
                return (
                  <tr key={ev.id}>
                    <td>{ev.pet_name || ev.pet_id}</td>
                    <td>{performer_name || ev.performed_by}</td>
                    <td>{ritual_name}</td>
                    <td>{ev.date}</td><td>{ev.time}</td><td>{ev.moon_phase}</td><td>{ev.weather}</td>
                  </tr>
                );
              })}
            </tbody>
          </table>
          <h3 style={{ marginTop: '2rem' }}>Create Resurrection Event</h3>
          {formError && <p style={{ color: 'var(--accent-color)' }}>{formError}</p>}
          {successMsg && <p style={{ color: 'var(--accent-color)' }}>{successMsg}</p>}
          <form onSubmit={handleSubmit} style={{ marginTop: '1rem' }}>
            <label>Pet: <select value={formData.pet_id} onChange={(e) => setFormData({ ...formData, pet_id: e.target.value })} required>
                <option value="">Select pet</option>
                {petsList.map((p) => (<option key={p.id} value={p.id}>{p.name} (ID {p.id})</option>))}
              </select></label><br />
            <label>Performed By: <select value={formData.performed_by} onChange={(e) => setFormData({ ...formData, performed_by: e.target.value })} required>
                <option value="">Select owner</option>
                {ownersList.map(([id, name]) => (<option key={id} value={id}>{name}</option>))}
              </select></label><br />
            <label>Ritual: <select value={formData.ritual_name} onChange={(e) => setFormData({ ...formData, ritual_name: e.target.value })} required>
                <option value="">Select ritual</option>
                {ritualsList.map((r) => (<option key={r.name} value={r.name}>{r.name}</option>))}
              </select></label><br />
            <label>Date: <input type="date" value={formData.date} onChange={(e) => setFormData({ ...formData, date: e.target.value })} required /></label><br />
            <label>Time: <input type="time" value={formData.time} onChange={(e) => setFormData({ ...formData, time: e.target.value })} required /></label><br />
            <label>Moon Phase: <select value={formData.moon_phase} onChange={(e) => setFormData({ ...formData, moon_phase: e.target.value })} required>
                <option value="New Moon">New Moon</option><option value="First Quarter">First Quarter</option><option value="Full Moon">Full Moon</option><option value="Last Quarter">Last Quarter</option>
              </select></label><br />
            <label>Weather: <input type="text" placeholder="e.g. Foggy" value={formData.weather} onChange={(e) => setFormData({ ...formData, weather: e.target.value })} required /></label><br />
            <button type="submit" className="entry-button" style={{ marginTop: '1rem' }}>Create Event</button>
          </form>
        </div>
      )}
    </div>
  );
}