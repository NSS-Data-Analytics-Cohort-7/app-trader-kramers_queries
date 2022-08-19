Select *
From app_store_apps;

Select name, price, rating
from app_store_apps;

Select name, a.price, p.price, rating
From app_store_apps AS A
Inner JOIN play_store_apps ON

SELECT name as app, price, genres, install_count, rating, review_count, years_survived, CAST(app_purchase_price as money),
CAST(total_marketing_cost as money), CAST(advertising_profit as money),
CAST((advertising_profit - (app_purchase_price + total_marketing_cost)) as money) as net_income,
CAST(ROUND((advertising_profit - (app_purchase_price + total_marketing_cost))/(12 * (CAST(rating as NUMERIC) * 2 + 1)),2) as money) as monthly_income
FROM (SELECT DISTINCT name, psa.install_count, asa.rating, psa.review_count, asa.price, psa.category, psa.genres,
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
LIMIT 15