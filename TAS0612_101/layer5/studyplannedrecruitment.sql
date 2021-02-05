/*
CCDM studyplannedrecruitment mapping
Notes: Standard mapping to CCDM studyplannedrecruitment table
*/

WITH included_studies AS (
                SELECT studyid FROM study ),
                

                
 site_count AS (
                SELECT case when "siv"='NULL' then null else "siv" end as siv_date FROM tas0612_101_ctms.site_startup_metrics
                where trim(site_status_icon) = 'Ongoing'),
				



     studyplannedrecruitment_data AS (
                 SELECT  'TAS0612_101'::text AS studyid,
                        'Enrollment'::text AS category,
                        'Monthly'::text AS frequency,
                       max(COALESCE("MinCreated" ,"RecordDate"))::date AS enddate,
                        'Planned'::text AS type,
                        count("IEYN") ::int AS recruitmentcount
               From tas0612_101."IE"--, 
			   where "IEYN" = 'Yes' 
               
               union all
                   SELECT  'TAS0612_101'::text AS studyid,
                        'Site Activation'::text AS category,
                        'Monthly'::text AS frequency,
                        
                        max(sc."siv_date")::date AS enddate,
                        'Planned'::text AS type,
                        count("site_status_icon")::int AS recruitmentcount
            From tas0612_101_ctms.site_startup_metrics,site_count sc
             where trim("site_status_icon") = 'Ongoing'
             union all
                    SELECT  'TAS0612_101'::text AS studyid,
                        'SUBJECT SCREENED'::text AS category,
                        'Monthly'::text AS frequency,
                        max("DMICDAT")::date AS enddate,
                        'Planned'::text AS type,
                        count("Folder") ::int AS recruitmentcount
            From tas0612_101."DM"
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


