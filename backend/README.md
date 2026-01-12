# Backend – Pet Sematary DB

This folder contains the Node.js/Express backend for the **Pet Sematary DB – Versioned Reality Portal**.  The API exposes data stored in a MySQL database and supports multiple _Reality Modes_ (`official`, `redacted`, `research`) controlled via a `mode` query parameter.

## Prerequisites

- **MySQL** 8+ installed locally or accessible remotely.
- **Node.js** v18 or later and **npm** installed.  You can verify your installation with:

  ```bash
  node --version
  npm --version
