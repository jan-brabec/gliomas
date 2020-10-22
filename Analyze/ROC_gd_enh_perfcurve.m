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

p1 = [dat.pgd];

for c_exp = 1:2
    
    switch c_exp
        case 1
            p2 = [dat.lte2000];
        case 2
            p2 = [dat.ste2000];
    end
    
    p1(isnan(p1)) = 0;
    p2(isnan(p2)) = 0;
    
    ground_truth = p1 > 1.1; %enhancing
    prediction   = p2;
    
    mdl = fitglm(prediction,ground_truth,'Distribution','binomial');
    scores = mdl.Fitted.Probability;
    
    labels = cell(1,numel(p2));
    labels(ground_truth) = {'enhancing'};
    labels(~ground_truth) = {'non-enhancing'};
    
    [X{c_exp},Y{c_exp},T{c_exp},AUC{c_exp},OPTROCPT{c_exp}] = perfcurve(labels,scores,'enhancing','NBoot',5000);
    
end

plot(X{1}(:,1), Y{1}(:,1), '-','Markersize',50,'Color',uint8([200 200 200]),'Linewidth',6);
hold on
plot(X{2}(:,1), Y{2}(:,1), '-','Markersize',50,'Color',uint8([75 75 75]),'Linewidth',6);

plot(X{1}(:,1), Y{1}(:,1), '.','Markersize',30,'Color','k');
plot(X{2}(:,1), Y{2}(:,1), '.','Markersize',30,'Color','k');

plot(OPTROCPT{1}(1), OPTROCPT{1}(2),'.','Markersize',70,'Color',colors{4+1*5})
plot(OPTROCPT{2}(1), OPTROCPT{2}(2),'.','Markersize',70,'Color',colors{2+1*5})

AUC{1}
AUC{2}

xlim([0 1])
ylim([0 1])

xticks([0 0.5 1])
xticklabels({'0','0.5','1'})

yticks([0 0.5 1])
yticklabels({'0','0.5','1'})

set(gca,'FontSize',35)
xtickangle(0)
ax = gca;
ax.XAxis.LineWidth = 3;
ax.YAxis.LineWidth = 3;

legend('LTE','STE','Location','Southeast')
legend boxoff
legend off

hold on;
