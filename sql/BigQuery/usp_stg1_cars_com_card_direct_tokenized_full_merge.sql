CREATE OR REPLACE PROCEDURE `paid-project-346208`.car_ads_ds_staging.usp_stg1_cars_com_card_direct_tokenized_full_merge()
BEGIN 
	
	
	
	DECLARE process_id STRING;
	--DECLARE truncated_row_cound INT64;
	DECLARE inserted_row_count INT64;
	DECLARE processed_row_count INT64;
	DECLARE updated_row_count INT64;
	--DECLARE message STRING;
	DECLARE metrics STRUCT <truncated INT64, inserted INT64, updated INT64, mark_as_deleted INT64, message STRING>;



	CALL `paid-project-346208`.meta_ds.usp_write_process_log ('START', process_id, 'usp_stg1_cars_com_card_direct_tokenized_full_merge', NULL);

	CALL `paid-project-346208`.meta_ds.usp_write_event_log(process_id, 'usp_stg1_cars_com_card_direct_tokenized_full_merge', 'start');
	---------------------------------------------------------------------------------------------------------------------------------------------


	CALL `paid-project-346208`.meta_ds.usp_write_event_log(process_id, 'create table wo duplicates lnd_cars_com_wo_duplicates', 'start');

	CREATE TEMP TABLE IF NOT EXISTS lnd_cars_com_wo_duplicates (
		gallery ARRAY<STRING>,
		card_id STRING,
		url STRING,
		title STRING,
		price_primary STRING,
		price_history STRING,
		options ARRAY<STRUCT<category STRING, items ARRAY<STRING>>>,
		vehicle_history STRING,
		comment STRING,
		location STRING,
		labels STRING,
		description STRING,
		scrap_date TIMESTAMP,
		input_file_name STRING NOT NULL,
		source_id STRING NOT NULL,
		modified_date TIMESTAMP NOT NULL,
		row_hash BYTES);
	
	TRUNCATE TABLE lnd_cars_com_wo_duplicates;

	CALL `paid-project-346208`.meta_ds.usp_write_event_log(process_id, 'create table wo duplicates lnd_cars_com_wo_duplicates', 'end');
	---------------------------------------------------------------------------------------------------------------------------------------------


	CALL `paid-project-346208`.meta_ds.usp_write_event_log(process_id, 'load data wo duplicates into lnd_cars_com_wo_duplicates', 'start');

	SET processed_row_count = (SELECT COUNT(*) FROM `paid-project-346208`.car_ads_ds_landing.cars_com_card_direct_300_Maksym);
	
	INSERT INTO lnd_cars_com_wo_duplicates(
		gallery, 
		card_id, 
		url, 
		title, 
		price_primary, 
		price_history, 
		`options`, 
		vehicle_history, 
		comment, 
		location, 
		labels, 
		description, 
		scrap_date, 
		input_file_name, 
		source_id, 
		modified_date,
		row_hash)
	WITH hashed_data AS (SELECT
		gallery, 
		card_id, 
		url, 
		title, 
		price_primary, 
		price_history, 
		`options`, 
		vehicle_history, 
		comment, 
		location, 
		labels, 
		description, 
		scrap_date, 
		input_file_name, 
		source_id, 
		SHA256(CONCAT(
					IFNULL(card_id, ''),
					IFNULL(title, ''),
					IFNULL(price_primary, ''),
					IFNULL(price_history, ''),
					IFNULL(vehicle_history, ''),
					IFNULL(comment, ''),
					IFNULL(location, ''),
					IFNULL(labels, ''),
					IFNULL(description, '')
					)) as row_hash
		FROM `paid-project-346208`.car_ads_ds_landing.cars_com_card_direct_300_Maksym
		),
	ordered_data as (SELECT 
		gallery, 
		card_id, 
		url, 
		title, 
		price_primary, 
		price_history, 
		`options`, 
		vehicle_history, 
		comment, 
		location, 
		labels, 
		description, 
		scrap_date, 
		input_file_name, 
		source_id, 
		row_hash,
		ROW_NUMBER () OVER(PARTITION BY row_hash ORDER BY scrap_date ASC) AS rn
		FROM hashed_data
		)
	SELECT 
		gallery, 
		card_id, 
		url, 
		title, 
		price_primary, 
		price_history, 
		`options`, 
		vehicle_history, 
		comment, 
		location, 
		labels, 
		description, 
		scrap_date, 
		input_file_name, 
		source_id, 
		CURRENT_TIMESTAMP() AS modified_date,
		row_hash,
	FROM ordered_data
	WHERE rn = 1 
		AND IFNULL(card_id, '') != '' 
		AND card_id != '–';

	SET inserted_row_count = @@row_count;  

	CALL `paid-project-346208`.meta_ds.usp_write_event_log(process_id, ('processed lnd rows = ' || SAFE_CAST(processed_row_count AS STRING) || 
															', inserted tmp deduplicated rows = '|| SAFE_CAST(inserted_row_count AS STRING)), 'info');
	CALL `paid-project-346208`.meta_ds.usp_write_event_log(process_id, 'load data wo duplicates into lnd_cars_com_wo_duplicates', 'end');
	---------------------------------------------------------------------------------------------------------------------------------------------


	CALL `paid-project-346208`.meta_ds.usp_write_event_log(process_id, 'create table lnd_cars_com_rows_for_process', 'start');

	CREATE TEMP TABLE IF NOT EXISTS lnd_cars_com_rows_for_process (
		card_id STRING,
		row_hash BYTES,
		modified_date TIMESTAMP,
		oper STRING);
	
	TRUNCATE TABLE lnd_cars_com_rows_for_process;

	CALL `paid-project-346208`.meta_ds.usp_write_event_log(process_id, 'create table lnd_cars_com_rows_for_process', 'end');
	---------------------------------------------------------------------------------------------------------------------------------------------	


	CALL `paid-project-346208`.meta_ds.usp_write_event_log(process_id, 'load data into lnd_cars_com_rows_for_process', 'start');

	INSERT INTO lnd_cars_com_rows_for_process (
		card_id,
		row_hash,
		modified_date,
		oper)
	WITH rows_for_insert AS (
		SELECT 
			l.card_id AS card_id,
			l.row_hash AS row_hash,
			l.modified_date AS modified_date,
			CASE 
				WHEN s.card_id IS NULL THEN 'i' 
				WHEN s.card_id IS NOT NULL AND s2.row_hash IS NULL THEN 'u'
				ELSE NULL 
			END AS oper
		FROM lnd_cars_com_wo_duplicates l
		LEFT JOIN `paid-project-346208`.car_ads_ds_staging.stg1_cars_com_card_direct s ON l.card_id = s.card_id
		LEFT JOIN `paid-project-346208`.car_ads_ds_staging.stg1_cars_com_card_direct s2 ON l.card_id = s2.card_id AND l.row_hash = s2.row_hash
		)
	SELECT 
		card_id,
		row_hash,
		modified_date,
		oper
	FROM rows_for_insert
	WHERE oper IS NOT NULL;
	
	CALL `paid-project-346208`.meta_ds.usp_write_event_log(process_id, 'rows to insert = ' || SAFE_CAST((SELECT COUNT(*) FROM lnd_cars_com_rows_for_process WHERE oper = 'i') AS STRING)
																	|| ', rows to update = ' || SAFE_CAST((SELECT COUNT(*) FROM lnd_cars_com_rows_for_process WHERE oper = 'u') AS STRING), 'info');	
	CALL `paid-project-346208`.meta_ds.usp_write_event_log(process_id, 'load data into lnd_cars_com_rows_for_process', 'end');	
	---------------------------------------------------------------------------------------------------------------------------------------------	


	CALL `paid-project-346208`.meta_ds.usp_write_event_log(process_id, 'load data into stg1_cars_com_card_direct', 'start');

	INSERT INTO `paid-project-346208`.car_ads_ds_staging.stg1_cars_com_card_direct 
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
			modified_date, 
			row_hash,
			oper) 
	WITH filetered_deduplicated_rows AS(
		SELECT 
			l.gallery, 
			l.card_id, 
			l.url, 
			l.title, 
			l.price_primary, 
			l.price_history, 
			l.`options`, 
			l.vehicle_history, 
			l.comment, 
			l.location, 
			l.labels, 
			l.description, 
			l.scrap_date, 
			l.input_file_name, 
			l.source_id, 
			l.modified_date,
			l.row_hash,
			lp.oper
		FROM lnd_cars_com_wo_duplicates l
		LEFT JOIN lnd_cars_com_rows_for_process lp ON l.card_id = lp.card_id AND l.row_hash = lp.row_hash
		WHERE lp.oper IS NOT NULL
	)
	SELECT
		GENERATE_UUID() AS row_id,
		card_id,
		REGEXP_EXTRACT(title, r'(\S+)', 1, 2) AS brand,
		LEFT(REGEXP_REPLACE(title, r'^(\S+) (\S+) ', ''), 100) AS model,
		SAFE_CAST(REGEXP_REPLACE(price_primary, r'[^0-9]+', '') AS INT64) AS price_primary, 
		price_history, 
		REGEXP_REPLACE(location, r',[^,]*$', '') AS adress,
		LEFT(TRIM(REGEXP_EXTRACT(location, r'[^,]+', 1, 2)), 2) AS state,
		RIGHT(TRIM(REGEXP_EXTRACT(location, r'[^,]+', 1, 2)), 5) AS zip_code,
		REPLACE(REGEXP_EXTRACT(labels, r'VIN: [0-9a-zA-Z]+'), 'VIN: ', '') AS vin_num,
		CASE WHEN REGEXP_CONTAINS(UPPER(labels), r'HOME DELIVERY') THEN 'Y' ELSE 'N' END AS home_delivery_flag,
		CASE WHEN REGEXP_CONTAINS(UPPER(labels), r'VIRTUAL APPOINTMENTS') THEN 'Y' ELSE 'N' END AS virtual_appointments_flag,
		comment,
		SAFE_CAST(REGEXP_EXTRACT(description, r'^\d{4}') AS INT64) AS `year`,
		CASE WHEN REGEXP_CONTAINS(UPPER(split(description, ', ')[1]), r'CVT') THEN 'CVT'
		     WHEN REGEXP_CONTAINS(UPPER(split(description, ', ')[1]), r'AUTO') THEN 'Automatic'
		     ELSE NULL 
		END AS transmission_type, 
		split(description, ', ')[1] AS transmission_details,
		SAFE_CAST(REPLACE(TRIM(REGEXP_EXTRACT(split(description, ', ')[2], r'(\d.\dL|\dL)')), 'L', '') AS NUMERIC) * 1000 AS engine,
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
		modified_date,
		row_hash,
		oper
		FROM filetered_deduplicated_rows;	

	SET inserted_row_count = (SELECT COUNT(*) 
								FROM `paid-project-346208`.car_ads_ds_staging.stg1_cars_com_card_direct
								WHERE oper ='i' AND modified_date = (SElECT MAX(modified_date) FROM lnd_cars_com_rows_for_process));
	SET updated_row_count =	(SELECT COUNT(*) 
								FROM `paid-project-346208`.car_ads_ds_staging.stg1_cars_com_card_direct
								WHERE oper ='u' AND modified_date = (SElECT MAX(modified_date) FROM lnd_cars_com_rows_for_process));
	CALL `paid-project-346208`.meta_ds.usp_write_event_log(process_id, 'inserted rows to stg1 = ' || SAFE_CAST(inserted_row_count AS STRING) || 
																		', updated rows to stg1 = ' || SAFE_CAST(updated_row_count AS STRING) , 'info');	
	CALL `paid-project-346208`.meta_ds.usp_write_event_log(process_id, 'load data into stg1_cars_com_card_direct', 'end');
	---------------------------------------------------------------------------------------------------------------------------------------------

	
	CALL `paid-project-346208`.meta_ds.usp_write_event_log(process_id, 'drop temp table lnd_cars_com_rows_for_process', 'start');
	
	DROP TABLE IF EXISTS lnd_cars_com_rows_for_process;

	CALL `paid-project-346208`.meta_ds.usp_write_event_log(process_id, 'drop temp table lnd_cars_com_rows_for_process', 'end');
	---------------------------------------------------------------------------------------------------------------------------------------------
	

	CALL `paid-project-346208`.meta_ds.usp_write_event_log(process_id, 'drop temp table lnd_cars_com_wo_duplicates', 'start');
	
	DROP TABLE IF EXISTS lnd_cars_com_wo_duplicates;

	CALL `paid-project-346208`.meta_ds.usp_write_event_log(process_id, 'drop temp table lnd_cars_com_wo_duplicates', 'end');
	---------------------------------------------------------------------------------------------------------------------------------------------
	

	SET metrics = (NULL, inserted_row_count, updated_row_count, NULL, NULL);
	---------------------------------------------------------------------------------------------------------------------------------------------


	CALL `paid-project-346208`.meta_ds.usp_write_event_log(process_id, 'usp_stg1_cars_com_card_direct_tokenized_full_merge', 'end');


	CALL `paid-project-346208`.meta_ds.usp_write_process_log ('END', process_id, 'usp_stg1_cars_com_card_direct_tokenized_full_merge', metrics);



END;

