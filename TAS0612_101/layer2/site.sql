/*
CCDM Site mapping
Client:taiho
Limits added for PR build efficiency (not applied for standard builds)
Notes: Standard mapping to CCDM Site table
*/

WITH included_studies AS (
                SELECT studyid FROM study ),

    site_data AS (
            SELECT  'TAS0612_101'::text AS studyid,
                        "oid"::text AS siteid,
                        "name"::text AS sitename,
                        'Syneos'::text AS croid,
                        'Syneos'::text AS sitecro,
						null::text AS siteinvestigatorname,
						null::text AS sitecraname,
                        case
							when length(trim(SUBSTRING( oid,POSITION('_' in oid)+1)))=3
								 THEN CASE when substring(substring(oid,POSITION('_' in oid)+1),1,1)='1' then 'United States of America'
										   when substring(substring(oid,POSITION('_' in oid)+1),1,1)='2' then 'France'
										end
						 end::text AS sitecountry,
                        case
							when length(trim(SUBSTRING( oid,POSITION('_' in oid)+1)))=3
								 THEN CASE when substring(substring(oid,POSITION('_' in oid)+1),1,1)='1' then 'North America'
										   when substring(substring(oid,POSITION('_' in oid)+1),1,1)='2' then 'Europe'
										end
						 end ::text AS siteregion,
                        nullif("effectivedate",'')::date AS sitecreationdate,
                        nullif("effectivedate",'')::date AS siteactivationdate,
                        null::date AS sitedeactivationdate,
                        null::text AS siteaddress1,
                        null::text AS siteaddress2,
                        null::text AS sitecity,
                        null::text AS sitestate,
                        null::text AS sitepostal,
                        null::text AS sitestatus,
                        null::date AS sitestatusdate
			From TAS0612_101."__sites")
			

SELECT 
        /*KEY (s.studyid || '~' || s.siteid)::text AS comprehendid, KEY*/
        s.studyid::text AS studyid,
        s.siteid::text AS siteid,
        s.sitename::text AS sitename,
        s.croid::text AS croid,
        s.sitecro::text AS sitecro,
        s.sitecountry::text AS sitecountry,
        s.siteregion::text AS siteregion,
        s.sitecreationdate::date AS sitecreationdate,
        s.siteactivationdate::date AS siteactivationdate,
        s.sitedeactivationdate::date AS sitedeactivationdate,
        s.siteinvestigatorname::text AS siteinvestigatorname,
        s.sitecraname::text AS sitecraname,
        s.siteaddress1::text AS siteaddress1,
        s.siteaddress2::text AS siteaddress2,
        s.sitecity::text AS sitecity,
        s.sitestate::text AS sitestate,
        s.sitepostal::text AS sitepostal,
        s.sitestatus::text AS sitestatus,
        s.sitestatusdate::date AS sitestatusdate
        /*KEY , now()::timestamp with time zone AS comprehend_update_time KEY*/
FROM site_data s 
JOIN included_studies st ON (s.studyid = st.studyid);

