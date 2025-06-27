-- ============================
-- Allocation Queries
-- ============================

-- Summarize allocation quantities by region and date from Enriched source
LOCK ROW FOR ACCESS
SELECT as_of_dt, region_cd, 
       SUM(level_1_alloc_qty), 
       SUM(level_2_alloc_qty)
FROM reporting_schema.allocation_enriched
WHERE as_of_dt >= CURRENT_DATE - 1
GROUP BY 1, 2
ORDER BY 1, 2;

-- Summarize allocation quantities from Plan of Record (POR) source
LOCK ROW FOR ACCESS
SELECT as_of_dt, region_cd, 
       SUM(level_1_alloc_qty), 
       SUM(level_2_alloc_qty)
FROM data_warehouse.allocation_por
WHERE as_of_dt >= CURRENT_DATE - 1
GROUP BY 1, 2
ORDER BY 1, 2;


-- ============================
-- Shipment Plan (Commit) Queries
-- ============================

-- Summarize plan-of-record commit quantities from Enriched source
LOCK ROW FOR ACCESS
SELECT as_of_dt, region_cd, 
       SUM(por_commit)
FROM reporting_schema.commit_enriched
WHERE as_of_dt >= CURRENT_DATE - 1
GROUP BY 1, 2
ORDER BY 1, 2;

-- Summarize commit quantities from core POR source
LOCK ROW FOR ACCESS
SELECT as_of_dt, region_cd, 
       SUM(por_commit)
FROM data_warehouse.commit_por
WHERE as_of_dt >= CURRENT_DATE - 1
GROUP BY 1, 2
ORDER BY 1, 2;


-- ============================
-- JST (Judged Sell-Thru) Queries
-- ============================

-- Summarize judged sell-thru quantity by region from Enriched source
LOCK ROW FOR ACCESS
SELECT as_of_dt, region_cd, 
       SUM(judged_st_qty)
FROM reporting_schema.jst_enriched
WHERE as_of_dt >= CURRENT_DATE - 1
GROUP BY 1, 2
ORDER BY 1, 2;

-- Summarize judged sell-thru quantity from core POR source with filters
LOCK ROW FOR ACCESS
SELECT as_of_dt, region_cd, 
       SUM(judged_st_qty)
FROM data_warehouse.judged_sell_through
WHERE as_of_dt >= CURRENT_DATE - 1
  AND (
    (region_cd = 'WW' AND por_version = 'POR')
    OR (region_cd <> 'WW' AND por_version IN ('POR', 'FINAL_POR') AND st_version = 'POR')
  )
GROUP BY 1, 2
ORDER BY 1, 2;


-- ============================
-- Transformer Process (Adhoc Refresh)
-- ============================

-- Retrieve transformer job metadata for enrichment layer
SELECT process_id, process_name
FROM etl_metadata.process_table
WHERE process_name LIKE '%SAT_ENRICHED%';

-- This process is triggered post COB completion in the core pipeline
-- Process: core_cob_trigger
