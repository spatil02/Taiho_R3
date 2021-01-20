/*
CCDM studyplannedrecruitment mapping
Notes: Standard mapping to CCDM studyplannedrecruitment table
*/

WITH included_studies AS (
                SELECT studyid FROM study ),
                
/* Subject_count AS (
                SELECT count(*) as sub_cnt FROM tas3681_101_ctms.subjects 
                where subject_status in ('Completed','Screening')),
                
 site_count AS (
                SELECT count(*) as site_cnt FROM tas3681_101_ctms.site_visits 
                where visit_status in ('Completed','Projected','Scheduled')),
screen_count AS (
				select count(*) as screen_cnt FROM tas3681_101_ctms.subject_visits 
				where visit_reference = 'SCR'),*/


     studyplannedrecruitment_data AS (
                SELECT  'TAS0612_101'::text AS studyid,
                        'Enrollment'::text AS category,
                        'Monthly'::text AS frequency,
                       max(nullif("last_subject_1st_visit_planned",''))::date AS enddate,
                        'Planned'::text AS type,
                        '1' ::int AS recruitmentcount
               From tas0612_101_ctms.milestone_status_study--,  Subject_count sc
               group by 1,2,3,5,6
               union all
                   SELECT  'TAS0612_101'::text AS studyid,
                        'Site Activation'::text AS category,
                        'Monthly'::text AS frequency,
                        max("siv_date_planned")::date AS enddate,
                        'Planned'::text AS type,
                        '1' ::int AS recruitmentcount
            From tas0612_101_ctms.milestone_status_site--, site_count sc
             group by 1,2,3,5,6
			 union all
                   SELECT  'TAS0612_101'::text AS studyid,
                        'Screening'::text AS category,
                        'Monthly'::text AS frequency,
                        max("1st_subject_1st_visit_planned")::date AS enddate,
                        'Planned'::text AS type,
                        '1' ::int AS recruitmentcount
            From tas0612_101_ctms.milestone_status_study--, screen_count sc
             group by 1,2,3,5,6
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


