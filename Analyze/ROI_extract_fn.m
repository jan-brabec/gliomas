function dat = ROI_extract_fn(s)
% function dat = ROI_extract(s)

global dat iter_no

tp = '../data/processed';
rp = '../data/roi_Enhancements';

if (nargin == 0)
    clc; mdm_iter_lund(tp, @ROI_extract_fn); return;
end

if (~strcmp(s.modality_name, 'Diff/ver3')), return; end
% if (~strcmp(s.subject_name(end-2:end), '152')), return; end

op = fullfile(tp, s.subject_name, s.exam_name, 'T1_coreg');

disp(s.subject_name)

roi_pgd_fn = fullfile(rp,strcat(s.subject_name(end-2:end),'_',s.exam_name,'_Gd_enh.nii.gz'));
roi_ste_fn = fullfile(rp,strcat(s.subject_name(end-2:end),'_',s.exam_name,'_STE_enh.nii.gz'));
roi_lte_fn = fullfile(rp,strcat(s.subject_name(end-2:end),'_',s.exam_name,'_LTE_enh.nii.gz'));
roi_mki_fn = fullfile(rp,strcat(s.subject_name(end-2:end),'_',s.exam_name,'_MKI_enh.nii.gz'));
roi_WMc_fn = fullfile(rp,strcat(s.subject_name(end-2:end),'_',s.exam_name,'_WM_contra.nii.gz'));
roi_pgw_fn = fullfile(rp,strcat(s.subject_name(end-2:end),'_',s.exam_name,'_TF1.nii.gz'));

pgd_fn = fullfile(op,'T1_MPRAGE_postc.nii.gz');
mki_fn = fullfile(op,'dtd_covariance_MKi.nii.gz');
mka_fn = fullfile(op,'dtd_covariance_MKa.nii.gz');
mkt_fn = fullfile(op,'dtd_covariance_MKt.nii.gz');

ste2000_fn = fullfile(op,'STE_b_2000c.nii.gz');
lte2000_fn = fullfile(op,'LTE_b_2000c.nii.gz');

ste1400_fn = fullfile(op,'STE_b_1400c.nii.gz');
lte1400_fn = fullfile(op,'LTE_b_1400c.nii.gz');

ste700_fn  = fullfile(op,'STE_b_700c.nii.gz');
lte700_fn  = fullfile(op,'LTE_b_700c.nii.gz');

s0_fn      = fullfile(op,'dtd_covariance_s0.nii.gz');

if ~exist(lte2000_fn) || ~exist(pgd_fn)
    dat(iter_no).bof = str2num(s.subject_name(end-2:end));
    dat(iter_no).del = 1;
    iter_no = iter_no + 1;
    return;
end

try
    I_roi_pgw = mdm_nii_read(roi_pgw_fn);
catch
    I_roi_pgw = 0;
end

try
    I_roi_pgd = mdm_nii_read(roi_pgd_fn);
catch
    I_roi_pgd = 0;
end

try
    I_roi_ste = mdm_nii_read(roi_ste_fn);
catch
    I_roi_ste = 0;
end

try
    I_roi_lte = mdm_nii_read(roi_lte_fn);
catch
    I_roi_lte = 0;
end

try
    I_roi_mki = mdm_nii_read(roi_mki_fn);
catch
    I_roi_mki = 0;
end

try
    I_roi_WMc = mdm_nii_read(roi_WMc_fn);
catch
    I_roi_WMc = 0;
end

try
    I_pgd = mdm_nii_read(pgd_fn);
catch
    I_pgd = 0;
end

try
    I_ste2000 = mdm_nii_read(ste2000_fn);
catch
    I_ste2000 = 0;
end

try
    I_lte2000 = mdm_nii_read(lte2000_fn);
catch
    I_lte2000 = 0;
end

try
    I_ste1400 = mdm_nii_read(ste1400_fn);
catch
    I_ste1400 = 0;
end

try
    I_lte1400 = mdm_nii_read(lte1400_fn);
catch
    I_lte1400 = 0;
end

try
    I_ste700 = mdm_nii_read(ste700_fn);
catch
    I_ste700 = 0;
end

try
    I_lte700 = mdm_nii_read(lte700_fn);
catch
    I_lte700 = 0;
end

try
    I_s0 = mdm_nii_read(s0_fn);
catch
    I_s0 = 0;
end

try
    I_mki = mdm_nii_read(mki_fn);
catch
    I_mki = 0;
end

try
    I_mka = mdm_nii_read(mka_fn);
catch
    I_mka = 0;
end

try
    I_mkt = mdm_nii_read(mkt_fn);
catch
    I_mkt = 0;
end

lte2000 = mean(I_lte2000(I_roi_lte > 0),'omitnan') / mean(I_lte2000(I_roi_WMc > 0),'omitnan');
sprintf('LTE2000: %0.2g',lte2000)

lte2000_with_ste = mean(I_lte2000(I_roi_ste > 0),'omitnan') / mean(I_lte2000(I_roi_WMc > 0),'omitnan');
sprintf('LTE2000: %0.2g',lte2000_with_ste)

lte2000_90th = prctile(I_lte2000(I_roi_lte > 0),90) / mean(I_lte2000(I_roi_WMc > 0),'omitnan');
sprintf('LTE2000: %0.2g',lte2000_90th)

lte2000_10th = prctile(I_lte2000(I_roi_lte > 0),10) / mean(I_lte2000(I_roi_WMc > 0),'omitnan');
sprintf('LTE2000: %0.2g',lte2000_10th)

lte700_with_ste = mean(I_lte700(I_roi_ste > 0),'omitnan') / mean(I_lte700(I_roi_WMc > 0),'omitnan');
sprintf('LTE700: %0.2g',lte700_with_ste)

lte1400 = mean(I_lte1400(I_roi_lte > 0),'omitnan') / mean(I_lte1400(I_roi_WMc > 0),'omitnan');
sprintf('LTE1400: %0.2g',lte1400)

lte700 = mean(I_lte700(I_roi_lte > 0),'omitnan') / mean(I_lte700(I_roi_WMc > 0),'omitnan');
sprintf('LTE700: %0.2g',lte700)

ste2000 = mean(I_ste2000(I_roi_ste > 0),'omitnan') / mean(I_ste2000(I_roi_WMc > 0),'omitnan');
sprintf('STE2000: %0.2g',ste2000)

ste2000_90th = prctile(I_ste2000(I_roi_ste > 0),90) / mean(I_ste2000(I_roi_WMc > 0),'omitnan');
sprintf('STE2000: %0.2g',ste2000_90th)

ste2000_10th = prctile(I_ste2000(I_roi_ste > 0),10) / mean(I_ste2000(I_roi_WMc > 0),'omitnan');
sprintf('STE2000: %0.2g',ste2000_10th)

ste1400 = mean(I_ste1400(I_roi_ste > 0),'omitnan') / mean(I_ste1400(I_roi_WMc > 0),'omitnan');
sprintf('STE1400: %0.2g',ste1400)

ste700 = mean(I_ste700(I_roi_ste > 0),'omitnan') / mean(I_ste700(I_roi_WMc > 0),'omitnan');
sprintf('STE700: %0.2g',ste700)

s0 = mean(I_s0(I_roi_ste > 0),'omitnan') / mean(I_s0(I_roi_WMc > 0),'omitnan');
sprintf('S0: %0.2g',s0)

pgd = mean(I_pgd(I_roi_pgd > 0),'omitnan') / mean(I_pgd(I_roi_WMc > 0),'omitnan');
sprintf('PGD: %0.2g',pgd)

mki_in_pgw     = I_mki(I_roi_pgw > 0);
mka_in_pgw     = I_mka(I_roi_pgw > 0);
mkt_in_pgw     = I_mkt(I_roi_pgw > 0);
lte2000_in_pgw = I_lte2000(I_roi_pgw > 0);
ste2000_in_pgw = I_ste2000(I_roi_pgw > 0);
lte700_in_pgw  = I_lte700(I_roi_pgw > 0);
ste700_in_pgw  = I_ste700(I_roi_pgw > 0);

mki_vs_wm = mean(I_mki(I_roi_mki > 0),'omitnan') / mean(I_mki(I_roi_WMc > 0),'omitnan');
mkt_vs_wm = mean(I_mkt(I_roi_mki > 0),'omitnan') / mean(I_mkt(I_roi_WMc > 0),'omitnan');

mki_val_in_STE = I_mki(I_roi_ste > 0);
mka_val_in_STE = I_mka(I_roi_ste > 0);
mkt_val_in_STE = I_mkt(I_roi_ste > 0);

mki_val_in_WM = I_mki(I_roi_WMc > 0);
mka_val_in_WM = I_mka(I_roi_WMc > 0);
mkt_val_in_WM = I_mkt(I_roi_WMc > 0);

dat(iter_no).bof = str2num(s.subject_name(end-2:end));
dat(iter_no).lte2000 = lte2000;
dat(iter_no).lte2000_90th = lte2000_90th;
dat(iter_no).lte2000_10th = lte2000_10th;
dat(iter_no).ste2000 = ste2000;
dat(iter_no).ste2000_90th = ste2000_90th;
dat(iter_no).ste2000_10th = ste2000_10th;
dat(iter_no).lte1400 = lte1400;
dat(iter_no).ste1400 = ste1400;
dat(iter_no).lte700  = lte700;
dat(iter_no).ste700  = ste700;

dat(iter_no).lte2000_with_ste  = lte2000_with_ste;
dat(iter_no).lte700_with_ste   = lte700_with_ste;

dat(iter_no).s0      = s0;
dat(iter_no).pgd     = pgd;
dat(iter_no).del     = 0;

dat(iter_no).mki_vs_wm      = mki_vs_wm;
dat(iter_no).mkt_vs_wm_in_mki_ROI  = mkt_vs_wm;

dat(iter_no).mki_val_in_STE = mki_val_in_STE;
dat(iter_no).mka_val_in_STE = mka_val_in_STE;
dat(iter_no).mkt_val_in_STE = mkt_val_in_STE;
dat(iter_no).mki_val_in_WM  = mki_val_in_WM;
dat(iter_no).mka_val_in_WM  = mka_val_in_WM;
dat(iter_no).mkt_val_in_WM  = mkt_val_in_WM;

dat(iter_no).mki_in_pgw  = mki_in_pgw;
dat(iter_no).mka_in_pgw  = mka_in_pgw;
dat(iter_no).mkt_in_pgw  = mkt_in_pgw;
dat(iter_no).lte2000_in_pgw  = lte2000_in_pgw;
dat(iter_no).ste2000_in_pgw  = ste2000_in_pgw;
dat(iter_no).lte700_in_pgw  = lte700_in_pgw;
dat(iter_no).ste700_in_pgw  = ste700_in_pgw;

dat(iter_no).num_roi_wmc = numel(find(I_roi_WMc>0));
dat(iter_no).num_roi_mki = numel(find(I_roi_mki>0));
dat(iter_no).num_roi_lte = numel(find(I_roi_lte>0));
dat(iter_no).num_roi_ste = numel(find(I_roi_ste>0));

dat(iter_no).s = s;



sprintf('-----------------')

iter_no = iter_no + 1;

end


