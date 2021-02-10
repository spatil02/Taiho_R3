/*
CCDM studyplannedrecruitment mapping
Notes: Standard mapping to CCDM studyplannedrecruitment table
*/

WITH included_studies AS (
                SELECT studyid FROM study ),
                
     studyplannedrecruitment_data AS (
                SELECT  'TAS120_202'::text AS studyid,
                        'Enrollment'::text AS category,
                        'Monthly'::text AS frequency,
                       max("ENRDAT")::date AS enddate,
                        'Planned'::text AS type,
                        count("ENRYN") ::int AS recruitmentcount
              From tas120_202."ENR"
			   where "ENRYN" = 'Yes'
               
               union all
                   SELECT  replace("protocol_#",'-','_')::text AS studyid,
                        'Site Activation'::text AS category,
                        'Monthly'::text AS frequency,
                        max("planned_date")::date AS enddate,
                        'Planned'::text AS type,
                        count("visit_status") ::int AS recruitmentcount
            From tas120_202_ctms.monvisit_tracker
			where "visit_status" = 'Planned'
             group by "protocol_#"
			 union all
			  SELECT  'TAS120_202'::text AS studyid,
                        'Screening'::text AS category,
                        'Monthly'::text AS frequency,
                        max(COALESCE("MinCreated" ,"RecordDate"))::date AS enddate,
                        'Planned'::text AS type,
                        count("Folder") ::int AS recruitmentcount
         From tas120_202."DM"
         where "Folder" = 'SCRN'			
                )

SELECT
        /*KEY spr.studyid::text AS comprehendid, KEY*/
        spr.studyid::text AS studyid,
        spr.category::text AS category,
        spr.frequency::text AS frequency,
        spr.enddate::date AS enddate,
        spr.type::text AS type,
        spr.recruitmentcount::int AS recruitmentcount
        /*KEY ,(spr.studyid || '~' || spr.category || '~' || spr.frequency || '~' || spr.enddate || '~' || spr.type)::text  AS objectuniquekey KEY*/
        /*KEY , now()::timestamp with time zone AS comprehend_update_time KEY*/
FROM studyplannedrecruitment_data spr
JOIN included_studies st ON (st.studyid = spr.studyid); 


