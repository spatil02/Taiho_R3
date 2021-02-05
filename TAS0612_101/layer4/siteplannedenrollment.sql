/*
CCDM SitePlannedEnrollment mapping
Notes: Standard mapping to CCDM SitePlannedEnrollment table
*/

WITH included_sites AS (
                SELECT DISTINCT studyid, siteid FROM site ),

     siteplannedenrollment_data AS (
                SELECT  'TAS0612_101'::text AS studyid,
                        "sitenumber"::text AS siteid,
                        'Monthly'::text AS frequency,
                        "last_subject_1st_visit_planned"::date AS enddate,
                        'Planned'::text AS enrollmenttype,
                        null::NUMERIC AS enrollmentcount
				from tas0612_101_ctms."startup" 		)

SELECT 
        /*KEY (spe.studyid || '~' || spe.siteid)::text AS comprehendid, KEY*/
        spe.studyid::text AS studyid,
        spe.siteid::text AS siteid,
        spe.frequency::text AS frequency,
        spe.enddate::date AS enddate,
        spe.enrollmenttype::text AS enrollmenttype,
        spe.enrollmentcount::NUMERIC AS enrollmentcount
        /*KEY , (spe.studyid || '~' || spe.siteid || '~' || spe.enrollmentType || '~' || spe.frequency || '~' || spe.endDate)::text  AS objectuniquekey KEY*/
        /*KEY , now()::timestamp with time zone AS comprehend_update_time KEY*/
FROM siteplannedenrollment_data spe
JOIN included_sites si ON (spe.studyid = si.studyid AND spe.siteid = si.siteid);
 