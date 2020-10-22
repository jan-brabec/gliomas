function a = step2_copy_cest(s)
% function a = step_copy_cest(s)

a = [];
rp = '../data/raw/';
tp = '../data/processed/';

if (nargin == 0)
    %     run ../../../../MATLAB/mdm/setup_paths
    mdm_iter_lund(rp, @step2_copy_cest);
    return;
end


ip = fullfile(rp, s.subject_name, s.exam_name, 'NII');
op = fullfile(tp, s.subject_name, s.exam_name, 'CEST/ver1');

% if (~strcmp(s.subject_name(end-2:end), '119')), return; end

msf_mkdir(op);

disp(s.subject_name)


% those that are called 3d_gauss_spoil are turbo-spin echo and the analysis
% need a different treatment, these are in this analysis disregarded
% these are approx 4 cases and are not copied to the raw folder from server

% all other are gradient echo sequences

if ~strcmp(s.subject_name(end-2:end), '101') &&...
        ~strcmp(s.subject_name(end-2:end), '102') && ...
        ~strcmp(s.subject_name(end-2:end), '103') && ...
        ~strcmp(s.subject_name(end-2:end), '126') && ...
        ~strcmp(s.subject_name(end-2:end), '129')
    
    i_cest_nii_fn{1} = msf_find_fn(ip, '*tra_1_REG.nii.gz',1); %REG, temlate for coregistration
    i_cest_nii_fn{2} = msf_find_fn(ip, '*tra_1_CEST_BW.nii.gz',1); %BW, map
    
    
    %Fix special cases where the naming is different
elseif strcmp(s.subject_name(end-2:end), '101')
    i_cest_nii_fn{1} = msf_find_fn(ip, 'Serie_05_aptw_cest_3d_tra_REG.nii.gz',1); %REG
    i_cest_nii_fn{2} = msf_find_fn(ip, 'Serie_08_aptw_cest_3d_tra_CEST_BW.nii.gz',1); %BW
    
elseif strcmp(s.subject_name(end-2:end), '102')
    i_cest_nii_fn{1} = msf_find_fn(ip, 'Serie_05_aptw_cest_3d_tra_REG.nii.gz',1);
    i_cest_nii_fn{2} = msf_find_fn(ip, 'Serie_08_aptw_cest_3d_tra_CEST_BW.nii.gz',1);
    
elseif strcmp(s.subject_name(end-2:end), '103')
    i_cest_nii_fn{1} = msf_find_fn(ip, 'Serie_06_aptw_cest_3d_tra_REG.nii.gz',1);
    i_cest_nii_fn{2} = msf_find_fn(ip, 'Serie_09_aptw_cest_3d_tra_CEST_BW.nii.gz',1);
    
elseif strcmp(s.subject_name(end-2:end), '126')
    i_cest_nii_fn{1} = msf_find_fn(ip, 'Serie_10_aptw_cest_3d_tra_1_REG.nii.gz',1);
    i_cest_nii_fn{2} = msf_find_fn(ip, 'Serie_13_aptw_cest_3d_tra_1_CEST_BW.nii.gz',1);
    
elseif strcmp(s.subject_name(end-2:end), '129')
    i_cest_nii_fn{1} = msf_find_fn(ip, 'Serie_05_aptw_cest_3d_tra_1_REG.nii.gz',1);
    i_cest_nii_fn{2} = msf_find_fn(ip, 'Serie_08_aptw_cest_3d_tra_1_CEST_BW.nii.gz',1);
end

%output names for all
o_cest_nii_fn{1} = fullfile(op, 'CEST_tra_1_REG.nii.gz');
o_cest_nii_fn{2} = fullfile(op, 'CEST_tra_1_BW.nii.gz');


%No CEST data for:
% 106 3rd timepoint (20180313_2)
% 119 1st timepoint (20180822_1)
% 123
% 124
% 125
% 128


for i = 1:2
    
    copyfile( i_cest_nii_fn{i}, o_cest_nii_fn{i});
    
end



end


