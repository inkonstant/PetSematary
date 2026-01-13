import React, { useEffect, useState } from 'react';
import { motion } from 'framer-motion';
import {
  getResurrections,
  getPets,
  getRituals,
  createResurrection,
} from '../api/client.js';
import { useReality } from '../context/RealityContext.jsx';

/**
 * Resurrections screen shows a list of resurrection events.  In
 * official and redacted modes it provides a form to create new events.
 * In research mode only a minimal view is shown.  Weather fields are
 * redacted in redacted mode when the moon phase is Full Moon.
 */
export default function Resurrections() {
  const { mode } = useReality();
  const [events, setEvents] = useState([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [formData, setFormData] = useState({
    pet_id: '',
    performed_by: '',
    ritual_name: '',
    date: '',
    time: '',
    moon_phase: 'New Moon',
    weather: '',
  });
  const [petsList, setPetsList] = useState([]);
  const [ownersList, setOwnersList] = useState([]);
  const [ritualsList, setRitualsList] = useState([]);
  const [formError, setFormError] = useState(null);
  const [successMsg, setSuccessMsg] = useState(null);

  // Fetch events when mode changes or after creation
  useEffect(() => {
    let isMounted = true;
    async function fetchEvents() {
      try {
        setLoading(true);
        const res = await getResurrections(mode);
        if (!res.success) {
          throw new Error(res.message || 'Error fetching events');
        }
        if (isMounted) {
          if (mode === 'research') {
            setEvents(res.data.events || []);
            setTotal(res.data.total || 0);
          } else {
            setEvents(res.data || []);
            setTotal(res.data.length || 0);
          }
        }
      } catch (err) {
        if (isMounted) setError('Failed to load resurrection events');
      } finally {
        if (isMounted) setLoading(false);
      }
    }
    fetchEvents();
    return () => {
      isMounted = false;
    };
  }, [mode]);

  // Fetch lists for select inputs only in non-research modes
  useEffect(() => {
    if (mode === 'research') return;
    let isMounted = true;
    async function fetchLists() {
      try {
        const petsRes = await getPets('official');
        const ritualsRes = await getRituals('official');
        if (petsRes.success && ritualsRes.success) {
          // Pets list may be nested differently depending on API shape
          const pets = Array.isArray(petsRes.data)
            ? petsRes.data
            : petsRes.data.pets;
          const rituals = Array.isArray(ritualsRes.data)
            ? ritualsRes.data
            : ritualsRes.data.rituals;
          // Build owners map from pets
          const ownersMap = new Map();
          pets.forEach((p) => {
            if (!ownersMap.has(p.owner_id)) {
              ownersMap.set(p.owner_id, p.owner_name);
            }
          });
          if (isMounted) {
            setPetsList(pets);
            setRitualsList(rituals);
            setOwnersList(Array.from(ownersMap.entries()));
          }
        }
      } catch (err) {
        // ignore
      }
    }
    fetchLists();
    return () => {
      isMounted = false;
    };
  }, [mode]);

  if (loading) {
    return <p>Loading...</p>;
  }
  if (error) {
    return <p>{error}</p>;
  }

  return (
    <div>
      <motion.h2
        initial={{ opacity: 0, x: -20 }}
        animate={{ opacity: 1, x: 0 }}
        transition={{ duration: 0.5 }}
      >
        {mode === 'research' ? '> EVENT_LOGS_DECRYPTED' : (
          <span className={`censor-tape ${mode === 'redacted' ? 'is-censored' : ''}`}>
            Resurrections
          </span>
        )}
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
            <thead>
              <tr>
                <th>Pet</th>
                <th>Performed By</th>
                <th>Ritual</th>
                <th>Date</th>
                <th>Time</th>
                <th>Moon Phase</th>
                <th>Weather</th>
              </tr>
            </thead>
            <tbody>
              {events.map((ev) => {
                const performer_name = ev.performer_name === '[REDACTED]'
                  ? <span className="redacted">[REDACTED]</span>
                  : ev.performer_name;
                const ritual_name = ev.ritual_name === '[REDACTED]'
                  ? <span className="redacted">[REDACTED]</span>
                  : ev.ritual_name;
                return (
                  <tr key={ev.id}>
                    <td>{ev.pet_name || ev.pet_id}</td>
                    <td>{performer_name || ev.performed_by}</td>
                    <td>{ritual_name}</td>
                    <td>{ev.date}</td>
                    <td>{ev.time}</td>
                    <td>{ev.moon_phase}</td>
                    <td>{ev.weather}</td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
