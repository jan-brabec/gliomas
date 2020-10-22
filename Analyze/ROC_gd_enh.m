clear; clc; clf;
load dat.mat

colors = {...
    [0.3176    0.3412    0.2902]...
    [0.2667    0.4863    0.4118]...
    [0.4549    0.7686    0.5765]...
    [0.5569    0.5490    0.4275]...
    [0.8941    0.7490    0.5020]...
    [0.9137    0.8431    0.5569]...
    [0.8863    0.5922    0.3647]...
    [0.9451    0.5882    0.4392]...
    [0.8824    0.3961    0.3216]...
    [0.7882    0.2902    0.3255]...
    [0.7451    0.3176    0.4078]...
    [0.6392    0.2863    0.4549]...
    [0.6000    0.2157    0.4039]...
    [0.3961    0.2196    0.4902]...
    [0.3059    0.1412    0.4471]...
    [0.5686    0.3882    0.7137]...
    [0.8863    0.4745    0.6392]...
    [0.8784    0.3490    0.5451]...
    [0.4863    0.6235    0.6902]...
    [0.3373    0.5961    0.7686]...
    [0.6039    0.7490    0.5333]};

for c_plot = 1:2
    switch (c_plot)
        case 1
            p2 = [dat.lte2000];
            v  = '\n LTE_{2000} \n';
            
        case 2
            p2 = [dat.ste2000];
            v  = '\n STE_{2000} \n';
    end
    
    p1 = [dat.pgd];
    p1(isnan(p1)) = 0;
    p2(isnan(p2)) = 0;
    
    if (1)
        target = p1 > 1.1; % target is to predict Gd enhancement
    else
        target = grade >= 3;
    end
    
    limit{c_plot} = linspace(-10,max(p2) + 10,10000);
    
    if (0) %to chaeck what limit is needed to get sensitivity/specificity = 1
        limit{c_plot} = 0.2;
    end
    
    spec{c_plot} = zeros(size(limit{c_plot}));
    sens{c_plot} = zeros(size(limit{c_plot}));
    
    for i = 1:numel(limit{c_plot})
        prediction = p2 > limit{c_plot}(i);
        tp = sum( (prediction == 1) & (target == 1) );
        tn = sum( (prediction == 0) & (target == 0) );
        fp = sum( (prediction == 1) & (target == 0) );
        fn = sum( (prediction == 0) & (target == 1) );
        sens{c_plot}(i) = tp / (tp + fn);
        spec{c_plot}(i) = tn / (tn + fp);
    end
end

if (0) %to chaeck what limit is needed to get sensitivity/specificity = 1
    fprintf('LTE Lim: %0.2f, Spec: %0.2f, Sens: %0.2f \n',limit{1},spec{1},sens{1});
    fprintf('STE Lim: %0.2f, Spec: %0.2f, Sens: %0.2f \n',limit{2},spec{2},sens{2});
    return
end


plot(1 - spec{1}, sens{1}, '-','Markersize',50,'Color',uint8([200 200 200]),'Linewidth',6);
hold on
plot(1 - spec{2}, sens{2}, '-','Markersize',50,'Color',uint8([75 75 75]),'Linewidth',6);

% plot(1 - spec{1}, sens{1}, '.','Markersize',50,'Color',colors{2+1*5});
% plot(1 - spec{2}, sens{2}, '.','Markersize',50,'Color',colors{2+2*5});

ind = abs(spec{1} - spec{2}) < 0.1 & abs(sens{1} - sens{2}) < 0.3;
plot(1 - spec{1}(ind), sens{1}(ind), '.','Markersize',70,'Color','k');

hold on
xlim([0 1])
ylim([0 1])

%   xticks([0 0.25 0.5 0.75 1])
% xticklabels({'0','0.25','0.50','0.75','1.00'})

set(gca,'FontSize',35)
xtickangle(0)
ax = gca;
ax.XAxis.LineWidth = 3;
ax.YAxis.LineWidth = 3;
% ax.XColor = [100 100 100]./255;
% ax.YColor = [100 100 100]./255;

[best_lim,best_spec,best_sens,pnt] = closest_pnt(spec{1},sens{1},limit{1});
auc = trapz(spec{1}, sens{1});
disp(sprintf(strcat('LTE: Lim: %0.2f, AUC: %0.2f, Spec: %0.2f, Sens: %0.2f \n'),best_lim,auc,best_spec,best_sens))
plot(1-spec{1}(pnt), sens{1}(pnt),'.','Markersize',70,'Color',colors{4+1*5})

[best_lim,best_spec,best_sens,pnt] = closest_pnt(spec{2},sens{2},limit{2});
auc = trapz(spec{2}, sens{2});
disp(sprintf(strcat('STE: Lim: %0.2f, AUC: %0.2f, Spec: %0.2f, Sens: %0.2f \n'),best_lim,auc,best_spec,best_sens))
plot(1-spec{2}(pnt), sens{2}(pnt),'.','Markersize',70,'Color',colors{2+1*5})

%   plot(0.5, 0.5,'.','Markersize',70,'Color',colors{2+1*5})
plot(0.5, 0.5,'.','Markersize',70,'Color',colors{4+1*5})


% legend('LTE','STE','Location','Southeast')
legend boxoff
legend off

hold on;
