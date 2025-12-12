-- ------------------------------------------------
-- 1. Visitor user (read-only basic access)
-- ------------------------------------------------

CREATE USER 'visitor_user'@'localhost' IDENTIFIED BY 'visitorpass';
CREATE USER 'visitor_user'@'%' IDENTIFIED BY 'visitorpass';

GRANT SELECT ON pet_sematary_db.Pet TO 'visitor_user'@'localhost';
GRANT SELECT ON pet_sematary_db.Pet TO 'visitor_user'@'%';

GRANT SELECT ON pet_sematary_db.Section TO 'visitor_user'@'localhost';
GRANT SELECT ON pet_sematary_db.Section TO 'visitor_user'@'%';

GRANT SELECT ON pet_sematary_db.Burial_Plot TO 'visitor_user'@'localhost';
GRANT SELECT ON pet_sematary_db.Burial_Plot TO 'visitor_user'@'%';


-- ------------------------------------------------
-- 2. Caretaker user (update burial plots & sections)
-- ------------------------------------------------

CREATE USER 'caretaker_user'@'localhost' IDENTIFIED BY 'caretakerpass';
CREATE USER 'caretaker_user'@'%' IDENTIFIED BY 'caretakerpass';

GRANT SELECT, UPDATE ON pet_sematary_db.Section TO 'caretaker_user'@'localhost';
GRANT SELECT, UPDATE ON pet_sematary_db.Section TO 'caretaker_user'@'%';

GRANT SELECT, UPDATE ON pet_sematary_db.Burial_Plot TO 'caretaker_user'@'localhost';
GRANT SELECT, UPDATE ON pet_sematary_db.Burial_Plot TO 'caretaker_user'@'%';

GRANT SELECT ON pet_sematary_db.Pet TO 'caretaker_user'@'localhost';
GRANT SELECT ON pet_sematary_db.Pet TO 'caretaker_user'@'%';


-- ------------------------------------------------
-- 3. Researcher user (full read-only access)
-- ------------------------------------------------

CREATE USER 'researcher_user'@'localhost' IDENTIFIED BY 'researcherpass';
CREATE USER 'researcher_user'@'%' IDENTIFIED BY 'researcherpass';

-- read-only on all tables
GRANT SELECT ON pet_sematary_db.* TO 'researcher_user'@'localhost';
GRANT SELECT ON pet_sematary_db.* TO 'researcher_user'@'%';

-- read-only on all views
GRANT SELECT ON pet_sematary_db.ACTIVE_BURIALS TO 'researcher_user'@'localhost';
GRANT SELECT ON pet_sematary_db.ACTIVE_BURIALS TO 'researcher_user'@'%';

GRANT SELECT ON pet_sematary_db.FORBIDDEN_PATHS TO 'researcher_user'@'localhost';
GRANT SELECT ON pet_sematary_db.FORBIDDEN_PATHS TO 'researcher_user'@'%';

GRANT SELECT ON pet_sematary_db.RITUAL_CORRUPTION TO 'researcher_user'@'localhost';
GRANT SELECT ON pet_sematary_db.RITUAL_CORRUPTION TO 'researcher_user'@'%';


-- ------------------------------------------------
-- 4. Full Administrator
-- ------------------------------------------------

CREATE USER 'admin_psdb'@'localhost' IDENTIFIED BY 'superadminpass';
CREATE USER 'admin_psdb'@'%' IDENTIFIED BY 'superadminpass';

GRANT ALL PRIVILEGES ON pet_sematary_db.* TO 'admin_psdb'@'localhost';
GRANT ALL PRIVILEGES ON pet_sematary_db.* TO 'admin_psdb'@'%';

-- ------------------------------------------------
-- FLUSH PRIVILEGES
-- ------------------------------------------------

FLUSH PRIVILEGES;