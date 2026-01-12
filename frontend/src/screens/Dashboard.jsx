import React, { useEffect, useState } from 'react';
import { motion } from 'framer-motion';
import {
  getResearchOverview,
  getSectionsRisk,
  getRitualPerformance,
} from '../api/client.js';
import { useReality } from '../context/RealityContext.jsx';

/**
 * Dashboard screen displays aggregated statistics about the cemetery,
 * including counts of pets, resurrected pets, resurrection events,
 * forbidden rituals and high‑risk sections.  It also shows risk
 * profiles per section danger level and ritual performance metrics.
 */
export default function Dashboard() {
  const { mode } = useReality();
  const [overview, setOverview] = useState(null);
  const [sectionRisk, setSectionRisk] = useState([]);
  const [ritualPerf, setRitualPerf] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    let isMounted = true;
    async function fetchData() {
      try {
        setLoading(true);
        const [ovRes, secRes, ritRes] = await Promise.all([
          getResearchOverview(),
          getSectionsRisk(),
          getRitualPerformance(),
        ]);
        if (isMounted) {
          setOverview(ovRes.data);
          setSectionRisk(secRes.data);
          setRitualPerf(ritRes.data);
        }
      } catch (err) {
        if (isMounted) setError('Failed to load dashboard data');
      } finally {
        if (isMounted) setLoading(false);
      }
    }
    fetchData();
    return () => {
      isMounted = false;
    };
  }, []);

  if (loading) {
    return <p>Loading...</p>;
  }
  if (error) {
    return <p>{error}</p>;
  }
  if (!overview) {
    return null;
  }

  return (
    <div>
      <section className="dashboard-section">
        <motion.h2
          initial={{ opacity: 0, x: -20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 0.6 }}
        >
          Dashboard
        </motion.h2>
        {/* Overview cards */}
        <div className="cards">
          <div className="card">
            <h3>Total Pets</h3>
            <p>{overview.totalPets}</p>
          </div>
          <div className="card">
            <h3>Resurrected Pets</h3>
            <p>{overview.resurrectedPets}</p>
          </div>
          <div className="card">
            <h3>Total Events</h3>
            <p>{overview.totalEvents}</p>
          </div>
          <div className="card">
            <h3>Forbidden Rituals</h3>
            <p>{overview.forbiddenRituals}</p>
          </div>
          <div className="card">
            <h3>High‑Risk Sections</h3>
            <p>{overview.highRiskSections}</p>
          </div>
        </div>
      </section>
      {/* Section risk table */}
      <section className="dashboard-section">
        <h2>Section Risk</h2>
        <table>
          <thead>
            <tr>
              <th>Danger Level</th>
              <th>Events Count</th>
            </tr>
          </thead>
          <tbody>
            {sectionRisk.map((row, idx) => (
              <tr key={idx}>
                <td>{row.danger_level}</td>
                <td>{row.events_count}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </section>
      {/* Ritual performance table */}
      <section className="dashboard-section">
        { mode === 'redacted' ? (
        <div>
          <h2>Ritual Performance</h2>
          <h3>This section has been removed.</h3>
        </div>
        ) : (
        <div>
          <h2>Ritual Performance</h2>
          <table>
            <thead>
              <tr>
                <th>Ritual</th>
                <th>Success Rate</th>
                <th>Usage</th>
                <th>Corrupted</th>
              </tr>
            </thead>
            <tbody>
              {ritualPerf.map((r, idx) => (
                <tr key={idx}>
                  <td>{r.name}</td>
                  <td>{parseFloat(r.success_rate).toFixed(2)}%</td>
                  <td>{r.usage_count}</td>
                  <td className={r.corrupted ? 'redacted' : ''}>{r.corrupted ? 'Yes' : 'No'}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        )}
      </section>
    </div>
  );
}
