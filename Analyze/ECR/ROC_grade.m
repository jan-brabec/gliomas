clear; clc;
load dat.mat
clf;

for i = 1:size(dat,2)
    grade(i) = dat(i).h.grade;
    
    lte2000_in_pgw(i) = prctile(dat(i).lte2000_in_pgw,50);
    ste2000_in_pgw(i) = prctile(dat(i).ste2000_in_pgw,50);
    lte700_in_pgw(i) = prctile(dat(i).lte700_in_pgw,50);
    ste700_in_pgw(i) = prctile(dat(i).ste700_in_pgw,50);
    mki_in_pgw(i) = prctile(dat(i).mki_in_pgw,50);
end

for c_plot = 1:6
    switch (c_plot)
        
        case 1
            p2 = [dat.lte700];
            v  = '\n lte_{700} \n';
            
        case 2
            p2 = [dat.ste700];
            v  = '\n ste_{700} \n';
            
        case 3
            p2 = [dat.lte2000];
            v  = '\n LTE_{2000} \n';
            
        case 4
            p2 = [dat.ste2000];
            v  = '\n STE_{2000} \n';
            
        case 5
            p2 = [dat.mki_vs_wm];
            v  = '\n MK_{I} \n';
            
        case 6
            continue;
    end
    
    p1 = [dat.pgd];
    p1(isnan(p1)) = 0;
    p2(isnan(p2)) = 0;
    
    target = grade >= 3; %target is to predict high grade glioma
    limit = linspace(-10,max(p2) + 10,10000);
    
    spec = zeros(size(limit));
    sens = zeros(size(limit));
    
    for i = 1:numel(limit)
        prediction = p2 > limit(i);% & p1 > 1.1;
        tp = sum( (prediction == 1) & (target == 1) );
        tn = sum( (prediction == 0) & (target == 0) );
        fp = sum( (prediction == 1) & (target == 0) );
        fn = sum( (prediction == 0) & (target == 1) );
        sens(i) = tp / (tp + fn);
        spec(i) = tn / (tn + fp);
    end
    
    subplot(3,2,c_plot);
    plot(1 - spec, sens, '.-','Markersize',30,'Color','k','Linewidth',2);
    hold on
    plot(1-0.625,0.76,'.','Markersize',30,'Color','red')
    xlabel('1-Specificity')
    ylabel('Sensitivity')
%     axis equal
    xlim([0 1])
    ylim([0 1])
    set(gca,'FontSize',17)
    
    
    [best_lim,best_spec,best_sens,pnt] = closest_pnt(spec,sens,limit);
    auc = trapz(spec, sens);
    title(sprintf(strcat(v,'Lim: %0.2f, AUC: %0.2f, Spec: %0.2f, Sens: %0.2f \n'),best_lim,auc,best_spec,best_sens))
    
    hold on;
    plot(1-spec(pnt), sens(pnt),'.','Markersize',20,'Color','blue')
    
end