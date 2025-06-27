Allocation:
============
--Query to summarize allocation quantities by region and date

lock row for access select as_of_dt ,Ww_Region_Cd,sum(Regnl_Level_1_Alloc_Qty),sum(Regnl_Level_2_Alloc_Qty) from IBB_APP.SAT_ALLOC_ENRICHED where as_of_dt>=date-1 group by 1,2 order by 1,2;


-- Query to summarize allocation quantities from Supply_Chain schema

lock row for access select as_of_dt ,Ww_Region_Cd,sum(Regnl_Level_1_Alloc_Qty),sum(Regnl_Level_2_Alloc_Qty) FROM Supply_Chain.SAT_ALLOCATION_POR a  where as_of_dt>=date-1 group by 1,2 order by 1,2;



Shipment plan (Commit):
=======================

-- Query to summarize plan of record commit quantities

lock row for access select as_of_dt ,Ww_Region_Cd,sum(POR_COMMIT) from IBB_APP.SAT_COMMIT_ENRICHED  where as_of_dt>=date-1 group by 1,2 order by 1,2;


-- Query to summarize commit quantities from Supply_Chain schema

lock row for access select as_of_dt ,Ww_Region_Cd,sum(Por_Commit) FROM SUPPLY_CHAIN.SAT_COMMIT   where  As_Of_Dt >=date-1 group by 1,2 order by 1,2;


JST (Judged Sell-Thru):
=====

-- Query to summarize judged sell-thru quantity by region

lock row for access select as_of_dt ,Ww_Region_Cd,sum(regnl_judged_st_qty) from IBB_APP.SAT_JST_ENRICHED  where as_of_dt>=date-1 group by 1,2 order by 1,2;

-- Query to summarize judged sell-thru quantity from Supply_Chain schema

lock row for access select as_of_dt ,Ww_Region_Cd,sum(Regnl_Judged_St_Qty) FROM SUPPLY_CHAIN.SAT_JUDGED_SELL_THROUGH   where  As_Of_Dt >=date-1 
and ((ww_region_cd = 'WW' AND plan_of_record_version_nr = 'POR') OR (ww_region_cd <> 'WW' AND plan_of_record_version_nr in ( 'POR','FINAL_POR') AND judged_st_version_cd = 'POR')) group by 1,2 order by 1,2;


Transformer process for Adhoc refresh

-- Query to list relevant processes for SAT enrichment

SQL> select process_sk ,process_name from gbi_process where process_name like '%SEM_IBB_SAT%ENRICHED';

This process is enqueued upon completion of COB in core: sat_cob_processing.

