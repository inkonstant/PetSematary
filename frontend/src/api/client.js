/**
 * Simple API client for the Pet Sematary backend.  Each function
 * wraps a call to a particular endpoint and returns the parsed JSON.
 */

const API_BASE = 'http://localhost:3000/api';

async function fetchJson(url, options = {}) {
  const response = await fetch(url, options);
  const data = await response.json();
  return data;
}

export async function getPets(mode = 'official') {
  const res = await fetchJson(`${API_BASE}/pets?mode=${mode}`);
  return res;
}

export async function getPet(id, mode = 'official') {
  const res = await fetchJson(`${API_BASE}/pets/${id}?mode=${mode}`);
  return res;
}

export async function getRituals(mode = 'official') {
  const res = await fetchJson(`${API_BASE}/rituals?mode=${mode}`);
  return res;
}

export async function getResurrections(mode = 'official') {
  const res = await fetchJson(`${API_BASE}/resurrections?mode=${mode}`);
  return res;
}

export async function createResurrection(body) {
  const res = await fetchJson(`${API_BASE}/resurrections`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  });
  return res;
}

export async function getResearchOverview() {
  const res = await fetchJson(`${API_BASE}/research/overview`);
  return res;
}

export async function getSectionsRisk() {
  const res = await fetchJson(`${API_BASE}/research/sections-risk`);
  return res;
}

export async function getRitualPerformance() {
  const res = await fetchJson(`${API_BASE}/research/ritual-performance`);
  return res;
}
