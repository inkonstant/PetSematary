-- Seed script for the Pet Sematary database
-- This script drops any existing database with the same name, creates all
-- tables and populates them with sample data. Run this script from your
-- MySQL client before starting the backend.

DROP DATABASE IF EXISTS pet_sematary_db;
CREATE DATABASE pet_sematary_db;
USE pet_sematary_db;

-- Table: Owner
CREATE TABLE Owner (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  address VARCHAR(50) NOT NULL,
  mental_state VARCHAR(50) NOT NULL
);

-- Table: Caretaker
CREATE TABLE Caretaker (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  years_of_service INT NOT NULL,
  knows_secret BIT NOT NULL
);

-- Table: Section
CREATE TABLE Section (
  name VARCHAR(50) PRIMARY KEY,
  caretaker_id INT,
  danger_level ENUM('low','mid','high','cursed') NOT NULL,
  access_restrictions TEXT,
  FOREIGN KEY (caretaker_id) REFERENCES Caretaker(id)
);

-- Table: Burial_Plot
CREATE TABLE Burial_Plot (
  id INT PRIMARY KEY AUTO_INCREMENT,
  section_name VARCHAR(50),
  soil_type VARCHAR(50),
  inscription TEXT,
  has_marker BIT NOT NULL,
  date_of_burial VARCHAR(10) NOT NULL,
  FOREIGN KEY (section_name) REFERENCES Section(name)
);

-- Table: Pet
CREATE TABLE Pet (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  owner_id INT,
  burial_plot_id INT,
  species VARCHAR(50) NOT NULL,
  date_of_birth VARCHAR(10) NOT NULL,
  date_of_death VARCHAR(10) NOT NULL,
  cause_of_death TEXT,
  resurrection_status BIT NOT NULL DEFAULT 0,
  temperament VARCHAR(50),
  appearance_changes TEXT,
  FOREIGN KEY (owner_id) REFERENCES Owner(id),
  FOREIGN KEY (burial_plot_id) REFERENCES Burial_Plot(id)
);

-- Table: Ritual
CREATE TABLE Ritual (
  name VARCHAR(50) PRIMARY KEY,
  required_items VARCHAR(50),
  chant TEXT,
  origin_legend TEXT,
  success_rate DECIMAL(5,2) NOT NULL,
  forbidden BIT NOT NULL
);

-- Table: Resurrection_Event
CREATE TABLE Resurrection_Event (
  id INT PRIMARY KEY AUTO_INCREMENT,
  pet_id INT,
  performed_by INT,
  ritual_name VARCHAR(50),
  date VARCHAR(10) NOT NULL,
  time VARCHAR(5) NOT NULL,
  moon_phase ENUM('New Moon','First Quarter','Full Moon','Last Quarter') NOT NULL,
  weather VARCHAR(50),
  FOREIGN KEY (pet_id) REFERENCES Pet(id),
  FOREIGN KEY (performed_by) REFERENCES Owner(id),
  FOREIGN KEY (ritual_name) REFERENCES Ritual(name)
);

-- Table: Visitor
CREATE TABLE Visitor (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  age INT NOT NULL,
  visitor_type ENUM('Tourist','Researcher','Family','Miscellaneous') NOT NULL,
  purpose_of_visit TEXT,
  is_alive BIT NOT NULL
);

-- Table: VisitorAccess
CREATE TABLE VisitorAccess (
  visitor_id INT,
  section_name VARCHAR(50),
  access_duration INT NOT NULL,
  PRIMARY KEY (visitor_id, section_name),
  FOREIGN KEY (visitor_id) REFERENCES Visitor(id),
  FOREIGN KEY (section_name) REFERENCES Section(name)
);

-- Table: WitnessEvent
CREATE TABLE WitnessEvent (
  visitor_id INT,
  resurrection_id INT,
  severity ENUM('Low','Mid','High','Fatal') NOT NULL,
  casualties INT NOT NULL,
  description TEXT,
  PRIMARY KEY (visitor_id, resurrection_id),
  FOREIGN KEY (visitor_id) REFERENCES Visitor(id),
  FOREIGN KEY (resurrection_id) REFERENCES Resurrection_Event(id)
);

-- Insert sample owners
INSERT INTO Owner (name, address, mental_state) VALUES
  ('John Doe', '123 Maple St', 'Stable'),
  ('Jane Smith', '456 Elm St', 'Anxious'),
  ('Robert Brown', '789 Oak St', 'Disturbed'),
  ('Alice Johnson', '321 Pine St', 'Calm'),
  ('Mary Davis', '654 Cedar St', 'Traumatized');

-- Insert sample caretakers
INSERT INTO Caretaker (name, years_of_service, knows_secret) VALUES
  ('Samuel', 10, 1),
  ('Emily', 5, 0),
  ('George', 7, 1);

-- Insert sample sections
INSERT INTO Section (name, caretaker_id, danger_level, access_restrictions) VALUES
  ('North', 1, 'low', 'None'),
  ('South', 2, 'mid', 'Visitors with guide'),
  ('East', 2, 'high', 'Restricted after sunset'),
  ('West', 3, 'cursed', 'Authorized personnel only'),
  ('Center', 1, 'mid', 'No children allowed');

-- Insert sample burial plots
INSERT INTO Burial_Plot (section_name, soil_type, inscription, has_marker, date_of_burial) VALUES
  ('North', 'Loamy', 'Beloved pet', 1, '2024-01-01'),
  ('North', 'Sandy', 'Rest in peace', 1, '2024-02-02'),
  ('South', 'Clay', 'Our friend', 0, '2024-03-03'),
  ('East', 'Rocky', 'Forever missed', 1, '2024-04-04'),
  ('West', 'Peaty', 'Gone too soon', 0, '2024-05-05'),
  ('Center', 'Loamy', 'Loved always', 1, '2024-06-06'),
  ('Center', 'Sandy', 'Cherished', 1, '2024-07-07'),
  ('East', 'Clay', 'Faithful', 0, '2024-08-08');

-- Insert sample pets
INSERT INTO Pet (name, owner_id, burial_plot_id, species, date_of_birth, date_of_death, cause_of_death, resurrection_status, temperament, appearance_changes) VALUES
  ('Buster', 1, 1, 'Dog', '2015-05-10', '2023-12-20', 'Old age', 0, 'Friendly', NULL),
  ('Whiskers', 2, 2, 'Cat', '2017-03-14', '2024-01-10', 'Accident', 1, 'Feisty', 'Glowing eyes'),
  ('Rex', 3, 3, 'Dog', '2018-07-20', '2024-02-14', 'Illness', 0, 'Loyal', NULL),
  ('Bella', 4, 4, 'Cat', '2016-11-01', '2024-03-20', 'Unknown', 1, 'Calm', 'Translucent fur'),
  ('Shadow', 5, 5, 'Rabbit', '2019-06-10', '2024-04-25', 'Predator', 0, 'Timid', NULL),
  ('Max', 1, 6, 'Dog', '2014-09-12', '2023-11-15', 'Disease', 0, 'Playful', NULL),
  ('Oscar', 2, 7, 'Bird', '2020-02-02', '2024-05-01', 'Unknown', 0, 'Curious', NULL),
  ('Daisy', 3, 8, 'Dog', '2015-05-05', '2024-06-20', 'Accident', 1, 'Gentle', 'Glowing aura'),
  ('Luna', 4, 1, 'Cat', '2018-09-09', '2024-07-30', 'Illness', 0, 'Quiet', NULL),
  ('Buddy', 5, 2, 'Dog', '2013-01-01', '2023-10-10', 'Old age', 1, 'Energetic', 'Strange scars');

-- Insert sample rituals
INSERT INTO Ritual (name, required_items, chant, origin_legend, success_rate, forbidden) VALUES
  ('Standard Ritual', 'Candle, Soil', 'Rise again, creature of old', 'Traditional', 75.00, 0),
  ('Blood Moon Rite', 'Blood, Incense', 'By the blood of the moon, awaken', 'Ancient', 50.00, 0),
  ('Forbidden Resurgence', 'Bone, Black Candle', 'Spirits unbound, return to life', 'Dark magic', 20.00, 1),
  ('Soul Binding', 'Feather, Silver', 'Bind the soul to the earth', 'Mystic', 40.00, 0),
  ('Secret Whisper', 'Whisper Herb, Stone', 'Secrets spoken, life awoken', 'Lost', 10.00, 1),
  ('Harvest Charm', 'Corn, Pumpkin', 'From harvest to heart, breathe again', 'Folk tale', 60.00, 0);

-- Insert sample resurrection events
INSERT INTO Resurrection_Event (pet_id, performed_by, ritual_name, date, time, moon_phase, weather) VALUES
  (2, 2, 'Blood Moon Rite', '2024-02-20', '23:00', 'Full Moon', 'Stormy'),
  (4, 4, 'Forbidden Resurgence', '2024-03-25', '00:30', 'New Moon', 'Clear'),
  (2, 1, 'Standard Ritual', '2024-04-15', '21:45', 'First Quarter', 'Windy'),
  (8, 3, 'Soul Binding', '2024-05-18', '22:10', 'Last Quarter', 'Rainy'),
  (10, 5, 'Harvest Charm', '2024-06-22', '23:59', 'Full Moon', 'Foggy'),
  (4, 2, 'Forbidden Resurgence', '2024-07-01', '01:15', 'Full Moon', 'Thunderstorm'),
  (8, 3, 'Blood Moon Rite', '2024-07-30', '23:30', 'First Quarter', 'Cloudy'),
  (10, 4, 'Standard Ritual', '2024-08-10', '22:45', 'Last Quarter', 'Clear'),
  (2, 2, 'Secret Whisper', '2024-09-17', '23:05', 'New Moon', 'Misty'),
  (8, 1, 'Forbidden Resurgence', '2024-10-05', '00:50', 'Full Moon', 'Windy');

-- Insert sample visitors
INSERT INTO Visitor (name, age, visitor_type, purpose_of_visit, is_alive) VALUES
  ('Thomas Visitor', 30, 'Tourist', 'Sightseeing', 1),
  ('Dr. Caldwell', 45, 'Researcher', 'Study rituals', 1),
  ('Ellen Grace', 50, 'Family', 'Pay respects', 1),
  ('Marcus Reed', 38, 'Miscellaneous', 'Photography', 1),
  ('Sarah Connor', 28, 'Tourist', 'Explore folklore', 1),
  ('Ian Malcolm', 55, 'Researcher', 'Observe events', 1),
  ('Lucy Brown', 35, 'Family', 'Remember pet', 1),
  ('George King', 42, 'Miscellaneous', 'Legend chasing', 1),
  ('Nancy Drew', 25, 'Researcher', 'Investigate anomalies', 1),
  ('Rick Sanchez', 60, 'Tourist', 'Curiosity', 1);

-- Insert sample visitor access records
INSERT INTO VisitorAccess (visitor_id, section_name, access_duration) VALUES
  (1, 'North', 120),
  (2, 'South', 60),
  (2, 'East', 30),
  (3, 'North', 90),
  (3, 'South', 45),
  (4, 'West', 30),
  (5, 'Center', 60),
  (5, 'East', 120),
  (6, 'East', 80),
  (6, 'West', 40),
  (7, 'North', 30),
  (8, 'South', 50),
  (8, 'West', 20),
  (9, 'Center', 70),
  (10, 'South', 60),
  (10, 'East', 50);

-- Insert sample witness events
INSERT INTO WitnessEvent (visitor_id, resurrection_id, severity, casualties, description) VALUES
  (1, 1, 'Low', 0, 'Saw faint glow'),
  (2, 2, 'Mid', 0, 'Heard strange chants'),
  (3, 3, 'High', 1, 'Experienced physical shock'),
  (4, 4, 'Low', 0, 'Felt breeze'),
  (5, 5, 'Fatal', 2, 'Witnessed horrific scene'),
  (6, 6, 'Mid', 0, 'Saw flash of light'),
  (7, 7, 'Low', 0, 'Heard whispers'),
  (8, 8, 'High', 1, 'Frightened by apparition'),
  (9, 9, 'Mid', 0, 'Unexpected voices'),
  (10, 10, 'Fatal', 3, 'Mass panic');
