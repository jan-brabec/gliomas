function a = step4_coreg4_cest_to_t1(s)
% function a = coreg4_cest_to_t1(s)

a = [];
ap = '../data/raw';
tp = '../data/processed';
zp = '../data/interim';

if (nargin == 0)
    clc; mdm_iter_lund(tp, @step4_coreg4_cest_to_t1); return;
end

if (~strcmp(s.modality_name, 'CEST/ver1')), return; end
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
i_ce_nii_fn = msf_find_fn(ip, 'CEST_tra_1_REG.nii.gz', 0);

cest_contrasts = {...
    'CEST_tra_1_BW.nii.gz', ...
    };

for c = 1:numel(cest_contrasts)
    i_ce_nii_fns{c} = fullfile(ip, cest_contrasts{c});
    o_ce_nii_fns{c} = fullfile(op, cest_contrasts{c});
end

if (opt.do_overwrite) || (~exist(i_ce_nii_fns{end}, 'file'))
    
    % Find the transform using the last PA data
    [I_T1, h_T1] = mdm_nii_read(i_t1_nii_fn);
    [I_CE, h_CE] = mdm_nii_read(i_ce_nii_fn);
    
    p = elastix_p_affine(500);
    
    opt = mio_opt(opt);
    
    I_CE2reg = I_CE(:,:,:,1);
    mdm_nii_write(I_CE2reg, fullfile(ip,'cest_reg_pa.nii.gz'), h_CE); %output for sanity check, take average? no, right_
    
    [I_reg, tp, ~, elastix_t] = mio_coreg(I_CE2reg, I_T1, p, opt, h_CE, h_T1);
    
    mdm_nii_write(I_reg, fullfile(ip,'cest_reg_coreg.nii.gz'), h_T1); %output for sanity check
    
    % Apply the transform to all perf contrasts
    for c = 1:numel(cest_contrasts)
        
        [I,h_tmp] = (mdm_nii_read(i_ce_nii_fns{c}));
        I = double(I);
        T = mio_transform(I, elastix_t, h_CE, opt);
        h = h_T1;
               
        % Remap to percentage units
        if (strcmp(cest_contrasts{c}, 'CEST_tra_1_BW.nii.gz'))
            scale = 10;
            intercept = 2048;
            
            h.scl_slope = 100 / (2000 * scale);
            h.scl_inter = -intercept * h.scl_slope;
                       
        end
        
        mdm_nii_write(T, o_ce_nii_fns{c}, h);
        
        % Repmap to color
        if (strcmp(cest_contrasts{c}, 'CEST_tra_1_BW.nii.gz'))
            T = mdm_nii_read_and_rescale(o_ce_nii_fns{c});
            cmap = ff_cmap_viridis(256);
            T = mio_min_max_cut(T, -5, 5);
            T = floor( (T + 5) / 10 * 255.999) + 1;
            
            TC = cat(4, ...
                reshape(cmap(T(:),1), size(T)), ...
                reshape(cmap(T(:),2), size(T)), ...
                reshape(cmap(T(:),3), size(T)));
                
            TC = permute(TC, [4 1 2 3]);
            
            col_fn = fullfile(op, 'CEST_tra_1_col_viridis.nii.gz');
            mdm_nii_write(uint8(TC * 256), col_fn, h_T1, 1);
            
        end
        
        
    end
    
    
end

return;

end












