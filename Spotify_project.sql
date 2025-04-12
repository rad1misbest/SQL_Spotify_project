-- SQL spotify project
-- CREATING SPOTIFY TABLE
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
Artist VARCHAR(300),
Track VARCHAR (300),
Album VARCHAR(300),
Album_type VARCHAR(50),
Danceability FLOAT,
Energy FLOAT,
Loudness FLOAT,
Speechiness FLOAT,
Acousticness FLOAT,
Instrumentalness FLOAT,
Liveness FLOAT,
Valence	FLOAT,
Tempo FLOAT,
Duration_min FLOAT,
Title VARCHAR(400),
Channel VARCHAR(100),
Views FLOAT,
Likes BIGINT,
Comments BIGINT,
Licensed BOOLEAN,
official_video BOOLEAN,
Stream INT,
Energy_Liveness FLOAT,
most_played_on VARCHAR (50)

);
ALTER TABLE spotify
ALTER column Likes TYPE FLOAT;

ALTER TABLE spotify
ALTER column Comments TYPE FLOAT;

ALTER TABLE spotify
ALTER column Stream TYPE FLOAT;

ALTER TABLE spotify
ADD COLUMN energy_liveness FLOAT


--Data Exploration
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

-- DATA ANALYSIS


--1.Retrieve the names of all tracks that have more than 1 billion streams.
SELECT * FROM spotify
WHERE stream > 1000000000;

--2.List all albums along with their respective artists.
SELECT DISTINCT album,artist FROM spotify
ORDER BY 1;




--3.Get the total number of comments for tracks where licensed = TRUE.

SELECT SUM(comments) AS Total_comments FROM spotify
WHERE licensed = 'true';


--4.Find all tracks that belong to the album type single.

SELECT album_type,track FROM spotify
WHERE album_type ILIKE'single';



--5.Count the total number of tracks by each artist
SELECT artist, COUNT(track) AS Total_songs FROM spotify
GROUP BY artist
ORDER BY 2 DESC;


--6.Calculate the average danceability of tracks in each album.
SELECT album, AVG(danceability) AS avg_danceability FROM spotify
GROUP BY 1
ORDER BY 2 DESC;

--7.Find the top 5 tracks with the highest energy values.
SELECT track, MAX(energy) FROM spotify
GROUP BY track
ORDER BY 2 DESC
LIMIT 5;


--8.List all tracks along with their views and likes where official_video = TRUE.
SELECT track, SUM(Views) AS Total_views,SUM(likes) AS Total_likes FROM spotify
WHERE official_video = 'true'
GROUP BY 1
ORDER BY 2;

--9.For each album, calculate the total views of all associated tracks.
SELECT album, track, SUM(Views) AS Total_views_on_album FROM spotify
GROUP BY 1, 2
ORDER BY 3 DESC;

--10.Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT * FROM 
(SELECT track,
COALESCE(SUM(CASE WHEN most_played_on ='Youtube' THEN stream END),0) AS streamed_on_youtube,
COALESCE(SUM(CASE WHEN most_played_on ='Spotify' THEN stream END),0) AS streamed_on_spotify FROM spotify
GROUP BY 1) AS t1
WHERE streamed_on_spotify > streamed_on_youtube
AND streamed_on_youtube <>0;


--11.Find the top 3 most-viewed tracks for each artist using window functions.
WITH ranking_artist

AS

(SELECT artist,track, SUM(views) AS Total_view,
DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
FROM spotify
GROUP BY 1,2
ORDER BY 1,3 DESC)

SELECT * FROM ranking_artist
WHERE rank <=3;

--12. Write a query to find tracks where the liveness score is above the average.
SELECT AVG(liveness) FROM spotify; --0.19

SELECT track,artist,liveness FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify)


--13.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
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


--14.Find tracks where the energy-to-liveness ratio is greater than 1.2.
SELECT track,SUM(energy_liveness) FROM spotify
GROUP BY 1
HAVING SUM(energy_liveness) > 1.2;
















