
% load processed_data.mat

for c = 1:size(dat,2)

    ind = (dat(c).MD > 3 | dat(c).Mka > 1 | dat(c).Mki > 1 |...
           dat(c).MD < 0 | dat(c).Mka < 0 | dat(c).Mki < 0      );

    dat(c).MD(ind) = [];
    dat(c).Mka(ind) = [];
    dat(c).Mki(ind) = [];
    clear ind
end

clf
clear nec pl_MD_val pl_Mka_val pl_Mki_val pl_no
for i = 1:size(dat,2)
    
    pl_no(i) = dat(i).h.group;
    
    ind = dat(i).I_MD(:) < 1.9;
    ind = reshape(ind,[size(dat(i).I_MD,1) size(dat(i).I_MD,2) size(dat(i).I_MD,3)]);
    
    pl_MD_val(i) = entropy(dat(i).I_MD);
    
    pl_Mka_val(i) = entropy(dat(i).I_Mka);
    
    pl_Mki_val(i) = entropy(dat(i).I_Mki);
    
    %tried entropy, 
end




subplot(3,1,1)
hold on
boxplot(pl_MD_val,pl_no)
plot(pl_no,pl_MD_val,'.','Color','black','Markersize',20)
hold on
xlim([0.5 3.5])
ylabel('\langleMD\rangle')
xticks([1 2 3])
xticklabels({'High-grade','Low-grade','Metastasis'})
% ylim([0 2.6])
set(gca,'FontSize',18)


subplot(3,1,2)
hold on
boxplot(pl_Mka_val,pl_no)
plot(pl_no,pl_Mka_val,'.','Color','black','Markersize',30)
hold on
xlim([0.5 3.5])
ylabel('\langleMk_a\rangle')
xticks([1 2 3])
xticklabels({'High-grade','Low-grade','Metastasis'})
% ylim([0 1])
set(gca,'FontSize',18)


subplot(3,1,3)
hold on
boxplot(pl_Mki_val,pl_no)
plot(pl_no,pl_Mki_val,'.','Color','black','Markersize',30)
hold on
xlim([0.5 3.5])
ylabel('\langleMk_i\rangle')
xticks([1 2 3])
xticklabels({'High-grade','Low-grade','Metastasis'})
% ylim([0 0.8])
set(gca,'FontSize',18)

