clear; clc; clf;
load dat.mat

for i = 1:size(dat,2)
    IDH(i) = dat(i).h.IDH;
end

for i = 1:size(dat,2)
    MGMT(i) = dat(i).h.MGMT;
end

for i = 1:size(dat,2)
    grade(i) = dat(i).h.grade;
end

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

% p2 = [dat.mki_vs_wm];
% p2(isnan(p2)) = 0;

p2 = [dat.ste2000];
p2(isnan(p2)) = 0;

% ground_truth = grade >= 3;
ground_truth = MGMT == 0;

prediction = p2;

mdl = fitglm(prediction,ground_truth,'Distribution','binomial');
scores = mdl.Fitted.Probability;

labels = cell(1,numel(p2));
labels(ground_truth) = {'high-grade'};
labels(~ground_truth) = {'low-grade'};

[X,Y,T,AUC,OPTROCPT] = perfcurve(labels,scores,'high-grade','NBoot',5000,'Cost',[0 0.3;0.5 0]);

% [X,Y,T,AUC,OPTROCPT] = perfcurve(labels,scores,'high-grade','NBoot',5000,'Cost',[0 0.5;0.4 0]);
[X,Y,T,AUC,OPTROCPT] = perfcurve(labels,scores,'high-grade','NBoot',5000,'Cost',[0 0.8;0.5 0]);


plot(X(:,1), Y(:,1), '-','Markersize',50,'Color',uint8([200 200 200]),'Linewidth',6);
hold on
plot(X(:,1), Y(:,1), '.','Markersize',30,'Color','k');

plot(OPTROCPT(1), OPTROCPT(2),'.','Markersize',70,'Color',colors{4+1*5})
% plot(1-0.625, 0.76,'.','Markersize',70,'Color',colors{2+2*5})

AUC

1-OPTROCPT(1)
OPTROCPT(2)

xlim([0 1])
ylim([0 1])

xticks([0 0.5 1])
xticklabels({'0','0.5','1'})

set(gca,'FontSize',35)
xtickangle(0)
ax = gca;
ax.XAxis.LineWidth = 3;
ax.YAxis.LineWidth = 3;
