create or replace table strong-harbor-474616-p4.assignment3_kyp.patients_stg as 
select id as patient_id,
name as patient_name,
surname as patient_surname, 
gender as patient_gender, 
parse_date("%m/%d/%Y", birth_date) as birth_date_patient,
cast(age as int64) as patient_age,
doctor_id,
phone_number,
days_in_hospital 
from strong-harbor-474616-p4.assignment3_kyp.patients;

create or replace table strong-harbor-474616-p4.assignment3_kyp.doctors_stg as 
select id as doctor_id,
name as doctor_name,
speciality as doctor_speciality,
cast(years_of_experience as int64) as years_of_experience, 
gender as doctor_gender, 
cast(REPLACE(salary, '$', '') as float64) as salary,
from strong-harbor-474616-p4.assignment3_kyp.doctors;

create or replace table strong-harbor-474616-p4.assignment3_kyp.medication_stg as 
select id as med_id,
name as med_name,
cast(REPLACE(price, '$', '') as float64) as med_price_usd,
cast(REPLACE(dosage, 'mg', '') as float64) as med_dosage_mg, 
cast(illness_id as int64) as illness_id, 
cast(prescribed_by as int64) as prescribed_by, 
from strong-harbor-474616-p4.assignment3_kyp.medications;

create or replace table strong-harbor-474616-p4.assignment3_kyp.illness_records_stg as 
select record_id, 
cast(patient_id as int64) as patient_id, 
cast(illness_id as int64) as illness_id, 
trim(severity) as severity
from strong-harbor-474616-p4.assignment3_kyp.illness_records;

create or replace table strong-harbor-474616-p4.assignment3_kyp.illnesses_stg as 
select i.id as illness_id,
i.name as illness_name, 
cast(r.patient_id as int64) as patient_id, 
r.severity as illness_severity,
cast(i.doctor_name as int64) as doctor_id, 
i.symptoms as illness_symptoms
from strong-harbor-474616-p4.assignment3_kyp.illness_records_stg r
left join strong-harbor-474616-p4.assignment3_kyp.illnesses i
on r.illness_id = i.id;

create or replace table strong-harbor-474616-p4.assignment3_kyp.patients_dim as
select patient_id, patient_name, patient_surname, patient_gender, birth_date_patient, patient_age, doctor_id, phone_number
from strong-harbor-474616-p4.assignment3_kyp.patients_stg;

create or replace table strong-harbor-474616-p4.assignment3_kyp.illnesses_dim as
select illness_id, illness_name, illness_symptoms
from strong-harbor-474616-p4.assignment3_kyp.illnesses_stg;

create or replace table strong-harbor-474616-p4.assignment3_kyp.medications_dim as
select med_id, med_name, med_dosage_mg
from strong-harbor-474616-p4.assignment3_kyp.medication_stg; 

create or replace table strong-harbor-474616-p4.assignment3_kyp.doctors_dim as
select doctor_id, doctor_name, doctor_speciality, years_of_experience, doctor_gender
from strong-harbor-474616-p4.assignment3_kyp.doctors_stg;

create or replace table strong-harbor-474616-p4.assignment3_kyp.treatment_fact as 
select ir.record_id as treatment_id, 
ir.patient_id, 
ir.illness_id, 
me.med_id as medication_id, 
me.prescribed_by as prescriber_doctor_id, 
p.doctor_id as doctor_curator_id, 
(me.med_price_usd * p.days_in_hospital) as calculated_cost,
p.days_in_hospital as treatment_duration, 
me.med_price_usd, me.med_dosage_mg, ir.severity as illness_severity
from strong-harbor-474616-p4.assignment3_kyp.illness_records_stg ir
left join strong-harbor-474616-p4.assignment3_kyp.medication_stg me 
on ir.illness_id = me.illness_id
left join strong-harbor-474616-p4.assignment3_kyp.patients_stg p
on ir.patient_id = p.patient_id
 
