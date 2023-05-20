/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon%';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT * FROM animals WHERE name <> 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT *FROM animals WHERE neutered = true;

BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT name, species FROM animals;
ROLLBACK;
SELECT name, species FROM animals;


BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
SELECT name, species FROM animals;
COMMIT;
SELECT name, species FROM animals;


BEGIN;
DELETE FROM animals;
ROLLBACK;
SELECT * FROM animals;


BEGIN;
DELETE FROM animals WHERE date_of_birth = '2022-01-01';
SAVEPOINT my_savepoint;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO my_savepoint;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;

SELECT neutered, COUNT(*) AS escape_count
FROM animals
WHERE escape_attempts > 0
GROUP BY neutered
ORDER BY escape_count DESC
LIMIT 1;

SELECT name, AVG(escape_attempts) AS average_escape_attempts
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY name;

SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;

SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Melody Pond';


SELECT a.name
FROM animals a
JOIN species s ON a.species_id = s.id
WHERE s.name = 'Pokemon';


SELECT o.full_name, COALESCE(a.name, 'No animal') AS animal
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id;


SELECT s.name, COUNT(*) AS animal_count
FROM animals a
JOIN species s ON a.species_id = s.id
GROUP BY s.name;


SELECT a.name
FROM animals a
JOIN species s ON a.species_id = s.id
JOIN owners o ON a.owner_id = o.id
WHERE s.name = 'Digimon' AND o.full_name = 'Jennifer Orwell';

SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;


SELECT o.full_name, COUNT(*) AS animal_count
FROM owners o
JOIN animals a ON o.id = a.owner_id
GROUP BY o.full_name
ORDER BY animal_count DESC
LIMIT 1;

SELECT animal
FROM visits
WHERE vet_id = (SELECT id FROM vets WHERE name = 'William Tatcher')
ORDER BY visit_date DESC
LIMIT 1;

SELECT COUNT(DISTINCT animal)
FROM visits
WHERE vet_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez');

SELECT vets.name, specializations.species
FROM vets
LEFT JOIN specializations ON vets.id = specializations.vet_id;

SELECT animal
FROM visits
WHERE vet_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez')
  AND visit_date BETWEEN '2020-04-01' AND '2020-08-30';

SELECT animal, COUNT(*) AS visit_count
FROM visits
GROUP BY animal
ORDER BY visit_count DESC
LIMIT 1;

SELECT vet_id, visit_date
FROM visits
WHERE animal = (SELECT animal FROM visits WHERE vet_id = (SELECT id FROM vets WHERE name = 'Maisy Smith') ORDER BY visit_date LIMIT 1)
ORDER BY visit_date
LIMIT 1;

SELECT v.name AS vet_name, v.age AS vet_age, v.date_of_graduation AS vet_graduation_date,
       a.animal, vst.visit_date
FROM visits vst
JOIN vets v ON vst.vet_id = v.id
JOIN (SELECT animal, MAX(visit_date) AS max_date FROM visits GROUP BY animal) AS a
  ON vst.animal = a.animal AND vst.visit_date = a.max_date;

SELECT COUNT(*)
FROM visits v
LEFT JOIN specializations s ON v.vet_id = s.vet_id AND v.animal = s.species
WHERE s.vet_id IS NULL;

SELECT s.species, COUNT(*) AS visit_count
FROM visits v
JOIN specializations s ON v.vet_id = s.vet_id
WHERE v.animal = (SELECT animal FROM visits WHERE vet_id = (SELECT id FROM vets WHERE name = 'Maisy Smith') ORDER BY visit_date LIMIT 1)
GROUP BY s.species
ORDER BY visit_count DESC
LIMIT 1;