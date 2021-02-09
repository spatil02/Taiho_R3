/*
CCDM SiteMonitoringVisitSchedule mapping
Notes: Standard mapping to CCDM SiteMonitoringVisitSchedule table
*/

WITH included_sites AS (
                SELECT DISTINCT studyid, siteid FROM site ),

     sitemonitoringvisitschedule_data AS (
               SELECT  replace("protocol_#",'-','_')::text AS studyid,
 						case when"site_#" is not null 
                        	then concat('TAS120_201_',"site_#")
                        	end::text AS siteid,
						 "account_name"::text  as visitname,
						 "planned_date" ::date AS plannedvisitdate
						 --,"siv_actual_or_planned"::text as smvvtype
				from tas120_202_ctms.monvisit_tracker)

SELECT 
        /*KEY (smvs.studyid || '~' || smvs.siteid)::text AS comprehendid, KEY*/
        smvs.studyid::text AS studyid,
        smvs.siteid::text AS siteid,
        smvs.visitname::text AS visitname,
        smvs.plannedvisitdate::date AS plannedvisitdate,
		smvs.smvvtype::text as smvvtype
        /*KEY , (smvs.studyid || '~' || smvs.siteid || '~' || smvs.visitname)::text  AS objectuniquekey KEY*/
        /*KEY , now()::timestamp with time zone AS comprehend_update_time KEY*/
FROM sitemonitoringvisitschedule_data smvs
JOIN included_sites si ON (smvs.studyid = si.studyid AND smvs.siteid = si.siteid); 