# PETS WITH UNKNOWN CAUSE OF DEATH

SELECT name, date_of_death
FROM pet
WHERE cause_of_death IS NULL;