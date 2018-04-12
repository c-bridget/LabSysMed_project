function [pat_structs] = get_patient_data(patients, diagnoses)
% Function to combine patient data with diagnoses data
% Input: Structure array of patients, structure array of diagnoses
% Output: Modified structure array of patients
% Function matches patients with EM visits by empi ID, concatenates
% diagnoses codes and dates as well as inpatient/outpatient status and
% number of different doctors and adds them as fields to the patient structure

nex = 1;
for p = 1:size(patients,1)
    if patients(p).race == 'BLACK OR AFRICAN AMERICAN'
        patients(p).race = string('Black-BLACK');
    end
    dia_codes = [];
    dia_dates = [];
    in_out = [];
    docs = [];
    for q = nex:size(diagnoses,1)
        % collect diagnoses data from EM visits for 1 patient based on empi
        if patients(p).empi == diagnoses(q).empi
            dia_codes = [dia_codes str2num(diagnoses(q).dia_code)];
            dia_dates = [dia_dates diagnoses(q).dia_date];
            in_out = [in_out string(diagnoses(q).inpatient_outpatient)];
            docs = [docs string(diagnoses(q).provider)];
        % when patient is finished, add to patient struct
        elseif patients(p).empi ~= diagnoses(q).empi
            patients(p).dia_codes = dia_codes;
            patients(p).dia_dates = dia_dates;
            patients(p).visits = length(dia_dates);
            patients(p).in_out = in_out;
            patients(p).docs = length(unique(docs));
            
            nex = q;
            break
        end
        % edge case for last patient
        if q == size(diagnoses,1)
            patients(end).dia_codes = dia_codes;
            patients(end).dia_dates = dia_dates;
            patients(end).visits = length(dia_dates);
            patients(end).in_out = in_out;
            patients(end).docs = length(unique(docs));
        end
    end
end

pat_structs = patients;
end

