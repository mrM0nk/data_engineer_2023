CREATE TABLE IF NOT EXISTS `paid-project-346208.car_ads_ds_staging.stg1_cars_com_card_direct`
(
  row_id STRING NOT NULL,
  card_id STRING NOT NULL,
  brand STRING NOT NULL,
  model STRING NOT NULL,
  price_primary INT64 NOT NULL,
  price_history STRING,
  adress STRING NOT NULL,
  state STRING,
  zip_code STRING,
  vin_num STRING,
  home_delivery_flag STRING NOT NULL,
  virtual_appointments_flag STRING NOT NULL,
  comment STRING,
  `year` INT64 NOT NULL,
  transmission_type STRING,
  transmission_details STRING,
  engine NUMERIC,
  engine_details STRING, 
  fuel STRING, 
  mpg STRING, 
  mileage INT64 NOT NULL,
  mileage_type STRING,
  body STRING, 
  drive_type STRING, 
  color STRING, 
  vehicle_history STRING, 
  scrap_date TIMESTAMP NOT NULL,
  input_file_name STRING NOT NULL,
  modified_date TIMESTAMP NOT NULL,
  row_hash BYTES NOT NULL,
  oper STRING NOT NULL,
  PRIMARY KEY (row_id) NOT ENFORCED
);

