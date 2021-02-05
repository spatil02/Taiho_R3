/*
CCDM studyplannedrecruitment mapping
Notes: Standard mapping to CCDM studyplannedrecruitment table
*/

WITH included_studies AS (
                SELECT studyid FROM study ),
                
/* Subject_count AS (
                SELECT count(*) as sub_cnt FROM tas3681_101_ctms.subjects 
                where subject_status in ('Completed','Screening')),*/
                
 site_count AS (
                SELECT count(*) as site_cnt FROM tas120_201_ctms.site_startup_metrics
                where trim(site_status_icon) = 'Ongoing'),
				
/*screen_count AS (
				select count(*) as screen_cnt FROM tas3681_101_ctms.subject_visits 
				where visit_reference = 'SCR'),*/


     studyplannedrecruitment_data AS (
                SELECT  'TAS120_201'::text AS studyid,
                        'Enrollment'::text AS category,
                        'Monthly'::text AS frequency,
                       max(nullif("ENRDAT",''))::date AS enddate,
                        'Planned'::text AS type,
                        count("ENRYN") ::int AS recruitmentcount
               From tas120_201."ENR"--,  Subject_count sc
               where "ENRYN" = 'Yes'
               union all
                   SELECT  'TAS120_201'::text AS studyid,
                        'Site Activation'::text AS category,
                        'Monthly'::text AS frequency,
                        max("siv_date_planned")::date AS enddate,
                        'Planned'::text AS type,
                        site_cnt ::int AS recruitmentcount
            From tas120_201_ctms.milestone_status_site, site_count sc
			where "siv_date_planned" not in ('NULL','N/A') 
             group by 1,2,3,5,6
			 union all
                 SELECT  'TAS120_201'::text AS studyid,
                        'SUBJECT SCREENED'::text AS category,
                        'Monthly'::text AS frequency,
                        max(COALESCE("MinCreated" ,"RecordDate"))::date AS enddate,
                        'Planned'::text AS type,
                        count("Folder") ::int AS recruitmentcount
         From tas120_201."DM"
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


