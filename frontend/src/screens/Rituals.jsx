import React, { useEffect, useState } from 'react';
import { motion } from 'framer-motion';
import { getRituals } from '../api/client.js';
import { useReality } from '../context/RealityContext.jsx';

/**
 * Rituals screen displays the list of resurrection rituals.  In
 * research mode only names and success rates are shown.  In other
 * modes all fields are displayed, and chants that are redacted are
 * styled appropriately.
 */
export default function Rituals() {
  const { mode } = useReality();
  const [rituals, setRituals] = useState([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    let isMounted = true;
    async function fetchData() {
      try {
        setLoading(true);
        const res = await getRituals(mode);
        if (!res.success) {
          throw new Error(res.message || 'Error fetching rituals');
        }
        if (isMounted) {
          if (mode === 'research') {
            setRituals(res.data.rituals || []);
            setTotal(res.data.total || 0);
          } else {
            setRituals(res.data || []);
            setTotal(res.data.length || 0);
          }
        }
      } catch (err) {
        if (isMounted) setError('Failed to load rituals');
      } finally {
        if (isMounted) setLoading(false);
      }
    }
    fetchData();
    return () => {
      isMounted = false;
    };
  }, [mode]);

  if (loading) {
    return <p className={mode === 'research' ? 'terminal-text' : ''}>Loading...</p>;
  }
  if (error) {
    return <p className={mode === 'research' ? 'terminal-text' : ''}>{error}</p>;
  }

  return (
    <div className={mode === 'research' ? 'terminal-wrapper' : ''}>
      <motion.h2
        initial={{ opacity: 0, x: -20 }}
        animate={{ opacity: 1, x: 0 }}
        transition={{ duration: 0.5 }}
      >
        {mode === 'research' ? '> ACCESSING_RITUAL_LOGS' : 'Rituals'}
      </motion.h2>
      {mode === 'research' ? (
        <div className="terminal-container">
          <div className="terminal-header">
            <div className="terminal-title">CONSOLE // RITUAL_DATABASE</div>
            <div className="terminal-controls">
              <span className="t-dot red"></span>
              <span className="t-dot yellow"></span>
              <span className="t-dot green"></span>
            </div>
          </div>

          <div className="terminal-content">
            <p className="terminal-stats">STATUS: CONNECTION_ESTABLISHED</p>
            <p className="terminal-stats">TOTAL_RECORDS_FOUND: {total}</p>

            <table className="terminal-table">
              <thead>
                <tr>
                  <th>[NAME]</th>
                  <th>[SUCCESS_RATE]</th>
                </tr>
              </thead>
              <tbody>
                  {rituals.map((r) => (
                    <tr key={r.name}>
                      <td>{r.name}</td>
                      <td>{parseFloat(r.success_rate).toFixed(2)}%</td>
                    </tr>
                  ))}
                </tbody>
            </table>

            <div className="terminal-prompt">
              researcher@petsematary:~$ <span className="blink-cursor">_</span>
            </div>
          </div>
        </div>
      ) : (
        <table>
          <thead>
            <tr>
              <th>Name</th>
              <th>Required Items</th>
              <th>Chant</th>
              <th>Origin Legend</th>
              <th>Success Rate</th>
              <th>
                <span className={`censor-tape ${mode === 'redacted' ? 'is-censored' : ''}`}>
                  Forbidden
                </span>
              </th>
            </tr>
          </thead>
          <tbody>
            {rituals.map((r) => (
              <tr key={r.name}>
                <td>
                  {r.name === '[REDACTED]' ? (
                    <span className="redacted">[REDACTED]</span>
                  ) : (
                    r.name
                  )}
                </td>
                <td>
                  {r.required_items === '[REDACTED]' ? (
                    <span className="redacted">[REDACTED]</span>
                  ) : (
                    r.required_items
                  )}
                </td>
                <td>
                  {r.chant === '[REDACTED]' ? (
                    <span className="redacted">[REDACTED]</span>
                  ) : (
                    r.chant
                  )}
                </td>
                <td>
                  {r.origin_legend === '[REDACTED]' ? (
                    <span className="redacted">[REDACTED]</span>
                  ) : (
                    r.origin_legend
                  )}
                </td>
                <td>
                  {r.success_rate === '[REDACTED]' ? (
                    <span className="redacted">[REDACTED]</span>
                  ) : (
                    parseFloat(r.success_rate).toFixed(2) + '%'
                  )}
                </td>
                <td>
                  {r.forbidden === '[REDACTED]' ? (
                    <span className="redacted">[REDACTED]</span>
                  ) : (
                    r.forbidden ? 'Yes' : 'No'
                  )}
                </td>                
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}
