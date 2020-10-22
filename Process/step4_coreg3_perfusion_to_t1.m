function a = step4_coreg3_perfusion_to_t1(s)
% function a = coreg3_perfusion_to_t1(s)

a = [];
ap = '../data/raw';
tp = '../data/processed';
zp = '../data/interim';

if (nargin == 0)
    clc; mdm_iter_lund(tp, @step4_coreg3_perfusion_to_t1); return;
end


if (~strcmp(s.modality_name, 'Perf/ver1')), return; end
if (~strcmp(s.subject_name(end-2:end), '136')) || (~strcmp(s.exam_name, '20191011_1')), return; end

disp(s.subject_name);

opt = mdm_opt;
opt.do_overwrite = 1;
opt.verbose      = 1;

% ip - input path, op - output path, wp - interim path
ip = fullfile(tp, s.subject_name, s.exam_name, s.modality_name);
op = fullfile(tp, s.subject_name, s.exam_name, 'T1_coreg');
wp = fullfile(zp, s.subject_name, s.exam_name, 'T1_coreg', 'tmp');
msf_mkdir(op); msf_mkdir(wp);

% identify pre contrast image and the powder averaged dMRI data
if (~strcmp(s.subject_name(end-2:end), '133'))
    i_t1_nii_fn = msf_find_fn(op, 'T1_MPRAGE_pre.nii.gz', 0);
else
    i_t1_nii_fn = msf_find_fn(op, 'T1_MPRAGE_post.nii.gz', 0);
end

i_pe_nii_fn = msf_find_fn(ip, 'ep2d_perf.nii.gz', 0);

perf_contrasts = { ...
    'rBV_bw.nii.gz', ...
    'rBF_bw.nii.gz', ...
    'rBV_col.nii.gz', ...
    'rBF_col.nii.gz'};

for c = 1:numel(perf_contrasts)
    i_perf_nii_fns{c} = fullfile(ip, perf_contrasts{c});
    o_perf_nii_fns{c} = fullfile(op, perf_contrasts{c});
end

if (opt.do_overwrite) || (~exist(i_perf_nii_fns{end}, 'file'))
    
    % Find the transform using the last PA data
    [I_T1, h_T1] = mdm_nii_read(i_t1_nii_fn);
    [I_PE, h_PE] = mdm_nii_read(i_pe_nii_fn);
    
    p = elastix_p_6dof(500);
    
    opt = mio_opt(opt);
    
    I_PE_avg = mean(I_PE,4);
    mdm_nii_write(I_PE_avg, fullfile(ip,'ep2d_perf_pa.nii.gz'), h_PE); %output for sanity check
    
    [I_reg, tp, ~, elastix_t] = mio_coreg(I_PE_avg, I_T1, p, opt, h_PE, h_T1);
    mdm_nii_write(I_reg, fullfile(ip,'ep2d_perf_coreg.nii.gz'), h_T1); 
    
    % Apply the transform to all perf contrasts
    for c = 1:numel(i_perf_nii_fns)
        
        I = double(mdm_nii_read(i_perf_nii_fns{c}));
        
        if ndims(I)<4
            T = mio_transform(I, elastix_t, h_PE, opt);
            mdm_nii_write(T, o_perf_nii_fns{c}, h_T1);
        else
            T = zeros(size(I,1),size(I_T1,1),size(I_T1,2),size(I_T1,3));
            for i = 1:size(I,1)
                T(i,:,:,:) = mio_transform(squeeze(I(i,:,:,:)), elastix_t, h_PE, opt);
            end
            
            mdm_nii_write(T, o_perf_nii_fns{c}, h_T1, 1); %is colour = 1
        end
    end
        
end


end









