/*
CCDM AE mapping
Notes: Standard mapping to CCDM AE table
*/

WITH included_subjects AS (
    SELECT DISTINCT studyid, siteid, usubjid FROM subject),


    ae_data AS (
SELECT "project"::text AS studyid,
                       ae."SiteNumber"::text AS siteid,
                       ae."Subject"::text AS usubjid,
                       ae."AETERM"::text AS aeterm,
                       ae."AETERM"::text AS aeverbatim,
                       ae."AETERM_SOC"::text AS aebodsys,
                       ae."AESTDAT"::timestamp without time zone AS aestdtc,
                       ae."AEENDAT"::timestamp without time zone AS aeendtc,
					   case when(ae."AEONSGR")= '0' then 'G0'
							when(ae."AEONSGR")= '1' then 'G1'
							when(ae."AEONSGR")= '2' then 'G2'
							when(ae."AEONSGR")= '3' then 'G3'
							when(ae."AEONSGR")= '4' then 'G4'
							when(ae."AEONSGR")= '5' then 'G5'
							end ::text AS aesev,
					   case when lower(ae."AESER")='yes' then 'Serious' 
                       when lower(ae."AESER")='no' then 'Non-Serious' 
                       else 'Unknown' end::text AS aeser ,
					   
					   CASE WHEN lower("AEREL")=lower('Reasonably Possible') THEN 'Yes' 
					   WHEN lower("AEREL") =lower('Not Reasonably Possible') THEN 'No'  
					   else 'Unknown' END::text AS aerelnst,

					   ae."AESTDAT"::time without time zone AS aesttm,
					   ae."AEENDAT"::time without time zone AS aeentm,
                       ae."AETERM_LLT" ::text AS aellt,
					   nullif(ae."AETERM_LLT_CD"::text,''):: int AS aelltcd,
					   nullif(ae."AETERM_PT_CD"::text,''):: int AS aeptcd,
					   ae."AETERM_HLT" ::text AS aehlt,
					   nullif(ae."AETERM_HLT_CD"::text,''):: int AS aehltcd,
					   ae."AETERM_HLGT" ::text AS aehlgt,
					   nullif(ae."AETERM_HLGT_CD"::text,''):: int AS aehlgtcd,
					   Null:: int AS aebdsycd,
					   ae."AETERM_SOC"::text AS aesoc,
					   nullif(ae."AETERM_SOC_CD"::text,'') :: int AS aesoccd,
					   ROW_NUMBER () OVER (PARTITION BY "project", ae."SiteNumber", ae."Subject" ORDER BY ae."AESTDAT") as aeseq,
                      coalesce(ae."AEACTSN",ae."AEACTSDR",ae."AEACTSID",ae."AEACTSDQ")::text  AS aeacn
		        FROM tas3681_101."AE" ae 
  )

SELECT
        /*KEY (ae.studyid || '~' || ae.siteid || '~' || ae.usubjid)::text AS comprehendid, KEY*/
        ae.studyid::text AS studyid,
        ae.siteid::text AS siteid,
        ae.usubjid::text AS usubjid,
        ae.aeterm::text AS aeterm,
        ae.aeverbatim::text AS aeverbatim,
        ae.aebodsys::text AS aebodsys,
        ae.aestdtc::timestamp without time zone AS aestdtc, --client requested change
        ae.aeendtc::timestamp without time zone AS aeendtc, --client requested change
        ae.aesev::text AS aesev,
        ae.aeser::text AS aeser,
        ae.aerelnst::text AS aerelnst,
        ae.aeseq::int AS aeseq,
        ae.aesttm::time without time zone AS aesttm,
        ae.aeentm::time without time zone AS aeentm,
		ae.aellt::text AS aellt,
		ae.aelltcd::int AS aelltcd,
		ae.aeptcd::int AS aeptcd,
		ae.aehlt::text AS aehlt,
		ae.aehltcd::int AS aehltcd,
		ae.aehlgt::text AS aehlgt,
		ae.aehlgtcd::int AS aehlgtcd,
		ae.aebdsycd::int AS aebdsycd,
		ae.aesoc::text AS aesoc,
		ae.aesoccd::int AS aesoccd,
		ae.aeacn::text AS aeacn
		
		
        /*KEY , (ae.studyid || '~' || ae.siteid || '~' || ae.usubjid || '~' || ae.aeseq)::text  AS objectuniquekey KEY*/
        /*KEY , now()::timestamp without time zone AS comprehend_update_time KEY*/
FROM ae_data ae
JOIN included_subjects s ON (ae.studyid = s.studyid AND ae.siteid = s.siteid AND ae.usubjid = s.usubjid);
