import { useEffect } from 'react';

export function useFlashlight(mode) {
  useEffect(() => {
    if (mode !== 'redacted') {
      document.body.style.removeProperty('--mouse-x');
      document.body.style.removeProperty('--mouse-y');
      return;
    }

    let targetX = window.innerWidth / 2;
    let targetY = window.innerHeight / 2;

    let currentX = targetX;
    let currentY = targetY;

    let rafId;

    const handleMouseMove = (e) => {
      targetX = e.clientX;
      targetY = e.clientY;
    };

    const animate = () => {
      const lag = 0.1;

      currentX += (targetX - currentX) * lag;
      currentY += (targetY - currentY) * lag;

      document.body.style.setProperty('--mouse-x', `${currentX}px`);
      document.body.style.setProperty('--mouse-y', `${currentY}px`);

      rafId = requestAnimationFrame(animate);
    };

    window.addEventListener('mousemove', handleMouseMove);
    rafId = requestAnimationFrame(animate);

    return () => {
      window.removeEventListener('mousemove', handleMouseMove);
      cancelAnimationFrame(rafId);
    };
  }, [mode]);
}
