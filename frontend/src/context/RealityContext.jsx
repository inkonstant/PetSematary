import React, { createContext, useContext, useState, useLayoutEffect } from 'react';

/**
 * RealityContext exposes the current reality mode (official, redacted,
 * research) and a setter to change it.  Components can use this
 * context to adapt their UI based on the active mode.  The default
 * mode is "official".
 */
const RealityContext = createContext({
  mode: 'official',
  setMode: () => {},
});

/**
 * RealityProvider wraps the application and stores the current mode in
 * React state.  It also toggles a class on the document body to
 * update the CSS variables defined in global.css.
 */
export function RealityProvider({ children }) {
  const [mode, setMode] = useState('official');

  // Update body class whenever mode changes.  This ensures CSS
  // variables and themes update automatically.
  useLayoutEffect(() => {
    const body = document.body;
    body.classList.remove('mode-official', 'mode-redacted', 'mode-research');
    body.classList.add(`mode-${mode}`);
  }, [mode]);

  return (
    <RealityContext.Provider value={{ mode, setMode }}>
      {children}
    </RealityContext.Provider>
  );
}

/**
 * Hook to access the RealityContext easily from functional components.
 */
export function useReality() {
  return useContext(RealityContext);
}
