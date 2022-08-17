Select *
From play_store_apps;

Select *
from play_store_apps
Where type = 'Paid';

Select name, price
from app_store_apps
Where price >= 5.99;

Select p.name, a.price, p.install_count, p.rating
from play_store_apps AS p
Inner Join app_store_apps AS a
On p.name = a.name;

Select DISTINCT(p.name), a.price, p.install_count, p.rating, p.genres, p.content_rating
from play_store_apps AS p
Inner Join app_store_apps AS a
On p.name = a.name;

Select DISTINCT(p.name), a.price, p.install_count, p.rating, p.genres, p.content_rating
from play_store_apps AS p
Inner Join app_store_apps AS a
On p.name = a.name
WHERE a.price > '4.99';

