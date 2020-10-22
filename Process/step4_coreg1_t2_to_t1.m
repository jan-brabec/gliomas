function a = step4_coreg1_t2_to_t1(s)
% function a = step4_coreg1_t2_to_t1(s)

a = [];
ap = '../data/raw';
tp = '../data/processed';
zp = '../data/interim';

if (nargin == 0)
    clc; mdm_iter_lund(tp, @step4_coreg1_t2_to_t1); return;
end

if (~strcmp(s.modality_name, 'T1/ver1')), return; end
% if (~strcmp(s.subject_name(end-2:end), '136')) || (~strcmp(s.exam_name, '20190709_1')), return; end
% if (~strcmp(s.subject_name(end-2:end), '104')), return; end

disp(s.subject_name);

opt = mdm_opt;
opt.do_overwrite = 1;
opt.verbose      = 1;

% ip - input path, op - output path, wp - interim path
ip_raw = fullfile(ap, s.subject_name, s.exam_name, 'NII');
ip     = fullfile(tp, s.subject_name, s.exam_name, 'T2');
op = fullfile(tp, s.subject_name, s.exam_name, 'T1_coreg');
wp = fullfile(zp, s.subject_name, s.exam_name, 'T1_coreg', 'tmp');
msf_mkdir(op); msf_mkdir(wp); msf_mkdir(ip);

%% identify pre and post contrast files and copy them
bof = str2num(s.subject_name(end-2:end));
if bof == 101 || bof == 102 || bof == 133
    i_t2_nii_fn = msf_find_fn(ip_raw, '*t2_tirm_tra_dark*', 0);
elseif bof == 119 || bof == 132
    i_t2_nii_fn = msf_find_fn(ip_raw, '*t2_spc_da-fl_sag*', 0);
else
    i_t2_nii_fn = msf_find_fn(ip_raw, '*t2_spc_da-fl*', 0); %find
end

o_t2_copy_nii_fn = fullfile(ip, 'T2_FLAIR.nii.gz'); %just copied

if (opt.do_overwrite || ~exist(o_t2_copy_nii_fn, 'file'))
    copyfile(i_t2_nii_fn, o_t2_copy_nii_fn);
end

%% register post to pre T1 with rigid body registration from copied file
o_t2_nii_fn   = fullfile(op, 'T2_FLAIR.nii.gz'); %coregistered
t1_pre_nii_fn = msf_find_fn(op, 'T1_MPRAGE_pre.nii.gz', 0);

%129 no T2

if (opt.do_overwrite || ~exist(o_t2_nii_fn, 'file'))
    p_fn = elastix_p_write(elastix_p_6dof(1500), fullfile(wp, 'p_t1_pre_post.txt'));
    res_fn = elastix_run_elastix(o_t2_copy_nii_fn, t1_pre_nii_fn, p_fn, wp);
    
    % Save the result
    [I_T2,h] = mdm_nii_read(res_fn);
    mdm_nii_write(I_T2, o_t2_nii_fn, h);
end


% Check the result
if (1)
    I_T1_pre = mdm_nii_read(t1_pre_nii_fn);
    I_T2 = mdm_nii_read(o_t2_nii_fn);
    
    figure;
    msf_imagesc(cat(1, I_T1_pre, I_T2));
end


end