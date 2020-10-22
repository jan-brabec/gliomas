clear
clc

%       bof  register what  register to timepoint what timepoint to
ss =  {'107', '20180420_1', '20180118_1', 2, 1;
       '108', '20180410_1', '20180125_1', 2, 1;
       '113', '20180817_1', '20180321_1', 2, 1;
       '121', '20181112_1', '20180903_1', 2, 1;
       '122', '20181206_1', '20180914_1', 2, 1;
       '131', '20190506_1', '20190125_1', 2, 1;
       '136', '20191011_1', '20190709_1', 2, 1;
       '140', '20191212_1', '20191022_1', 2, 1;
       '147', '20200130_1', '20191219_1', 2, 1;
       '117', '20180810_1', '20180608_1', 2, 1;
       '117', '20181025_1', '20180608_1', 3, 1;
       '117', '20190118_1', '20180608_1', 4, 1};

for i = 1:size(ss,1)
    
    ap = '../data/raw';
    tp = '../data/processed';
    zp = '../data/interim';
    
    subject_name = strcat('BoF130_APTw_',ss{i,1});
    disp(subject_name)
    
    s_exam1 = ss{i,3};
    s_exam2 = ss{i,2};
    exam_name = s_exam2;
    snum2 = num2str(ss{i,4});
    snum1 = num2str(ss{i,5});
    
    opt = mdm_opt;
    opt = mio_opt(opt);
    opt.do_overwrite = 1;
    opt.verbose      = 1;
    
    ip2  = fullfile(tp, subject_name, s_exam2, 'T1/ver1'); %2nd
    ipT2 = fullfile(tp, subject_name, s_exam2, 'T2'); 
    ip2d = fullfile(tp, subject_name, s_exam2, 'Diff/ver3', 'Serie_01_FWF'); %2nd
    ip1c = fullfile(tp, subject_name, s_exam1, 'T1_coreg'); %1st coregistered
    op2  = fullfile(tp, subject_name, s_exam2, 'T1_coreg2first'); %output
    wp   = fullfile(zp, subject_name, s_exam2, 'T1_coreg2first', 'tmp'); %write path
    msf_mkdir(op2); msf_mkdir(wp);
    
    %% T1 coregister second PRE to the first PRE and second POST to first POST
    
    % identify pre and post contrast files
    i1_t1_pre_nii_fn  = msf_find_fn(ip1c, 'T1_MPRAGE_pre.nii.gz', 0);
    i2_t1_pre_nii_fn  = msf_find_fn(ip2, 'T1_MPRAGE_pre.nii.gz', 0);
    i1_t1_post_nii_fn = msf_find_fn(ip1c,'T1_MPRAGE_post.nii.gz', 0);
    i2_t1_post_nii_fn = msf_find_fn(ip2, 'T1_MPRAGE_post.nii.gz', 0);
    
    o1_t1_pre_nii_fn  = fullfile(op2, strcat(snum1,'_T1_MPRAGE_pre.nii.gz'));
    o2_t1_pre_nii_fn  = fullfile(op2, strcat(snum2,'_T1_MPRAGE_pre.nii.gz'));
    o1_t1_post_nii_fn = fullfile(op2, strcat(snum1,'_T1_MPRAGE_post.nii.gz'));
    o2_t1_post_nii_fn = fullfile(op2, strcat(snum2,'_T1_MPRAGE_post.nii.gz'));
    
    if (0)
        
        % copy to pre to output
        copyfile(i1_t1_pre_nii_fn, o1_t1_pre_nii_fn);
        copyfile(i1_t1_post_nii_fn, o1_t1_post_nii_fn);
        
        % register second to first to PRE T1 with rigid body registration
        p_fn  = elastix_p_write(elastix_p_6dof(1500), fullfile(wp, 'p_t1_pre_pre.txt'));
        res_fn = elastix_run_elastix(i2_t1_pre_nii_fn, o1_t1_pre_nii_fn, p_fn, wp);
        
        % Save the result PRE
        [I2_pre,h] = mdm_nii_read(res_fn);
        mdm_nii_write(I2_pre, o2_t1_pre_nii_fn, h);
        
        % register second to first to POST T1 with rigid body registration
        p_fn  = elastix_p_write(elastix_p_6dof(1500), fullfile(wp, 'p_t1_post_post.txt'));
        res_fn = elastix_run_elastix(i2_t1_post_nii_fn, o1_t1_post_nii_fn, p_fn, wp);
        
        % Save the result POST
        [I2_post,h] = mdm_nii_read(res_fn);
        mdm_nii_write(I2_post, o2_t1_post_nii_fn, h);
        
    end
    
%% T2 coregister second to the first T2 and second POST to first POST
    
    % identify pre and post contrast files
    i1_t2_nii_fn  = msf_find_fn(ip1c, 'T2_FLAIR.nii.gz', 0);
    i2_t2_nii_fn  = msf_find_fn(ipT2, 'T2_FLAIR.nii.gz', 0);
    
    o1_t2_nii_fn  = fullfile(op2, strcat(snum1,'_T2_FLAIR.nii.gz'));
    o2_t2_nii_fn  = fullfile(op2, strcat(snum2,'_T2_FLAIR.nii.gz'));
    
    if (0)
        % copy to pre to output
        copyfile(i1_t2_nii_fn, o1_t2_nii_fn);
        
        % register second to first to PRE T1 with rigid body registration
        p_fn  = elastix_p_write(elastix_p_6dof(1500), fullfile(wp, 'p_t1_pre_pre.txt'));
        res_fn = elastix_run_elastix(i2_t2_nii_fn, o1_t2_nii_fn, p_fn, wp);
        
        % Save the result PRE
        [I2_pre,h] = mdm_nii_read(res_fn);
        mdm_nii_write(I2_pre, o2_t2_nii_fn, h);

        
    end    
    
    if (1)
        %% Diffusion coregister SECOND dMRI to FIRST PRE T1, COPY FIRST
        
        i_pa_nii_fn = msf_find_fn(ip2d, 'FWF_topup_pa.nii.gz');
        [I_T1, h_T1] = mdm_nii_read(i1_t1_pre_nii_fn);
        [I_PA, h_PA] = mdm_nii_read(i_pa_nii_fn);
        
        if i == 1 %107 ok
            I_PA(:,:,36:37,:) = [];
            I_PA(:,:,1,:) = [];
            I_PA(:,90:end,:,:) = 0;
            
            h_PA.qform_code = 0;
            h_PA.srow_x(4) = h_PA.srow_x(4) - 0;
            h_PA.srow_y(4) = h_PA.srow_y(4) + 9;
            h_PA.srow_z(4) = h_PA.srow_z(4) - 6;
            p = elastix_p_6dof(1000);
            
        elseif i == 2 %108 fix
            I_PA(:,:,36:37,:) = [];
            I_PA(:,:,1,:) = [];
            I_PA(:,90:end,:,:) = 0;
            
            h_PA.qform_code = 0;
            h_PA.srow_x(4) = h_PA.srow_x(4) + 3;
            h_PA.srow_z(4) = h_PA.srow_z(4) + 20;
            p = elastix_p_6dof(1000);
            
        elseif i == 3 %113 ok
            h_PA.qform_code = 0;
            h_PA.srow_x(4) = h_PA.srow_x(4) - 3;
            h_PA.srow_y(4) = h_PA.srow_y(4) - 4;
            h_PA.srow_z(4) = h_PA.srow_z(4) + 30;
            p = elastix_p_6dof(1000);
            
        elseif i == 4 %121 ok
            h_PA.qform_code = 0;
            h_PA.srow_x(4) = h_PA.srow_x(4) + 6;
            h_PA.srow_z(4) = h_PA.srow_z(4) + 18;
            p = elastix_p_6dof(1000);
            
        elseif i == 5 %122 ok
            h_PA.qform_code = 0;
            h_PA.srow_x(4) = h_PA.srow_x(4) + 13;
            h_PA.srow_y(4) = h_PA.srow_y(4) - 9;
            h_PA.srow_z(4) = h_PA.srow_z(4) - 15;
            p = elastix_p_6dof(1000);
            
        elseif i == 6 %131 ok
            h_PA.qform_code = 0;
            h_PA.srow_x(4) = h_PA.srow_x(4) + 5;
            h_PA.srow_y(4) = h_PA.srow_y(4) - 9;
            h_PA.srow_z(4) = h_PA.srow_z(4) - 21;
            p = elastix_p_6dof(1000);
            
        elseif i == 7 %136 ok
            h_PA.qform_code = 0;
            h_PA.srow_x(4) = h_PA.srow_x(4) + 2;
            h_PA.srow_y(4) = h_PA.srow_y(4) + 5;
            h_PA.srow_z(4) = h_PA.srow_z(4) - 1;
            p = elastix_p_6dof(1000);
            
        elseif i == 8 %140 ok
            I_PA(:,:,35:37,:) = [];
            I_PA(:,85:end,7:18,:) = 0;
            p = elastix_p_6dof(1000);
            
        elseif i == 9 % 147 ok
            I_PA(:,:,35:37,:) = [];
            I_PA(:,:,1,:) = [];
            p = elastix_p_6dof(1000);
            
        elseif i == 10 %117 ok
            h_PA.qform_code = 0;
            h_PA.srow_x(4) = h_PA.srow_x(4) + 15;
            h_PA.srow_z(4) = h_PA.srow_z(4) + 27;
            p = elastix_p_6dof(1000);
            
        elseif i == 11 %117 ok
            h_PA.qform_code = 0;
            h_PA.srow_x(4) = h_PA.srow_x(4) + 13;
            h_PA.srow_y(4) = h_PA.srow_y(4) + 5;
            h_PA.srow_z(4) = h_PA.srow_z(4) - 10;
            
            I_PA(:,:,35:37,:) = [];
            I_PA(:,:,1,:) = [];
            p = elastix_p_6dof(1000);
            
        elseif i == 12 %117 ok
            h_PA.qform_code = 0;
            h_PA.srow_x(4) = h_PA.srow_x(4) + 18;
            h_PA.srow_y(4) = h_PA.srow_y(4) - 5;
            h_PA.srow_z(4) = h_PA.srow_z(4) + 40;
            p = elastix_p_6dof(1000);
        end
        
        [I_reg, tp, ~, elastix_t] = mio_coreg(I_PA(:,:,:,end), I_T1, p, opt, h_PA, h_T1);
        
        if (0) % debug
            mdm_nii_write(I_reg, fullfile(op2,'FWF_topup_pa.nii.gz'), h_T1);
            
            dim = 1;
            clf
            subplot(2,2,1);
            msf_imagesc(I_reg,dim);
            
            subplot(2,2,2);
            msf_imagesc(I_T1, dim);
            
            A = double(I_T1) / max(double(I_T1(:)));
            B = double(I_reg) / max(double(I_reg(:)));
            Z = zeros(size(A));
            
            subplot(2,2,3);
            X = double(permute(cat(4,A,B,Z), [4 1 2 3]));
            X = X * 2;
            X(X > 1) = 1;
            
            msf_imagesc(X, dim);
            error('stop');
        end
        
        % Separate STE_pa, LTE_pa to two files
        mdm_nii_write(I_PA(:,:,:,7),fullfile(ip2d,'LTE_b_2000_2to1.nii.gz'), h_PA);
        mdm_nii_write(I_PA(:,:,:,8),fullfile(ip2d,'STE_b_2000_2to1.nii.gz'), h_PA);
        mdm_nii_write(I_PA         ,fullfile(ip2d,'FWF_topup_pa_2to1.nii.gz'), h_PA);
        
        % Apply the transform to all dMRI contrasts second timepoint
        i_dmri_contrasts = { ...
            'dtd_covariance_MD.nii.gz', ...
            'dtd_covariance_MKi.nii.gz', ...
            'dtd_covariance_MKa.nii.gz'...
            'dtd_covariance_MKt.nii.gz'...
            'LTE_b_2000_2to1.nii.gz'...
            'STE_b_2000_2to1.nii.gz'...
            'FWF_topup_pa_2to1.nii.gz'};
        
        o_dmri_contrasts = { ...
            strcat(snum2,'_dtd_covariance_MD.nii.gz'), ...
            strcat(snum2,'_dtd_covariance_MKi.nii.gz'), ...
            strcat(snum2,'_dtd_covariance_MKa.nii.gz')...
            strcat(snum2,'_dtd_covariance_MKt.nii.gz')...
            strcat(snum2,'_LTE_b_2000.nii.gz')...
            strcat(snum2,'_STE_b_2000.nii.gz')...
            strcat(snum2,'_FWF_topup_pa.nii.gz')...
            };
        
        for c = 1:numel(i_dmri_contrasts)
            i_dmri_nii_fns{c} = fullfile(ip2d, i_dmri_contrasts{c});
            o_dmri_nii_fns{c} = fullfile(op2, o_dmri_contrasts{c});
        end
        
        for c = 1:numel(i_dmri_nii_fns)
            I = double(mdm_nii_read(i_dmri_nii_fns{c}));
            T = mio_transform(I, elastix_t, h_PA, opt);
            mdm_nii_write(T, o_dmri_nii_fns{c}, h_T1);
        end
        
        % Copy FIRST coregistered dMRI to OUTPUT
        copyfile(fullfile(ip1c, 'dtd_covariance_MD.nii.gz'),  fullfile(op2,strcat(snum1,'_dtd_covariance_MD.nii.gz')));
        copyfile(fullfile(ip1c, 'dtd_covariance_MKi.nii.gz'), fullfile(op2,strcat(snum1,'_dtd_covariance_MKi.nii.gz')));
        copyfile(fullfile(ip1c, 'dtd_covariance_MKa.nii.gz'), fullfile(op2,strcat(snum1,'_dtd_covariance_MKa.nii.gz')));
        copyfile(fullfile(ip1c, 'dtd_covariance_MKt.nii.gz'), fullfile(op2,strcat(snum1,'_dtd_covariance_MKt.nii.gz')));        
        copyfile(fullfile(ip1c, 'LTE_b_2000.nii.gz'),         fullfile(op2,strcat(snum1,'_LTE_b_2000.nii.gz')));
        copyfile(fullfile(ip1c, 'STE_b_2000.nii.gz'),         fullfile(op2,strcat(snum1,'_STE_b_2000.nii.gz')));
        copyfile(fullfile(ip1c, 'FWF_topup_pa.nii.gz'),       fullfile(op2,strcat(snum1,'_FWF_topup_pa.nii.gz')));
        
    end
    
    clearvars -except i ss
end