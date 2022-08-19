SELECT *
FROM app_store_apps

SELECT *
FROM play_store_apps

SELECT DISTINCT *
FROM app_store_apps as asa
INNER JOIN play_store_apps as psa
USING (name)
WHERE asa.rating = '5.0'
-- Apps used on both platforms 500


SELECT DISTINCT name, psa.install_count, psa.content_rating 
FROM app_store_apps as asa
INNER JOIN play_store_apps as psa
USING (name)
ORDER BY psa.install_count
-- Apps used on both platforms without duplicates


SELECT DISTINCT name, psa.install_count, psa.content_rating, asa.price, psa.genres, asa.rating
FROM app_store_apps as asa
INNER JOIN play_store_apps as psa
USING (name)
WHERE psa.content_rating = 'Everyone'
ORDER BY psa.install_count
LIMIT 3
-- Top 3 apps with no content rating and highest install count

-- "WhatsApp Messenger"	"1,000,000,000+"	"Everyone"
-- "Google Street View"	"1,000,000,000+"	"Everyone"
-- "Hangouts"	        "1,000,000,000+"	"Everyone"


SELECT DISTINCT name, psa.install_count, psa.content_rating, asa.price, psa.genres, asa.rating
FROM app_store_apps as asa
INNER JOIN play_store_apps as psa
USING (name)
WHERE psa.content_rating = 'Everyone'
ORDER BY psa.install_count
LIMIT 10



SELECT DISTINCT name, psa.install_count, asa.rating, asa.price,
CASE WHEN asa.price <= 1.00 THEN 10000  
WHEN asa.price > 1.00 THEN asa.price * 10000 END as purchase_price, 
CAST(asa.rating as NUMERIC) * 1000 * 12 as marketing_cost, 
CAST(asa.rating as NUMERIC) * 5000 * 12 as advertising_profit
FROM app_store_apps as asa
INNER JOIN play_store_apps as psa
USING (name) 
WHERE psa.content_rating = 'Everyone' 
ORDER BY psa. install_count
LIMIT 15



SELECT name as app, price, genres, install_count, rating, years_survived, CAST(app_purchase_price as money),
CAST(total_marketing_cost as money), CAST(advertising_profit as money),
CAST((advertising_profit - (app_purchase_price + total_marketing_cost)) as money) as net_income, 
CAST(ROUND((advertising_profit - (app_purchase_price + total_marketing_cost))/(12 * (CAST(rating as NUMERIC) * 2 + 1)),2) as money) as monthly_income
FROM
    (SELECT DISTINCT name, psa.install_count, asa.rating, asa.price, psa.category, psa.genres,
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



-- SELECT DISTINCT name, install_count, psa.review_count
-- FROM app_store_apps as asa
-- INNER JOIN play_store_apps as psa
-- USING (name, review_count)
-- ORDER BY review_count DESC


SELECT name as app, price, genres, install_count, rating, years_survived, CAST(app_purchase_price as money),
CAST(total_marketing_cost as money), CAST(advertising_profit as money),
CAST((advertising_profit - (app_purchase_price + total_marketing_cost)) as money) as net_income, 
CAST(ROUND((advertising_profit - (app_purchase_price + total_marketing_cost))/(12 * (CAST(rating as NUMERIC) * 2 + 1)),2) as money) as monthly_income
FROM
    (SELECT DISTINCT name, psa.install_count, asa.rating, asa.price, psa.category, psa.genres,
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


-- Simple Query
SELECT name as app, price, genres, install_count, rating, years_survived, CAST(app_purchase_price as money),
CAST(total_marketing_cost as money), CAST(advertising_profit as money),
CAST((advertising_profit - (app_purchase_price + total_marketing_cost)) as money) as net_income, 
CAST(ROUND((advertising_profit - (app_purchase_price + total_marketing_cost))/(12 * (CAST(rating as NUMERIC) * 2 + 1)),2) as money) as monthly_income
FROM
    (SELECT DISTINCT name, psa.install_count, asa.rating, asa.price, psa.category, psa.genres,
    (CAST(asa.rating as NUMERIC) * 2 + 1) as years_survived,
    CASE WHEN asa.price <= 1.00 THEN 10000  
    WHEN asa.price > 1.00 THEN asa.price * 10000 END as app_purchase_price, 
    (CAST(asa.rating as NUMERIC) * 2 + 1) * 1000 * 12 as total_marketing_cost, 
    (CAST(asa.rating as NUMERIC) * 2 + 1) * 5000 * 12 as advertising_profit
    FROM app_store_apps as asa
    INNER JOIN play_store_apps as psa
    USING (name)) as subq
ORDER BY monthly_income DESC

-- CTE

WITH subq AS (SELECT DISTINCT name, psa.install_count, asa.rating, asa.price, psa.category, psa.genres,
    (CAST(asa.rating as NUMERIC) * 2 + 1) as years_survived,
    CASE WHEN asa.price <= 1.00 THEN 10000  
    WHEN asa.price > 1.00 THEN asa.price * 10000 END as app_purchase_price, 
    (CAST(asa.rating as NUMERIC) * 2 + 1) * 1000 * 12 as total_marketing_cost, 
    (CAST(asa.rating as NUMERIC) * 2 + 1) * 5000 * 12 as advertising_profit
    FROM app_store_apps as asa
    INNER JOIN play_store_apps as psa
    USING (name)

SELECT name as app, price, genres, install_count, rating, years_survived, CAST(app_purchase_price as money),
CAST(total_marketing_cost as money), CAST(advertising_profit as money),
CAST((advertising_profit - (app_purchase_price + total_marketing_cost)) as money) as net_income, 
CAST(ROUND((advertising_profit - (app_purchase_price + total_marketing_cost))/(12 * (CAST(rating as NUMERIC) * 2 + 1)),2) as money) as monthly_income
FROM subq
ORDER BY monthly_income DESC