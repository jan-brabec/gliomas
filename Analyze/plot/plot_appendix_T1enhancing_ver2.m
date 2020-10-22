clear
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

l = 1.1;
for i = 1:size(dat,2)
    mki(i) = mean(dat(i).mki_in_pgw,'omitnan');
    ste(i) = mean(dat(i).ste2000_in_pgw,'omitnan');
    lte(i) = mean(dat(i).lte2000_in_pgw,'omitnan');
end

pgd = [dat.pgd];
ind = pgd > l;

for c_exp = 1:3
        figure;
    switch c_exp
        case 1
            par = mki; name = '\langleMK_I\rangle';
        case 2
            par = ste; name = '\langleSTE_{2000}\rangle';
        case 3
            par = lte; name = '\langleLTE_{2000}\rangle';
    end

    bp = boxplot([par(~ind) par(ind)],[ind(ind ~= 1) ind(ind==1)*2]);

    a = get(get(gca,'children'),'children');   % Get the handles of all the objects
    set(a(5:6),  'Color', colors{14});   % Set the color of the boxes
    set(a(11:14),  'Color', colors{14});   % Set the color of the boxes
    set(a(5:6),  'Color', [119 147 60]./255);   % Set the color of the boxes
    set(a(11:14),  'Color',  [119 147 60]./255);   % Set the color of the boxes
    
    hold on
    plot([ind(ind ~= 1)+1 ind(ind==1)*2],[par(~ind) par(ind)],'.','Color','black','Markersize',70)
    
    ylabel(name)
    xticks([1 2])
    xticklabels({'No','Yes'})
    set(gca,'FontSize',55)
    xtickangle(0)
    set(bp,'linew',10)
    ax = gca;
    ax.XAxis.LineWidth = 6;
    ax.YAxis.LineWidth = 6;
    
    switch c_exp
        case 1
            ylim([0 0.6])
            yticks([0 0.3 0.6])

        case 2
            ylim([0 60])
            yticks([0 30 60])

        case 3
            ylim([0 80])
            yticks([0 40 80])
    end
    
    [p, h ] = ranksum(par(~ind),par(ind))
    
end

