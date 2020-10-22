%for ECR and ISMRM
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

for i = 1:size(dat,2)
    bof(i)   = dat(i).h.bof;
end

%%
non_enh_gb = [105, 106, 111, 117, 132]; %5 samples
% 105, 106, 132 ok
% 111  very small part of the tumor is enhancing and not extremely, will be in
% 122 excluded because it could be very well a cyst (ultrahomogenous)

for i = 1:numel(non_enh_gb)
    
    id = find(bof== non_enh_gb(i));
    
    vMki_g(i) = sqrt(var(dat(id).Mki));
    vMka_g(i) = sqrt(var(dat(id).Mka));
    vMkt_g(i) = sqrt(var(dat(id).Mkt));
    vMD_g(i)  = sqrt(var(dat(id).MD));
    
    mMki_g(i) = mean(dat(id).Mki);
    mMka_g(i) = mean(dat(id).Mka);
    mMkt_g(i) = mean(dat(id).Mkt);
    mMD_g(i)  = mean(dat(id).MD);
    
end

%%

non_enh_ol = [110, 112, 118, 124]; %4 samples

% 110 seems most legit

% 112 - there is enhancement but very close to operative spot, could be
% post-operative, also close to the edge, included for the same reason as
% 111 is included

% 118 also close to the edge of the operative spot

% 124 very bad location when it comes to artifacts

for i = 1:numel(non_enh_ol)
    
    id = find(bof == non_enh_ol(i));
    
    vMki_o(i) = sqrt(var(dat(id).Mki));
    vMka_o(i) = sqrt(var(dat(id).Mka));
    vMkt_o(i) = sqrt(var(dat(id).Mkt));
    vMD_o(i) = sqrt(var(dat(id).MD));
    
    mMki_o(i) = mean(dat(id).Mki);
    mMka_o(i) = mean(dat(id).Mka);
    mMkt_o(i) = mean(dat(id).Mkt);
    mMD_o(i)  = mean(dat(id).MD);
    
end

id  = [ones(1,numel(non_enh_gb))*1,ones(1,numel(non_enh_ol))*2];

vMD  = [vMD_g , vMD_o];
vMkt = [vMkt_g, vMkt_o];
vMki = [vMki_g, vMki_o];
vMka = [vMka_g, vMka_o];
mMD  = [mMD_g , mMD_o];
mMkt = [mMkt_g, mMkt_o];
mMki = [mMki_g, mMki_o];
mMka = [mMka_g, mMka_o];

param{1} = mMD;
param{2} = mMkt;
param{3} = mMka;
param{4} = mMki;
param{5} = vMD;
param{6} = vMkt;
param{7} = vMka;
param{8} = vMki;

ylab = {'\langleMean diffusivity\rangle [µm^2/ms]', '\langleTotal kurtosis\rangle',...
    '\langleAnisotropic kurtosis\rangle', '\langleIsotropic kurtosis\rangle'...
    'std\langleMean diffusivity\r', 'std(Total kurtosis)', 'std(Anisotropic kurtosis)'...
    'std (MK_I)'};

clf

ha = tight_subplot(2,4,[.1,.05],[.12,.08],[.1,.02]);

for c_exp = 1:8
    
    
    axes(ha(c_exp));
    
    hold on
    
    bp = boxplot(param{c_exp},id);
    plot(id,param{c_exp},'.','Color','black','Markersize',40)
    
    ylabel(ylab{c_exp})
    if c_exp == 3 || c_exp == 7
        ylabel(ylab{c_exp},'Color',[192 80 77]./255)
    elseif c_exp == 4 || c_exp == 8
        ylabel(ylab{c_exp},'Color',[119 147 60]./255)
    end
    
    if c_exp == 1
        ylim([0 2])
        yticks([0 1 2])
        yticklabels({'0','1','2'})
    elseif c_exp == 2 || c_exp == 3 || c_exp == 4
        ylim([0 1])
        yticks([0  0.5 1])
        yticklabels({'0','0.5','1'})
    elseif c_exp >= 5
        ylim([0 0.4])
        yticks([0  0.2 0.4])
        yticklabels({'0','0.2','0.4'})
    end
    
    xticks([1 2])
    xticklabels({'Gbm','Odg'})
    xtickangle(0)
    set(gca,'FontSize',25)
    set(bp,'linew',3)
    
    if c_exp == 8
        ax = gca;
        ax.XAxis.LineWidth = 3;
        ax.YAxis.LineWidth = 3;
    end
    
    a = get(get(gca,'children'),'children');   % Get the handles of all the objects
    a = a{2};
    set(a(5:6),  'Color', colors{14});   % Set the color of the boxes
    set(a(11:14),  'Color', colors{14});   % Set the color of the boxes
    
    if c_exp == 3 || c_exp == 7
        set(a(5:6),  'Color', [192 80 77]./255);   % Set the color of the boxes
        set(a(11:14),  'Color',  [192 80 77]./255);   % Set the color of the boxes
    end
    if c_exp == 4 || c_exp == 8
        set(a(5:6),  'Color', [119 147 60]./255);   % Set the color of the boxes
        set(a(11:14),  'Color',  [119 147 60]./255);   % Set the color of the boxes
    end
    
end

[p, h] = ranksum(vMki_g, vMki_o,'tail','both')
