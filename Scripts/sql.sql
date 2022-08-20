

SELECT name, play_store_apps.price, app_store_apps.price
FROM play_store_apps
INNER JOIN app_store_apps
USING (name)
ORDER BY play_store_apps.price DESC, app_store_apps.price


SELECT name
FROM subquery

SELECT name, play_store_apps.price, app_store_apps.price
FROM play_store_apps
INNER JOIN app_store_apps
USING (name)
WHERE name LIKE 'Geometry Dash Lite'
ORDER BY name


Create a table that shows prices of our top 10 apps from both the appstore and play store in order to make sure that the apps are all free. 

SELECT name, play_store_apps.price, app_store_apps.price
FROM play_store_apps
INNER JOIN app_store_apps
USING (name)
WHERE name IN ('Geometry Dash Lite', 'ASOS', 'Domino?s Pizza USA', 'PewDiePie?s Tuber Simulator', 
'Egg, Inc.', 'The Guardian', 'WhatsApp Messenger', 'Subway Surfers', 'Instagram', 'Candy Crush Saga')
ORDER BY name






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







--Kevin's Code: 

SELECT name as app, price, genres, install_count,rating, years_survived, CAST(app_purchase_price as money), review_count,
CAST(total_marketing_cost as money), CAST(advertising_profit as money),
CAST((advertising_profit - (app_purchase_price + total_marketing_cost)) as money) as net_income,
CAST(ROUND((advertising_profit - (app_purchase_price + total_marketing_cost))/(12 * (CAST(rating as NUMERIC) * 2 + 1)),2) as money) as monthly_income
FROM
(SELECT DISTINCT name, psa.install_count, asa.rating, asa.price, psa.category, psa.genres, psa.review_count,
    (CAST(asa.rating as NUMERIC) * 2 + 1) as years_survived,
    CASE WHEN asa.price <= 1.00 THEN 10000
    WHEN asa.price > 1.00 THEN asa.price * 10000 END as app_purchase_price,
    (CAST(asa.rating as NUMERIC) * 2 + 1) * 1000 * 12 as total_marketing_cost,
    (CAST(asa.rating as NUMERIC) * 2 + 1) * 5000 * 12 as advertising_profit
    FROM app_store_apps as asa
    INNER JOIN play_store_apps as psa
    USING (name)
    WHERE psa.content_rating = 'Everyone') as subq
ORDER BY monthly_income DESC
LIMIT 10

-- "Egg, Inc."
-- "Geometry Dash Lite"
-- "Domino's Pizza USA"
-- "ASOS"
-- "My Talking Tom"
-- "Disney Crossy Road"
-- "Trivia Crack"
-- "Fishdom"
-- "WGT Golf Game by Topgolf"
-- "Dude Perfect 2"

SELECT name as app, price, genres, install_count,rating, years_survived, CAST(app_purchase_price as money), review_count,
CAST(total_marketing_cost as money), CAST(advertising_profit as money),
CAST((advertising_profit - (app_purchase_price + total_marketing_cost)) as money) as net_income,
CAST(ROUND((advertising_profit - (app_purchase_price + total_marketing_cost))/(12 * (CAST(rating as NUMERIC) * 2 + 1)),2) as money) as monthly_income
FROM
(SELECT DISTINCT name, psa.install_count, asa.rating, asa.price, psa.category, psa.genres, psa.review_count,
    (CAST(asa.rating as NUMERIC) * 2 + 1) as years_survived,
    CASE WHEN asa.price <= 1.00 THEN 10000
    WHEN asa.price > 1.00 THEN asa.price * 10000 END as app_purchase_price,
    (CAST(asa.rating as NUMERIC) * 2 + 1) * 1000 * 12 as total_marketing_cost,
    (CAST(asa.rating as NUMERIC) * 2 + 1) * 5000 * 12 as advertising_profit
    FROM app_store_apps as asa
    INNER JOIN play_store_apps as psa
    USING (name)
    WHERE psa.content_rating = 'Everyone') as subq
ORDER BY monthly_income DESC
LIMIT 30



SELECT name as app, price, genres, install_count,rating, years_survived, CAST(app_purchase_price as money), review_count,
CAST(total_marketing_cost as money), CAST(advertising_profit as money),
CAST((advertising_profit - (app_purchase_price + total_marketing_cost)) as money) as net_income,
CAST(ROUND((advertising_profit - (app_purchase_price + total_marketing_cost))/(12 * (CAST(rating as NUMERIC) * 2 + 1)),2) as money) as monthly_income
FROM
(SELECT DISTINCT asa.name, psa.install_count, asa.rating, asa.price, psa.category, psa.genres, psa.review_count,
    ((CAST(asa.rating as NUMERIC) * 2 + 1) as years_survived,
    CASE WHEN asa.price <= 1.00 THEN 10000
    WHEN asa.price > 1.00 THEN asa.price * 10000 END as app_purchase_price,
    (CAST(asa.rating as NUMERIC) * 2 + 1) * 1000 * 12 as total_marketing_cost,
    (CAST(asa.rating as NUMERIC) * 2 + 1) * 5000 * 12 as advertising_profit
    FROM app_store_apps as asa
    INNER JOIN play_store_apps as psa
    ON psa.name = asa.name) as subq
ORDER BY monthly_income DESC
LIMIT 10



SELECT name, play_store_apps.price, app_store_apps.price
FROM play_store_apps
INNER JOIN app_store_apps
USING (name)
WHERE name LIKE 'Geometry Dash Lite'
ORDER BY name

--  START HERE. All above is gibberish. 
 
 
-- I made questions for myself so I could figure out how to run each query seperately:

-- Create a table that shows the app name, review count, and app rating to show which apps have over 1000 reviews and ratings of 5 stars. 
 
 SELECT DISTINCT(play.name), play.review_count, app.rating
FROM app_store_apps AS app
INNER JOIN play_store_apps AS play
USING (name)
WHERE app.rating =5 AND play.review_count > 1000
ORDER BY app.rating, play.review_count DESC
 
 --Create a table that shows the number of app per 1/2 star rating. 

SELECT COUNT(DISTINCT(name)), rating
FROM app_store_apps
GROUP BY rating
ORDER BY rating DESC
 
--Create a table that shows the app name, purchase price of each app from apps in Play Store Table and App Store Table. Use the assumption that each app $1 and under costs App Trader $10,000 and all other apps cost 10000 times the purchase price. 
 
SELECT name, psa.price, asa.price, CASE WHEN (asa.price > 1.00) THEN asa.price * 10000 ELSE 10000 END AS purchase_price
 FROM app_store_apps AS asa
 INNER JOIN play_store_apps AS psa
 USING (name)
 ORDER BY purchase_price
 LIMIT 10;


--Create a table that shows the app name and total advertising profits. Use the assumption that apps earn $5000 per month on average from in-app advertising and in-app purchases _regardless_ of the price of the app. 

--Create a table that shows total marketing costs. Use the assumption app Trader will spend an average of $1000 per month to market an app _regardless_ of the price of the app. If App Trader owns rights to the app in both stores, it can market the app for both stores for a single cost of $1000 per month.  

 
--Create a table that shows projected lifespan of the app. Use the assumption that for every half point that an app gains in rating, its projected lifespan increases by one year, in other words, an app with a rating of 0 can be expected to be in use for 1 year, an app with a rating of 1.0 can be expected to last 3 years, and an app with a rating of 4.0 can be expected to last 9 years. Ratings should be rounded to the nearest 0.5 to evaluate an app's likely longevity.  



-- Kevin's Final Code with top 20 so we can compare taking review_counts into account: 
 
SELECT DISTINCT name as app, CAST((advertising_profit - (app_purchase_price + total_marketing_cost)) as money) as net_income,
CAST(ROUND((advertising_profit - (app_purchase_price + total_marketing_cost))/(12 * (CAST(rating as NUMERIC) * 2 + 1)),2) as money) as monthly_income, 
ROUND(CAST(REPLACE(REPLACE(install_count,',',''),'+','') as NUMERIC)/1000000,0) as users_by_million, content_rating, review_count, price, rating, years_survived, 
CAST(app_purchase_price as money),
CAST(total_marketing_cost as money), CAST(advertising_profit as money)
FROM
(SELECT DISTINCT name, psa.install_count, asa.rating, asa.price, psa.category, asa.review_count, psa.genres, psa.content_rating,
    (CAST(asa.rating as NUMERIC) * 2 + 1) as years_survived,
    CASE WHEN asa.price <= 1.00 THEN 10000  
    WHEN asa.price > 1.00 THEN asa.price * 10000 END as app_purchase_price, 
    (CAST(asa.rating as NUMERIC) * 2 + 1) * 1000 * 12 as total_marketing_cost, 
    (CAST(asa.rating as NUMERIC) * 2 + 1) * 5000 * 12 as advertising_profit
    FROM app_store_apps as asa
    INNER JOIN play_store_apps as psa
    USING (name)) as subq
ORDER BY monthly_income DESC, users_by_million DESC, content_rating, review_count DESC
LIMIT 20
 
-- Kevin's Code without limit. I did this so I can copy it into Excel and look at the distribution of monthly income across all apps.
 
SELECT DISTINCT name as app, CAST((advertising_profit - (app_purchase_price + total_marketing_cost)) as money) as net_income,
CAST(ROUND((advertising_profit - (app_purchase_price + total_marketing_cost))/(12 * (CAST(rating as NUMERIC) * 2 + 1)),2) as money) as monthly_income, 
ROUND(CAST(REPLACE(REPLACE(install_count,',',''),'+','') as NUMERIC)/1000000,0) as users_by_million, content_rating, review_count, price, rating, years_survived, 
CAST(app_purchase_price as money),
CAST(total_marketing_cost as money), CAST(advertising_profit as money)
FROM
(SELECT DISTINCT name, psa.install_count, asa.rating, asa.price, psa.category, asa.review_count, psa.genres, psa.content_rating,
    (CAST(asa.rating as NUMERIC) * 2 + 1) as years_survived,
    CASE WHEN asa.price <= 1.00 THEN 10000  
    WHEN asa.price > 1.00 THEN asa.price * 10000 END as app_purchase_price, 
    (CAST(asa.rating as NUMERIC) * 2 + 1) * 1000 * 12 as total_marketing_cost, 
    (CAST(asa.rating as NUMERIC) * 2 + 1) * 5000 * 12 as advertising_profit
    FROM app_store_apps as asa
    INNER JOIN play_store_apps as psa
    USING (name)) as subq
ORDER BY monthly_income DESC, users_by_million DESC, content_rating, review_count DESC




