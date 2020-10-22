% 
% clear all
% load processed_data.mat


for c = 1:size(dat,2)
   
    ind = (dat(c).MD > 3 | dat(c).Mka > 1 | dat(c).Mki > 1 |...
           dat(c).MD < 0 | dat(c).Mka < 0 | dat(c).Mki < 0      );

    dat(c).MD(ind) = [];
    dat(c).Mka(ind) = [];
    dat(c).Mki(ind) = [];
    
end

clf
clear nec pl_MD_val pl_Mka_val pl_Mki_val pl_no
for i = 1:size(dat,2)
    
    ind = dat(i).MD < 1.9;
    pl_no(i) = dat(i).h.group;
    
    pl_MD_val(i) = mean(dat(i).MD(ind));
    
%     tmp = sort(dat(i).Mka(ind),'Ascend');
%     number = round(numel(tmp*0.01)*0.05);
%     tmp = tmp(end-number:end);
    
    tmp = numel(find(dat(i).Mka(ind) > 0.8)) / numel(dat(i).Mka(ind)) * 100;
%     tmp = var(dat(i).Mka(ind));
    pl_Mka_val(i) = mean(tmp);

%     tmp    = sort(dat(i).Mki(ind),'Ascend');
%     number = round(numel(tmp)*0.05);
%     tmp    = tmp(1:number);

    tmp = numel(find(dat(i).Mki(ind) < 0.1)) / numel(dat(i).Mki(ind)) * 100;
%     tmp = var(dat(i).Mki(ind));

    pl_Mki_val(i) = mean(tmp);
    
    
    if numel(find(dat(i).MD(ind)>1.9))/numel(dat(i).MD(ind))*100 > 10
        nec(i) = true;
    else
        nec(i) = false;
    end
    
end




% subplot(3,1,1)
% hold on
% boxplot(pl_MD_val,pl_no)
% plot(pl_no,pl_MD_val,'.','Color','black','Markersize',20)
% hold on
% xlim([0.5 3.5])
% ylabel('\langleMD\rangle')
% xticks([1 2 3])
% xticklabels({'High-grade','Low-grade','Metastasis'})
% ylim([0 2])
% set(gca,'FontSize',18)
% plot(pl_no(nec),pl_MD_val(nec),'.','Color','red','Markersize',20)


subplot(2,1,1)
hold on
boxplot(pl_Mka_val,pl_no)
plot(pl_no,pl_Mka_val,'.','Color','black','Markersize',20)
hold on
xlim([0.5 3.5])
ylabel('\langleMk_a\rangle')
xticks([1 2 3])
xticklabels({'High-grade','Low-grade','Metastasis'})
% ylim([0.2 1])
set(gca,'FontSize',18)
plot(pl_no(nec),pl_Mka_val(nec),'.','Color','red','Markersize',20)


subplot(2,1,2)
hold on
boxplot(pl_Mki_val,pl_no)
plot(pl_no,pl_Mki_val,'.','Color','black','Markersize',20)
hold on
xlim([0.5 3.5])
ylabel('\langleMk_i\rangle')
xticks([1 2 3])
xticklabels({'High-grade','Low-grade','Metastasis'})
% ylim([0 0.2])
set(gca,'FontSize',18)
plot(pl_no(nec),pl_Mki_val(nec),'.','Color','red','Markersize',20)

