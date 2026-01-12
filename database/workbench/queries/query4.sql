# PETS RESURRECTED AT NIGHT

SELECT p.name
FROM pet AS p 
JOIN resurrection_event AS r ON p.id = r.pet_id
WHERE STR_TO_DATE(r.time, '%H:%i') >= '20:00' OR STR_TO_DATE(r.time, '%H:%i') <= '05:00';