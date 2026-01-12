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
        Rituals
      </motion.h2>
      {mode === 'research' ? (
        <div>
          <p>Total rituals: {total}</p>
          <table>
            <thead>
              <tr>
                <th>Name</th>
                <th>Success Rate</th>
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
              <th>Forbidden</th>
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
