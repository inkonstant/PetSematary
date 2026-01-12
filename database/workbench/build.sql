DROP SCHEMA IF EXISTS pet_sematary_db;
CREATE SCHEMA pet_sematary_db;
USE pet_sematary_db;

-- ==========================================
-- CREATE TABLES
-- ==========================================

-- OWNER
CREATE TABLE Owner (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  address VARCHAR(100),
  mental_state VARCHAR(50)
) ENGINE=InnoDB;

-- CARETAKER
CREATE TABLE Caretaker (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  years_of_service INT,
  knows_secret BIT(1)
) ENGINE=InnoDB;

-- SECTION
CREATE TABLE Section (
  name VARCHAR(50) PRIMARY KEY,
  caretaker_id INT,
  danger_level ENUM('low','mid','high','cursed'),
  access_restrictions TEXT,
  FOREIGN KEY (caretaker_id)
    REFERENCES Caretaker(id)
    ON UPDATE CASCADE
    ON DELETE SET NULL
) ENGINE=InnoDB;

-- BURIAL_PLOT
CREATE TABLE Burial_Plot (
  section_name VARCHAR(50),
  plot_number INT,
  soil_type VARCHAR(50),
  inscription TEXT,
  has_marker BIT(1),
  date_of_burial VARCHAR(10),
  PRIMARY KEY (section_name, plot_number),
  FOREIGN KEY (section_name)
    REFERENCES Section(name)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- PET
CREATE TABLE Pet (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  owner_id INT,
  species VARCHAR(50),
  date_of_birth VARCHAR(10),
  date_of_death VARCHAR(10),
  cause_of_death TEXT,
  resurrection_status BIT(1),
  temperament VARCHAR(50),
  appearance_changes TEXT,

  section_name VARCHAR(50),
  plot_number INT,

  FOREIGN KEY (owner_id)
    REFERENCES Owner(id)
    ON UPDATE CASCADE
    ON DELETE SET NULL,

  FOREIGN KEY (section_name, plot_number)
    REFERENCES Burial_Plot(section_name, plot_number)
    ON UPDATE CASCADE
    ON DELETE SET NULL
) ENGINE=InnoDB;

-- RITUAL
CREATE TABLE Ritual (
  name VARCHAR(50) PRIMARY KEY,
  required_items VARCHAR(255),
  chant TEXT,
  origin_legend TEXT,
  success_rate DECIMAL(5,2),
  forbidden BIT(1)
) ENGINE=InnoDB;

-- RESURRECTION EVENT
CREATE TABLE Resurrection_Event (
  id INT AUTO_INCREMENT PRIMARY KEY,
  pet_id INT NOT NULL,
  ritual_name VARCHAR(50),
  date VARCHAR(10),
  time VARCHAR(5),
  moon_phase ENUM('New Moon', 'First Quarter', 'Full Moon', 'Last Quarter'),
  weather VARCHAR(50),
  FOREIGN KEY (pet_id)
    REFERENCES Pet(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (ritual_name)
    REFERENCES Ritual(name)
    ON UPDATE CASCADE
    ON DELETE SET NULL
) ENGINE=InnoDB;

-- VISITOR
CREATE TABLE Visitor (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50),
  age INT,
  visitor_type ENUM('Tourist', 'Researcher', 'Miscellaneous', 'Family'),
  purpose_of_visit TEXT,
  is_alive BIT(1)
) ENGINE=InnoDB;

-- VISITOR ACCESS
CREATE TABLE VisitorAccess (
  visitor_id INT,
  section_name VARCHAR(50),
  access_duration INT,
  PRIMARY KEY (visitor_id, section_name),
  FOREIGN KEY (visitor_id)
    REFERENCES Visitor(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (section_name)
    REFERENCES Section(name)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- WITNESS EVENT
CREATE TABLE WitnessEvent (
  visitor_id INT,
  resurrection_id INT,
  severity ENUM('Low','Mid','High','Fatal'),
  casualties INT,
  description TEXT,
  PRIMARY KEY (visitor_id, resurrection_id),
  FOREIGN KEY (visitor_id)
    REFERENCES Visitor(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (resurrection_id)
    REFERENCES Resurrection_Event(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- ==========================================
-- INSERT DATA
-- ==========================================

-- CARETAKER
INSERT INTO Caretaker VALUES
(1, 'Jud Crandall', 33, 1),
(2, 'Joe Strummer', 2, 0);

-- SECTION
INSERT INTO Section VALUES
('Micmac Grounds', 1, 'cursed', 'Authorized personnel only.'),
('Pet Memorial Park', 2, 'mid', 'Daytime access only.'),
('Forest Perimeter', 2, 'low', 'Open to public.');

-- BURIAL PLOT
INSERT INTO Burial_Plot VALUES
('Micmac Grounds', 1, 'Black cotton soil', 'Here Lies Brian Griffin. Beloved Friend, Failed Author', 1, '2013-11-30'),
('Pet Memorial Park', 1, 'Black cotton soil', 'Herein lies Garfield. May his rest finally be… uninterrupted', 1, '2016-12-26'),
('Micmac Grounds', 2, 'Clay soil', NULL, 0, '1999-10-05'),
('Pet Memorial Park', 2, 'Soft soil', 'Here lies Snoopy, faithful dreamer', 1, '1999-10-10'),
('Pet Memorial Park', 3, 'Soft soil', 'Scooby-Doo, forever afraid', 1, '2005-04-02'),
('Forest Perimeter', 1, 'Rocky soil', 'Hachiko, eternal loyalty', 1, '1935-03-08'),
('Micmac Grounds', 3, 'Dark soil', 'Laika, lost to the stars', 0, '1960-04-12'),
('Pet Memorial Park', 4, 'Soft soil', 'Bolt, good boy', 1, '2010-08-18'),
('Micmac Grounds', 4, 'Cold soil', 'Salem, returned differently', 0, '1997-10-31'),
('Pet Memorial Park', 5, 'Soft soil', 'Tom, finally at rest', 1, '2002-06-01'),
('Pet Memorial Park', 6, 'Soft soil', 'Snowball II, again', 1, '1992-02-13'),
('Forest Perimeter', 2, 'Loose soil', 'Stuart Little, too small', 0, '2000-07-15'),
('Micmac Grounds', 5, 'Ancient soil', 'Toothless, silent shadow', 0, '2019-03-22');

-- OWNER
INSERT INTO Owner (name, address, mental_state) VALUES
('Peter Griffin', '31 Spooner Street', 'Sad'),
('Jon Arbuckle', 'Muncie, Indiana', 'Kinda Happy'),
('Mickey Mouse', 'Disneyland', 'Distraught'),
('Charlie Brown', 'Peanuts Street', 'Melancholic'),
('Shaggy Rogers', 'Crystal Cove', 'Anxious'),
('Professor Ueno', 'Tokyo, Japan', 'Grieving'),
('Unnamed Soviet Astronaut', 'Baikonur Cosmodrome', 'Guilt'),
('Penny', 'Hollywood', 'Hopeful'),
('Sabrina Spellman', 'Greendale', 'Uneasy'),
('Jerry', 'Unknown Wall Hole', 'Relieved'),
('Homer Simpson', '742 Evergreen Terrace', 'Confused'),
('Little Family', 'New York City', 'Worried'),
('Hiccup Horrendous Haddock', 'Berk', 'Determined');

-- PET
INSERT INTO Pet (
  id, name, owner_id, species, date_of_birth, date_of_death,
  cause_of_death, resurrection_status, temperament, appearance_changes,
  section_name, plot_number
) VALUES
(1, 'Brian Griffin', 1, 'Dog', '1999-01-31', '2013-11-24', 'Car Accident', 1, 'Angry', 'Mouth sewn shut', 'Micmac Grounds',1),
(2, 'Garfield', 2, 'Cat', '1978-01-02', '2016-12-24', 'Choking', 1, 'Hungry', 'Slit Stomach', 'Pet Memorial Park',1),
(3, 'Pluto', 3, 'Dog', '1930-05-09', '1999-09-25', NULL, 0, NULL, NULL, 'Micmac Grounds',2),
(4, 'Snoopy', 4, 'Dog', '1950-10-04', '1999-10-04', 'Old age', 0, 'Calm', NULL, 'Pet Memorial Park', 2),
(5, 'Scooby-Doo', 5, 'Dog', '1969-09-13', '2005-03-28', 'Fright-induced heart failure', 1, 'Fearful', 'Eyes refuse to close', 'Pet Memorial Park', 3),
(6, 'Toothless', 13, 'Dragon', '2010-03-26', '2019-03-22', 'Unknown ritual side effect', 1, 'Unnaturally Calm', 'Scales darkened permanently', 'Micmac Grounds', 5),
(7, 'Tom', 10, 'Cat', '1940-02-10', '2002-06-01', 'Blunt trauma', 0, 'Aggressive', NULL, 'Pet Memorial Park', 5),
(8, 'Bolt', 8, 'Dog', '2008-11-21', '2010-08-18', 'Accident', 0, 'Energetic', NULL, 'Pet Memorial Park', 4),
(9, 'Salem', 9, 'Cat', '1996-01-01', '1997-10-31', 'Unknown', 1, 'Hostile', 'Eyes glow faintly red', 'Micmac Grounds', 4),
(10, 'Laika', 7, 'Dog', '1954-01-01', '1960-04-12', 'Orbital failure', 1, 'Silent', 'Burn marks beneath fur', 'Micmac Grounds', 3),
(11, 'Snowball II', 11, 'Cat', '1989-04-19', '1992-02-13', 'Multiple incidents', 1, 'Unstable', 'Missing fur patches', 'Pet Memorial Park', 6),
(12, 'Stuart Little', 12, 'Mouse', '1999-12-17', '2000-07-15', 'Predation', 0, 'Nervous', NULL, 'Forest Perimeter', 2),
(13, 'Hachiko', 6,  'Dog', '1923-11-10', '1935-03-08', 'Starvation', 0, 'Loyal', NULL, 'Forest Perimeter', 1);

-- RITUAL
INSERT INTO Ritual VALUES
('Moonlit Return', 'An animal shaped candle, a whisker from the pet', 'Tusen takk for gild helsing, Knut!',
 'Ancient tribes believed that the full moon opened a passage through which loyal animals could return to the living world.', 45.26, 1),
('Whispered Passage', 'A small clay tube, the ashes of a sacred herb, the pet''s collar', 'Saelon vora, hear my call Cross the veil and rise from fall',
 'It is said that the old forest guardians would leave whispered messages on the graves so that wandering spirits could find their way back.', 28.30, 0),
('Ancestral Awakening', 'Red-sage ceremonial herb, stone circle, drop of owner blood', 'Ekoran thulei, spirits near awaken kin we hold so dear',
 'An ancient ceremony practiced by tribes', 74.00, 0),
('Gravebound Whisper', 'Black candle, soil from first grave', 'Mortis voca, terra audi',
 'An old Micmac burial chant used only when the ground has already tasted death.', 22.50, 1),
('Echo of Loyalty', 'Personal belonging of the pet, lock of fur', 'Return not as you were, but as you remember',
 'A ritual believed to work only on animals with extreme loyalty.', 55.00, 0);

-- RESURRECTION EVENTS
INSERT INTO Resurrection_Event VALUES
-- Brian
(1, 1, 'Moonlit Return', '2003-05-18', '01:30', 'Full Moon', 'Storm'),
-- Garfeild
(2, 2, 'Ancestral Awakening', '2015-09-30', '12:05', 'New Moon', 'Cloudy'),
-- Scooby-Doo
(3, 5, 'Echo of Loyalty', '2005-04-01', '22:45', 'Full Moon', 'Fog'),
-- Laika
(4, 10, 'Moonlit Return', '1960-04-13', '01:10', 'New Moon', 'Clear'),
-- Salem
(5, 9, 'Gravebound Whisper', '1997-11-01', '23:59', 'Full Moon', 'Windy'),
-- Snowball II
(6, 11, 'Gravebound Whisper', '1992-02-14', '21:30', 'Last Quarter', 'Snow'),
-- Toothless
(7, 6, 'Ancestral Awakening', '2019-03-23', '00:05', 'New Moon', 'Storm'),
-- Tom
(8, 7, 'Echo of Loyalty', '2002-06-02', '21:00', 'Last Quarter', 'Clear');


-- VISITOR
INSERT INTO Visitor VALUES
(1, 'Marjorie Holloway', 62, 'Family', 'Visiting the grave of her childhood dog', 1),
(2, 'Elias Crowe', 34, 'Researcher', 'Documenting unexplained events', 0),
(3, 'Timothy Wexler', 12, 'Miscellaneous', 'Looking for his missing cat', 0),
(4, 'Dana Creed', 38, 'Family', 'Checking old burial grounds', 1),
(5, 'Mark Petrie', 29, 'Researcher', 'Studying resurrection patterns', 1),
(6, 'Eleanor Finch', 67, 'Tourist', 'Visiting famous graves', 1),
(7, 'Lucas Bell', 15, 'Miscellaneous', 'Exploring forbidden areas', 1),
(8, 'Jane Doe', 20, 'Miscellaneous', 'Unidentified presence', 0);

-- VISITOR ACCESS
INSERT INTO VisitorAccess VALUES
(1,'Micmac Grounds',5),
(1,'Pet Memorial Park',10),
(2,'Pet Memorial Park',12),
(2,'Micmac Grounds',3),
(4, 'Pet Memorial Park', 30),
(5, 'Micmac Grounds', 15),
(5, 'Forest Perimeter', 60),
(6, 'Pet Memorial Park', 20),
(7, 'Forest Perimeter', 10);

-- WITNESS EVENTS
INSERT INTO WitnessEvent VALUES
(1, 1, 'High', 5, 'No one lived to tell the tale'),
(3, 2, 'Low', 0, 'A kid saw something weird and fell'),
(3, 1, 'Mid', 2, 'I think I see something coming… DUCK!'),
(4, 3, 'High', 1, 'Subject emerged altered and aggressive'),
(5, 2, 'Fatal', 3, 'Resurrection caused structural collapse'),
(6, 4, 'Low', 0, 'Witness reported strange sounds'),
(7, 8, 'Mid', 1, 'Entity moved unnaturally fast'),
(8, 5, 'Fatal', 2, 'No physical remains recovered'),
(5, 1, 'Mid', 0, 'Subject responded to owner voice'),
(6, 7, 'High', 2, 'Multiple injuries reported'),
(4, 6, 'Low', 0, 'Subject showed recognition behavior');

-- ==========================================
-- CREATE VIEWS
-- ==========================================

-- ACTIVE BURIALS
CREATE VIEW ACTIVE_BURIALS AS
SELECT 
  P.name AS pet_name,
  P.species,
  O.name AS owner_name,
  P.section_name,
  P.plot_number,
  S.danger_level
FROM Pet P
JOIN Owner O ON P.owner_id = O.id
JOIN Section S ON P.section_name = S.name
WHERE P.resurrection_status = 0;

-- FORBIDDEN PATHS
CREATE VIEW FORBIDDEN_PATHS AS
SELECT
  V.name AS visitor_name,
  V.visitor_type,
  S.name AS section_name,
  S.access_restrictions
FROM Visitor V
CROSS JOIN Section S
LEFT JOIN VisitorAccess A
  ON V.id = A.visitor_id
 AND S.name = A.section_name
WHERE A.visitor_id IS NULL;

-- RITUAL CORRUPTION
CREATE VIEW RITUAL_CORRUPTION AS
SELECT 
  R.name,
  R.success_rate,
  IFNULL(C.total,0) AS total_uses
FROM Ritual R
LEFT JOIN (
    SELECT ritual_name, COUNT(*) AS total
    FROM Resurrection_Event
    GROUP BY ritual_name
) C ON R.name = C.ritual_name
WHERE 
      C.total = 0
   OR (R.success_rate < 30 AND C.total >= 3)
   OR (R.success_rate < 50 AND C.total >= 1);
