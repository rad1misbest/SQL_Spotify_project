# Spotify  SQL Project and Query Optimization 

## Overview
This project involves analyzing a Spotify dataset from kaggle  with various attributes about tracks, albums, and artists using **SQL**. 


###  Data Exploration
Before diving into SQL, it’s important to understand the dataset thoroughly. The dataset contains attributes such as:
- `Artist`: The performer of the track.
- `Track`: The name of the song.
- `Album`: The album to which the track belongs.
- `Album_type`: The type of album (e.g., single or album).
- Various metrics such as `danceability`, `energy`, `loudness`, `tempo`, and more.
  
```sql
SELECT COUNT(*) FROM spotify;

SELECT COUNT(DISTINCT(artist)) FROM spotify;

SELECT COUNT(DISTINCT(album)) FROM spotify;

SELECT DISTINCT(album_type) FROM spotify;

SELECT DISTINCT(most_played_on) FROM spotify;

SELECT MAX(Duration_min) FROM spotify;

SELECT MIN(Duration_min) FROM spotify;

SELECT * FROM spotify
WHERE Duration_min =0;

DELETE FROM spotify
WHERE Duration_min =0;

SELECT ROUND(AVG(Duration_min)) FROM spotify;

SELECT DISTINCT(channel) FROM spotify;

SELECT MAX(Views) FROM spotify;

SELECT MIN(Views) FROM spotify;

SELECT * FROM spotify
WHERE Views = 0;
DELETE FROM spotify
WHERE Views = 0;


```


## TASKS

### 
 Retrieve the names of all tracks that have more than 1 billion streams.
```sql
SELECT * FROM spotify
WHERE stream > 1000000000;
```
 List all albums along with their respective artists.
 ```sql
SELECT DISTINCT album,artist FROM spotify
ORDER BY 1;
```
 Get the total number of comments for tracks where `licensed = TRUE`.
  ```sql
SELECT SUM(comments) AS Total_comments FROM spotify
WHERE licensed = 'true';
```
 Find all tracks that belong to the album type `single`.
  ```sql
SELECT album_type,track FROM spotify
WHERE album_type ILIKE'single';
```
 Count the total number of tracks by each artist.
 ```sql
SELECT artist, COUNT(track) AS Total_songs FROM spotify
GROUP BY artist
ORDER BY 2 DESC;
```

 Calculate the average danceability of tracks in each album.
   ```sql
SELECT album, AVG(danceability) AS avg_danceability FROM spotify
GROUP BY 1
ORDER BY 2 DESC;
```
 Find the top 5 tracks with the highest energy values.
   ```sql
SELECT track, MAX(energy) FROM spotify
GROUP BY track
ORDER BY 2 DESC
LIMIT 5;
```
 List all tracks along with their views and likes where `official_video = TRUE`.
   ```sql
SELECT track, SUM(Views) AS Total_views,SUM(likes) AS Total_likes FROM spotify
WHERE official_video = 'true'
GROUP BY 1
ORDER BY 2;
```
 For each album, calculate the total views of all associated tracks.
   ```sql
SELECT album, track, SUM(Views) AS Total_views_on_album FROM spotify
GROUP BY 1, 2
ORDER BY 3 DESC;
```
Retrieve the track names that have been streamed on Spotify more than YouTube.
  ```sql
SELECT * FROM 
(SELECT track,
COALESCE(SUM(CASE WHEN most_played_on ='Youtube' THEN stream END),0) AS streamed_on_youtube,
COALESCE(SUM(CASE WHEN most_played_on ='Spotify' THEN stream END),0) AS streamed_on_spotify FROM spotify
GROUP BY 1) AS t1
WHERE streamed_on_spotify > streamed_on_youtube
AND streamed_on_youtube <>0;
```

 
 Find the top 3 most-viewed tracks for each artist using window functions.
  ```sql
WITH ranking_artist

AS

(SELECT artist,track, SUM(views) AS Total_view,
DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
FROM spotify
GROUP BY 1,2
ORDER BY 1,3 DESC)

SELECT * FROM ranking_artist
WHERE rank <=3;

```
 Write a query to find tracks where the liveness score is above the average.
   ```sql
SELECT AVG(liveness) FROM spotify; --0.19

SELECT track,artist,liveness FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify)
```
 **Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
```sql
WITH cte
AS
(SELECT 
album,
MAX(energy) AS highest_energy,
MIN(energy) AS lowest_energy
FROM spotify
GROUP BY 1)
SELECT album, highest_energy - lowest_energy AS energy_diff
FROM cte
ORDER BY 2 DESC;
```
   
 Find tracks where the energy-to-liveness ratio is greater than 1.2.
 ```sql
SELECT track,SUM(energy_liveness) FROM spotify
GROUP BY 1
HAVING SUM(energy_liveness) > 1.2;
```


## Technology Stack
- **Database**: PostgreSQL
- **SQL Queries**: DDL, DML, Aggregations, Joins, Subqueries, Window Functions
- **Tools**: pgAdmin 4 (or any SQL editor), PostgreSQL (via Homebrew, Docker, or direct installation)

## How to Run the Project
1. Install PostgreSQL and pgAdmin (if not already installed).
2. Set up the database schema and tables using the provided normalization structure.
3. Insert the sample data into the respective tables.
4. Execute SQL queries to solve the listed problems.
5. Explore query optimization techniques for large datasets.



