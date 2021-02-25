/*
CCDM SiteMilestone mapping
Notes: Standard mapping to CCDM SiteMilestone table
*/

WITH included_sites AS (
                SELECT DISTINCT studyid, siteid FROM site),

     sitemilestone_data AS (
                SELECT  'TAS120_201'::text AS studyid,
                        concat('TAS120_201_',site_number)::text AS siteid,
                        row_number() over (partition by site_number,site_status)::int AS milestoneseq,
                        site_status::text AS milestonelabel,
                        'Planned'::text AS milestonetype,
                        case when (siv_date_planned='N/A' or siv_date_planned='NULL')  then null else siv_date_planned end ::date AS expecteddate,
                        'Yes'::boolean AS ismandatory
from tas120_201_ctms.milestone_status_site )

SELECT 
        /*KEY (sm.studyid || '~' || sm.siteid)::text AS comprehendid, KEY*/
        sm.studyid::text AS studyid,
        sm.siteid::text AS siteid,
        sm.milestoneseq::int AS milestoneseq,
        sm.milestonelabel::text AS milestonelabel,
        sm.milestonetype::text AS milestonetype,
        sm.expecteddate::date AS expecteddate,
        sm.ismandatory::boolean AS ismandatory
        /*KEY , (sm.studyid || '~' || sm.siteid || '~' || sm.milestonetype || '~' || sm.milestoneseq)::text  AS objectuniquekey KEY*/
        /*KEY , now()::timestamp with time zone AS comprehend_update_time KEY*/
FROM sitemilestone_data sm
JOIN included_sites si ON (sm.studyid = si.studyid AND sm.siteid = si.siteid); 

