-- ### App Trader

-- Your team has been hired by a new company called App Trader to help them explore and gain insights from apps that are made available through the Apple App Store and Android Play Store. App Trader is a broker that purchases the rights to apps from developers in order to market the apps and offer in-app purchase. App developers retain **all** money from users purchasing the app, and they retain _half_ of the money made from in-app purchases. App Trader will be solely responsible for marketing apps they purchase rights to.  

-- Unfortunately, the data for Apple App Store apps and Android Play Store Apps is located in separate tables with no referential integrity.

-- #### 2. Assumptions
-- Based on research completed prior to launching App Trader as a company, you can assume the following:  

-- a. App Trader will purchase apps for 10,000 times the price of the app. For apps that are priced from free up to $1.00, the purchase price is $10,000.  

-- b. Apps earn $5000 per month on average from in-app advertising and in-app purchases _regardless_ of the price of the app.  

-- c. App Trader will spend an average of $1000 per month to market an app _regardless_ of the price of the app. If App Trader owns rights to the app in both stores, it can market the app for both stores for a single cost of $1000 per month.  

-- d. For every half point that an app gains in rating, its projected lifespan increases by one year, in other words, an app with a rating of 0 can be expected to be in use for 1 year, an app with a rating of 1.0 can be expected to last 3 years, and an app with a rating of 4.0 can be expected to last 9 years. Ratings should be rounded to the nearest 0.5 to evaluate an app's likely longevity.  

-- e. App Trader would prefer to work with apps that are available in both the App Store and the Play Store since they can market both for the same $1000 per month. 

-- #### 3. Deliverables
-- a. Develop some general recommendations as to the price range, genre, content rating, or anything else for apps that the company should target.  

-- b. Develop a Top 10 List of the apps that App Trader should buy next week for its **Fourth of July** debut.  

-- c. Prepare a 5-10 minute presentation for the leadership team of App Trader to inform them of your recommendations.



-- ### All analysis work must be done in PostgreSQL, however you may export query results if you want to create charts in Excel for your presentations.

-- Becca suggestion - 
-- SELECT asa.name, psa.name, CAST(asa.price as money) AS appstore_cost, CAST(psa.price as money) AS playstore_cost
-- FROM app_store_apps AS asa
-- INNER JOIN play_store_apps AS psa
-- USING(name)
-- WHERE psa.price <> asa.price;

-- ^ work in progress.


-- credit to Kevin for the below 

-- SELECT name as app, price, genres, install_count, rating, years_survived, CAST(app_purchase_price as money),
-- CAST(total_marketing_cost as money), CAST(advertising_profit as money),
-- CAST((advertising_profit - (app_purchase_price + total_marketing_cost)) as money) as net_income, 
-- CAST(ROUND((advertising_profit - (app_purchase_price + total_marketing_cost))/(12 * (CAST(rating as NUMERIC) * 2 + 1)),2) as money) as monthly_income
-- FROM
-- (SELECT DISTINCT name, psa.install_count, asa.rating, asa.price, psa.category, psa.genres,
--     (CAST(asa.rating as NUMERIC) * 2 + 1) as years_survived,
--     CASE WHEN asa.price <= 1.00 THEN 10000  
--     WHEN asa.price > 1.00 THEN asa.price * 10000 END as app_purchase_price, 
--     (CAST(asa.rating as NUMERIC) * 2 + 1) * 1000 * 12 as total_marketing_cost, 
--     (CAST(asa.rating as NUMERIC) * 2 + 1) * 5000 * 12 as advertising_profit
--     FROM app_store_apps as asa
--     INNER JOIN play_store_apps as psa
--     USING (name) 
--     WHERE psa.content_rating = 'Everyone') as subq
-- ORDER BY monthly_income DESC
-- LIMIT 10


-- SELECT name as app, price, genres, install_count, rating, years_survived, CAST(app_purchase_price as money),
-- CAST(total_marketing_cost as money), CAST(advertising_profit as money),
-- CAST((advertising_profit - (app_purchase_price + total_marketing_cost)) as money) as net_income, 
-- CAST(ROUND((advertising_profit - (app_purchase_price + total_marketing_cost))/(12 * (CAST(rating as NUMERIC) * 2 + 1)),2) as money) as monthly_income
-- FROM
-- (SELECT DISTINCT name, psa.install_count, asa.rating, asa.price, psa.category, psa.genres,
--     (CAST(asa.rating as NUMERIC) * 2 + 1) as years_survived,
--     CASE WHEN asa.price <= 1.00 THEN 10000  
--     WHEN asa.price > 1.00 THEN asa.price * 10000 END as app_purchase_price, 
--     (CAST(asa.rating as NUMERIC) * 2 + 1) * 1000 * 12 as total_marketing_cost, 
--     (CAST(asa.rating as NUMERIC) * 2 + 1) * 5000 * 12 as advertising_profit
--     FROM app_store_apps as asa
--     INNER JOIN play_store_apps as psa
--     USING (name) 
--     WHERE psa.content_rating = 'Everyone') as subq
-- ORDER BY monthly_income DESC
-- LIMIT 30;


-- exploratory - 

-- SELECT DISTINCT(category)
-- FROM play_store_apps; -- 33


-- SELECT DISTINCT(primary_genre)
-- FROM app_store_apps; -- 23


-- SELECT MAX(CAST(price as money))
-- FROM app_store_apps; -- $299.99


-- SELECT MAX(CAST(price as money))
-- FROM play_store_apps; -- $400


-- SELECT name, CAST(review_count as integer)
-- FROM app_store_apps
-- ORDER BY review_count DESC; -- Facebook 2,974,676, Insta 2,161,558, Clash of Clans 2,130,805


-- SELECT name, review_count
-- FROM play_store_apps
-- GROUP BY name, review_count
-- ORDER BY review_count DESC; -- Facebook 78,158,306, WhatsApp 69,119,316, Insta 66,577,446


-- SELECT DISTINCT(name), rating, review_count, primary_genre
-- FROM app_store_apps
-- WHERE 
-- ORDER BY rating DESC
-- LIMIT 20;

-- FINAL PRODUCT BELOW --

SELECT DISTINCT name as app, CAST((advertising_profit - (app_purchase_price + total_marketing_cost)) as money) as net_income, genres, 
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
LIMIT 10
