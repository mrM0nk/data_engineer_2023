CREATE OR REPLACE PROCEDURE `paid-project-346208`.car_ads_ds_staging.usp_stg1_cars_com_card_direct_tokenized_full_reload_Maksym()
BEGIN 
	
	DECLARE inserted_task_id INT64;
	DECLARE task_id INT64;
	
	CALL `paid-project-346208`.meta_ds.usp_write_log_Maksym(null, 'usp_stg1_cars_com_card_direct_tokenized_full_reload_Maksym', 'Started', inserted_task_id);

	SET task_id = inserted_task_id;
 

	TRUNCATE TABLE `paid-project-346208`.car_ads_ds_staging.stg1_cars_com_card_direct_300_Maksym;
	
	INSERT INTO `paid-project-346208`.car_ads_ds_staging.stg1_cars_com_card_direct_300_Maksym 
	   (row_id, 
		card_id, 
		brand, 
		model, 
		price_primary, 
		price_history, 
		adress, 
		state, 
		zip_code, 
		vin_num, 
		home_delivery_flag, 
		virtual_appointments_flag, 
		comment, 
		`year`, 
		transmission_type, 
		transmission_details, 
		engine, 
		engine_details, 
		fuel, 
		mpg, 
		mileage, 
		mileage_type, 
		body, 
		drive_type, 
		color, 
		vehicle_history, 
		scrap_date, 
		input_file_name, 
		dl_loaded_date, 
		stg1_loaded_date, 
		row_hash) 
	SELECT 
		GENERATE_UUID() AS row_id,
		card_id,
		REGEXP_EXTRACT(title, r'(\S+)', 1, 2) AS brand,
		LEFT(REGEXP_REPLACE(title, r'^(\S+) (\S+) ', ''), 100) AS model,
		CAST(REGEXP_REPLACE(price_primary, r'[^0-9]+', '') AS INT64) AS price_primary, 
		price_history, 
		REGEXP_REPLACE(location, r',[^,]*$', '') AS adress,
		LEFT(TRIM(REGEXP_EXTRACT(location, r'[^,]+', 1, 2)), 2) AS state,
		RIGHT(TRIM(REGEXP_EXTRACT(location, r'[^,]+', 1, 2)), 5) AS zip_code,
		REPLACE(REGEXP_EXTRACT(labels, r'VIN: [0-9a-zA-Z]+'), 'VIN: ', '') AS vin_num,
		CASE WHEN REGEXP_CONTAINS(UPPER(labels), r'HOME DELIVERY') THEN 'Y' ELSE 'N' END AS home_delivery_flag,
		CASE WHEN REGEXP_CONTAINS(UPPER(labels), r'VIRTUAL APPOINTMENTS') THEN 'Y' ELSE 'N' END AS virtual_appointments_flag,
		comment,
		CAST(REGEXP_EXTRACT(description, r'^\d{4}') AS INT64) AS `year`,
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
		vehicle_history, 
		scrap_date,
		input_file_name,
		dl_loaded_date,
		CURRENT_TIMESTAMP() as stg1_loaded_date,
		SHA256(CONCAT(
					IFNULL(card_id, ''),
					IFNULL(title, ''),
					IFNULL(price_primary, ''),
					IFNULL(price_history, ''),
					IFNULL(location, ''),
					IFNULL(labels, ''),
					IFNULL(comment, ''),
					IFNULL(description, ''),
					IFNULL(vehicle_history, '')
					)) as row_hash
	FROM `paid-project-346208`.car_ads_ds_landing.cars_com_card_direct_300_Maksym;
	

	CALL `paid-project-346208`.meta_ds.usp_write_log_Maksym(task_id, 'usp_stg1_cars_com_card_direct_tokenized_full_reload_Maksym', 'Succeed', inserted_task_id);

END;