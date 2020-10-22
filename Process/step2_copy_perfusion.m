function a = step2_copy_perfusion(s)
% function a = step1_copy_data(s)

a = [];
rp = '../data/raw/';
tp = '../data/processed/';

if (nargin == 0)
    %     run ../../../../MATLAB/mdm/setup_paths
    mdm_iter_lund(rp, @step2_copy_perfusion);
    return;
end

% if (~strcmp(s.subject_name(end-2:end), '119')), return; end


ip = fullfile(rp, s.subject_name, s.exam_name, 'NII');
op = fullfile(tp, s.subject_name, s.exam_name, 'Perf/ver1');
msf_mkdir(op);

disp(s.subject_name)

%standard patterns
i_rBV_bw = '*rBVmap-Leakagecorrected_DERIVED*'; %rBV black & white
i_rBF_bw = '*rBFmap-Leakagecorrected_DERIVED*'; %rBF black & white
i_rBV_col= '*rBVmap-Leakagecorrectedcolour*';   %rBV color
i_rBF_col= '*rBFmap-Leakagecorrectedcolour*';   %rBF color
i_template='*ep2d_perf_p3.nii.gz';              %template for registration


%Fix special cases where the naming is different
if strcmp(s.subject_name(end-2:end), '106') && strcmp(s.exam_name, '20180118_1')
    i_rBF_bw  = '23_rBFmap-Leakagecorrected_HE1-4;NE1,2.nii.gz';
end

if strcmp(s.subject_name(end-2:end), '106') && strcmp(s.exam_name, '20180313_2') %3rd timepoint
    i_rBV_bw = 'Serie_20_rBVmap-Leakagecorrected.nii.gz';
    i_rBF_bw = 'Serie_21_rBFmap-Leakagecorrected.nii.gz';
end

if strcmp(s.subject_name(end-2:end), '107') && strcmp(s.exam_name, '20180420_1') %2nd timepoint
    i_rBF_bw = '23_rBFmap-Leakagecorrected_HE1-4;NE1,2;SP1.nii.gz';
end

if strcmp(s.subject_name(end-2:end), '108') && strcmp(s.exam_name, '20180125_1') %1st timepoint
    i_template = 'Serie_20_ep2d_perf_p3_MoCo.nii.gz';
end

if strcmp(s.subject_name(end-2:end), '109')
    i_template = 'Serie_20_ep2d_perf_p3_MoCo.nii.gz';
end

if strcmp(s.subject_name(end-2:end), '112') && strcmp(s.exam_name, '20180129_1') %1st timepoint
    i_rBF_bw = 'Serie_27_rBFmap-Leakagecorrected.nii.gz';
end

if strcmp(s.subject_name(end-2:end), '116')
    i_rBV_bw = '21_rBVmap-Leakagecorrected_HE1-4;NE1,2.nii.gz';
end

if strcmp(s.subject_name(end-2:end), '117') && strcmp(s.exam_name, '20181025_1') %3rd timepoint
    i_rBV_col = 'Serie_30_rBVmap-Leakagecorrected.nii.gz';
    i_rBF_col = 'Serie_31_rBFmap-Leakagecorrected.nii.gz';
    i_template= 'Serie_24_ep2d_perf_p3_MoCo.nii.gz';
end

if strcmp(s.subject_name(end-2:end), '117') && strcmp(s.exam_name, '20190118_1') %4th
    i_rBF_bw = '22_rBFmap-Leakagecorrected_HE1-4;NE1,2.nii.gz';
end

% if strcmp(s.subject_name(end-2:end), '119') && strcmp(s.exam_name, '20180822_2') %4th
%     i_rBV_bw = '20_rBVmap-Leakagecorrected_HE1-4.nii.gz';
%     i_rBF_bw = '21_rBFmap-Leakagecorrected_HE1-4.nii.gz';
% end

if strcmp(s.subject_name(end-2:end), '119') && strcmp(s.exam_name, '20180822_1') %4th
    i_rBV_bw = '20_rBVmap-Leakagecorrected_HE1-4.nii.gz';
    i_rBF_bw = '21_rBFmap-Leakagecorrected_HE1-4.nii.gz';
end

if strcmp(s.subject_name(end-2:end), '120')
    i_rBV_bw = 'Serie_20_rBVmap-Leakagecorrected.nii.gz';
    i_rBF_bw = 'Serie_21_rBFmap-Leakagecorrected.nii.gz';
end

if strcmp(s.subject_name(end-2:end), '121') && strcmp(s.exam_name, '20180903_1')
    i_rBV_bw = 'Serie_25_rBVmap-Leakagecorrected.nii.gz';
    i_rBF_bw = 'Serie_21_rBFmap-Leakagecorrected.nii.gz';
end

if strcmp(s.subject_name(end-2:end), '122') && strcmp(s.exam_name, '20180914_1')
    i_template = 'Serie_20_ep2d_perf_p3_MoCo.nii.gz';
end

if strcmp(s.subject_name(end-2:end), '122') && strcmp(s.exam_name, '20181206_1')
    i_rBV_bw = '20_rBVmap-Leakagecorrected_HE1-4;NE1,2.nii.gz';
    i_rBV_col= 'Serie_25_rBVmap-Leakagecorrected.nii.gz';
    i_rBF_col= 'Serie_26_rBFmap-Leakagecorrected.nii.gz';
end

if strcmp(s.subject_name(end-2:end), '123')
    i_rBF_bw = '34_rBFmap-Leakagecorrected_HE1-4.nii.gz';
end

if strcmp(s.subject_name(end-2:end), '125')
    i_rBV_bw = 'Serie_20_rBVmap-Leakagecorrected.nii.gz';
    i_rBF_bw = 'Serie_21_rBFmap-Leakagecorrected.nii.gz';
    i_rBV_col= 'Serie_25_rBVmap-Leakagecorrected.nii.gz';
    i_rBF_col= 'Serie_26_rBFmap-Leakagecorrected.nii.gz';
    i_template='Serie_13_ep2d_perf_p3_MoCo.nii.gz';
end

if strcmp(s.subject_name(end-2:end), '130')
    i_rBV_bw = '20_rBVmap-Leakagecorrected_HE1-4;NE1,2;SP1.nii.gz';
    i_rBF_bw = '21_rBFmap-Leakagecorrected_HE1-4;NE1,2;SP1.nii.gz';
end

if strcmp(s.subject_name(end-2:end), '132')
    i_rBF_bw = '21_rBFmap-Leakagecorrected_HE1-4;NE1,2.nii.gz';
end

if strcmp(s.subject_name(end-2:end), '133')
    i_rBV_bw = 'Serie_20_rBVmap-Leakagecorrected.nii.gz';
    i_rBF_bw = 'Serie_21_rBFmap-Leakagecorrected.nii.gz';
    i_template='Serie_14_ep2d_perf_p3_MoCo.nii.gz';
end


%No perfusion data for
% 101
% 102
% 103
% 106 2nd (20180313_1)
% 108 2nd (20180410_1)
% 112 2nd (20180228_1) missing only the registration e2pdf but that is needed
% 119 1st (20180822_1)
% 126
% 127
% 128
% 129

% do not use 112 2nd because it is missing file needed for registration
if strcmp(s.subject_name(end-2:end), '112') && strcmp(s.exam_name, '20180228_1') %1st timepoint
    i_rBV_bw = [];
    i_rBF_bw = [];
    i_rBV_col= [];
    i_rBF_col = [];
    i_template=[];
end


i_patterns = {i_rBV_bw,...
    i_rBF_bw,...
    i_rBV_col, ...
    i_rBF_col, ...
    i_template};

%for all the same
o_patterns = {'rBV_bw.nii.gz',...
    'rBF_bw.nii.gz'...
    'rBV_col.nii.gz'...
    'rBF_col.nii.gz',...
    'ep2d_perf.nii.gz'};


for i = 1:5
    i_perf_nii_fn = msf_find_fn(ip, i_patterns{i} ,1);
    o_perf_nii_fn = fullfile(op, o_patterns{i});
    
    copyfile( i_perf_nii_fn, o_perf_nii_fn);
    
end






end


