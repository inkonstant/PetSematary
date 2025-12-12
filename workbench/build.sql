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
  caretaker_id INT NOT NULL,
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
  owner_id INT NOT NULL,
  species VARCHAR(50),
  date_of_birth VARCHAR(10),
  date_of_death VARCHAR(10),
  cause_of_death TEXT,
  resurrection_status BIT(1),
  temperament VARCHAR(50),
  appearance_changes TEXT,

  section_name VARCHAR(50) NOT NULL,
  plot_number INT NOT NULL,

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
  ritual_name VARCHAR(50) NOT NULL,
  date VARCHAR(10),
  time VARCHAR(5),
  moon_phase ENUM('New Moon','First Quarter','Full Moon','Last Quarter'),
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
  visitor_type ENUM('Tourist','Researcher','Miscellaneous','Family'),
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
(1,'Jud Crandall',33,1),
(2,'Joe Strummer',2,0);

-- SECTION
INSERT INTO Section VALUES
('Micmac Grounds',1,'cursed','Authorized personnel only.'),
('Pet Memorial Park',2,'mid','Daytime access only.'),
('Forest Perimeter',2,'low','Open to public.');

-- BURIAL PLOT
INSERT INTO Burial_Plot VALUES
('Micmac Grounds', 1, 'Black cotton soil','Here Lies Brian Griffin\nBeloved Friend, Failed Author',1,'2013-11-30'),
('Pet Memorial Park', 1, 'Black cotton soil','Herein lies Garfield\nMay his rest finally be… uninterrupted',1,'2016-12-26'),
('Micmac Grounds', 2, 'Clay soil',NULL,0,'1999-10-05');

-- OWNER
INSERT INTO Owner VALUES
(1,'Peter Griffin','31 Spooner Street, Quahog, Rhode Island','Sad'),
(2,'Jon Arbuckle','22 Robinwood, Muncie, Indiana','Kinda Happy'),
(3,'Mickey Mouse','Disneyland, Anaheim, California','Distraught');

-- PET
INSERT INTO Pet (
  id, name, owner_id, species, date_of_birth, date_of_death,
  cause_of_death, resurrection_status, temperament, appearance_changes,
  section_name, plot_number
) VALUES
(1,'Brian Griffin',1,'Dog','1999-01-31','2013-11-24','Car Accident',1,'Angry','Mouth sewn shut','Micmac Grounds',1),
(2,'Garfield',2,'Cat','1978-01-02','2016-12-24','Choking',1,'Hungry','Slit Stomach','Pet Memorial Park',1),
(3,'Pluto',3,'Dog','1930-05-09','1999-09-25',NULL,0,NULL,NULL,'Micmac Grounds',2);

-- RITUAL
INSERT INTO Ritual VALUES
('Moonlit Return','an animal shaped candle, a whisker from the pet','Tusen takk for gild helsing, Knut!','Ancient tribes believed...',45.26,1),
('Whispered Passage','a small clay tube, the ashes of a sacred herb, the pet''s collar','Saelon vora, hear my call...','Old forest legends...',28.30,0),
('Ancestral Awakening','red-sage ceremonial herb, stone circle, drop of owner blood','Ekoran thulei...','Ancestral bloodline...',74.00,0);

-- RESURRECTION EVENTS
INSERT INTO Resurrection_Event VALUES
(1,1,'Moonlit Return','2003-05-18','01:30','Full Moon','Storm'),
(2,2,'Ancestral Awakening','2015-09-30','12:05','New Moon','Cloudy');

-- VISITOR
INSERT INTO Visitor VALUES
(1,'Marjorie Holloway',62,'Family','Visiting the grave of her childhood dog',1),
(2,'Elias Crowe',34,'Researcher','Documenting unexplained events',0),
(3,'Timothy Wexler',12,'Miscellaneous','Looking for his missing cat',0);

-- VISITOR ACCESS
INSERT INTO VisitorAccess VALUES
(1,'Micmac Grounds',5),
(1,'Pet Memorial Park',10),
(2,'Pet Memorial Park',12),
(2,'Micmac Grounds',3);

-- WITNESS EVENTS
INSERT INTO WitnessEvent VALUES
(1,1,'High',5,'No one lived to tell the tale'),
(3,2,'Low',0,'A kid saw something weird and fell'),
(3,1,'Mid',2,'I think I see something coming… DUCK!');

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
