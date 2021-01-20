/*
CCDM StudyMilestone mapping
Notes: Standard mapping to CCDM StudyMilestone table
*/

WITH included_studies AS (
                SELECT studyid FROM study ),

     studymilestone_data AS (
                SELECT  'TAS0612_101'::text AS studyid,
                        '1'::int AS milestoneseq,
                        sm."trial_name"::text AS milestonelabel,
                        'Planned'::text AS milestonetype,
                        sm."1st_subject_1st_visit_planned"::date AS expecteddate,
                        'yes'::boolean AS ismandatory,
                        'yes'::boolean AS iscriticalpath
                        from tas0612_101_ctms.milestone_status_study sm                        
				
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

