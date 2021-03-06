/*
CCDM DS mapping
Notes: Standard mapping to CCDM DS table
*/

WITH included_subjects AS (
                SELECT DISTINCT studyid, siteid, usubjid FROM subject ),
                
 max_eot as (
 select eot."project",
 concat('TAS0612_101_',split_part(eot."SiteNumber",'_',2)) as siteid,
eot."Subject",
max(eot."EOTDAT") as eotdat
from tas0612_101."EOT" eot
group by 1,2,3
 ),

ds_data AS (

----Disposition Event: All Subjects----

SELECT  dm."project"::text AS studyid,
--dm."SiteNumber"::text AS siteid,
concat('TAS0612_101_',split_part(dm."SiteNumber",'_',2))::text AS siteid,
dm."Subject"::text AS usubjid,
1.0::NUMERIC AS dsseq, 
'All Subjects'::text AS dscat,
'All Subjects'::text AS dsterm,
null::DATE AS dsstdtc,
null::text AS dsscat 
from tas0612_101."DM" dm

union all 

--Disposition Event: Consented

SELECT  dm."project"::text AS studyid,
--dm."SiteNumber"::text AS siteid,
concat('TAS0612_101_',split_part(dm."SiteNumber",'_',2))::text AS siteid,
dm."Subject"::text AS usubjid,
2.0::NUMERIC AS dsseq, 
'Consent'::text AS dscat,
'Consented'::text AS dsterm,
dm."DMICDAT"::DATE AS dsstdtc,
null::text AS dsscat 
from tas0612_101."DM" dm

union all 

--Disposition Event: Failed Screen

SELECT  ie."project"::text AS studyid,
--ie."SiteNumber"::text AS siteid,
concat('TAS0612_101_',split_part(ie."SiteNumber",'_',2))::text AS siteid,
ie."Subject"::text AS usubjid,
2.1::NUMERIC AS dsseq, 
'Enrollment'::text AS dscat,
'Failed Screen'::text AS dsterm,
COALESCE(ie."MinCreated" ,ie."RecordDate")::DATE AS dsstdtc,
case 
	when nullif("IECAT",'') is null and nullif("IETESTCD",'') is null
					then null 
	else concat(concat("IECAT",' '),"IETESTCD") 					
end::text AS dsscat
from tas0612_101."IE" as ie
where ie."IEYN" = 'No'
  
union all 

--Disposition Event: Enrollment

SELECT  ie."project"::text AS studyid,
--ie."SiteNumber"::text AS siteid,
concat('TAS0612_101_',split_part(ie."SiteNumber",'_',2))::text AS siteid,
ie."Subject"::text AS usubjid,
3.0::NUMERIC AS dsseq,
'Enrollment'::text AS dscat,
'Enrolled'::text AS dsterm,
COALESCE(ie."MinCreated" ,ie."RecordDate")::DATE AS dsstdtc,
null::text AS dsscat  
from tas0612_101."IE" ie
where ie."IEYN" = 'Yes'

union all 

--Disposition Event: Early EOT

SELECT  eot."project"::text AS studyid,
--eot."SiteNumber"::text AS siteid,
concat('TAS0612_101_',split_part(eot."SiteNumber",'_',2))::text AS siteid,
eot."Subject"::text AS usubjid,
4.01::NUMERIC AS dsseq, 
'Treatment'::text AS dscat,
'Early EOT'::text AS dsterm,
eot."EOTDAT"::DATE AS dsstdtc,
eot."EOTREAS"::text AS dsscat  
from tas0612_101."EOT" eot
where eot."EOTDAT" in (select EOTDAT from max_eot )

union all 

--Disposition Event: Withdrawn

SELECT  es."project"::text AS studyid,
--es."SiteNumber"::text AS siteid,
concat('TAS0612_101_',split_part(es."SiteNumber",'_',2))::text AS siteid,
es."Subject"::text AS usubjid,
4.1::NUMERIC AS dsseq, 
'Completion'::text AS dscat,
'Withdrawn'::text AS dsterm,
es."EOSDAT"::DATE AS dsstdtc,
case when es."EOSREAS" = '' then 'Missing' else es."EOSREAS" end ::text AS dsscat  
from tas0612_101."EOS" es
where es."EOSREAS" <> 'Study Completion'


union all 

--Disposition Event: Study Completion

SELECT  es."project"::text AS studyid,
--es."SiteNumber"::text AS siteid,
concat('TAS0612_101_',split_part(es."SiteNumber",'_',2))::text AS siteid,
es."Subject"::text AS usubjid,
5.0::NUMERIC AS dsseq, 
'Completion'::text AS dscat,
'Completed'::text AS dsterm,
es."EOSDAT"::DATE AS dsstdtc,
es."EOSREAS"::text AS dsscat  
from tas0612_101."EOS" es
where es."EOSREAS" = 'Study Completion'


)

SELECT
        /*KEY (ds.studyid || '~' || ds.siteid || '~' || ds.usubjid)::text AS comprehendid,  KEY*/
        ds.studyid::text AS studyid,
        ds.siteid::text AS siteid,
        ds.usubjid::text AS usubjid,
        ds.dsseq::NUMERIC AS dsseq,
        ds.dscat::text AS dscat,
        ds.dsscat::text AS dsscat,
        ds.dsterm::text AS dsterm,
        ds.dsstdtc::DATE AS dsstdtc
         /*KEY, (ds.studyid || '~' || ds.siteid || '~' || ds.usubjid || '~' || ds.dsseq)::text  AS objectuniquekey KEY*/
        /*KEY , now()::TIMESTAMP WITH TIME ZONE AS comprehend_update_time KEY*/
FROM ds_data ds
JOIN included_subjects s ON (ds.studyid = s.studyid AND ds.siteid = s.siteid AND ds.usubjid = s.usubjid);

