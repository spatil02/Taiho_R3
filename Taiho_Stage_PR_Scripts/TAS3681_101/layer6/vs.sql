/*
CCDM VS mapping
Notes: Standard mapping to CCDM VS table
*/

WITH included_subjects AS (
                SELECT DISTINCT studyid, siteid, usubjid FROM subject),

     vs_data AS (
                select 
                     studyid,
                     siteid, 
                     usubjid,
                     (row_number() over (partition by studyid, siteid, usubjid order by vsdtc, vstm))::int as vsseq,
                     vstestcd,
                     vstest,
                     vscat,
                     vsscat,
                     vspos,
                     vsorres,
                     vsorresu,
                     vsstresn,
                     vsstresu,
                     vsstat,
                     vsloc,
                     vsblfl,
                     visit,
                     vsdtc,
                     vstm
                     from
(SELECT  vs."project"::text AS studyid,
                    vs."SiteNumber"::text AS siteid, 
				 	vs."Subject"::text    AS usubjid,
						Null::int AS vsseq,
                    vstestcd::text AS vstestcd,
                    vstest::text AS vstest,
                    vscat::text AS vscat,
                    vsscat::text AS vsscat,
                    null::text AS vspos,
                    vsorres::text AS vsorres,
                    vsorresu::text AS vsorresu,
                    vsstresn::numeric AS vsstresn,
                    vsstresu::text AS vsstresu,
                    null::text AS vsstat,
                    null::text AS vsloc,
                    null::text AS vsblfl,
                    REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE("InstanceName",'<WK[0-9]D[0-9]/>\sEscalation',''),'<WK[0-9]D[0-9][0-9]/>\sEscalation',''),'Escalation',''):: text as visit,
                    vs."VSDAT"::timestamp without time zone AS vsdtc,
                    null::time without time zone AS vstm
                FROM tas3681_101."VS" vs
                cross join lateral(
				values
					('Diastolic Blood Pressure'	, 'VSDBP' , 'Vital Signs','Vital Signs', "VSDBP"	,"VSDBP_Units"	  ,"VSDBP"	,"VSDBP_Units"),
					('Systolic Blood Pressure'	, 'VSSBP' , 'Vital Signs','Vital Signs', "VSSBP"	,"VSSBP_Units"	  ,"VSSBP"	,"VSSBP_Units"),
					('Heart Rate'			    , 'VSHR'  , 'Vital Signs','Vital Signs', "VSHR"	    ,"VSHR_Units"	  ,"VSHR"	,"VSHR_Units"),
					('Respiratory Rate'			, 'VSRESP', 'Vital Signs','Vital Signs', "VSRESP"	,"VSRESP_Units"	  ,"VSRESP"	,"VSRESP_Units"),
					('Temperature'				, 'VSTEMP', 'Vital Signs','Vital Signs', "VSTEMP"	,"VSTEMP_Units"	  ,"VSTEMP"	,"VSTEMP_Units"),
					('Weight'					, 'VSWT'  , 'Vital Signs','Vital Signs', "VSWT"		,"VSWT_Units"	  ,"VSWT"	,"VSWT_Units")
					
				)as t
					(vstest,vstestcd,vscat,vsscat,vsorres,vsorresu,vsstresn,vsstresu)
								
				union 
				
				-- TAS3681-101  VSB
                SELECT  vsb."project"::text AS studyid,
                    vsb."SiteNumber"::text AS siteid, 
				 	vsb."Subject"::text    AS usubjid,
						Null::int AS vsseq,
                    vstestcd::text AS vstestcd,
                    vstest::text AS vstest,
                    vscat::text AS vscat,
                    vsscat::text AS vsscat,
                    null::text AS vspos,
                    vsorres::text AS vsorres,
                    vsorresu::text AS vsorresu,
                    vsstresn::numeric AS vsstresn,
                    vsstresu::text AS vsstresu,
                    null::text AS vsstat,
                    null::text AS vsloc,
                    null::text AS vsblfl,
                    vsb."FolderName"::text AS visit,
                    vsb."VSDAT"::timestamp without time zone AS vsdtc,
                    null::time without time zone AS vstm
                FROM tas3681_101."VSB" vsb
                cross join lateral(
				values
					('Diastolic Blood Pressure'	, 'VSDBP' , 'Vital Signs','Vital Signs', "VSDBP"	,"VSDBP_Units"	  ,"VSDBP"	,"VSDBP_Units"),
					('Systolic Blood Pressure'	, 'VSSBP' , 'Vital Signs','Vital Signs', "VSSBP"	,"VSSBP_Units"	  ,"VSSBP"	,"VSSBP_Units"),
					('Heart Rate'			    , 'VSHR'  , 'Vital Signs','Vital Signs', "VSHR"	    ,"VSHR_Units"	  ,"VSHR"	,"VSHR_Units"),
					('Respiratory Rate'			, 'VSRESP', 'Vital Signs','Vital Signs', "VSRESP"	,"VSRESP_Units"	  ,"VSRESP"	,"VSRESP_Units"),
					('Temperature'				, 'VSTEMP', 'Vital Signs','Vital Signs', "VSTEMP"	,"VSTEMP_Units"	  ,"VSTEMP"	,"VSTEMP_Units"),
					('Weight'					, 'VSWT'  , 'Vital Signs','Vital Signs', "VSWT"		,"VSWT_Units"	  ,"VSWT"	,"VSWT_Units"),
					('Height'					, 'VSHT'  , 'Vital Signs','Vital Signs', "VSHT"		,"VSHT_Units"	  ,"VSHT"	,"VSHT_Units")
					
				)as t
					(vstest,vstestcd,vscat,vsscat,vsorres,vsorresu,vsstresn,vsstresu)) eg
	
     ),
     all_data as (
                SELECT
                    vs.studyid::text AS studyid,
                    vs.siteid::text AS siteid,
                    vs.usubjid::text AS usubjid,
                    vs.vsseq::int as vsseq,
                    vs.vstestcd::text AS vstestcd,
                    vs.vstest::text AS vstest,
                    vs.vscat::text AS vscat,
                    vs.vsscat::text AS vsscat,
                    vs.vspos::text AS vspos,
                    vs.vsorres::text AS vsorres,
                    vs.vsorresu::text AS vsorresu,
					vs.vsstresn::numeric AS vsstresn,
					vs.vsstresu ::text AS vsstresu,
					vs.vsstat::text AS vsstat,
                    vs.vsloc::text AS vsloc,
                    vs.vsblfl::text AS vsblfl,
                    vs.visit::text AS visit,
                    vs.vsdtc::text::timestamp without time zone AS vsdtc,
                    vs.vstm::text::time without time zone AS vstm
                FROM vs_data vs
    )

SELECT
        /*KEY (vs.studyid || '~' || vs.siteid || '~' || vs.usubjid)::text AS comprehendid, KEY*/
        vs.studyid::text AS studyid,
        vs.siteid::text AS siteid,
        vs.usubjid::text AS usubjid,
        vs.vsseq::int AS vsseq, 
        vs.vstestcd::text AS vstestcd,
        vs.vstest::text AS vstest,
        vs.vscat::text AS vscat,
        vs.vsscat::text AS vsscat,
        vs.vspos::text AS vspos,
        vs.vsorres::text AS vsorres,
        vs.vsorresu::text AS vsorresu,
        vs.vsstresn::numeric AS vsstresn,
        vs.vsstresu::text AS vsstresu,
        vs.vsstat::text AS vsstat,
        vs.vsloc::text AS vsloc,
        vs.vsblfl::text AS vsblfl,
        vs.visit::text AS visit,
        vs.vsdtc::timestamp without time zone AS vsdtc,
        vs.vstm::time without time zone AS vstm
        /*KEY , (vs.studyid || '~' || vs.siteid || '~' || vs.usubjid || '~' || vs.vsseq)::text  AS objectuniquekey KEY*/
        /*KEY , now()::timestamp without time zone AS comprehend_update_time KEY*/
FROM all_data vs
JOIN included_subjects s ON (vs.studyid = s.studyid AND vs.siteid = s.siteid AND vs.usubjid = s.usubjid);

