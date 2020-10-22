function plot_figure_2_lesions_vs_WM()

c_subject = 3; %enhancing

warning off
sss = readtable('figs_print.xlsx');
warning on
sss = table2cell(sss);
sss(find([sss{:,1}] ~= c_subject),:) = [];

ss{1} = num2str(sss{2});
ss{2} = num2str(sss{3});
ss{3} = str2num(sss{4});
ss{4} = [str2num(sss{5}) str2num(sss{6})];
ss{5} = [str2num(sss{7}) str2num(sss{8})];
ss{6} = [str2num(sss{9}) str2num(sss{10})];
ss{7} = [str2num(sss{11}) str2num(sss{12})];

contrast_scale_list = ...
    {[str2num(sss{16}) (sss{17})],... %post
    [str2num(sss{26}) (sss{27})],... %MKI
    [str2num(sss{22}) (sss{23})]...  %STE
    };

subject_name = strcat('BoF130_APTw_',ss{1});
disp(subject_name)

data_dir =  fullfile('../../data/processed', subject_name, ss{2}, 'T1_coreg');

I_mask = mdm_nii_read(fullfile(data_dir,'mask.nii.gz'));
I_mask = I_mask(:,:,ss{3});

data_ROI_dir =  fullfile('../../data/roi_Enhancements');

ROI_gd_fn = fullfile(data_ROI_dir,strcat(ss{1},'_',ss{2},'_Gd_enh.nii.gz'));
ROI_wm_fn = fullfile(data_ROI_dir,strcat(ss{1},'_',ss{2},'_WM_contra.nii.gz'));

ROI_WM = mdm_nii_read(ROI_wm_fn);
ROI_WM = ROI_WM(:,:,ss{3});

ROI_GD = mdm_nii_read(ROI_gd_fn);
ROI_GD = ROI_GD(:,:,ss{3});

contrast_name_list = {...
    'T1_MPRAGE_postc.nii.gz',...
    };

c_contrast_select = 1;
n_contrast = numel(contrast_scale_list);

n_exam  = 1;

m_upper = 0.1;
m_lower = 0.6;
m_left  = 0.1;
m_right = 0.1;
cnw     = 0;
ph      = 1;
phm1    = 0.1;
phm2    = 0.25;
phm     = [phm2 phm1 phm1 0];
enh     = 0;
pw      = 1;
pwm     = [0 0.1 0.4];

% Axis setup
n_c = 7;
fh = m_upper + enh  + n_exam * 2 * ph  + sum(phm)  + m_lower;
fw = m_left  + cnw  + n_c * pw  + sum(pwm) + m_right;

m_upper = m_upper / fh;
m_left  = m_left / fw;
ph      = ph / fh;
enh     = enh / fw;
pw      = pw / fw;

figure(183)
clf
set(gcf,'color', 'w');

c_con = 1;
c_row = 1;

nii_fn = fullfile(data_dir, contrast_name_list{c_contrast_select(c_con)});
I      = mdm_nii_read(nii_fn);

ax_l = m_left  + (c_con-1) * pw;
ax_b = 1 - m_upper - c_row * ph;
ax_w = pw;
ax_h = ph;
axes('position', [ax_l ax_b  ax_w ax_h]);

tmp    = I(:,:,ss{3},:);
tmp1   = crop_image(tmp,    ss{4}, ss{5});
mask   = crop_image(I_mask, ss{4}, ss{5});
ROI_GD = crop_image(ROI_GD, ss{4}, ss{5});
ROI_WM = crop_image(ROI_WM, ss{4}, ss{5});

% Plot
msf_imagesc(double(tmp1) .* double(mask));
plot_roi(flipud(double(ROI_GD)'));
plot_roi(flipud(double(ROI_WM)'),'b');

hold on;
caxis(contrast_scale_list{c_contrast_select(c_con)});
colormap gray

% set(gcf, 'pos', [ 98   126   829   676]);
set(gcf,'Color','k')
set(gcf, 'InvertHardcopy', 'off')

print(sprintf('STE_LTE_%d.png',c_subject),'-dpng','-r300')

end