import React from 'react';
import { motion } from 'framer-motion';

/**
 * EntryGate renders an initial screen with a warning and an "Enter
 * Portal" button.  The glitch effect on the title conveys the
 * unsettling nature of the application.  The parent component
 * provides an `onEnter` callback which is invoked when the user
 * chooses to proceed.  The animations are kept subtle to avoid
 * distracting from the core content.
 */
export default function EntryGate({ onEnter }) {
  return (
    <div className="entry-wrapper">
      {/* Title with glitch effect using CSS pseudo-elements.  The
          `data-text` attribute is used by the CSS to duplicate the
          text in pseudo-elements. */}
      <motion.h1
        className="glitch"
        data-text="Pet Sematary Portal"
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 1.2, delay: 0.2 }}
      >
        Pet&nbsp;Sematary&nbsp;Portal
      </motion.h1>
      <motion.p
        initial={{ opacity: 0, y: -10 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 1, delay: 1 }}
      >
        Some records were never meant to be accessed. Proceed at your own risk.
      </motion.p>
      <motion.button
        className="entry-button"
        onClick={onEnter}
        whileHover={{ scale: 1.05 }}
        whileTap={{ scale: 0.95 }}
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ duration: 1, delay: 1.8 }}
      >
        Enter&nbsp;Portal
      </motion.button>
    </div>
  );
}
