SELECT name, rating, review_count
FROM app_store_apps
WHERE review_count > '1000'
ORDER BY rating DESC

-- Content rating = age-appropriate rating

SELECT COUNT(DISTINCT(name)), rating
FROM app_store_apps
GROUP BY rating
ORDER BY rating DESC

-- App Store Apps
--492 app names have reviews of 5 stars
--2663 app names have reviews of 4.5 stars
--1626 app names have reviews of 4 stars


SELECT DISTINCT(sub.name)
FROM 
(SELECT *
FROM app_store_apps
INNER JOIN play_store_apps
USING (name)) AS sub
        
-- returns 328 rows of app names

SELECT COUNT(name) AS name_count, name
FROM app_store_apps
FULL JOIN play_store_apps
USING (name)
GROUP BY name
ORDER BY name_count DESC

--Shows all app names that are duplicates

SELECT DISTINCT(play.name), play.review_count, app.rating
FROM app_store_apps AS app
INNER JOIN play_store_apps AS play
USING (name)
WHERE app.rating >=4.5 AND play.review_count > 1000
ORDER BY app.rating, play.review_count DESC



SELECT DISTINCT(play.name), play.review_count, app.rating
FROM app_store_apps AS app
INNER JOIN play_store_apps AS play
USING (name)
WHERE app.rating =5 AND play.review_count > 1000
ORDER BY app.rating, play.review_count DESC

--Returns the top 7 apps with over 1000 reviews and 5 star ratings

SELECT *
FROM play_store_apps