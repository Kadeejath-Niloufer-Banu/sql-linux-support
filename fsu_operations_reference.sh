################################################################################
# FSU Operations Reference
# Description: Useful commands and queries for filesystem usage, batch monitoring,
#              Autosys job checks, daemon status, and general operational health checks.
################################################################################

##############################
# Disk Usage and Large Files #
##############################

# Find large files (>10MB)
find . -xdev -type f -size +10000000 -exec ls -lht {} \;

# Check disk usage per folder (display folders using GB)
du -xh --max-depth=0 * | egrep "[0-9]G" | sort -rn

# Count files in each subdirectory
for d in $(find -maxdepth 1 -type d | cut -d/ -f2 | grep -xv . | sort); do
  c=$(find "$d" | wc -l)
  printf "%s\t- %s\n" "$c" "$d"
done

# Suggestion: Identify folders consuming more space, navigate into them, and repeat.

#####################################
# SQL Batch Queue Monitoring Checks #
#####################################

# Query batch queue (historical)
# Replace <source_batch_sk> with your source batch SK value.
echo "
SELECT PROCESS_SK, ENV_CD, BATCH_STATUS, BATCH_STATE, SOURCE_BATCH_SK
FROM hist_process_batch_queue
WHERE source_batch_sk = <source_batch_sk>;
"

# Query batch queue (current)
echo "
SELECT PROCESS_SK, ENV_CD, BATCH_STATUS, BATCH_STATE, SOURCE_BATCH_SK
FROM gbi_process_batch_queue
WHERE source_batch_sk = <source_batch_sk>;
"

######################
# Autosys Job Checks #
######################

# List Autosys jobs running on a specific host
# Replace <HOSTNAME> with actual host name (often prefixed with GLOB.)
jr % -M <HOSTNAME> -d

#########################
# Daemon Status Queries #
#########################

# Check daemon details for a specific host
echo "
SELECT *
FROM etl_daemon_details
WHERE UPPER(host_name) = '<HOSTNAME>';
"

# Check daemon status for a specific host
echo "
SELECT host_name, account_name, status
FROM etl_daemon_details
WHERE UPPER(host_name) = '<HOSTNAME>';
"

#################
# Inode Usage   #
#################

# Check inode usage in the current directory
df -i .

##################
# Swap Utilization
##################

# Check swap usage percentage
free | grep Swap | awk '{printf "%s used is %.2f%% of Total\n", $1, $3*100/$2}'
