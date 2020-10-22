function plot_first_b_figure()

c_subject = [3,602]; %enhancing, non-enhancing

for c_exp = 1:2
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
       {[str2num(sss{14}) (sss{15})],... %pre
        [str2num(sss{16}) (sss{17})],... %post
        [str2num(sss{18}) (sss{19})],... %Flair
        [str2num(sss{24}) (sss{25})],... %S0          
        [str2num(sss{28}) (sss{29})],... %MD
        [str2num(sss{26}) (sss{27})],... %MKI
        [str2num(sss{38}) (sss{39})],... %MKA     
        [str2num(sss{34}) (sss{35})]...  %lte 700
        [str2num(sss{36}) (sss{37})]...  %ste 700
        [str2num(sss{20}) (sss{21})],... %lte 2000
        [str2num(sss{22}) (sss{23})],... %ste 2000
        };
    
    subject_name = strcat('BoF130_APTw_',ss{c_exp,1});
    disp(subject_name)
    
    data_dir{c_exp} =  fullfile('../../data/processed', subject_name, ss{c_exp,2}, 'T1_coreg');
    
    I_mask{c_exp} = mdm_nii_read(fullfile(data_dir{c_exp},'mask.nii.gz'));
    I_mask{c_exp} = I_mask{c_exp}(:,:,ss{c_exp,3});
    
end

contrast_name_list = {...
    'T1_MPRAGE_prec.nii.gz',...
    'T1_MPRAGE_postc.nii.gz',...
    'T2_FLAIRc.nii.gz',...
    'dtd_covariance_s0.nii.gz',...
    'dtd_covariance_MD.nii.gz',...
    'dtd_covariance_Mki.nii.gz',...
    'dtd_covariance_Mka.nii.gz',...
    'LTE_b_700c.nii.gz'...
    'STE_b_700c.nii.gz'...
    'LTE_b_2000c.nii.gz'...
    'STE_b_2000c.nii.gz'...
    };

c_contrast_select = [1 2 3 4 5 6 7 8 9 10 11 12];
n_contrast = numel(contrast_scale_list);

n_exam  = 1;
m_upper = 0.1;
m_lower = 0.6;
m_left  = 0.1;
m_right = 0.1;
cnw     = 0;
ph      = 1;
phm1    = 0.1;
phm2    = 1.5;
phm     = [phm2 phm1 phm1 0];
enh     = 0;
pw      = 1;
pwm     = [0 0.1 0.4];

% Axis setup
n_c = 11;
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

for c_con = 1:11
    for c_exp = 1:2
        
        if c_con == 5
            1;
        end
        
        if c_exp == 1
            c_row = 1;
        else
            c_row = 2;
        end
        
        nii_fn = fullfile(data_dir{c_exp}, contrast_name_list{c_contrast_select(c_con)});
        I      = mdm_nii_read(nii_fn);
        
        ax_l = m_left  + (c_con-1) * pw;

        if c_row == 1
            ax_b = 1 - m_upper - c_row * ph;
        else
            ax_b = 1 - c_row * ph;
        end
        
        ax_w = pw;
        ax_h = ph;
        axes('position', [ax_l ax_b  ax_w ax_h]);
        
        tmp  = I(:,:,ss{c_exp,3},:);
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

print(sprintf('First_fig_b_%d.png',c_subject),'-dpng','-r300')

end