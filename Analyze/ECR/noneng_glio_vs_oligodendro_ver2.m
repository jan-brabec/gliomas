%updated with current data

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
    bof(i)   = dat(i).bof;
    
    if i == 7
        1;
    end
    if strcmp(dat(i).h.type,'Glioblastoma') && (dat(i).pgd <= l  || isnan(dat(i).pgd))
        ind(i) = 1;
    elseif strcmp(dat(i).h.type,'Oligodendroglioma') && (dat(i).pgd <= l || isnan(dat(i).pgd))
        ind(i) = 2;
    else
        ind(i) = 0;
    end
end

%last time up to bof 133, new cases just 149 at 31 and 145 at 27
%% !!!!!!
%Gb
% ind(7) = 1; %Gb, bof 111, this is really enhancing
% ind(17) = 0; %Gb, bof 122, rather some kind of cyst maybe
% ind(31) = 0; %Gb, bof 149, new case

disp(sprintf('Number of non-enh Gb %d',numel(find(ind==1))))

%Og
% ind(8) = 2; %Og, bof 112
% ind(27) = 0; %Og, bof 145, new case

disp(sprintf('Number of non-enh Og %d',numel(find(ind==2))))


%%

for i = 1:size(dat,2)
    vMki(i)  = sqrt(var(dat(i).mki_in_pgw));
end

clf
bp = boxplot([vMki(ind == 1) vMki(ind == 2)],[ind(ind==1) ind(ind == 2)]);
xticks([1 2])
% xticklabels({'Non-enh Gbm','Non-enh Odg'})
xticklabels({'',''})
hold on


a = get(get(gca,'children'),'children');   % Get the handles of all the objects
set(a(5:6),  'Color', colors{14});   % Set the color of the boxes
set(a(11:14),  'Color', colors{14});   % Set the color of the boxes
set(a(5:6),  'Color', [119 147 60]./255);   % Set the color of the boxes
set(a(11:14),  'Color',  [119 147 60]./255);   % Set the color of the boxes

ylim([0 0.4])
yticks([0 0.2 0.4])
% yticklabels({'0','0.3','0.6'})
set(gca,'FontSize',55)
xtickangle(0)
set(bp,'linew',10)
ax = gca;
ax.XAxis.LineWidth = 6;
ax.YAxis.LineWidth = 6;

hold on
plot([ind(ind==1) ind(ind == 2)],[vMki(ind == 1) vMki(ind == 2)],'.','Markersize',40,'Color','black')

[p, h] = ranksum(vMki(ind == 1), vMki(ind == 2),'tail','both')
hold on
% plot([ind(ind ~= 1)+1 ind(ind==1)*2],[mki(~ind) mki(ind)],'.','Color','black','Markersize',70)









% non_enh_gb = [105, 106, 111, 117, 132]; %5 samples
% now it is     105, 106,    , 117, 132, 122, 149
%
% 105, 106, 132 ok
% 111  very small part of the tumor is enhancing and not extremely, will be in
% 122 excluded because it could be very well a cyst (ultrahomogenous)
% 110 seems most legit

% non-enhancing oligodendroglioma
% non_enh_ol = [110, 112, 118, 124]; %4 samples
% now it is     110,      118, 124, 145
%
% 112 - there is enhancement but very close to operative spot, could be
% post-operative, also close to the edge, included for the same reason as
% 111 is included
% 118 also close to the edge of the operative spot
% 124 very bad location when it comes to artifacts


