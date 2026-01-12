import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// Vite configuration for the React app.  We enable the React plugin
// which provides support for JSX and automatic fast refresh during
// development.
export default defineConfig({
  plugins: [react()],
  server: {
    // By default Vite runs on port 5173.  Feel free to change this if
    // another service occupies that port.
    port: 5173,
  },
});
