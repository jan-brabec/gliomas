function plot_appendix_low_b_high_b()

%TICK to what should be plotted

%smaller -> larger
c_subject = [701,703,710,711];

%contrast same size but more visible, better SIR
% c_subject = [702,705,706,707];

%contrast lower (first, second) and disappear (third)
% c_subject = [708,709,704];

for c_exp = 1:numel(c_subject)
    
    warning off
    sss = readtable('figs_print.xlsx');
    warning on
    sss = table2cell(sss);
    sss(find([sss{:,1}] ~= c_subject(c_exp)),:) = [];
    
    ss{c_exp,1} = num2str(sss{2});
    ss{c_exp,2} = num2str(sss{3});
    ss{c_exp,3} = str2num(sss{4});
    ss{c_exp,4} = [str2num(sss{5}) str2num(sss{6})];
    ss{c_exp,5} = [str2num(sss{7}) str2num(sss{8})];
    ss{c_exp,6} = [str2num(sss{9}) str2num(sss{10})];
    ss{c_exp,7} = [str2num(sss{11}) str2num(sss{12})];
    
    contrast_scale_list = ...
        {[str2num(sss{14}) (sss{15})],... % T1 pre
        [str2num(sss{16}) (sss{17})],...  % T1 post
        [str2num(sss{18}) (sss{19})],...  % T2
        [str2num(sss{28}) (sss{29})],...  % MD
        [str2num(sss{20}) (sss{21})],...  % LTE 700
        [str2num(sss{24}) (sss{25})],...  % STE 700
        [str2num(sss{22}) (sss{23})],...  % LTE 2000        
        [str2num(sss{26}) (sss{27})],...  % STE 2000
        };
    
    subject_name{c_exp} = strcat('BoF130_APTw_',ss{c_exp,1});
    disp(subject_name{c_exp})
    
    data_dir{c_exp} =  fullfile('../../data/processed', subject_name{c_exp}, ss{c_exp,2}, 'T1_coreg');
    
    I_mask{c_exp} = mdm_nii_read(fullfile(data_dir{c_exp},'mask.nii.gz'));
    I_mask{c_exp} = I_mask{c_exp}(:,:,ss{c_exp,3});
    
end

contrast_name_list = {...
    'T1_MPRAGE_pre.nii.gz',...
    'T1_MPRAGE_post.nii.gz',...
    'T2_FLAIR.nii.gz',...
    'dtd_covariance_MD.nii.gz',...
    'LTE_b_700c.nii.gz',...
    'STE_b_700c.nii.gz'...
    'LTE_b_2000c.nii.gz',...
    'STE_b_2000c.nii.gz'};

c_contrast_select = [1 2 3 4 5 6 7 8];
n_contrast = numel(contrast_scale_list);

n_exam  = 1;
m_upper = 0.1;
m_lower = 0.6;
m_left  = 0.1;
m_right = 0.1;
cnw     = 0;
ph      = 1;
phm1    = 0;
phm2    = 0;
phm     = [phm2 phm1 phm1 0];
enh     = 0;
pw      = 1;
pwm     = [0 0 0];

% Axis setup
n_c = 9;
fh = m_upper + enh  + n_exam * 4 * ph  + sum(phm)  + m_lower;
fw = m_left  + cnw  + n_c * pw  + sum(pwm) + m_right;

m_upper = m_upper / fh;
m_left  = m_left / fw;
ph      = ph / fh;
enh     = enh / fw;
pw      = pw / fw;

figure(183)
clf
set(gcf,'color', 'w');

for c_con = 1:n_contrast
    for c_exp = 1:numel(c_subject)
        
        nii_fn = fullfile(data_dir{c_exp}, contrast_name_list{c_contrast_select(c_con)});
        
        I      = mdm_nii_read(nii_fn);
        
        ax_l = m_left  + (c_con-1) * pw;
        
        d = 0.02;
        if c_exp == 1
            ax_b = 1 - m_upper - c_exp * ph;
        else
            ax_b = 1 - c_exp * (ph + d);
        end
        
        ax_w = pw;
        ax_h = ph;
        axes('position', [ax_l ax_b  ax_w ax_h]);
        
        tmp  = I(:,:,ss{c_exp,3});
        tmp1  = crop_image(tmp,    ss{c_exp,4}, ss{c_exp,5});
        mask  = crop_image(I_mask{c_exp}, ss{c_exp,4}, ss{c_exp,5});
        
        % Plot
        msf_imagesc(double(tmp1) .* double(mask));
        
        hold on;
        caxis(contrast_scale_list{c_contrast_select(c_con)});
        colormap gray
    end
end

% set(gcf, 'pos', [ 98   126   829   676]);
set(gcf,'Color','k')
set(gcf, 'InvertHardcopy', 'off')

print(sprintf('High_b_low_b.png'),'-dpng','-r300')

end