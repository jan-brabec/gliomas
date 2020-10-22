clear; clc;
load dat.mat

c_case = 'enh';
switch c_case
    case 'grade_gd'
        
        for i = 1:size(dat,2)
            grade(i) = dat(i).h.grade;
        end
        
        limit_1 = 1.1;
        limit_2 = 1.4;
        
        p1 = [dat.pgd];
        p2 = [dat.ste700];
        
        p1(isnan(p1)) = 0;
        p2(isnan(p2)) = 0;
        
        prediction = p1 > limit_1;% & p2 > limit_2;
        target = grade >= 3;
        
    case 'grade_alone'
        
        for i = 1:size(dat,2)
            grade(i) = dat(i).h.grade;
        end
        
        limit_1 = 0.9;
        limit_2 = 2;
        
        p1 = [dat.lte2000];
        p2 = [dat.mki_vs_wm];
        
        p1(isnan(p1)) = 0;
        p2(isnan(p2)) = 0;
        
        prediction = p1 > limit_1 & p2 > limit_2;
        target = grade >= 3;
        
    case 'enh'
        
        limit = 1.36;
        
        p1 = [dat.ste2000];
        p1(isnan(p1)) = 0;
        
        for i = 1:size(dat,2)
            if strcmp(dat(i).h.type,'Glioblastoma') ~= 1
                ind(i) = true;
            else
                ind(i) = false;
            end
        end
        
        prediction = p1 > limit;
        target = [dat.pgd] > 1.1; %target is to predict enhancements
        
        if (1) %only glioblastomas
            prediction(ind) = [];
            target(ind) = [];
        end
end

tp = sum( (prediction == 1) & (target == 1) );
tn = sum( (prediction == 0) & (target == 0) );
fp = sum( (prediction == 1) & (target == 0) );
fn = sum( (prediction == 0) & (target == 1) );
spec = tn / (tn + fp)
sens = tp / (tp + fn)
ppv  = tp / (tp + fp)
npv  = tn / (tn + fn)

