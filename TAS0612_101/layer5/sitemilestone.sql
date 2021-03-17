/*
CCDM SiteMilestone mapping
Notes: Standard mapping to CCDM SiteMilestone table
*/

WITH included_sites AS (
                SELECT DISTINCT studyid, siteid FROM site),

 sitemilestone_data AS (   
	 select studyid,
	 siteid,
	 row_number() over (partition by studyid,siteid order by expecteddate, milestonelabel) as milestoneseq,
	 milestonelabel,
	 milestonetype,
	 expecteddate,
	 ismandatory
	 from
	 (           SELECT  'TAS0612_101'::text AS studyid,
                        concat('TAS0612_101_',site_number)::text AS siteid,
                       null::int AS milestoneseq,
                        site_status::text AS milestonelabel,
                        'Planned'::text AS milestonetype,
                        siv_date_planned::date AS expecteddate,
                        'Yes'::boolean AS ismandatory
               from tas0612_101_ctms.milestone_status_site 
               
               union ALL
               
                SELECT  'TAS0612_101'::text AS studyid,
                        concat('TAS0612_101_',site_number)::text AS siteid,
                        null::int AS milestoneseq,
                        site_status::text AS milestonelabel,
                        'Actual'::text AS milestonetype,
                        case when (siv_date ='N/A' or siv_date ='NULL')  then null else siv_date end::date AS expecteddate,
                        'Yes'::boolean AS ismandatory
               from tas0612_101_ctms.milestone_status_site
               )a)

SELECT 
        /*KEY (sm.studyid || '~' || sm.siteid)::text AS comprehendid, KEY*/
        sm.studyid::text AS studyid,
        sm.siteid::text AS siteid,
        sm.milestoneseq::int AS milestoneseq,
        sm.milestonelabel::text AS milestonelabel,
        sm.milestonetype::text AS milestonetype,
        sm.expecteddate::date AS expecteddate,
        sm.ismandatory::boolean AS ismandatory,
		 'startup'::text as milestonebucketid,
		true::boolean as iskeymilestone,
		true::boolean as startkeymilestone
        /*KEY , (sm.studyid || '~' || sm.siteid || '~' || sm.milestonetype || '~' || sm.milestoneseq)::text  AS objectuniquekey KEY*/
        /*KEY , now()::timestamp with time zone AS comprehend_update_time KEY*/
FROM sitemilestone_data sm
JOIN included_sites si ON (sm.studyid = si.studyid AND sm.siteid = si.siteid); 

