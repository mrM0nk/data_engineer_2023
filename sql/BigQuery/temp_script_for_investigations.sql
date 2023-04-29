SELECT card_id, title, price_primary, price_history, location, labels, comment, description, vehicle_history, scrap_date
FROM `paid-project-346208`.car_ads_ds_landing.`lnd_cars-com_card_300`
WHERE card_id IN 
(
'WA1GAAFY9N2020042',
'WAUDACF55NA023680',
'KM8R4DHE7NU454227'
)
ORDER BY 1


SELECT card_id, COUNT(*) as cnt
FROM `paid-project-346208`.car_ads_ds_landing.`lnd_cars-com_card_300`
GROUP BY 1
ORDER BY 2 DESC


SELECT card_id, title, price_primary, price_history, location, labels, comment, description, vehicle_history, scrap_date
FROM `paid-project-346208`.car_ads_ds_landing.`lnd_cars-com_card_300`



