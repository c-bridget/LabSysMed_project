
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
fem_pat=[]; mal_pat=[]; natam=[]; asam=[]; afam=[]; white=[]; hisp=[];
deceased=[]; alive=[];
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
colormap summer
% graphs
figure(1); clf
subplot(1,2,1)
histogram(categorical([fem_pat.race]), 'FaceColor', [0.9290, 0.6940, 0.1250])
title('Female patients')
ylabel('# of patients')
axis([0 6 0 150])
subplot(1,2,2)
histogram(categorical([mal_pat.race]), 'FaceColor', [0.3010, 0.7450, 0.9330])
title('Male patients')
ylabel('# of patients')
axis([0 6 0 150])

figure(2); clf
subplot(1,2,1)
histogram([fem_pat.age], 'FaceColor', [0.9290, 0.6940, 0.1250])
title('Female patients')
ylabel('# of patients')
xlabel('Age')
axis([0 100 0 60])
subplot(1,2,2)
histogram([mal_pat.age], 'FaceColor', [0.3010, 0.7450, 0.9330])
title('Male patients')
ylabel('# of patients')
xlabel('Age')
axis([0 100 0 60])
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
% unique doctors v. comorbidity + number of visits - 
X0 = [ones(size([pat_diag.comorb]))' [pat_diag.comorb]' [pat_diag.visits]'];
b0 = regress([pat_diag.docs]', X0)
X1 = [ones(size([white.comorb]))' [white.comorb]' [white.visits]'];
b1 = regress([white.docs]', X1)

figure(1); clf
scatter3([white.comorb], [white.visits], [white.docs], 'filled')

X2 = [ones(size([afam.comorb]))' [afam.comorb]' [afam.visits]'];
b2 = regress([afam.docs]', X2)

figure(2); clf
scatter3([afam.comorb], [afam.visits], [afam.docs], 'filled')

X3 = [ones(size([fem_pat.comorb]))' [fem_pat.comorb]' [fem_pat.visits]'];
b3 = regress([fem_pat.docs]', X3)
% figure(3); clf
% scatter3([fem_pat.comorb], [fem_pat.visits], [fem_pat.docs], 'filled')
X4 = [ones(size([mal_pat.comorb]))' [mal_pat.comorb]' [mal_pat.visits]'];
b4 = regress([mal_pat.docs]', X4)
% figure(4); clf
% scatter3([mal_pat.comorb], [mal_pat.visits], [mal_pat.docs], 'filled')

%% diagnostic codes
diag_edges = [0 139.8 239.9 279.9 289.9 319 389.9 459.9 519.9 527.9 629.9 ...
    679.14 709.9 739.9 759.9 779.9 799.9 999.9];
diagprop = @(diag_counts) (histcounts(diag_counts, diag_edges)/size(diag_counts,2) * 100);
figure(1); clf           
subplot(2,2,2)
bar(diagprop([afam.dia_codes]))
title('African American')
ylabel('Proportion of diagnosis code occurrence (%)')
axis([0 18 0 25])
subplot(2,2,1)
bar(diagprop([white.dia_codes]))
title('White')
ylabel('Proportion of diagnosis code occurrence (%)')
axis([0 18 0 25])
subplot(2,2,3)
bar(diagprop([asam.dia_codes]))
title('Asian')
ylabel('Proportion of diagnosis code occurrence (%)')
axis([0 18 0 25])
subplot(2,2,4)
bar(diagprop([hisp.dia_codes]))
title('Hispanic')
ylabel('Proportion of diagnosis code occurrence (%)')
axis([0 18 0 25])

figure(2); clf
subplot(1,2,2)
bar(diagprop([mal_pat.dia_codes]),'FaceColor', [0.3010, 0.7450, 0.9330])
title('Male')
ylabel('Proportion of diagnosis code occurrence (%)')
axis([0 18 0 35])
subplot(1,2,1)
bar(diagprop([fem_pat.dia_codes]), 'FaceColor', [0.9290, 0.6940, 0.1250])
title('Female')
ylabel('Proportion of diagnosis code occurrence (%)')
axis([0 18 0 35])

% diagnosis code doesn't seem to change with increasing visits - issue not
% being taken care of before discharge?

    