function [mask_data, normal_mask_data,coordinates] = extract_voxelwise_data(data, mask) %, style)% num_subjects, data_file, normal_file, coord_file)
%INPUTS:
%data -- filtered_func_data.nii
%mask -- thresh_zstat1.nii
%OUPUT:
%mask_data -- the tiempoints for each voxel of the mask
%normal_mask_data -- the data normalized to mean = 0, std = 1
%coordinates -- a list of coordinates for each voxel
%EXAMPLE
% [data,normal_data,coordinates]=extract_voxelwise_data('filtered_func_data.nii','thresh_zstat1.nii')
tic

data = char(data);
data = load_untouch_nii(data);

mask = char(mask);
mask = load_untouch_nii(mask);

data = data.img;
mask = mask.img;


[x_planes, y_planes, z_planes, time] = size(data);  % get size of coordinate space

num_voxels=nnz(mask); 

mask_data = zeros(time, num_voxels); % initialize array with a row for each time lag and a column for each voxel

coordinates = zeros(num_voxels, 4);

coordinates(:, 1) = 1:num_voxels;

mask = logical(mask);

[rows, cols] = find(mask); % assigns row indices of voxels of interest to rows, and linear indices (column-first search) to cols

coordinates(:, 2) = rows;
coordinates(:, 3) = mod(cols, y_planes); % gets Y indices
coordinates(:, 4) = ceil(cols/y_planes); % gets Z indices

for i = 1:time
    slice = data(:, :, :, i);   % assigns to slice all voxel values at time i
    mask_data(i, :) = slice(mask); % assigns to the ith row of the mask_data a vector containing all the values in data at nonzero coordinates in the mask
end

% normalize data [FIND A WAY TO ADJUST FOR NAN VALUES]
avg = mean(mask_data,1); %a vector containing the mean of each voxel timeseries
sd = std(mask_data,1);  %a vector containing the std of each voxel timeseries

normal_mask_data = zeros(time, num_voxels);

for n=1:num_voxels
normal_mask_data(:,n)=(mask_data(:,n)-avg(n))./sd(n);
end

%lab = 1:num_voxels;

disp('Extraction done');


%% file writing
%{
f = fopen(['voxel_data_', style, '.txt'],'wt');

headerSpec = 'X%i\t';               % print header
fprintf(f, headerSpec, 1:num_voxels-1);
fprintf(f, 'X%i\n', num_voxels);

disp('Header done');

%dlmwrite(['voxel_data_', style, '.txt'],lab,'');  %create a txt file with the list of ROIs names
dlmwrite(['voxel_data_', style, '.txt'],normal_mask_data,'-append','delimiter','\t','precision','%6.8f'); %append to the txt file the bold signals.

disp('Data write done');

% print coordinates of voxels in ROI w

f2 = fopen(['coordinates_', style, 'txt.'], 'wt');
    
for i = 1:num_voxels
    fprintf(f2, 'X%i\t%i\t%i\t', coordinates(i, 1:3));     % print coordinates
    fprintf(f2, '%i\n', coordinates(i, 4));
end
%}
toc