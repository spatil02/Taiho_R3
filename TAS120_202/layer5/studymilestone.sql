/*
CCDM StudyMilestone mapping
Notes: Standard mapping to CCDM StudyMilestone table
*/

WITH included_studies AS (
                SELECT studyid FROM study ),
	
     studymilestone_data AS (
     select sm.studyid,
     row_number() over(partition by studyid order by expecteddate) as milestoneseq,
     case when sm.milestonelabel = 'First Subject Enrolled' then 'FIRST SUBJECT IN'
     when sm.milestonelabel = 'Last Subject Enrolled' then 'LAST SUBJECT IN'
     when sm.milestonelabel = 'First Site Activated' then 'FIRST SITE READY TO ENROLL' 
	when sm.milestonelabel = 'Last Site Activated' then 'ALL SITES ACTIVATED'	 
     else sm.milestonelabel end as milestonelabel,
     milestonetype,
     sm.expecteddate,
     ismandatory,
     iscriticalpath
     from
     (
                SELECT  'TAS120_202'::text AS studyid,
                        null::int AS milestoneseq,
                        sm."type"::text AS milestonelabel,
                        'Planned'::text AS milestonetype,
                        nullif(sm."planned_date",'')::date AS expecteddate,
                        'yes'::boolean AS ismandatory,
                        'yes'::boolean AS iscriticalpath
                        from tas120_202_ctms.milestone sm                       
                        )sm  where expecteddate is not null                       
                        )

SELECT 
        /*KEY sm.studyid::text AS comprehendid, KEY*/
        sm.studyid::text AS studyid,
        sm.milestoneseq::int AS milestoneseq,
        sm.milestonelabel::text AS milestonelabel,
        sm.milestonetype::text AS milestonetype,
        sm.expecteddate::date AS expecteddate,
        sm.ismandatory::boolean AS ismandatory,
        sm.iscriticalpath::boolean AS iscriticalpath
        /*KEY , (sm.studyid || '~' || sm.milestoneType || '~' || sm.milestoneSeq)::text  AS objectuniquekey KEY*/
        /*KEY , now()::timestamp with time zone AS comprehend_update_time KEY*/
FROM studymilestone_data sm
JOIN included_studies st ON (sm.studyid = st.studyid);

