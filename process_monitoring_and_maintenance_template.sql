-- ===================================================================
-- Script: Process Monitoring and Maintenance Template
-- Description: Generic commands and queries for monitoring,
--              killing, restarting, and troubleshooting
--              batch jobs and processes.
-- ===================================================================

-- 1. Stop processes on hosts

-- Host A
cd /path/to/app/hostA/scripts;
./stop_process_script.sh ALL;

-- Parallel process (confirmation needed)
cd /path/to/app/hostA/parallel_scripts;
./stop_parallel_process_script.sh ALL;

-- Host B
cd /path/to/app/hostB/scripts;
./stop_process_script.sh ALL;

-- Parallel process (confirmation needed)
cd /path/to/app/hostB/parallel_scripts;
./stop_parallel_process_script.sh ALL;

-- 2. Start processes on hosts

-- Host A
cd /path/to/app/hostA/scripts;
./start_process_script.sh ALL;

-- Parallel process (confirmation needed)
cd /path/to/app/hostA/parallel_scripts;
./start_parallel_process_script.sh ALL;

-- Host B
cd /path/to/app/hostB/scripts;
./start_process_script.sh ALL;

cd /path/to/app/hostB/parallel_scripts;
./start_parallel_process_script.sh ALL;

-- 3. Restart monitoring and publishing scripts if issues arise

cd /path/to/app/hostA/scripts;
nohup ./publishing_script.sh & 
nohup ./monitoring_script.sh &

-- 4. Check process counts

-- Count running processes by name
ps -ef | grep -v grep | grep process_name | wc -l;

-- 5. Query job statuses and events

SELECT job_id,
       CAST(environment_code AS VARCHAR(15)) AS Environment,
       CAST(job_type AS VARCHAR(20)) AS Job_Type,
       (SELECT CAST(field_value AS VARCHAR(25)) FROM static_master_table WHERE field_key = status_code) AS Status
FROM job_status_table
WHERE job_type = 'RULE'
  AND status_code = '<STATUS_CODE>'
  AND host_name = '<HOSTNAME>';

SELECT event_id, event_status, event_transaction_id
FROM event_status_table
WHERE rule_id = <RULE_ID>;

SELECT MAX(end_date), status
FROM job_status_history_table
WHERE process_id IN (<PROCESS_ID>)
  AND start_date > (SYSDATE - 1)
GROUP BY status;

-- 6. Query recent exceptions

SELECT DISTINCT problem_description, suggested_solution, exception_date
FROM exceptions_table
WHERE exception_date > (SYSDATE - (200/1440))
ORDER BY exception_date DESC;

-- 7. Monitor process delays

SELECT process_type,
       process_name,
       (SYSDATE - next_expected_time) * 86400 AS seconds_delayed,
       threshold_seconds,
       status_code,
       next_expected_time
FROM process_monitoring_table
ORDER BY process_name;

-- 8. Reset failed job statuses

UPDATE job_execution_table
SET status = 'PENDING'
WHERE status = 'FAILED';
COMMIT;

-- 9. Identify failed sequences

SELECT region,
       data_category,
       sequence_number,
       status,
       process_type
FROM job_execution_table
GROUP BY region, data_category, sequence_number, status, process_type
HAVING status = 'FAILED';

-- 10. Troubleshoot partition-related failures

SELECT table_name,
       partition_name,
       high_value,
       interval_setting
FROM all_table_partitions
WHERE table_name = '<TABLE_NAME>'
  AND interval_setting = 'NO';

-- Drop problematic partition and reset interval (adjust names)

ALTER TABLE <TABLE_NAME> SET INTERVAL;
ALTER TABLE <TABLE_NAME> DROP PARTITION <PARTITION_NAME>;
ALTER TABLE <TABLE_NAME> SET INTERVAL(1);

-- 11. Restart processes after fixes

cd /path/to/app/hostA/scripts;
./start_process_script.sh ALL;

-- 12. Additional monitoring queries (example: duplicates check)

SELECT *
FROM (
  SELECT COUNT(*),
         product_hierarchy,
         channel_hierarchy,
         geo_level,
         intersection_type,
         manufacturing_hierarchy,
         organization_hierarchy,
         version,
         process_id,
         process_name,
         program_name,
         region_code,
         as_of_date,
         fiscal_date
  FROM staging_table SUBPARTITION(<SUBPARTITION_NAME>)
  GROUP BY product_hierarchy, channel_hierarchy, geo_level, intersection_type,
           manufacturing_hierarchy, organization_hierarchy, version, process_id, process_name,
           program_name, region_code, as_of_date, fiscal_date
  HAVING COUNT(*) > 1
)
WHERE ROWNUM <= 6;

-- 13. Backup and cleanup failed sequences

CREATE TABLE job_execution_backup_<DATE> AS
SELECT *
FROM job_execution_table
WHERE data_category = '<DATA_CATEGORY>'
  AND region = '<REGION>'
  AND sequence_number IN (<SEQUENCE_LIST>);

DELETE FROM job_execution_table
WHERE data_category = '<DATA_CATEGORY>'
  AND region = '<REGION>'
  AND sequence_number IN (<SEQUENCE_LIST>);

CREATE TABLE event_status_backup_<DATE> AS
SELECT *
FROM event_status_table
WHERE sequence_number IN (<SEQUENCE_LIST>)
  AND database_name = '<DATABASE_NAME>'
  AND table_name = '<TABLE_NAME>';

DELETE FROM event_status_table
WHERE sequence_number IN (<SEQUENCE_LIST>)
  AND database_name = '<DATABASE_NAME>'
  AND table_name = '<TABLE_NAME>';

-- ===================================================================
-- End of Process Monitoring and Maintenance Template
-- ===================================================================
