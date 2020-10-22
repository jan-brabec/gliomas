clear; clc;
load('dat.mat');

% From ROC curve to predict Gd-enhancements
gd_limit = 1.1;
lte_limit = 1.02;
ste_limit = 1.39;
mki_limit = 2.08;

gd  = [dat.pgd]; gd(isnan(gd)) = 0;
lte = [dat.lte2000]; lte(isnan(lte)) = 0;
ste = [dat.ste2000]; ste(isnan(ste)) = 0;
mki = [dat.mki_vs_wm]; mki(isnan(mki)) = 0;

c_gd  = numel(find(gd >= gd_limit));
c_lte = numel(find(lte >= lte_limit));
c_ste = numel(find(ste >= ste_limit));
c_mki = numel(find(mki >= mki_limit));
fprintf('Counts of positives. Gd: %0.0f, LTE: %0.0f, STE: %0.0f, MKI: %0.0f \n',c_gd, c_lte, c_ste, c_mki)


lte_pp = numel(find(lte >= lte_limit & gd >= gd_limit));
lte_nn = numel(find(lte < lte_limit & gd < gd_limit));
lte_pn = numel(find(lte >= lte_limit & gd < gd_limit));
lte_np = numel(find(lte < lte_limit & gd >= gd_limit));
fprintf('LTE pp: %0.0f, pn %0.0f, np %0.0f, nn: %0.0f \n',lte_pp, lte_pn,lte_np, lte_nn)

ste_pp = numel(find(ste >= ste_limit & gd >= gd_limit));
ste_nn = numel(find(ste < ste_limit & gd < gd_limit));
ste_pn = numel(find(ste >= ste_limit & gd < gd_limit));
ste_np = numel(find(ste < ste_limit & gd >= gd_limit));
fprintf('STE pp: %0.0f, pn %0.0f, np %0.0f, nn: %0.0f \n',ste_pp, ste_pn,ste_np, ste_nn)

mki_pp = numel(find(mki >= mki_limit & gd >= gd_limit));
mki_nn = numel(find(mki < mki_limit & gd < gd_limit));
mki_pn = numel(find(mki >= mki_limit & gd < gd_limit));
mki_np = numel(find(mki < mki_limit & gd >= gd_limit));
fprintf('MKI pp: %0.0f, pn %0.0f, np %0.0f, nn: %0.0f \n\n\n',mki_pp, mki_pn, mki_np, mki_nn)


if lte_pp+lte_np+lte_pn+lte_nn ~= numel(dat)
    error('Numbers dont fit')
end
if ste_pp+ste_np+ste_pn+ste_nn ~= numel(dat)
    error('Numbers dont fit')
end
if mki_pp+mki_np+mki_pn+mki_nn ~= numel(dat)
    error('Numbers dont fit')
end




