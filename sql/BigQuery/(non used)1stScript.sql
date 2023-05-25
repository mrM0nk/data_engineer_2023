SELECT table_name, ddl
FROM car_ads_ds_staging_test.INFORMATION_SCHEMA.TABLES
--WHERE table_name LIKE '%tokenized%'


SELECT table_name, ddl
FROM meta_ds.INFORMATION_SCHEMA.TABLES


SELECT *
FROM `paid-project-346208.car_ads_ds_landing.cars_com_card_direct_300_Maksym`


SELECT *
FROM `paid-project-346208`.car_ads_ds_landing.cars_com_card_direct_300_Maksym_1stSnapshot
ORDER BY card_id


SELECT *
FROM `paid-project-346208`.car_ads_ds_landing.cars_com_card_direct_300_Maksym_2ndSnapshot
ORDER BY card_id


SELECT *
FROM`paid-project-346208`.car_ads_ds_staging.stg1_cars_com_card_direct_300_Maksym





SELECT FORMAT_TIMESTAMP('%H:%M:%S', TIMESTAMP_SECONDS(TIMESTAMP_DIFF(CURRENT_DATETIME(), CAST('2023-05-20 11:17:21.545' AS DATETIME), SECOND))),
TIMESTAMP_DIFF('2023-05-20 14:00:35.804', CURRENT_TIMESTAMP(), DAY), 
CURRENT_TIMESTAMP(),
CURRENT_DATETIME() 


SELECT TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), log_data, DAY)
FROM `paid-project-346208`.meta_ds.log_conversion_Maksym


INSERT INTO `paid-project-346208`.meta_ds.log_conversion_Maksym (id, log_data, task, status, duration, triggered_by) 
VALUES(1, CURRENT_TIMESTAMP(), '', '', '', '');



SELECT *,
FORMAT_TIMESTAMP('%H:%M:%S', TIMESTAMP_SECONDS(TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), log_data, SECOND)))
FROM `paid-project-346208`.meta_ds.log_conversion_Maksym



SELECT ROW_NUMBER () OVER(PARTITION BY row_hash ORDER BY modified_date ASC) AS rn,row_hash 
FROM`paid-project-346208`.car_ads_ds_staging.stg1_cars_com_card_direct_300_Maksym
ORDER BY row_hash DESC





CALL `paid-project-346208`.car_ads_ds_staging.usp_stg1_cars_com_card_direct_tokenized_full_reload_Maksym();




CREATE OR REPLACE PROCEDURE `paid-project-346208`.car_ads_ds_staging.usp_test_Maksym()
BEGIN 
	
	CALL `paid-project-346208`.car_ads_ds_staging.usp_stg1_cars_com_card_direct_tokenized_full_reload_Maksym();
	CALL `paid-project-346208`.car_ads_ds_staging.usp_stg1_cars_com_card_direct_tokenized_full_reload_Maksym();
	CALL `paid-project-346208`.car_ads_ds_staging.usp_stg1_cars_com_card_direct_tokenized_full_reload_Maksym();
	CALL `paid-project-346208`.car_ads_ds_staging.usp_stg1_cars_com_card_direct_tokenized_full_reload_Maksym();
	CALL `paid-project-346208`.car_ads_ds_staging.usp_stg1_cars_com_card_direct_tokenized_full_reload_Maksym();


END;



CALL `paid-project-346208`.car_ads_ds_staging.usp_test_Maksym();














