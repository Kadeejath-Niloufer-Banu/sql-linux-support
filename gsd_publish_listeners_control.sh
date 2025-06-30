#!/bin/bash
################################################################################
# gsd_publish_listeners_control.sh
#
# Description:
#   Runbook steps for safely stopping and starting
#   GSD publish listeners and validating batch processing status.
#
# Usage:
#   - Review validation queries first (to be run manually in SQL client).
#   - Stop listeners after confirming no pending batches.
#   - Start listeners after maintenance or changes.

################################################################################

################################################################################
# Step 1: Validate no pending batches in queue
#
# Run your internal query to confirm no rows are pending for processing.
# Expected result: No rows returned, so it is safe to stop listeners.
#
# Example SQL (replace with your own internal validated query):
#
# SELECT ... 
# FROM <status_table>
# WHERE <conditions>;
#
################################################################################

# Ask your support team to stop upstream publishing (e.g., APS-GBI).

################################################################################
# Step 2: Stop listeners
################################################################################

# Login to each server (example: 811 and 812), then run:

cd /path/to/your/listener/scripts
./stopAllListener.sh

# Validate listeners stopped (expected count: 0):
ps -ef | grep -c InfaDecommEFTListener

################################################################################
# Step 3: Additional optional SQL validations
#
# You may run queries to check maximum IDs, last extract statuses, etc.,
# as per your internal standard operating procedures.
#
# Example (replace with your own internal validated queries):
#
# SELECT interface_id, max(file_id)
# FROM <journal_table>
# WHERE status = 'PUBLISHED'
#   AND timestamp > sysdate - interval '5' hour
# GROUP BY interface_id;
#
# SELECT process_name, last_extract_id
# FROM <extract_table>;
#
################################################################################

################################################################################
# Step 4: Start listeners
################################################################################

# Login to each server (example: 811 and 812), then run:

cd /path/to/your/listener/scripts
./startAllListener.sh

# Validate listeners started (expected count: >1):
ps -ef | grep -c InfaDecommEFTListener

################################################################################
# Step 5: Ask your support team to resume upstream publishing
################################################################################

# Done.

################################################################################
# End of Script
################################################################################
