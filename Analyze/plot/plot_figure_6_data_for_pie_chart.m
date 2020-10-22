clc
load ../dat.mat

ste_limit = 1.35;

ste_mka = [];
ste_mki = [];
ste_mkt = [];
for i = 1:size(dat,2)
    if dat(i).ste2000 > ste_limit
        ste_mka = cat(1,dat(i).mka_val_in_STE,ste_mka);
        ste_mki = cat(1,dat(i).mki_val_in_STE,ste_mki);
        ste_mkt = cat(1,dat(i).mkt_val_in_STE,ste_mkt);
    end
end

wm_mka = [];
wm_mki = [];
wm_mkt = [];
for i = 1:size(dat,2)
    if dat(i).ste2000 > ste_limit
        wm_mka = cat(1,dat(i).mka_val_in_WM,wm_mka);
        wm_mki = cat(1,dat(i).mki_val_in_WM,wm_mki);
        wm_mkt = cat(1,dat(i).mkt_val_in_WM,wm_mkt);
    end
end

mean(ste_mki ./ (ste_mka + ste_mki)) * 100 %MKI contribution to STE enhhancing lesions in %
mean(ste_mka ./ (ste_mka + ste_mki)) * 100 %MKA contribution to STE enhhancing lesions in %

mean(wm_mki ./ (wm_mka + wm_mki)) * 100 %MKI contribution to WM in %
mean(wm_mka ./ (wm_mka + wm_mki)) * 100 %MKA contribtuion to WM in %

mean(ste_mka)
mean(ste_mki)
mean(ste_mkt)

mean(wm_mka)
mean(wm_mki)
mean(wm_mkt)


% 56 WM vs 50 STE %
% 1.12 in STE 1.28 in WM




