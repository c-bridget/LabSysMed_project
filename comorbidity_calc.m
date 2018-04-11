function [ comorbidity ] = comorbidity_calc( patient )
%Calculate comorbidity score based on code from Gagne, et al.
weights = [];
for d=1:length(patient.dia_codes)
    weight = 0;
    ICDnum = patient.dia_codes(d);
    ICD = num2str(patient.dia_codes(d));
    if contains(ICD, '.')
        ICD = strcat(ICD, '000');
    else
        ICD = strcat(ICD, '.000');
    end
    % metastatic romano
    if strcmp(ICD(1:3),'196') || strcmp(ICD(1:3),'197') || strcmp(ICD(1:3),'198') || strcmp(ICD(1:3),'199')
        weight = weight + 5;
    end
    % chf romano
    if strcmp(ICD,'402.01') || strcmp(ICD,'402.11') || strcmp(ICD,'402.91') || strcmp(ICD(1:4),'429.3') || ...
            strcmp(ICD(1:3),'425') || strcmp(ICD(1:3),'428')
        weight = weight + 2;
    end
    % dementia romano
    if strcmp(ICD(1:5),'331.0') || strcmp(ICD(1:5),'331.1') || strcmp(ICD(1:5),'331.2') || strcmp(ICD(1:3),'290')
        weight = weight + 2;
    end
    % renal elixhauser
    if strcmp(ICD,'403.11') || strcmp(ICD,'403.91') || strcmp(ICD,'404.12') || strcmp(ICD,'404.92') || ...
            strcmp(ICD(1:3),'585') || strcmp(ICD(1:3),'586') || strcmp(ICD(1:4),'V420') || ...
            strcmp(ICD(1:4),'V451') || strcmp(ICD(1:4),'V560') || strcmp(ICD(1:4),'V568')
        weight = weight + 2;
    end
    % wtloss elixhauser
    if ICDnum >= 260 && ICDnum <= 263
        weight = weight + 2;
    end
    % hemiplegia romano 
    if strcmp(ICD(1:3),'342') || strcmp(ICD(1:3),'344')
        weight = weight + 1;
    end
    % alcohol elixhauser
    if strcmp(ICD(1:5),'291.1') || strcmp(ICD(1:5),'291.2') || strcmp(ICD(1:5),'291.5') || strcmp(ICD(1:5),'291.8') || ...
            strcmp(ICD(1:5),'291.9') || (ICDnum >= 303.9 && ICDnum <= 303.93) || ... 
            (ICDnum >= 305 && ICDnum <= 305.03) || strcmp(ICD(1:5),'V1.13')
        weight = weight + 1;
    end
    % tumor romano
    if (ICDnum >= 140 && ICDnum <= 171) || (ICDnum >= 174 && ICDnum <= 195) || strcmp(ICD(1:5),'273.0') || ...
            strcmp(ICD(1:5),'273.3') || strcmp(ICD(1:6),'V10.46') || ...
            (ICDnum >= 200 && ICDnum <= 208)
        weight = weight + 1;
    end
    % arrhythmia elixhauser
    if strcmp(ICDnum,426.10) || strcmp(ICDnum,426.11) || strcmp(ICDnum,426.13) || (ICDnum >= 426.2 && ICDnum <= 426.4) || ...
            (ICDnum >= 426.5 && ICDnum <= 426.53) || (ICDnum >= 426.6 || ICDnum <= 426.8) || ...
            strcmp(ICD(1:5), '427.0') || strcmp(ICD(1:5), '427.2') || ICD == 427.3100 || ICD == 427.600 || ...
            strcmp(ICD(1:5), '785.0') || strcmp(ICD(1:5), 'V45.0') || strcmp(ICD(1:5), 'V53.3')
        weight = weight + 1;
    end
    % pulmonarydz romano
    if strcmp(ICD(1:5), '415.0') || strcmp(ICD(1:5), '416.8') || strcmp(ICD(1:5), '416.9') || ...
            strcmp(ICD(1:3), '491') || strcmp(ICD(1:3), '492') || strcmp(ICD(1:3), '493') || ...
            strcmp(ICD(1:3), '494') || strcmp(ICD(1:3), '496')
        weight = weight + 1;
    end
    % coagulopathy elixhauser
    if (ICDnum >= 286 && ICDnum <= 286.9) || strcmp(ICD(1:5), '287.1') || (ICDnum >= 287.3 && ICDnum <= 287.5)
        weight = weight + 1;
    end
    % compdiabetes elixhauser
    if (ICDnum >= 250.4 && ICDnum <= 250.73) || (ICDnum >= 250.9 && ICDnum <= 250.93)
        weight = weight + 1;
    end
    % anemia elixhauser
    if (ICDnum >= 280.1 && ICDnum <= 281.9) || strcmp(ICD(1:5), '285.9')
        weights = weights + 1;
    end
    % electrolytes elixhauser
    if (ICDnum >= 276 && ICDnum <= 276.9)
        weight = weight + 1;
    end
    % liver elixhauser
    if ICDnum == 70.3200 || ICDnum == 70.3300 || ICDnum == 70.5400 || strcmp(ICD(1:5), '456.0') || ...
            strcmp(ICD(1:5), '456.1') || ICDnum == 456.200 || ICDnum == 456.2100 || strcmp(ICD(1:5), '571.0') || ...
            strcmp(ICD(1:5), '571.2') || strcmp(ICD(1:5), '571.3') || (ICDnum >= 571.4 && ICDnum <= 571.49) || ...
            strcmp(ICD(1:5), '571.5') || strcmp(ICD(1:5), '571.6') || strcmp(ICD(1:5), '571.8') || ...
            strcmp(ICD(1:5), '571.9') || strcmp(ICD(1:5), '572.3') || strcmp(ICD(1:5), '572.8') || strcmp(ICD(1:5), 'V42.7')
        weight = weight + 1;
    end
    % pvd elixhauser
    if (ICDnum <= 440 && ICDnum >= 440.9) || strcmp(ICD(1:5), '441.2') || strcmp(ICD(1:5), '441.4') || ...
            strcmp(ICD(1:5), '441.7') || strcmp(ICD(1:5), '441.9') || (ICDnum <= 443.1 && ICDnum >= 443.9) || ...
            strcmp(ICD(1:5), '447.1') || strcmp(ICD(1:5), '557.1') || strcmp(ICD(1:5), '557.9') || strcmp(ICD(1:5), 'V43.4')
        weight = weight + 1;
    end
    % psychosis elixhauser
    if (ICDnum >= 295 && ICDnum <= 298.99) || ICDnum == 299.1 || ICDnum == 299.11
        weight = weight + 1;
    end
    % pulmcirc elixhauser
    if strcmp(ICD(1:3), '416') || strcmp(ICD(1:5), '417.9')
        weight = weight + 1;
    end
    % hivaids romano
    if ICDnum >= 42 && ICDnum < 45
        weight = weight - 1;
    end
    % hypertension elixhauser
    if strcmp(ICD(1:5), '401.1') || strcmp(ICD(1:5), '401.9') || ICDnum == 402.1 || ICDnum == 402.9 || ...
            ICDnum == 404.1 || ICDnum == 404.9 || ICDnum == 405.11 || ICDnum == 405.19 || ICDnum == 405.91 || ...
            ICDnum == 405.99
        weight = weight - 1;
    end
    weights = [weights weight]; 
end
comorbidity = sum(weights);
end

