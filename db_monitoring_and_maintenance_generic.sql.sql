-- Database Monitoring and Maintenance Script 

-- Check running processes count
-- Run in shell:
-- ps -ef | grep -v grep | grep <process_name_placeholder> | wc -l

-- Connect to database (replace placeholders accordingly)
-- sqlplus <db_user>@<db_connect_string>/<password_placeholder>

-- Check pending jobs/processes
select region, data_category, sequence_number, status, process_type, count(1)
from JOBS_TABLE_PLACEHOLDER
group by region, data_category, sequence_number, status, process_type
order by status desc;

select count(*) from (
  select region, data_category, sequence_number, status, process_type, count(1)
  from JOBS_TABLE_PLACEHOLDER
  group by region, data_category, sequence_number, status, process_type
) a;

select sequence_number, count(1)
from SOME_OTHER_TABLE_PLACEHOLDER
where sequence_number > 0
group by sequence_number
order by sequence_number;

-- Delete entries by sequence number
delete from JOBS_TABLE_PLACEHOLDER
where data_category = '<data_category_placeholder>'
  and region = '<region_placeholder>'
  and sequence_number = '<sequence_number_placeholder>';

delete from EVENT_STATUS_TABLE_PLACEHOLDER
where sequence_number = '<sequence_number_placeholder>'
  and db_name = '<db_name_placeholder>'
  and table_name = '<table_name_placeholder>';

-- Check failed jobs and exceptions
select * from ASSESSORS_TABLE_PLACEHOLDER where status = 'FAILED';

select exception_id, exception_code, data1, data2, data3, problem, solution
from EXCEPTIONS_TABLE_PLACEHOLDER
where exception_date like '%<date_placeholder>%'
order by data2;

select region, data_category, sequence_number, status, process_type
from JOBS_TABLE_PLACEHOLDER
group by region, data_category, sequence_number, status, process_type
having status = 'FAILED';

select * from DATA_CATEGORY_MAPPING_TABLE_PLACEHOLDER
where data_category = '<data_category_placeholder>'
  and region = '<region_placeholder>';

-- Partition info for problem tables
select table_name, partition_name, high_value, interval
from ALL_PARTITIONS_TABLE_PLACEHOLDER
where table_name = '<table_name_placeholder>'
  and interval = 'NO';

-- Event status and publish checks
select table_name, db_name, status_code, sequence_number, update_timestamp, count(*)
from EVENT_STATUS_TABLE_PLACEHOLDER
where table_name like '%<table_name_placeholder>%'
  and db_name = '<db_name_placeholder>'
  and trunc(update_timestamp) >= to_date('<date_placeholder>', 'DD-MON-YY')
group by table_name, db_name, status_code, sequence_number, update_timestamp;

select db_name, status_code, count(*)
from EVENT_STATUS_TABLE_PLACEHOLDER
group by db_name, status_code;

select region_name, data_category, response_status, sequence_number, count(*)
from PUBLISH_TABLE_PLACEHOLDER
where region_name = '<region_name_placeholder>'
  and data_category = '<data_category_placeholder>'
  and published_date = to_date('<date_placeholder>', 'DD-MON-YY')
group by region_name, data_category, response_status, sequence_number;

select exception_id, exception_code, data1, data2, data3, problem, solution
from EXCEPTIONS_TABLE_PLACEHOLDER
where exception_date like '<date_placeholder>'
  and data1 in ('<val1>', '<val2>', '<val3>');

-- Steps to resolve partition issues causing errors
-- Step 1: Bring processing down
-- ./shutdown_process_script.sh ALL

update ASSESSORS_TABLE_PLACEHOLDER set status = 'FAILED' where status = 'RUNNING';
update JOBS_TABLE_PLACEHOLDER set status = 'PENDING' where status = 'RUNNING';

-- Step 2: Identify failed jobs and partitions
select region, data_category, sequence_number, status, process_type
from JOBS_TABLE_PLACEHOLDER
group by region, data_category, sequence_number, status, process_type
having status = 'FAILED';

select * from DATA_CATEGORY_MAPPING_TABLE_PLACEHOLDER
where data_category = '<data_category_placeholder>'
  and region = '<region_placeholder>';

select table_name, partition_name, high_value, interval
from ALL_PARTITIONS_TABLE_PLACEHOLDER
where table_name = '<table_name_placeholder>'
  and interval = 'NO';

alter table <table_name_placeholder> set interval();
alter table <table_name_placeholder> drop partition <partition_name_placeholder>;
alter table <table_name_placeholder> set interval(1);

-- Step 3: Reset failed statuses
update JOBS_TABLE_PLACEHOLDER set status = 'PENDING' where status = 'FAILED';
commit;

-- Step 4: Bring processing back up
-- ./start_process_script.sh ALL

-- Check for unique primary keys
select cols.column_name
from ALL_CONSTRAINTS_TABLE_PLACEHOLDER cons, ALL_CONS_COLUMNS_TABLE_PLACEHOLDER cols
where cols.table_name = '<table_name_placeholder>'
  and cons.constraint_type = 'P'
  and cons.constraint_name = cols.constraint_name
  and cons.owner = cols.owner;

-- Backup and delete intraday sequences example:
create table JOBS_BACKUP_TABLE_PLACEHOLDER as
select * from JOBS_TABLE_PLACEHOLDER where sequence_number = <sequence_number_placeholder>;

delete from JOBS_TABLE_PLACEHOLDER where sequence_number = <sequence_number_placeholder>;

-- Add further commands as needed...
