CREATE OR REPLACE PROCEDURE `paid-project-346208`.meta_ds.usp_write_log_Maksym(
IN task_id INT64, 
IN task_name STRING, 
IN task_status STRING, 
OUT inserted_task_id INT64)

BEGIN 
	
	DECLARE new_task_id INT64;
	

	IF task_status = 'Started' OR task_status = 'Succeed'
		THEN 
		
			SET new_task_id = 1 + (SELECT IFNULL(MAX(ID), 0) FROM `paid-project-346208`.meta_ds.log_conversion_Maksym);
				
			IF task_status = 'Started'
				THEN 
					INSERT INTO `paid-project-346208`.meta_ds.log_conversion_Maksym 
					(id, log_data, task, status, duration, triggered_by) 
					VALUES(new_task_id, CURRENT_TIMESTAMP(), task_name, 'Started', '', SESSION_USER());
					
					SET inserted_task_id = new_task_id;
				END IF;
			
			
			IF task_status = 'Succeed'
				THEN
					UPDATE `paid-project-346208`.meta_ds.log_conversion_Maksym
						SET status = task_status,
						    duration = IF (TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), log_data, DAY) > 0,
						    			   ' > 1 day',
						    			   FORMAT_TIMESTAMP('%H:%M:%S', TIMESTAMP_SECONDS(TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), log_data, SECOND))))  
					WHERE id = task_id;
				
					SET inserted_task_id = NULL;
				END IF;
			
		END IF;
			
END;

