import React, { useEffect, useState } from 'react';
import { motion } from 'framer-motion';
import { getPets, getPet } from '../api/client.js';
import { useReality } from '../context/RealityContext.jsx';

/**
 * Pets screen allows users to browse animals interred in the cemetery.
 * In official and redacted modes, a search bar filters pets by name
 * or species and clicking on a row opens a detailed panel.  In
 * research mode, only minimal fields are displayed and details are
 * hidden to respect the aggregated nature of this mode.
 */
export default function Pets() {
  const { mode } = useReality();
  const [pets, setPets] = useState([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedPet, setSelectedPet] = useState(null);
  const [details, setDetails] = useState(null);

  useEffect(() => {
    let isMounted = true;
    async function fetchData() {
      try {
        setLoading(true);
        const res = await getPets(mode);
        if (!res.success) {
          throw new Error(res.message || 'Error fetching pets');
        }
        if (isMounted) {
          if (mode === 'research') {
            setPets(res.data.pets || []);
            setTotal(res.data.total || 0);
          } else {
            setPets(res.data || []);
            setTotal(res.data.length || 0);
          }
        }
      } catch (err) {
        if (isMounted) setError('Failed to load pets');
      } finally {
        if (isMounted) setLoading(false);
      }
    }
    fetchData();
    // Reset search and selected pet when mode changes
    setSearchTerm('');
    setSelectedPet(null);
    setDetails(null);
    return () => {
      isMounted = false;
    };
  }, [mode]);

  async function openDetails(pet) {
    try {
      setSelectedPet(pet);
      const res = await getPet(pet.id, mode);
      if (res.success) {
        setDetails(res.data);
      } else {
        setDetails(null);
      }
    } catch (err) {
      setDetails(null);
    }
  }

  function closeDetails() {
    setSelectedPet(null);
    setDetails(null);
  }

  if (loading) {
    return <p>Loading...</p>;
  }
  if (error) {
    return <p>{error}</p>;
  }

  // Filter pets based on search term (case insensitive) for non‑research modes
  const filteredPets = pets.filter((p) => {
    if (mode === 'research') return true;
    const lower = searchTerm.toLowerCase();
    return (
      p.name.toLowerCase().includes(lower) ||
      p.species.toLowerCase().includes(lower)
    );
  });

  return (
    <div>
      <motion.h2
        initial={{ opacity: 0, x: -20 }}
        animate={{ opacity: 1, x: 0 }}
        transition={{ duration: 0.5 }}
      >
        Pets
      </motion.h2>
      {mode !== 'research' && (
        <div className="search-container">
          <input
            type="text"
            placeholder="Search by name or species..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
      )}
      {/* Render the table differently depending on the mode */}
      {mode === 'research' ? (
        <div>
          <p>Total pets: {total}</p>
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Species</th>
                <th>Resurrected</th>
              </tr>
            </thead>
            <tbody>
              {pets.map((p) => (
                <tr key={p.id}>
                  <td>{p.id}</td>
                  <td>{p.name}</td>
                  <td>{p.species}</td>
                  <td>{p.resurrection_status ? 'Yes' : 'No'}</td>
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
              <th>Species</th>
              <th>Owner</th>
              <th>Cause of Death</th>
              <th>Resurrected</th>
            </tr>
          </thead>
          <tbody>
            {filteredPets.map((p) => (
              <tr key={p.id} onClick={() => openDetails(p)} style={{ cursor: 'pointer' }}>
                <td>{p.name}</td>
                <td>{p.species}</td>
                <td>{p.owner_name}</td>
                <td>
                  {p.cause_of_death === '[REDACTED]' ? (
                    <span className="redacted">[REDACTED]</span>
                  ) : (
                    p.cause_of_death
                  )}
                </td>
                <td>
                  {p.resurrection_status === '[REDACTED]' ? (
                    <span className="redacted">[REDACTED]</span>
                  ) : (
                    p.resurrection_status ? 'Yes' : 'No'
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
      {/* Detail overlay */}
      {details && (
        <div className="overlay" onClick={closeDetails}>
          <div className="panel" onClick={(e) => e.stopPropagation()}>
            <span className="panel-close" onClick={closeDetails}>&times;</span>
            <h3>Pet Details</h3>
            <table>
              <tbody>
                {Object.entries(details).map(([key, value]) => (
                  <tr key={key}>
                    <th style={{ textTransform: 'capitalize' }}>{key.replace(/_/g, ' ')}</th>
                    <td>
                      {value === '[REDACTED]' ? (
                        <span className="redacted">[REDACTED]</span>
                      ) : value === null || value === '' ? (
                        '-'
                      ) : (
                        String(value)
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  );
}