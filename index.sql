-- Active: 1747673919559@@127.0.0.1@5432@conservation_db

-- create database
CREATE DATABASE conservation_db
    TEMPLATE template0;

-- create rangers table 
CREATE TABLE rangers(
    ranger_id SERIAL PRIMARY KEY ,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100)
);
-- create species table
CREATE TABLE  species(
species_id SERIAL PRIMARY KEY ,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(100) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(100)
);

-- create sightings table
CREATE TABLE  sightings(
    sightings_id SERIAL PRIMARY KEY ,
    species_id INT NOT NULL,
    ranger_id INT NOT NULL,
    location VARCHAR(255) NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    notes TEXT,
    FOREIGN KEY (ranger_id) REFERENCES rangers(ranger_id) ON DELETE CASCADE,
    FOREIGN KEY (species_id) REFERENCES species(species_id) ON DELETE CASCADE 
);

-- show tables



-- insert data into rangers table
INSERT INTO rangers ( name, region) VALUES
('Alice Green', 'Northern Hills'),
( 'Bob White', 'River Delta'),
( 'Carol King', 'Mountain Range');


INSERT INTO species ( common_name, scientific_name, discovery_date, conservation_status) VALUES
( 'Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
( 'Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
( 'Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
( 'Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

INSERT INTO sightings (sightings_id, species_id ,ranger_id,location, sighting_time,  notes  ) VALUES
(1, 1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(4, 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);


SELECT* FROM rangers;
SELECT* FROM species;
SELECT* FROM sightings;

-- Problem 1
INSERT INTO rangers (name, region) VALUES
('Derek Fox', 'Coastal Plains');

-- Problem 2

SELECT COUNT(DISTINCT scientific_name) AS unique_species_count
FROM species;

-- Problem 3

SELECT *
FROM sightings
WHERE location LIKE '%Pass%'

-- Problem 4
SELECT rangers.name AS rangers_name ,count(sightings.ranger_id) AS total_sightings
FROM rangers
JOIN sightings ON sightings.ranger_id = rangers.ranger_id
GROUP BY name;

-- Problem 5
-- full issues


SELECT common_name
FROM species
WHERE species_id NOT IN (
    SELECT DISTINCT species_id FROM sightings
)
GROUP BY common_name; 



-- Problem 6

SELECT common_name, sighting_time, name
FROM sightings
JOIN species ON sightings.species_id = species.species_id
JOIN rangers ON sightings.ranger_id = rangers.ranger_id
ORDER BY (sighting_time) DESC
LIMIT 2;


-- Problem 7

UPDATE species
SET conservation_status = 'Historic'
WHERE EXTRACT(YEAR FROM discovery_date) < 1800;

-- Problem 8

SELECT
    sightings_id,
    (CASE
        WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sighting_time) >= 12 AND EXTRACT(HOUR FROM sighting_time) < 17 THEN 'Afternoon'
        WHEN EXTRACT(HOUR FROM sighting_time) >= 17  THEN 'Evening'
    END) AS time_of_day
FROM sightings;

-- Problem 9


DELETE FROM rangers
WHERE ranger_id IN (
    SELECT DISTINCT ranger_id FROM sightings
);




