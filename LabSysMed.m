
%% import and compile data

dem_file = 'dem.csv';
dia_file = 'dia.csv';

dem_data = sortrows(readtable(dem_file, 'TextType', 'string'),1);
dia_data = sortrows(readtable(dia_file),1);

patients = table2struct(dem_data);
diagnoses = table2struct(dia_data);

pat_diag = get_patient_data(patients, diagnoses);

%% calculate comorbidity
for p=1:size(pat_diag, 1)
    pat_diag(p).comorb = mean(comorbidity_calc(pat_diag(p)));
end
%% breaking down
fem_pat = []; mal_pat = []; 
afam = []; asam = []; natam = []; hisp = []; white = [];
deceased = []; alive = [];
for p=1:size(pat_diag, 1)
    if pat_diag(p).gender == 'female'
        fem_pat = [fem_pat pat_diag(p)];
    else
        mal_pat = [mal_pat pat_diag(p)];
    end
    if pat_diag(p).race == 'American Indian-AMERICAN INDIAN'
        natam = [natam pat_diag(p)];
    elseif pat_diag(p).race == 'Asian-ASIAN'
        asam = [asam pat_diag(p)];
    elseif pat_diag(p).race == 'Black-BLACK'
        afam = [afam pat_diag(p)];
    elseif pat_diag(p).race == 'Hispanic-HISPANIC'
        hisp = [hisp pat_diag(p)];
    elseif pat_diag(p).race == 'White-WHITE'
        white = [white pat_diag(p)];
    end
    if pat_diag(p).vital_status == 'deceased'
        deceased = [deceased pat_diag(p)];
    else
        alive = [alive pat_diag(p)];
    end
end

%% describe patient cohort
% colormap summer
% % graphs
% fem_races = histcounts(categorical([fem_pat.race]));
% mal_races = histcounts(categorical([mal_pat.race]));
% races = {'American Indian', 'Asian', 'Black or African American', 'Black', 'Hispanic', 'White'};
% 
% y1 = [fem_races' mal_races'];
% figure(1); clf
% bar(categorical(races), y, 'stacked')
% legend('female', 'male')
% [fem_ages, ages] = histcounts([fem_pat.age]);
% [mal_ages] = histcounts([mal_pat.age]);
% 
% y2 = [fem_ages' mal_ages'];
% figure(2); clf
% bar(ages(1:end-1), y2, 'stacked')
% legend('female', 'male')


%% comorbidity 
% significantly lower avg comorbidity for afam and women
[h1, p1] = ttest2([afam.comorb], [white.comorb])
[h2, p2] = ttest2([mal_pat.comorb], [fem_pat.comorb])
% controlling for number of visits, how many unique doctors do patients get?


% comorbidity + number of visits
X1 = [ones(400,1) [pat_diag.comorb]' [pat_diag.visits]'];
b1 = regress([pat_diag.docs]', X1)

X2 = [ones(size([afam.comorb]))' [afam.comorb]' [afam.visits]'];
b2 = regress([afam.docs]', X2)




            