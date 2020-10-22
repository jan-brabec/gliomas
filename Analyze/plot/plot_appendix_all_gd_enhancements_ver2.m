function plot_appendix_all_gd_enhancements_ver2()

load('../dat.mat');
limit = 1.1;
ind = find([dat.pgd] > limit);
bof = [dat(ind).bof]';

figure(183)
clf
c_con = 1;
c_row = 1;
for c_exp = 1:numel(bof)
    warning off
    sss = readtable('figs_print.xlsx');
    warning on
    sss = table2cell(sss);
    
    for c = 1:size(sss,1)
        if strcmp(sss{c,2},num2str(bof(c_exp))) && sss{c,1} == 9999
            
            ss{1} = num2str(sss{c,2});
            ss{2} = num2str(sss{c,3});
            gd_slice = str2num(sss{c,4}); %gd slice
            ss{4} = [str2num(sss{c,9}) str2num(sss{c,10})]; %left bottom
            ss{5} = [str2num(sss{c,11}) str2num(sss{c,12})]; %scalex, scale y
            
            contrast_scale_list = ...
                {[str2num(sss{c,14}) (sss{c,15})]};
            
            subject_name = strcat('BoF130_APTw_',ss{1});
            disp(subject_name)
            if sss{c,1} == 9999
                disp('For gadolinium')
            else
                error('not Gd')
            end
            
            data_dir =  fullfile('../../data/processed', subject_name, ss{2}, 'T1_coreg');
            contrast_name_list = {'T1_MPRAGE_postc.nii.gz'};
            
            I_mask = mdm_nii_read(fullfile(data_dir,'mask.nii.gz'));
            I_mask = I_mask(:,:,gd_slice);
            
            I_roi = mdm_nii_read(fullfile('../../data/roi_Enhancements',strcat(subject_name(end-2:end),'_', ss{2},'_Gd_enh.nii.gz')));
            I_roi = I_roi(:,:,gd_slice);            
            
            I_roi_wm = mdm_nii_read(fullfile('../../data/roi_Enhancements',strcat(subject_name(end-2:end),'_', ss{2},'_WM_contra.nii.gz')));
            I_roi_wm = I_roi_wm(:,:,gd_slice);            
            
            
            c_contrast_select = 1;
            n_contrast = 6;
            
            n_exam  = 5;
            m_upper = 0.1;
            m_lower = 0.1;
            m_left  = 0.1;
            m_right = 0.1;
            cnw     = 0;
            ph      = 1;
            phm     = 0;
            enh     = 0;
            pw      = 1;
            pwm     = 4;
            
            % Axis setup
            fh = m_upper + enh  + n_exam * ph  + sum(phm)  + m_lower;
            fw = m_left  + cnw  + n_contrast * pw  + sum(pwm) + m_right;
            
            m_upper = m_upper / fh;
            m_left  = m_left / fw;
            ph      = ph / fh;
            enh     = enh / fw;
            pw      = pw / fw;
            
            figure(183)
            set(gcf,'color', 'w');
            
            nii_fn = fullfile(data_dir, contrast_name_list{c_contrast_select(1)});
            I      = mdm_nii_read(nii_fn);
            
            if c_con == 7 || c_con == 13 || c_con == 19
                c_row = c_row + 1;
            end
            
            ax_l = m_left  + (c_con-1-6*(c_row-1)) * pw;
            
            if c_row == 1
                ax_b = 1 - m_upper - c_row * ph;
            else
                ax_b = 1 - c_row * ph - 0.01;
            end
            
            ax_w = pw;
            ax_h = ph;
            axes('position', [ax_l ax_b  ax_w ax_h]);
            
            tmp    = I(:,:,gd_slice);
            tmp1   = crop_image(tmp,      ss{4}, ss{5});
            mask   = crop_image(I_mask,   ss{4}, ss{5});
            roi    = crop_image(I_roi,    ss{4}, ss{5});     
            roi_wm = crop_image(I_roi_wm, ss{4}, ss{5});            
            
            
            % Plot
            msf_imagesc(double(tmp1) .* double(mask));
            plot_roi(flipud(double(roi)'),'r',0.3);
            plot_roi(flipud(double(roi_wm)'),'b',0.3);
            
            colormap gray;            
            
            hold on;
            caxis(contrast_scale_list{c_contrast_select(1)});
            colormap gray
            
            c_con = c_con + 1;
            
        end
    end
    
    set(gcf,'Color','k')
end

set(gcf,'Color','k')
set(gcf, 'InvertHardcopy', 'off')
print(sprintf('All_Gd.png'),'-dpng','-r500')

end