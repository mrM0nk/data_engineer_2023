INSERT INTO `paid-project-346208.car_ads_ds_landing.cars_com_card_direct_300_Maksym`
(gallery, card_id, url, title, price_primary, price_history, `options`, vehicle_history, comment, location, labels, description, scrap_date, input_file_name, source_id, dl_loaded_date)
SELECT gallery, card_id, url, title, price_primary, price_history, `options`, vehicle_history, comment, location, labels, description, scrap_date, input_file_name, source_id, dl_loaded_date
FROM `paid-project-346208`.car_ads_ds_landing.cars_com_card_direct
LIMIT 300;


--insert data to 1st snapshot
INSERT INTO `paid-project-346208`.car_ads_ds_landing.cars_com_card_direct_300_Maksym_1stSnapshot
(gallery, card_id, url, title, price_primary, price_history, `options`, vehicle_history, comment, location, labels, description, scrap_date, input_file_name, source_id, dl_loaded_date)
SELECT gallery, card_id, url, title, price_primary, price_history, `options`, vehicle_history, comment, location, labels, description, scrap_date, input_file_name, source_id, dl_loaded_date
FROM `paid-project-346208`.car_ads_ds_landing.cars_com_card_direct_300_Maksym


--insert data to 2nd snapshot
INSERT INTO `paid-project-346208`.car_ads_ds_landing.cars_com_card_direct_300_Maksym_2ndSnapshot
(gallery, card_id, url, title, price_primary, price_history, `options`, vehicle_history, comment, location, labels, description, scrap_date, input_file_name, source_id, dl_loaded_date)
SELECT gallery, card_id, url, title, price_primary, price_history, `options`, vehicle_history, comment, location, labels, description, scrap_date, input_file_name, source_id, dl_loaded_date
FROM `paid-project-346208`.car_ads_ds_landing.cars_com_card_direct_300_Maksym_1stSnapshot


--modifying data in 2nd snapshot

--SELECT *
--FROM `paid-project-346208`.car_ads_ds_landing.cars_com_card_direct
--WHERE card_id NOT IN (SELECT card_id FROM `paid-project-346208`.car_ads_ds_landing.cars_com_card_direct_300_Maksym_1stSnapshot)
--LIMIT 5

INSERT INTO `paid-project-346208`.car_ads_ds_landing.cars_com_card_direct_300_Maksym_2ndSnapshot
(gallery, card_id, url, title, price_primary, price_history, `options`, vehicle_history, comment, location, labels, description, scrap_date, input_file_name, source_id, dl_loaded_date)
VALUES(NULL, 
'84573', 
'https://www.cars.com/vehicledetail/e691efcb-683c-4079-9ee9-4c2bfed77c80/', 
'2019 Lexus RX 350 Base', 
'$41,797', 
'4/23/23: $41,997 | 4/25/23: $41,797 ', 
NULL, 
'Accidents or damage: None reported | 1-owner vehicle: No | Personal use only: Yes ', 
'Lowest price guaranteed!  Backed by a 5-day money back policy!  Oh, and NO SALESMEN FOLLOWING YOU AROUND!  Buy online and well have your car and paperwork ready for you! Out of town? We can even pick you up or pay for your ride share service!', 
'4813 McHenry Ave Modesto, CA 95356', 
'Good Deal|VIN: JTJBZMCA2K2040126', 
'2019, automatic, 3.5L V-6 port/direct injection  DOHC  VVT-iW variable valve cont, Gasoline (19–26 mpg), 38 852 mi. | suv, All-wheel Drive, Atomic Silver', 
'2023-05-15 16:00:35.000', 
'file:/C:/Users/gavri/PycharmProjects/car_ads_scrapper/scrapped_data/cars_com/json/2023-05-14-05-42-14/2019/price_40000-49999/https---www-cars-com-vehicledetail-e691efcb-683c-4079-9ee9-4c2bfed77c80-.json', 
'cars.com scrapper', 
'2023-05-17 10:21:56.576');


INSERT INTO `paid-project-346208`.car_ads_ds_landing.cars_com_card_direct_300_Maksym_2ndSnapshot
(gallery, card_id, url, title, price_primary, price_history, `options`, vehicle_history, comment, location, labels, description, scrap_date, input_file_name, source_id, dl_loaded_date)
SELECT gallery, card_id, url, title, price_primary, 
'5/14/23: $62,995' as price_history, 
`options`, vehicle_history, comment, location, labels, description, 
DATE_ADD(scrap_date, INTERVAL 1 DAY) as scrap_date, 
input_file_name, 
source_id, 
DATE_ADD(dl_loaded_date, INTERVAL 1 DAY) as dl_loaded_date
FROM `paid-project-346208`.car_ads_ds_landing.cars_com_card_direct_300_Maksym_1stSnapshot
WHERE card_id = '885744'




















