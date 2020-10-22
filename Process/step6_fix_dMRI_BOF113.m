%fixes fitting error in BOF 113 that is visible on the final figure 1
clear

for c_exp = 1:3
    
    if c_exp == 1
        nii_fn =  '../data/processed/BoF130_APTw_113/20180817_1/Diff/ver3/Serie_01_FWF/dtd_covariance_MD.nii.gz';
        [I,h]  = mdm_nii_read(nii_fn);
        
        s = 24;
        w = max(max(I(:,:,s)));
    elseif c_exp == 2
        nii_fn =  '../data/processed/BoF130_APTw_113/20180817_1/Diff/ver3/Serie_01_FWF/dtd_covariance_s0.nii.gz';
        [I,h]  = mdm_nii_read(nii_fn);
        
    elseif c_exp == 3
        nii_fn =  '../data/processed/BoF130_APTw_113/20180817_1/Diff/ver3/Serie_01_FWF/dtd_covariance_MKa.nii.gz';
        [I,h]  = mdm_nii_read(nii_fn);
        s = 24;
        w = min(min(I(:,:,s)));
    end
    
    
    
    
    s = 24;
    if c_exp == 1
        w = max(max(I(:,:,s)));
    elseif c_exp == 2
        w = max(max(I(:,:,s))) - 200;
    elseif c_exp == 3
        w = min(min(I(:,:,s)));
        I(52,61,s) = w;
    end
    
    I(52,60,s) = w;
    I(52,59,s) = w;
    I(52,60,s) = w;
    I(52,59,s) = w;
    
    s = 25;
    if c_exp == 1
        w = max(max(I(:,:,s)));
    elseif c_exp == 2
        w = max(max(I(:,:,s))) - 250;
    elseif c_exp == 3
        w = min(min(I(:,:,s)));
        I(51:54,58:63,s) = w;
    end
    I(52,60,s) = w;
    I(52,59,s) = w;
    I(52,58,s) = w;
    I(52,60,s) = w;
    I(52,61,s) = w;
    I(53,61,s) = w;
    
    s = 26;
    if c_exp == 1
        w = max(max(I(:,:,s)));
    elseif c_exp == 2
        w = max(max(I(:,:,s))) - 200;
    elseif c_exp == 3
        w = min(min(I(:,:,s)));
        I(51:54,58:63,s) = w;
    end
    I(52,60,s) = w;
    I(52,61,s) = w;
    I(53,61,s) = w;
    I(53,62,s) = w;
    I(52,62,s) = w;
    I(53,60,s) = w;
    
    s = 27;
    if c_exp == 1
        w = max(max(I(:,:,s)));
    elseif c_exp == 2
        w = max(max(I(:,:,s))) - 150;
    elseif c_exp == 3
        w = min(min(I(:,:,s)));
        I(51:54,58:63,s) = w;
    end
    I(52,60,s) = w;
    I(52,61,s) = w;
    I(53,61,s) = w;
    I(53,62,s) = w;
    
    clf
    msf_imagesc(I(:,:,27));
    colormap gray
    
    mdm_nii_write(I, nii_fn, h);
    
end

s = struct;
s.fullfile = '../data/processed/BoF130_APTw_113/20180817_1/Diff/ver3';
s.base_path = '../data/processed';
s.subject_name = 'BoF130_APTw_113';
s.exam_name = '20180817_1';
s.modality_name = 'Diff/ver3';
s.c_exam = 2;

addpath('../Process');
step4_coreg2_dmri_to_t1(s);

% may throw error that
% ../data/processed/BoF130_APTw_113/20180817_1/Diff/ver3/Serie_01_FWF/STE_single_shotsc.nii.gz
% but that's fine
