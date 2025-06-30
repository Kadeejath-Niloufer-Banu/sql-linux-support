#!/bin/bash
################################################################################
# gbi_sql_query_helpers.sh
#
# Description:
#   Collection of SQL query generator snippets for ETL support and monitoring.
#   Each echo block writes a SQL file that can be executed as needed.
#
# Usage:
#   Run this script to generate a set of parameterized SQL files for ETL analysis.
#   You can modify placeholders such as &process_name, &env_cd, etc.
################################################################################

# Example: connect using sqlplus (placeholder)
# sqlplus <username>/<password>@<db_service>

cd ~/work/SQL

# Generate SQL files
echo "Generating SQL helper files..."

echo "select cast(JOB_NAME as varchar(100)) as JOB_NAME, ENV_CD from gbi_process_env_job where PROCESS_SK in (select process_sk from gbi_process where process_name = '&ProcessName') group by JOB_NAME,ENV_CD;" > aj.sql

echo "select count(*) from gbi_process_batch_queue where process_sk in (select process_sk from gbi_process where process_name='&process_name') and env_cd='&env_cd';" > ce.sql

echo "select count(*),ENV_CD,min(insert_ts),max(insert_ts),min(source_batch_sk),max(source_batch_sk) from gbi_process_batch_queue where process_sk in (select process_sk from gbi_process where process_name='&process_name') group by env_cd;" > b.sql

echo "select cast(host_name as varchar(25)) HOST_NAME, cast(NFS_FILE_PATH_1 as varchar(30)) nfs_file_path1, insert_Ts, source_batch_sk, batch_status, env_Cd, target_batch_sk, process_sk from gbi_process_batch_queue where process_sk in (select process_sk from gbi_process where process_name='&process_name') and env_cd='&env_cd' order by insert_Ts;" > bs.sql

echo "select count(*),process_sk,ENV_CD,min(insert_ts),max(insert_ts) from gbi_process_batch_queue where process_sk in (select distinct process_sk from gbi_process where process_sk in (select process_sk from gbi_process where parent_process_sk in (select process_sk from gbi_process where process_name='&process_name'))) group by process_sk,env_cd order by env_cd;" > cb.sql

echo "select gp.PROCESS_SK, gp.process_name, gs.ENV_CD, gj.ticket_id, gs.status, gs.host_name, gs.START_DATE, gs.END_DATE from gbi_metadata_owner.gbi_job_error gj, gbi_metadata_owner.gbi_etl_daemon_status gs, gbi_process gp where gp.process_sk=gs.process_sk and gp.process_name=gj.job_name and ticket_id in (&t_id);" > cs.sql

echo "select * from gbi_metadata_owner.GBI_ETL_DAEMON_PROCESS_ENV where process_sk =(select process_sk from gbi_process where process_name='&process_name');" > de.sql

echo "select CONTROL_VALUE from gbi_metadata_owner.gbi_Etl_control where ACTION_CNTL_SK in (select ACTION_CNTL_SK from gbi_metadata_owner.gbi_Etl_control where CONTROL_VALUE='&process_name');" > hold.sql

echo "select d.PROCESS_SK||'|'||d.ENV_CD||'|'||d.JOB_TYPE||'|'||d.HOST_NAME||'|'||d.ACCOUNT_NAME||'|'||d.STATUS||'|'||d.START_DATE||'|'||d.END_DATE||'|||||||||||||||||||'||s.FIELD_VALUE from gbi_metadata_owner.GBI_ETL_DAEMON_STATUS d join gbi_static_master s on d.STATUS=s.STATIC_FIELD_SK where d.process_sk =(select process_sk from gbi_process where process_name='&process_name');" > ds2.sql

echo "select * from gbi_metadata_owner.fetch_dependent_processes_vw where f2s_process_name='&f2s_process_name';" > fdp.sql

echo "select max(insert_Ts),env_cd,BATCH_STATUS,max(source_batch_sk) from hist_process_batch_queue where process_sk in (select process_sk from gbi_process where process_name='&process_name') group by env_cd,BATCH_STATUS;" > hist.sql

echo "select TARGET_DB_NAME||'.'||TARGET_TABLE_NAME||'|'||SOURCE_DB_NAME||'.'||SOURCE_TABLE_NAME||'|'||REFRESH_TYPE from gbi_metadata_owner.etl_src2tgt_table_map_vw where process_sk in (select process_sk from gbi_process where process_name='&process_name');" > map.sql

echo "select cast(ea.SOURCE_DB_SERVER as varchar(30)) as Source_SERVER, cast(ea.SOURCE_DB as varchar(20)) as Source_DB, cast(ea.SOURCE_ENTITY as varchar(40)) as Source_Entity, gd.DATASTORE_SK as Datastore_SK, cast(gd.DATASTORE_NAME as varchar(20)) as Datastore_Name, cast(gd.CONNECTION_STRING as varchar(60)) as Connection_String, cast(dc.DATASTORE_USER as varchar(20)) as Datastore_User, cast(dc.ENV_CD as varchar(15)) as Environment, '<DECRYPTED_PASSWORD_PLACEHOLDER>' as Password, cast(dc.PASSWORD_KEY as varchar(20)) as Password_key from gbi_metadata_owner.GBI_ENTITY_ATTRIBUTE_USER_VW ea, gbi_metadata_owner.gbi_datastore gd, gbi_metadata_owner.gbi_env_datastore_cred dc where dc.DATASTORE_SK = gd.DATASTORE_SK and upper(gd.HOST_NAME) = upper(ea.SOURCE_DB_SERVER) and ea.process_sk = (select process_sk from gbi_process where '&name_or_psk' in (cast(PROCESS_SK as varchar(10)), PROCESS_NAME)) and rownum=1;" > sd.sql

# Repeat similar echo lines for other .sql files...

echo "Setting permissions for generated SQL files..."
chmod 777 *.sql

echo "SQL helper files generated successfully."
