import React, { useState } from 'react';
import { RealityProvider, useReality } from './context/RealityContext.jsx';
import EntryGate from './screens/EntryGate.jsx';
import Dashboard from './screens/Dashboard.jsx';
import Pets from './screens/Pets.jsx';
import Rituals from './screens/Rituals.jsx';
import Resurrections from './screens/Resurrections.jsx';
import { useEffect } from 'react';

/**
 * The root component of the application.  It handles the entry gate
 * (the initial screen that warns users) and then renders the main
 * layout with the selected screen.  The entire app is wrapped in
 * RealityProvider to enable global access to the current mode.
 */
function AppWrapper() {
  const [entered, setEntered] = useState(false);
  const [screen, setScreen] = useState('dashboard');
  const { mode, setMode } = useReality();

  useEffect(() => {
    if (mode !== 'redacted') return;

    const interval = setInterval(() => {
      const candidates = document.querySelectorAll('h1, h2, h3, td, th');
      if (candidates.length === 0) return;

      const el = candidates[Math.floor(Math.random() * candidates.length)];
      el.classList.add('glitch');

      setTimeout(() => {
        el.classList.remove('glitch');
      }, 400);
    }, 6000 + Math.random() * 6000); // every 6–12 seconds

    return () => clearInterval(interval);
  }, [mode]);

  // Helper to render the current screen component.
  const renderScreen = () => {
    switch (screen) {
      case 'dashboard':
        return <Dashboard />;
      case 'pets':
        return <Pets />;
      case 'rituals':
        return <Rituals />;
      case 'resurrections':
        return <Resurrections />;
      default:
        return <Dashboard />;
    }
  };

  // Render the entry gate if the user hasn't entered yet.
  if (!entered) {
    return <EntryGate onEnter={() => setEntered(true)} />;
  }


  return (
    <div>
      {/* Header / Navigation */}
      <nav className="navbar">
        <div className="nav-buttons">
          <button
            className={`nav-button ${screen === 'dashboard' ? 'active' : ''}`}
            onClick={() => setScreen('dashboard')}
          >
            Dashboard
          </button>
          <button
            className={`nav-button ${screen === 'pets' ? 'active' : ''}`}
            onClick={() => setScreen('pets')}
          >
            Pets
          </button>
          <button
            className={`nav-button ${screen === 'rituals' ? 'active' : ''}`}
            onClick={() => setScreen('rituals')}
          >
            Rituals
          </button>
          <button
            className={`nav-button ${screen === 'resurrections' ? 'active' : ''}`}
            onClick={() => setScreen('resurrections')}
          >
            Resurrections
          </button>
        </div>
        {/* Reality Mode selector */}
        <div className="mode-selector">
          <label htmlFor="mode-select">Reality&nbsp;Mode:</label>
          <select
            id="mode-select"
            value={mode}
            onChange={(e) => setMode(e.target.value)}
          >
            <option value="official">Official</option>
            <option value="redacted">Redacted</option>
            <option value="research">Research</option>
          </select>
        </div>
      </nav>
      {/* Main content area */}
      <main className="container">{renderScreen()}</main>
    </div>
  );
}

export default function App() {
  return (
    <RealityProvider>
      <AppWrapper />
    </RealityProvider>
  );
}
