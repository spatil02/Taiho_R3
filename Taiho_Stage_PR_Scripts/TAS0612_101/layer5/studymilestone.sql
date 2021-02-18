/*
CCDM StudyMilestone mapping
Notes: Standard mapping to CCDM StudyMilestone table
*/

WITH included_studies AS (
                SELECT studyid FROM study ),
                
  studymilestoneseq as (
   select  sm."milestones" as milestonelabel,
   row_number() over(order by convert_to_date(sm."planned_date")) as milestoneseq
   from tas0612_101_study_milestone.study_milestone sm
    where  nullif(sm."planned_date",'')  is not null
   
  ),
	
     studymilestone_data AS (
                SELECT  'TAS0612_101'::text AS studyid,
                        ms.milestoneseq::int AS milestoneseq,
                        sm."milestones"::text AS milestonelabel,
                        'Planned'::text AS milestonetype,
                        nullif(sm."planned_date",'')::date AS expecteddate,
                        'yes'::boolean AS ismandatory,
                        'yes'::boolean AS iscriticalpath
                        from tas0612_101_study_milestone.study_milestone sm
                        left join studymilestoneseq ms on (ms.milestonelabel = sm."milestones")
                        where  nullif(sm."planned_date",'')  is not null  
                                                
                        union all

                          SELECT  'TAS0612_101'::text AS studyid,
                        ms.milestoneseq::int AS milestoneseq,
                        sm."milestones"::text AS milestonelabel,
                        'Actual'::text AS milestonetype,
                        null::date AS expecteddate,
                        'yes'::boolean AS ismandatory,
                        'yes'::boolean AS iscriticalpath
                        from tas0612_101_study_milestone.study_milestone sm
                        left join studymilestoneseq ms on (ms.milestonelabel = sm."milestones")
                         where  nullif(sm."planned_date",'')  is not null
                         
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
