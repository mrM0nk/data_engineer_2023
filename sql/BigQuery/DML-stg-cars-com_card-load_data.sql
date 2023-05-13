SELECT 
card_id,
REGEXP_EXTRACT(title, r'(\S+)', 1, 2) AS brand,
LEFT(REGEXP_REPLACE(title, r'^(\S+) (\S+) ', ''), 100) AS model,
--title,
price_primary, 
price_history, 
REGEXP_REPLACE(location, r',[^,]*$', '') AS adress,
LEFT(TRIM(REGEXP_EXTRACT(location, r'[^,]+', 1, 2)), 2) AS state,
RIGHT(TRIM(REGEXP_EXTRACT(location, r'[^,]+', 1, 2)), 5) AS zip_code,
--location,
REPLACE(REGEXP_EXTRACT(labels, r'VIN: [0-9a-zA-Z]+'), 'VIN: ', '') AS vin_num,
CASE WHEN REGEXP_CONTAINS(UPPER(labels), r'HOME DELIVERY') THEN 'Y' ELSE 'N' END AS home_delivery_flag,
CASE WHEN REGEXP_CONTAINS(UPPER(labels), r'VIRTUAL APPOINTMENTS') THEN 'Y' ELSE 'N' END AS virtual_appointments_flag,
--labels, 
comment,
REGEXP_EXTRACT(description, r'^\d{4}') AS `year`,
CASE WHEN REGEXP_CONTAINS(UPPER(split(description, ', ')[1]), r'CVT') THEN 'CVT'
     WHEN REGEXP_CONTAINS(UPPER(split(description, ', ')[1]), r'AUTO') THEN 'Automatic'
     ELSE NULL 
END AS transmission_type, 
split(description, ', ')[1] AS transmission_details,
CAST(REPLACE(TRIM(REGEXP_EXTRACT(split(description, ', ')[2], r'(\d.\dL|\dL)')), 'L', '') AS NUMERIC) * 1000 AS engine,
split(description, ', ')[2] AS engine_details,
REGEXP_EXTRACT(split(description, ', ')[3], r'^\S+') AS fuel,
REPLACE(TRIM(REGEXP_EXTRACT(split(description, ', ')[3], r'[(](.+)[mpg)]')), ' mpg', '') AS mpg,
SAFE_CAST(REGEXP_REPLACE(REGEXP_EXTRACT(description, r'(\d+(?:\.\d+)?)\s*mi'), r'[^0-9]+', '') AS INT64) AS mileage,
CASE WHEN REGEXP_CONTAINS(REGEXP_EXTRACT(description, r'(\d+(?:\.\d+)?\s*mi)'), r'mi') THEN 'mile' ELSE NULL END AS mileage_type, 
split(split(description, '|')[1], ',')[0] as body,
split(split(description, '|')[1], ',')[1] as drive_type,
split(split(description, '|')[1], ',')[2] as color,
--description, 
vehicle_history, 
scrap_date
FROM `paid-project-346208`.car_ads_ds_landing.`lnd_cars-com_card_300`
ORDER BY card_id


