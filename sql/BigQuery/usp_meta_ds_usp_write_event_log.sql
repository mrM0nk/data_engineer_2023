CREATE OR REPLACE PROCEDURE `paid-project-346208`.meta_ds.usp_write_event_log(
IN process_id STRING, 
IN task_name STRING, 
IN task_status STRING)

BEGIN 
	
	
	INSERT INTO `paid-project-346208`.meta_ds.audit_event_log (
	event_log_id, 
	log_date_ts, 
	event_name, 
	status, 
	process_log_id
	) 
	VALUES(
	GENERATE_UUID(), 
	CURRENT_TIMESTAMP(), 
	task_name, 
	task_status, 
	process_id
	);
					
			
END;

