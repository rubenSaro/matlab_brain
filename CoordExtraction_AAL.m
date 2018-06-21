function [roi]=CoordExtraction_AAL(ROI)  %labels,outputfile)

tic

%extract the mask and functional BOLD information

MASK=load_untouch_nii(ROI);
mask=MASK.img(:,:,:);


%voxel space
[vx,vy,vz]=size(mask);

%time dimension (TRs)
%obtain set of selected ROIs from the mask
roi=unique(mask); %set of labels of ROIs

%%%THIS IS ADJUSTED FOR THE AAL ATLAS ROIS AS OBTAINED FROM
%%%http://www.cyceron.fr/index.php/en/plateforme-en/freeware
%%%I USED THE SPM8 VERSION %%%%

roi=roi(roi>0);    %set of ROIs removing 0, ie. no ROI.
%roi=roi(rem(roi,2)~=0);  %set or ROIs of only right(==0) or left(~=0) hemisphere.
%roi=roi(1:54); %set of ROIs of only right/left hemisphere removing vermis structures of the cerebellum, the last 8 ROIs of the set.
%roi=roi(1:108); %to get all except Vermis
%compute number of ROIs
numroi=numel(roi);

%loop through all the ROIs
for k=1:numroi

%select only the voxels belonging to the mask
index=find(mask(:,:,:)==roi(k)); %get the matrix index of each voxel in the ROI 

X=0;Y=0;Z=0; %clean the variables
IND = [index'];
s = [vx,vy,vz]; 
[X,Y,Z] = ind2sub(s,IND); %each index number is assigned to a X, Y, Z coordinate
%rest 1 so the first element is zero, as in FSLview
X=X-1;
Y=Y-1;
Z=Z-1;
CT=[X; Y; Z]'; %build data with the exact coordinates of each mask-voxel according to FSLVIEW display.
%CT=[vx-1-X; Y; Z];  %use this if it is necessary to shift LEFT-RIGHT orientation.   

[idx,C]=kmeans(CT,1);
co(k,:)=round(C);



%make a file with the coordinates of the voxels for each ROI 
%fname4=['coordinates_voxels_ROI_',num2str(roi(k)),'.txt'];
%fid4= fopen(fname4, 'w');
%fprintf(fid4, '%d\t %d\t %d\n', CT);
%fclose(fid4);



end

dlmwrite('coordinates_whole_AAL.txt',co,'delimiter',' ');

%save ROIS_mean.mat R

% r=importdata(labels);
% for h=1:numroi
% name{h}=cellstr(r.textdata(r.data==roi(h),2));
% nameS(h)=name{h};
% end
% lab=sprintf('%-14s\t',nameS{:});
% output=strcat(outputfile,'.txt');
% dlmwrite(output,lab,'');
% dlmwrite(output,R','-append','delimiter','\t','precision','%6.8f');





toc
