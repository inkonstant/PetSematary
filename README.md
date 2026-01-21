# 🪦 Pet Sematary Database
## Full-Stack Web Application (Node.js + React)

This repository contains a **full-stack web application** developed as part of the course **Database Systems** at the **Aristotle University of Thessaloniki**.

The application is built on top of the **Pet Sematary Database** and provides an interactive interface for managing, exploring, and analyzing data related to a fictional pet cemetery — including burials, visitors, rituals, and resurrection events.

---

## Project Overview

The application consists of:

- A **Node.js / Express backend** that exposes a REST API  
- A **React frontend** that consumes the API and visualizes the data  
- A **MySQL relational database** implementing the schema defined in **Deliverable 1**

The system supports both:

- Standard **CRUD operations**
- **Analytical and aggregated views**, such as identifying dangerous sections or unstable rituals

---

## Project Structure

```text
pet-sematary-app/
│
├── backend/                # Node.js / Express API
│   ├── src/
│   │   ├── routes/         # REST endpoints
│   │   ├── controllers/    # Request handling logic
│   │   ├── services/       # Business logic
│   │   ├── db/             # Database connection & queries
│   │   └── app.js
│   ├── .env.example
│   └── package.json
│
├── frontend/               # React application
│   ├── src/
│   │   ├── pages/          # Application views
│   │   ├── components/     # Reusable UI components
│   │   ├── services/       # API communication
│   │   ├── styles/         # Styling & mode themes
│   │   └── App.jsx
│   └── package.json
│
└── README.md
```

## Reality Modes

The frontend supports multiple **Reality Modes**, which affect how data is presented:

### Official Mode
Clean, administrative view of the database  
*(what users are officially allowed to see)*

### Redacted Mode
Partial data masking  
Used to hide sensitive or dangerous information

### Research Mode
Full analytical access with raw data, statistics, and anomaly indicators  
Intended for advanced analysis and exploration

Mode switching is handled on the **frontend**, while the backend provides the required data and aggregations.

---

## Tech Stack

### Backend
- Node.js
- Express
- MySQL
- .env
- REST API architecture

### Frontend
- React
- Axios
- Vite
- CSS (custom theming per mode)

---

## API Overview

Indicative REST endpoints exposed by the backend:

```http
GET /api/pets
GET /api/owners
GET /api/sections
GET /api/rituals
GET /api/resurrections
GET /api/dashboard/summary
```

Endpoints return **relational or aggregated data** and are designed to support the different frontend modes.

---

## How to Run the Application

The application consists of **two separate services**:

- **Backend** (Node.js / Express)
- **Frontend** (React)

Both must be running simultaneously.

---

### Prerequisites

Ensure the following are installed:

- Node.js (v18+ recommended)
- npm
- MySQL Server
- A MySQL database initialized with the project schema and data

---

### Setup

1. Create the database:

```sql
CREATE DATABASE pet_sematary_db;
```

Import the schema and sample data:

```bash
mysql -u root -p pet_sematary_db < build.sql
```

The database must be running before starting the backend.

2. Backend Setup

```bash
cd backend
npm install
```

Create a .env file based on example:

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=pet_sematary_db
PORT=5000
```

Start the backend server:

```bash
npm run dev
```

The API will be available at:

```arduino
http://localhost:5000
```

3️. Frontend Setup

Open a new terminal:

```bash
cd frontend
npm install
npm run dev
```

The frontend will run at:

```arduino
http://localhost:5173
```

4️. Using the Application

Open the frontend URL in your browser

The dashboard loads data from the backend API

Use the UI controls to switch between:

- Official Mode
- Redacted Mode
- Research Mode

Navigate between pages (Dashboard, Pets, Rituals, Resurrections)

## Development Notes

Backend uses nodemon for hot reload

Frontend uses the Vite development server

Authentication is intentionally omitted (academic scope)

SQL views are used for higher-level logic and analysis

## Team

Group 7 – Aristotle University of Thessaloniki

- Yiannis Konstantakis
- Vlassis Voulkidis
- Ilias Mastrogiannis

## Disclaimer

This project was developed for educational purposes only.
All entities, rituals, and resurrection events are fictional.

If something in the data looks unsettling —
that is most likely intentional.
