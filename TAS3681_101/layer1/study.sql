/*
CCDM Study mapping
Notes: Standard mapping to CCDM Study table
*/


WITH study_data AS (
                    SELECT  'TAS3681_101'::text AS studyid,
                            'TAS3681_101'::text AS studyname,
                            'A Phase 1, Open-Label, Non-Randomized, Safety, Tolerability, and
Pharmacokinetic Study of TAS3681 in Patients with Metastatic Castration-Resistant Prostate Cancer'::text AS studydescription,
                            'Active'::text AS studystatus,
                            'Phase 1'::text AS studyphASe,
                            'Taiho'::text AS studysponsor,
                            'Oncology'::text AS therapeuticarea,
                            null::text AS program,
                            'Metastatic Castration-Resistant Prostate Cancer'::text AS medicalindication,
                            '13-Aug-2015'::date AS studystartdate,
                            '17-Jan-2023'::date AS studycompletiondate,
                            null::date AS studystatusdate,
                            null::boolean AS isarchived )

SELECT 
        /*KEY s.studyid::text AS comprehendid, KEY*/
        s.studyid::text AS studyid,
        s.studyname::text AS studyname,
        s.studydescription::text AS studydescription,
        s.studystatus::text AS studystatus,
        s.studyphase::text AS studyphase,
        s.studysponsor::text AS studysponsor,
        s.therapeuticarea::text AS therapeuticarea,
        s.program::text AS program,
        s.medicalindication::text AS medicalindication,
        s.studystartdate::date AS studystartdate,
        s.studycompletiondate::date AS studycompletiondate,
        s.studystatusdate::date AS studystatusdate,
        s.isarchived::boolean AS isarchived 
        /*KEY , now()::timestamp with time zone AS comprehend_update_time KEY*/
FROM study_data s;
