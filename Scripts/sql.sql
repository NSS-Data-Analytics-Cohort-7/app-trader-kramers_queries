-- I made questions for myself so I could figure out how to run each query seperately:

--Show all app names that are duplicates
 
SELECT COUNT(name) AS name_count, name
FROM app_store_apps
FULL JOIN play_store_apps
USING (name)
GROUP BY name
ORDER BY name_count DESC 
 
--I don't remember the purpose of this. Probably verifying something. 
 
 SELECT DISTINCT(sub.name)
FROM 
(SELECT *
FROM app_store_apps
INNER JOIN play_store_apps
USING (name)) AS sub
        
-- returns 328 rows of app names
 
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



SELECT name, (years_projected_lifespan * 12 * 5000) AS total_advertising_profits, (years_projected_lifespan * 12 * 1000) AS marketing_costs
FROM 
  (SELECT asa.name, psa.rating, asa.rating, 
    CASE WHEN (rating =0) THEN 1
    WHEN (rating BETWEEN 0.3 AND 0.6) THEN 2
    WHEN (rating BETWEEN 0.7 AND 1.2) THEN 3
    WHEN (rating BETWEEN 1.3 AND 1.6) THEN 4
    WHEN (rating BETWEEN 1.7 AND 2.2) THEN 5
    WHEN (rating BETWEEN 2.3 AND 2.6) THEN 6
    WHEN (rating BETWEEN 2.7 AND 3.2) THEN 7
    WHEN (rating BETWEEN 3.3 AND 3.6) THEN 8
    WHEN (rating BETWEEN 3.7 AND 4.2) THEN 9
    WHEN (rating BETWEEN 4.3 AND 4.6) THEN 10
    WHEN (rating = 5) THEN 11
 ELSE 0 END AS years_projected_lifespan
 FROM app_store_apps AS asa
FULL JOIN play_store_apps AS psa
 USING (name, rating)
 ORDER BY years_projected_lifespan DESC) AS subquery

--Create a table that shows total marketing costs. Use the assumption app Trader will spend an average of $1000 per month to market an app _regardless_ of the price of the app. If App Trader owns rights to the app in both stores, it can market the app for both stores for a single cost of $1000 per month.  

SELECT name, (years_projected_lifespan * 12 * 1000) AS marketing_costs
FROM 
  (SELECT asa.name, psa.rating, asa.rating, 
    CASE WHEN (rating =0) THEN 1
    WHEN (rating BETWEEN 0.3 AND 0.6) THEN 2
    WHEN (rating BETWEEN 0.7 AND 1.2) THEN 3
    WHEN (rating BETWEEN 1.3 AND 1.6) THEN 4
    WHEN (rating BETWEEN 1.7 AND 2.2) THEN 5
    WHEN (rating BETWEEN 2.3 AND 2.6) THEN 6
    WHEN (rating BETWEEN 2.7 AND 3.2) THEN 7
    WHEN (rating BETWEEN 3.3 AND 3.6) THEN 8
    WHEN (rating BETWEEN 3.7 AND 4.2) THEN 9
    WHEN (rating BETWEEN 4.3 AND 4.6) THEN 10
    WHEN (rating = 5) THEN 11
 ELSE 0 END AS years_projected_lifespan
 FROM app_store_apps AS asa
FULL JOIN play_store_apps AS psa
 USING (name, rating)
 ORDER BY years_projected_lifespan DESC) AS subquery
 
--Create a table that shows projected lifespan of the app. Use the assumption that for every half point that an app gains in rating, its projected lifespan increases by one year, in other words, an app with a rating of 0 can be expected to be in use for 1 year, an app with a rating of 1.0 can be expected to last 3 years, and an app with a rating of 4.0 can be expected to last 9 years. Ratings should be rounded to the nearest 0.5 to evaluate an app's likely longevity.  

 
 SELECT CAST(years_projected_lifespan AS NUMERIC)
 FROM
 (SELECT name, rating, CASE WHEN (rating =0) THEN '1'
    WHEN (rating BETWEEN 0.3 AND 0.6) THEN '2'
    WHEN (rating BETWEEN 0.7 AND 1.2) THEN '3'
    WHEN (rating BETWEEN 1.3 AND 1.6) THEN '4'
    WHEN (rating BETWEEN 1.7 AND 2.2) THEN '5'
    WHEN (rating BETWEEN 2.3 AND 2.6) THEN '6'
    WHEN (rating BETWEEN 2.7 AND 3.2) THEN '7'
    WHEN (rating BETWEEN 3.3 AND 3.6) THEN '8'
    WHEN (rating BETWEEN 3.7 AND 4.2) THEN '9'
    WHEN (rating BETWEEN 4.3 AND 4.6) THEN '10'
    WHEN (rating = 5) THEN '11'
 ELSE '0' END AS years_projected_lifespan
 FROM play_store_apps
 ORDER BY years_projected_lifespan DESC) AS projected_lifespan
 
--  Couldn't figure out how to round to the nearest 0.5, so resulted in this CASE WHEN masterpiece. 
 
 SELECT asa.name, psa.rating, asa.rating, CASE WHEN (rating =0) THEN 1
    WHEN (rating BETWEEN 0.3 AND 0.6) THEN 2
    WHEN (rating BETWEEN 0.7 AND 1.2) THEN 3
    WHEN (rating BETWEEN 1.3 AND 1.6) THEN 4
    WHEN (rating BETWEEN 1.7 AND 2.2) THEN 5
    WHEN (rating BETWEEN 2.3 AND 2.6) THEN 6
    WHEN (rating BETWEEN 2.7 AND 3.2) THEN 7
    WHEN (rating BETWEEN 3.3 AND 3.6) THEN 8
    WHEN (rating BETWEEN 3.7 AND 4.2) THEN 9
    WHEN (rating BETWEEN 4.3 AND 4.6) THEN 10
    WHEN (rating = 5) THEN 11
 ELSE 0 END AS years_projected_lifespan
 FROM play_store_apps AS psa
LEFT JOIN app_store_apps AS asa 
 USING (name, rating)
 ORDER BY years_projected_lifespan DESC
 
-- Left join with play store on the left resulted in 10840 apps
 
  SELECT asa.name, psa.rating, asa.rating, CASE WHEN (rating =0) THEN 1
    WHEN (rating BETWEEN 0.3 AND 0.6) THEN 2
    WHEN (rating BETWEEN 0.7 AND 1.2) THEN 3
    WHEN (rating BETWEEN 1.3 AND 1.6) THEN 4
    WHEN (rating BETWEEN 1.7 AND 2.2) THEN 5
    WHEN (rating BETWEEN 2.3 AND 2.6) THEN 6
    WHEN (rating BETWEEN 2.7 AND 3.2) THEN 7
    WHEN (rating BETWEEN 3.3 AND 3.6) THEN 8
    WHEN (rating BETWEEN 3.7 AND 4.2) THEN 9
    WHEN (rating BETWEEN 4.3 AND 4.6) THEN 10
    WHEN (rating = 5) THEN 11
 ELSE 0 END AS years_projected_lifespan
 FROM app_store_apps AS asa
LEFT JOIN play_store_apps AS psa
 USING (name, rating)
 ORDER BY years_projected_lifespan DESC
 
-- Left join with app_store on the left resulted in 7245 apps

  SELECT asa.name, psa.rating, asa.rating, CASE WHEN (rating =0) THEN 1
    WHEN (rating BETWEEN 0.3 AND 0.6) THEN 2
    WHEN (rating BETWEEN 0.7 AND 1.2) THEN 3
    WHEN (rating BETWEEN 1.3 AND 1.6) THEN 4
    WHEN (rating BETWEEN 1.7 AND 2.2) THEN 5
    WHEN (rating BETWEEN 2.3 AND 2.6) THEN 6
    WHEN (rating BETWEEN 2.7 AND 3.2) THEN 7
    WHEN (rating BETWEEN 3.3 AND 3.6) THEN 8
    WHEN (rating BETWEEN 3.7 AND 4.2) THEN 9
    WHEN (rating BETWEEN 4.3 AND 4.6) THEN 10
    WHEN (rating = 5) THEN 11
 ELSE 0 END AS years_projected_lifespan
 FROM app_store_apps AS asa
FULL JOIN play_store_apps AS psa
 USING (name, rating)
 ORDER BY years_projected_lifespan DESC
 
-- Full join resulted in 17986 apps

-- Create a table that shows net overall profit (advertizing profit - (marketing costs + purchase price):

SELECT name, psa.price, asa.price, CASE WHEN (asa.price > 1.00) THEN asa.price * 10000 ELSE 10000 END AS purchase_price
 FROM app_store_apps AS asa
 INNER JOIN play_store_apps AS psa
 USING (name)
 ORDER BY purchase_price
 LIMIT 10;

SELECT name, asa_money, psa_money, (years_projected_lifespan * 12 * 5000) - (years_projected_lifespan * 12 * 1000) AS net_profit
FROM 
  (SELECT asa.name, psa.rating, asa.rating, CAST(CAST(asa.price AS money) AS NUMERIC) AS asa_money, CAST(CAST(psa.price AS MONEY) AS NUMERIC) AS psa_money,
    CASE WHEN (rating = 0) THEN 1
    WHEN (rating BETWEEN 0.3 AND 0.6) THEN 2
    WHEN (rating BETWEEN 0.7 AND 1.2) THEN 3
    WHEN (rating BETWEEN 1.3 AND 1.6) THEN 4
    WHEN (rating BETWEEN 1.7 AND 2.2) THEN 5
    WHEN (rating BETWEEN 2.3 AND 2.6) THEN 6
    WHEN (rating BETWEEN 2.7 AND 3.2) THEN 7
    WHEN (rating BETWEEN 3.3 AND 3.6) THEN 8
    WHEN (rating BETWEEN 3.7 AND 4.2) THEN 9
    WHEN (rating BETWEEN 4.3 AND 4.6) THEN 10
    WHEN (rating = 5) THEN 11
 ELSE 0 END AS years_projected_lifespan
 FROM app_store_apps AS asa
FULL JOIN play_store_apps AS psa
 USING (name, rating)
 ORDER BY years_projected_lifespan DESC) AS subquery
 
 SELECT CAST(CAST(price AS money) AS numeric)
 FROM play_store_apps
 
 SELECT CAST(CAST (price AS money) AS numeric)
 FROM app_store_apps


-- Create a table that shows prices of our top 10 apps from both the appstore and play store in order to make sure that the apps are all free. 
 
SELECT name, play_store_apps.price, app_store_apps.price
FROM play_store_apps
INNER JOIN app_store_apps
USING (name)
WHERE name LIKE 'Geometry Dash Lite'
ORDER BY name

SELECT name, play_store_apps.price, app_store_apps.price
FROM play_store_apps
INNER JOIN app_store_apps
USING (name)
WHERE name IN ('Geometry Dash Lite', 'ASOS', 'Domino's Pizza USA', 'PewDiePie?s Tuber Simulator', 
'Egg, Inc.', 'The Guardian', 'WhatsApp Messenger', 'Subway Surfers', 'Instagram', 'Candy Crush Saga'')
ORDER BY name

-- Having trouble finding the apps that have a single quotation mark inside their name. 


--Kevin's Code with review count added: 

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
