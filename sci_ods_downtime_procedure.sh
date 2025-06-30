#!/bin/bash
################################################################################
# SYSTEM Downtime and Startup Procedure Script Template
# Replace placeholders with actual values.
################################################################################

# 1. Take listener down and keep event reader on hold
# -- Insert your actual listener shutdown command here
# -- Keep event reader ON HOLD (do NOT force start)

# 2. Snapshot running relevant processes on servers
ssh user@SERVER_1 "ps -ef | grep -v grep | grep <process_keyword>"
ssh user@SERVER_2 "ps -ef | grep -v grep | grep <process_keyword>"

# 3. Check running batches in jobs table (run in DB client)
# Example SQL:
# SELECT region, category, sequence_no, status, process_type, COUNT(1)
# FROM jobs_table
# GROUP BY region, category, sequence_no, status, process_type
# ORDER BY status DESC;

# 4. Bring system DOWN

# 4a. Suspend monitoring (run in DB client)
# SELECT * FROM monitoring_table WHERE status = 'ACTIVE';
# UPDATE monitoring_table SET status = 'SUSPENDED' WHERE status = 'ACTIVE';
# SELECT * FROM monitoring_table WHERE status = 'ACTIVE';

# 4b. Stop processes on SYSTEM_1
ssh user@SERVER_1 <<'ENDSSH'
  cd /path/to/process_dir
  ps -ef | grep <process_keyword>
  ./shutdown_process_all.sh
  ./shutdown_publishing.sh
  ./shutdown_monitoring.sh
ENDSSH

# 4c. Stop processes on SYSTEM_2
ssh user@SERVER_2 <<'ENDSSH'
  cd /path/to/process_p_dir
  ./shutdown_process_all_p.sh
  ./shutdown_publishing_p.sh
ENDSSH

# 4d. Verify no relevant processes running on SYSTEM_1 and SYSTEM_2
ssh user@SERVER_1 "ps -ef | grep -v grep | grep <process_keyword>"
ssh user@SERVER_2 "ps -ef | grep -v grep | grep <process_keyword>"

# 4e. Stop file generation process on SERVER_2
ssh user@SERVER_2 <<'ENDSSH'
  cd /path/to/scripts_dir
  ./shutdown_file_generation_all.sh
  cd /path/to/scripts_p_dir
  ./shutdown_file_generation_all_p.sh
ENDSSH

# 5. Check max sequence number from publish table (run in DB client)
# SELECT MAX(seq_no), MAX(published_date), SYSDATE
# FROM publish_table
# WHERE published_date > SYSDATE - 1;

# 6. Bring system UP (after confirmation)

# 6a. Start processes on SYSTEM_1
ssh user@SERVER_1 <<'ENDSSH'
  cd /path/to/process_dir
  ./start_process_all_32.sh
  nohup ./publishing_script.sh &
  nohup ./monitoring_pack.sh &
ENDSSH

# 6b. Start processes on SYSTEM_2
ssh user@SERVER_2 <<'ENDSSH'
  cd /path/to/process_p_dir
  ./start_process_all_p.sh
  nohup ./publishing_script_p.sh &
ENDSSH

# 6c. Start file generation process on SERVER_2
ssh user@SERVER_2 <<'ENDSSH'
  cd /path/to/scripts_dir
  ./start_file_generation_all.sh
  cd /path/to/scripts_p_dir
  ./start_file_generation_all_p.sh
ENDSSH

# 7. Verify all processes are running on both servers
ssh user@SERVER_1 "ps -ef | grep -v grep | grep <process_keyword>"
ssh user@SERVER_2 "ps -ef | grep -v grep | grep <process_keyword>"

# 8. Bring up listener and OFF HOLD event reader
# -- Insert your commands here (do NOT force start event reader)

# 9. Monitor flow and resume monitoring (run in DB client)
# SELECT region, category, sequence_no, status, process_type, COUNT(1)
# FROM jobs_table
# GROUP BY region, category, sequence_no, status, process_type
# ORDER BY status DESC;
#
# SELECT * FROM publish_table WHERE seq_no > '<previous_max_seq_no>';
#
# Resume monitoring:
# SELECT * FROM monitoring_table WHERE status = 'SUSPENDED';
# UPDATE monitoring_table SET status = 'ACTIVE' WHERE status = 'SUSPENDED';
# SELECT * FROM monitoring_table WHERE status = 'SUSPENDED';

