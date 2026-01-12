# Spooky Frontend – Pet Sematary Portal

This folder contains a complete React implementation of the **Pet Sematary DB – Versioned Reality Portal**.  Inspired by classic horror interfaces, the frontend immerses users in a dark, unsettling world where reality modes (Official, Redacted, Research) alter not only the data returned by the API but also the presentation itself.

## Highlights

- **Entry Gate**: Before accessing any data, users are warned that some records were never meant to be accessed.  A glitchy title and subtle animations set the tone.
- **Reality Modes**: A global mode selector changes how data is fetched and displayed.  The CSS variables defined in `global.css` swap themes on the fly.
- **Dashboard**: Aggregated statistics from the backend appear as cards, with tables for section risk and ritual performance.  Corrupted rituals are highlighted in red.
- **Pets**: Search and browse pets in official and redacted modes with owner information and mental state redactions.  In research mode only minimal fields and totals are shown.  Clicking a pet opens a dossier panel with all fields.
- **Rituals**: Lists rituals with chant redaction where appropriate.  Research mode reduces the view to names and success rates.
- **Resurrections**: Shows events in either minimal or full detail.  A creation form allows new resurrection events in non‑research modes and automatically updates the pet’s resurrection status.
- **Framer Motion**: Animations bring life (or death) to screen transitions, button interactions and the entry screen.

## Prerequisites

- **Node.js** v18 or later and **npm** must be installed on your machine.
- The backend API must be running on `http://localhost:3000` with CORS enabled (as provided in the backend folder).

## Setup and Running

1. **Install dependencies**

   From the `spooky-frontend` directory, install the npm packages:

   ```bash
   cd spooky-frontend
   npm install
