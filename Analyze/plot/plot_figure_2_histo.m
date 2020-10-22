load('../dat.mat')
clf
clc

%Choose the optimal limit based on ROC curves
l_ste = 1.39;
l_lte = 1.02;

if (0)
    lte = [dat.lte700];
    ste = [dat.lte2000];
    
    ind = isnan(lte) | isnan(ste);
    lte = lte(~ind);
    ste = ste(~ind);
    
    ind = lte > l_lte & ste > l_lte;
    lte = lte(ind);
    ste = ste(ind);
    
else
    lte = [dat.lte2000];
    ste = [dat.ste2000];
    
    ind = isnan(lte) | isnan(ste);
    lte = lte(~ind);
    ste = ste(~ind);
    
    ind = lte > l_lte & ste > l_lte;
    lte = lte(ind);
    ste = ste(ind);
end

for i = 1:size(lte,2)
    line([0 1], [lte(i), ste(i)],'LineStyle','-','Color',uint8([150 150 150]),'Linewidth',3)
end

fprintf('\n')
fprintf('Higher first/second %0.2f\n ',sum(ste>lte)/numel(lte)*100)
fprintf('%0.2f +- %0.2f vs %0.2f +- %0.2f \n ',mean(lte),std(lte), mean(ste), std(ste))

fprintf('\n')
fprintf('mean(STE - LTE) %0.2f +-  %0.2f \n',mean(ste-lte), std(ste-lte))

hold on
plot([zeros(1,size(lte,2)),ones(1,size(ste,2))],[lte,ste],'.','MarkerSize',50,'Color','black')
xlim([-0.35 1.2])
ylim([0.5 3])
xticks([0 1])
yticks([1 1.5 2 2.5 3])
yticklabels({'1.0','1.5','2.0','2.5','3.0'})

xticklabels({'',''})
set(gca,'FontSize',30)
set(gca,'box','off')

ax = gca;
ax.XAxis.LineWidth = 3;
ax.YAxis.LineWidth = 3;

ax = gca;
set(ax,'tickdir','out');
ax.XGrid = 'off';
ax.YGrid = 'on';

p = signrank(lte,ste);

fprintf('Wilcoxon signed rank test for means p = %0.2e\n',p)

p = signrank(ste-lte);

fprintf('Wilcoxon signed rank test for differences STE - LTE p = %0.2e\n ',p)


print(sprintf('histo.png'),'-dpng','-r300')