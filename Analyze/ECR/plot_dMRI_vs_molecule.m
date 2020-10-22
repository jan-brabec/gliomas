clearvars -except dat

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


for c = 1:size(dat,2)

    ind = (dat(c).MD > 3 | dat(c).Mka > 1 | dat(c).Mki > 1 |...
           dat(c).MD < 0 | dat(c).Mka < 0 | dat(c).Mki < 0      );

    dat(c).MD(ind) = [];
    dat(c).Mka(ind) = [];
    dat(c).Mki(ind) = [];
    clear ind
end

for i = 1:size(dat,2)
    group(i) = dat(i).h.group;
    IDH(i) = dat(i).h.IDH;
    MGMT(i) = dat(i).h.MGMT;
    bof(i)   = dat(i).h.bof;
end

idx1 = find(MGMT == 0 & group == 1);
idx2 = find(MGMT == 1 & group == 1);


for i = 1:size(dat,2)
    if     ~isempty(find(i == idx1))
        id(i) = 1;
    elseif ~isempty(find(i == idx2))
        id(i) = 2;
    else
        id(i) = NaN;
    end
    param{1}(i) = var(dat(i).MD);
    param{2}(i) = var(dat(i).Mka);
    param{3}(i) = var(dat(i).Mki);
end

titles = {'MD','MK_A','MK_I'};
clf
for j = 1:3
    
    subplot(3,1,j)
    title(titles(j))
    hold on
    boxplot(param{j},id)
    plot(ones(1,numel(idx1))*1,param{j}(idx1),'.','Markersize',20,'Color','black');
    plot(ones(1,numel(idx2))*2,param{j}(idx2),'.','Markersize',20,'Color','black');
    ylim([0 max(param{j})])
    xticks([1 2])
    xticklabels({'MGMT-','MGMT+'})
    set(gca,'FontSize',18)
%     
    [p, h] = ranksum(param{j}(idx1), param{j}(idx2),'tail','left')

    
end


