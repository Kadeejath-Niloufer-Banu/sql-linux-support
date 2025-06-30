/***************************************************************************
* Script: deduplication_and_replication.sql
* Description: Generalized script for duplicate handling and replication
*              tasks in SQL environments (e.g., Teradata, Oracle, etc.).
***************************************************************************/

/*************************
 * Section 1: Duplicate Removal
 *************************/

-- Count duplicates
SELECT COUNT(*)
FROM (
    SELECT id, type_of_id, purpose_type
    FROM target_table
    GROUP BY id, type_of_id, purpose_type
    HAVING COUNT(*) > 1
) a;

-- Example: Show sample duplicates
SELECT TOP 3 *
FROM (
    SELECT id, type_of_id, purpose_type
    FROM target_table
    GROUP BY id, type_of_id, purpose_type
    HAVING COUNT(*) > 1
) a;

-- Backup duplicates
INSERT INTO backup_table
SELECT *
FROM target_table
WHERE (id, type_of_id, purpose_type, change_timestamp) IN (
    SELECT id, type_of_id, purpose_type, MIN(change_timestamp)
    FROM target_table
    GROUP BY id, type_of_id, purpose_type
    HAVING COUNT(*) > 1
);

-- Remove duplicates
DELETE FROM target_table
WHERE (id, type_of_id, purpose_type, change_timestamp) IN (
    SELECT id, type_of_id, purpose_type, MIN(change_timestamp)
    FROM target_table
    GROUP BY id, type_of_id, purpose_type
    HAVING COUNT(*) > 1
);

-- Create backup table structure (if needed)
CREATE TABLE backup_table AS target_table WITH NO DATA;


/*************************
 * Section 2: Replication Configuration (Example)
 *************************/

-- Example replication configuration file snippet (use as needed)

-- Source system details (placeholders)
-- SourceTdpId = 'SOURCE_SYS'
-- SourceUserName = 'source_user'
-- SourceUserPassword = '******'

-- Target system details (placeholders)
-- TargetTdpId = 'TARGET_SYS'
-- TargetUserName = 'target_user'
-- TargetUserPassword = '******'

-- Export and load configuration
-- ExportMinSessions = 2
-- ExportMaxSessions = 4
-- LoadMinSessions = 2
-- LoadMaxSessions = 4

-- Example select statement
-- SelectStmt = 'SELECT * FROM backup_table'

-- Example execution command:
-- tbuild -f Master_Rep.txt -v rep.txt -j job_name


/*************************
 * Section 3: Table Size Checks (Optional)
 *************************/

-- Check table sizes (Teradata style example)
LOCK ROW FOR ACCESS
SELECT databasename AS "Database",
       tablename AS "Table Name",
       SUM(currentperm) / (1024 * 1024 * 1024) AS "Current Perm Space (GB)"
FROM dbc.tablesize
WHERE databasename = 'YOUR_DB'
  AND tablename = 'YOUR_TABLE'
GROUP BY 1, 2
ORDER BY 3 DESC;


/*************************
 * Section 4: Additional Duplicate Handling Example
 *************************/

-- Count duplicates by comparing core and backup tables
SELECT COUNT(1)
FROM core_table c
WHERE EXISTS (
    SELECT 1
    FROM backup_table b
    WHERE b.key1 = c.key1
      AND b.key2 = c.key2
      AND c.batch_sk < b.batch_sk
);

-- Insert duplicates into backup table
INSERT INTO backup_table
SELECT *
FROM core_table c
WHERE EXISTS (
    SELECT 1
    FROM backup_table b
    WHERE b.key1 = c.key1
      AND b.key2 = c.key2
      AND c.batch_sk < b.batch_sk
);

-- Delete duplicates from core table
DELETE FROM core_table c
WHERE EXISTS (
    SELECT 1
    FROM backup_table b
    WHERE b.key1 = c.key1
      AND b.key2 = c.key2
      AND c.batch_sk < b.batch_sk
);

-- Re-insert missing rows if needed
INSERT INTO core_table
SELECT *
FROM backup_table b
WHERE NOT EXISTS (
    SELECT 1
    FROM core_table c
    WHERE b.key1 = c.key1
      AND b.key2 = c.key2
);


/*************************
 * Section 5: Batch Status and Count Queries (Optional)
 *************************/

-- Example batch status monitoring
SELECT rows_added_cnt,
       rows_updated_cnt,
       rows_deleted_cnt,
       rows_skipped_cnt,
       rows_duplicate_cnt,
       rows_source_cnt
FROM batch_run_history
WHERE process_id = 123456
GROUP BY rows_added_cnt, rows_updated_cnt, rows_deleted_cnt, rows_skipped_cnt, rows_duplicate_cnt, rows_source_cnt;

-- Example batch queue check
SELECT batch_status
FROM batch_queue
WHERE process_id = 123456
  AND source_batch_id BETWEEN 1000 AND 2000
GROUP BY batch_status;


/***************************************************************************
* End of Script
***************************************************************************/
