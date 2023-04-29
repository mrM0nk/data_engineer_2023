INSERT INTO `paid-project-346208`.car_ads_ds_landing.`lnd_cars-com_card_300`
(card_id, title, price_primary, price_history, location, labels, comment, description, vehicle_history, scrap_date)
SELECT card_id, title, price_primary, price_history, location, labels, comment, description, vehicle_history, scrap_date
FROM (
	SELECT card_id, title, price_primary, price_history, location, labels, comment, description, vehicle_history, scrap_date, 1 as ord
	FROM `paid-project-346208`.car_ads_ds_landing.`lnd_cars-com_card` 
	WHERE card_id IN
					(SELECT card_id 
						FROM (
								SELECT card_id, COUNT(*)
								FROM `paid-project-346208`.car_ads_ds_landing.`lnd_cars-com_card`
								GROUP BY 1
								ORDER BY 2 DESC
								LIMIT 10) t1
					)
	UNION ALL 
	SELECT card_id, title, price_primary, price_history, location, labels, comment, description, vehicle_history, scrap_date, 2 as ord
	FROM `paid-project-346208`.car_ads_ds_landing.`lnd_cars-com_card` 
	WHERE price_history IS NOT NULL and location IS NOT NULL and vehicle_history IS NOT NULL
	ORDER BY ord ASC
	) t
LIMIT 300;
