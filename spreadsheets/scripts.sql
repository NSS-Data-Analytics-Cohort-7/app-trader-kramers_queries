/*SELECT *
FROM play_store_apps*/

SELECT DISTINCT(a.name), p.genres AS genres
FROM play_store_apps AS p
INNER JOIN app_store_apps AS a
ON p.name = a.name
ORDER BY a.name 










