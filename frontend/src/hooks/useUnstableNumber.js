import { useEffect, useState } from 'react';

export function useUnstableNumber(value, mode) {
  const [display, setDisplay] = useState(value);

  useEffect(() => {
    setDisplay(value);
  }, [value]);

  useEffect(() => {
    if (mode !== 'redacted') {
      return;
    }

    const interval = setInterval(() => {
      const delta =
        Math.random() < 0.3
          ? Math.random() < 0.5
            ? -1
            : 1
          : 0;

      setDisplay(value + delta);

      setTimeout(() => {
        setDisplay(value);
      }, 30000);
    }, 8000 + Math.random() * 6000);

    return () => clearInterval(interval);
  }, [value, mode]);

  return display;
}
