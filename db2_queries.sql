-- This file contains scripts to create a spatial table to store NATD data in DB2, populates it with data, and performs some spatial queries.

-- Run this in cmd as administrator to import the CSV file into DB2
-- Make sure to replace the path with the correct one for your system
db2 "LOAD FROM 'D:/Advanced_Project/NTAD_North_American_Roads/North_American_Roads_WKT_Simplified.csv' OF DEL MODIFIED BY COLDEL, METHOD P (1, 9, 18, 7) INSERT INTO spatial1.north_american_roads (id, roadname, wkt, state)"

-- Create a new bufferpool for 8K pages
-- This is necessary for the spatial data type as it requires a larger page size.
CREATE BUFFERPOOL BP8K IMMEDIATE PAGESIZE 8 K;

-- Create a new tablespace for the spatial data
-- This tablespace will use the 8K bufferpool created above.
CREATE TABLESPACE SPATIAL_TS PAGESIZE 8 K MANAGED BY AUTOMATIC STORAGE BUFFERPOOL BP8K;

-- Create a new schema for the spatial data
-- This schema will contain the spatial table and any other related objects.
CREATE TABLE north_american_roads (
    id INTEGER,
    roadname VARCHAR(255),
    wkt CLOB(2M) LOGGED NOT COMPACT,
    geom ST_GEOMETRY,
    state VARCHAR(255)
)
IN SPATIAL_TS  
LONG IN SPATIAL_TS;

-- Cast the WKT column to a geometry type and populate the geom column
-- This step is necessary to convert the WKT representation of the roads into a spatial format.
UPDATE spatial1.north_american_roads
SET geom = ST_Geometry(CAST(wkt AS VARCHAR(32000)), 4326)
WHERE LENGTH(wkt) <= 32000;

-- Finding the number of populated geometries
-- This query counts the number of rows in the spatial table where the geom column is not null.
SELECT COUNT(*) AS populated_geom_count
FROM spatial1.north_american_roads
WHERE geom IS NOT NULL;

-- Finding the total number of points in the table
-- This query counts the total number of rows in the spatial table.
SELECT COUNT(*) AS total_points
FROM spatial1.north_american_roads
WHERE geom IS NOT NULL;

-- Find roads within a specific polygon (NY State example)
SELECT COUNT(*) AS filtered_points
FROM spatial1.north_american_roads
WHERE ST_Intersects(
    geom,
    ST_Polygon('POLYGON((
        -74.8465 40.4774, -71.1859 40.4774, -71.1859 45.01585, -74.8465 45.01585, -74.8465 40.4774 ))', 4326)
) = 1;

-- Find roads within 100 km from NYC
SELECT id, roadname, state
FROM spatial1.north_american_roads
WHERE ST_Distance(
          ST_Point(-73.935242, 40.730610, 4326),
          geom,
          'meter'
      ) <= 100000
FETCH FIRST 10 ROWS ONLY;