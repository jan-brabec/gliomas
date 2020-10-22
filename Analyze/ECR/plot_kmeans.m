function plot_kmeans(dat,idx,i,slice)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


subplot(2,4,1)
msf_imagesc(im2double(dat(i).I_T1),3,slice ,1);

subplot(2,4,2)
msf_imagesc(dat(i).I_MD,3,slice ,1);

subplot(2,4,3)
msf_imagesc(dat(i).I_Mka,3,slice ,1);

subplot(2,4,4)
msf_imagesc(dat(i).I_Mki,3,slice ,1);

subplot(2,4,5)
% title(slice)
% hold on
% msf_imagesc(idx,3,slice ,1);

subplot(2,4,6)
msf_imagesc(dat(i).I_MD .* im2double(dat(i).I_ROI),3,slice ,1);

subplot(2,4,7)
msf_imagesc(dat(i).I_Mka .* im2double(dat(i).I_ROI),3,slice ,1);

subplot(2,4,8)
msf_imagesc(dat(i).I_Mki .* im2double(dat(i).I_ROI),3,slice ,1);
end

