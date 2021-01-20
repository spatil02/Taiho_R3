/*
CCDM TV mapping
Notes: Standard mapping to CCDM TV table
*/

WITH included_studies AS (
	SELECT studyid FROM study
),

/*tv_scheduled AS (
SELECT 'TAS0612-101' as studyid, '1' as visitnum, 'Screening' as visit, 99999 as visitdy , 0 as  "visitwindowbefore", 0 as "visitwindowafter"
union all
select 'TAS0612-101' as studyid,'2' as visitnum, 'Cycle 01' as visit, 0 as visitdy , 0 as  "visitwindowbefore", 0 as "visitwindowafter"
union all
select 'TAS0612-101' as studyid,'3' as visitnum, 'Day 1 of Cycle 01' as visit, 0 as visitdy , 0 as  "visitwindowbefore", 0 as "visitwindowafter"
union all
select 'TAS0612-101' as studyid,'4' as visitnum, 'Day 8 of Cycle 01' as visit, 0 as visitdy , 0 as  "visitwindowbefore", 0 as "visitwindowafter"
union all
select 'TAS0612-101' as studyid,'5' as visitnum, 'Day 15 of Cycle 01' as visit, 0 as visitdy , 0 as  "visitwindowbefore", 0 as "visitwindowafter"
union all
select 'TAS0612-101' as studyid,'6' as visitnum, 'Day 22 of Cycle 01' as visit, 0 as visitdy , 0 as  "visitwindowbefore", 0 as "visitwindowafter"
union all
select 'TAS0612-101' as studyid,'7' as visitnum, 'Cycle' as visit, 0 as visitdy , 0 as  "visitwindowbefore", 0 as "visitwindowafter"
union all
select 'TAS0612-101' as studyid,'8' as visitnum, 'Day 1 of Cycle' as visit, 0 as visitdy , 0 as  "visitwindowbefore", 0 as "visitwindowafter"
union all
select 'TAS0612-101' as studyid,'9' as visitnum, 'Day 15 of Cycle' as visit, 0 as visitdy , 0 as  "visitwindowbefore", 0 as "visitwindowafter"
union all
select 'TAS0612-101' as studyid,'10' as visitnum, 'Unscheduled Visit' as visit, 99999 as visitdy , 0 as  "visitwindowbefore", 0 as "visitwindowafter"
union all
select 'TAS0612-101' as studyid,'11' as visitnum, 'Safety Follow-Up' as visit, 99999 as visitdy , 0 as  "visitwindowbefore", 0 as "visitwindowafter"
union all
select 'TAS0612-101' as studyid,'12' as visitnum, 'End of Treatment' as visit, 99999 as visitdy , 0 as  "visitwindowbefore", 0 as "visitwindowafter"
union all
select 'TAS0612-101' as studyid,'13' as visitnum, 'AE/CM/PROC' as visit, 99999 as visitdy , 0 as  "visitwindowbefore", 0 as "visitwindowafter"
union all
select 'TAS0612-101' as studyid,'14' as visitnum, 'Tumor Assessments' as visit, 99999 as visitdy , 0 as  "visitwindowbefore", 0 as "visitwindowafter"
union all
select 'TAS0612-101' as studyid,'15' as visitnum, 'Tumor Assessment' as visit, 99999 as visitdy , 0 as  "visitwindowbefore", 0 as "visitwindowafter"
union all
select 'TAS0612-101' as studyid,'16' as visitnum, 'Survival Follow-Up' as visit, 99999 as visitdy , 0 as  "visitwindowbefore", 0 as "visitwindowafter"
union all
select 'TAS0612-101' as studyid,'17' as visitnum, 'General Folder' as visit, 99999 as visitdy , 0 as  "visitwindowbefore", 0 as "visitwindowafter"
union all
select 'TAS0612-101' as studyid,'18' as visitnum, 'End of Study' as visit, 99999 as visitdy , 0 as  "visitwindowbefore", 0 as "visitwindowafter"
union all
select 'TAS0612-101' as studyid,'19' as visitnum, 'Death' as visit, 99999 as visitdy , 0 as  "visitwindowbefore", 0 as "visitwindowafter"
),*/

tv_data AS (
	/*SELECT
		'TAS0612-101'::text AS studyid,
		coalesce(visitnum,'99')::numeric AS visitnum,
		visit::text AS visit,
		visitdy::int AS visitdy,
		visitwindowbefore::int AS visitwindowbefore,
		visitwindowafter::int AS visitwindowafter
	FROM tv_scheduled tvs*/
	
	
	SELECT
		DISTINCT sv.studyid::text AS studyid,
		coalesce(sv."visitnum", 99)::numeric AS visitnum,
		sv."visit"::text AS visit,
		99999::int AS visitdy,
		0::int AS visitwindowbefore,
		0::int AS visitwindowafter
	FROM sv 
	--WHERE (studyid, visit) NOT IN (SELECT DISTINCT studyid, visit FROM tv_scheduled)

	UNION ALL
	SELECT 
		DISTINCT studyid::text AS studyid,
		'99'::numeric AS visitnum,
		visit::text AS visit,
		'99999'::int AS visitdy,
		0::int AS visitwindowbefore,
		0::int AS visitwindowafter
	FROM formdata 
	WHERE (studyid, visit) NOT IN (SELECT DISTINCT studyid, visit FROM sv) 
	--AND (studyid, visit) NOT IN (SELECT studyid, visit FROM tv_scheduled)
	)

SELECT
	/*KEY tv.studyid::text AS comprehendid, KEY*/
	tv.studyid::text AS studyid,
	tv.visitnum::numeric AS visitnum,
	tv.visit::text AS visit,
	tv.visitdy::int AS visitdy,
	tv.visitwindowbefore::int AS visitwindowbefore,
	tv.visitwindowafter::int AS visitwindowafter
	/*KEY , (tv.studyid || '~' || tv.visit)::text  AS objectuniquekey KEY*/
	/*KEY , now()::timestamp without time zone AS comprehend_update_time KEY*/
FROM tv_data tv
JOIN included_studies st ON (st.studyid = tv.studyid);

