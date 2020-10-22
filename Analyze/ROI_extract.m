clear
clc

global iter_no dat
iter_no = 1;
dat = ROI_extract_fn();

i = size(dat,2); %delete those that dont have post-Gd or diff scan
while i > 0
    if dat(i).del == 1
        dat(i) = [];
    end
    i = i - 1;
end

i = size(dat,2); %keep just first timepoints, delete other timepoints
while i > 1
    if dat(i).bof == dat(i-1).bof
        dat(i) = [];
    end
    i = i - 1;
    disp(dat(i).s.subject_name)
    disp(dat(i).s.exam_name)
end

save dat.mat

histo_info; %add histological info to the data structure
