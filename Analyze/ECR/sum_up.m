for c = 1:size(dat,2)
    
    ind = (dat(c).MD > 3 | dat(c).Mka > 1 | dat(c).Mki > 1 |...
        dat(c).MD < 0 | dat(c).Mka < 0 | dat(c).Mki < 0      );
    
    dat(c).MD(ind) = [];
    dat(c).Mka(ind) = [];
    dat(c).Mki(ind) = [];
    dat(c).Mkt(ind) = [];
    clear ind
end

clf
clear nec pl_MD_val pl_Mka_val pl_Mki_val pl_no
for i = 1:size(dat,2)
    
    ind = dat(i).MD < 1.9;
    pl_Mka_val(i) = mean(dat(i).Mka(ind));
    pl_Mki_val(i) = mean(dat(i).Mki(ind));
    
    pl_Mkt_val(i) = mean(dat(i).Mkt(ind));
    
    Mkt_comp{i} = (dat(i).Mka(ind) + dat(i).Mki(ind));
    Mkt_comp{i} = mean(Mkt_comp{i})-pl_Mkt_val(i);
    
    
    
    
end


for i = 1:25
    hold on
    plot(ones(1,numel(pl_Mka_val))*1, pl_Mka_val,'.','Markersize',30)
    plot(ones(1,numel(pl_Mki_val))*2, pl_Mki_val,'.','Markersize',30)
    plot(ones(1,numel(Mkt_comp{i}))*3, Mkt_comp{i},'.','Color','black','Markersize',30)
   
end

xlim([0.5 3.5])
ylim([-0.1 0.7])
xticks([1 2 3])
xticklabels({'\langleMk_A\rangle','\langleMk_I\rangle','\langleMk_A\rangle + \langleMk_I\rangle - \langleMk_t\rangle'})
set(gca,'FontSize',30)


% clf
% for i = 1:25
%         hold on
%         ind = dat(i).MD < 1.9;
% %         plot((dat(i).Mka(ind) + dat(i).Mki(ind)) - dat(i).Mkt(ind))
%         title(mean((dat(i).Mka(ind) + dat(i).Mki(ind)) - dat(i).Mkt(ind)))
%         plot(0,mean(dat(i).Mka(ind)),'.','Markersize',20)
%         plot(1,mean(dat(i).Mki(ind)),'.','Markersize',20)
%         plot(2,mean(dat(i).Mkt(ind)),'.','Markersize',20)
%         plot(2,mean((dat(i).Mka(ind) + dat(i).Mki(ind))),'.','Markersize',20)
%         title(i)
%         pause;
%         clf;
%
%
% end

