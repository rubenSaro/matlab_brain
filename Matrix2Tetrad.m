function []=Matrix2Tetrad(mat,outputfile,type)
%Convert a graph in matrix form into a list of corresponding edges.
%
%INPUT 
% mat -- a matrix encoding the graph. direction goes row to column
% mat(1,2) = 1 =>  X1 --> X2
%outputfile -- the name for the output txt file that will contain the edges
% goes inside quotations eg. 'tetradgraph'
%type : dir2dir // undir2undir // dir2undir
%
%OUTPUT
% A txt file with a list of edges with
%format node_i --> node_j, or node_i --- node_j
%
%Example
%Matrix2List(mat,'edges');
%output will be edges.txt
%
%

name=[outputfile];
fil= fopen(name, 'w');

fprintf(fil,'%s\n','Graph Nodes:');
for k=1:size(mat,1)
l{k}=strcat('X',num2str(k)); end
labels=strjoin(l,',');
fprintf(fil,'%s\n\n',labels);

fprintf(fil,'%s\n','Graph Edges:');


%To get the directed egdes, ie. (1,2)=1
 if strcmp(type,'dir2dir')
 [i,j]=ind2sub(size(mat),find(mat==1)); %FIND ALL THE ENTRIES THAT ARE EQUAL TO 1
 ar=cell(size(i));
 for m=1:size(i,1)
     ar{m}='-->'; 
 end
 
 elseif strcmp(type,'undir2undir')
     mat = triu(mat,1); %if original is undirected then symmetric, then only get the upper triangular.
 [i,j]=ind2sub(size(mat),find(mat==1)); %FIND ALL THE ENTRIES THAT ARE EQUAL TO 1
 ar=cell(size(i));
 for m=1:size(i,1)
     ar{m}='---';  %no arrowhead
 end
 
 elseif strcmp(type,'dir2undir') %2-cycles are count as one edge.
      mat = mat + mat'; %sum the lower triangular to the upper triangular to put all the info. into one side
      mat = triu(mat,1); %get the upper triangular, it has all the info, but now it may contain 2's, if there is a 2-cycle.
 [i,j]=ind2sub(size(mat),find(mat~=0)); %FIND ALL THE ENTRIES THAT ARE different from zero
 ar=cell(size(i));
 for m=1:size(i,1)
     ar{m}='---'; 
 end
 
 
 
 
 
 
 
 end
 
 
 ar=ar';
 e={l{i};ar{:};l{j}}';
 [nrows,~] = size(e);
for row = 1:nrows
    num={strcat(num2str(row),'.')};
    p={num{1},e{row,:}};
    fprintf(fil,'%s %s %s %s\n',p{:});
end



   



%To get the directed egdes, ie. (1,2)=2
%  [i,j]=ind2sub(size(mat),find(mat==2));%FIND ALL THE ENTRIES THAT ARE EQUAL TO 2
%  ar=cell(size(i));
%  for m=1:size(i,1)
%      ar{m}='-->'; 
%  end
%  ar=ar';
%  e={R{i};ar{:};R{j}}';
%  [nrows,ncols] = size(e);
% for row = 1:nrows
%     fprintf(fil,'%s %s %s\n',e{row,:});
% end
% 
% %To get the directed egdes, ie. (1,2)=-2
%  [i,j]=ind2sub(size(mat),find(mat==-2));%FIND ALL THE ENTRIES THAT ARE EQUAL TO -2
%  ar=cell(size(i));
%  for m=1:size(i,1)
%      ar{m}='-->'; 
%  end
%  ar=ar';
%  e={R{j};ar{:};R{i}}';
%  [nrows,ncols] = size(e);
% for row = 1:nrows
%     fprintf(fil,'%s %s %s\n',e{row,:});
% end
% 
% %To get the directed egdes, ie. (1,2)=3
%  [i,j]=ind2sub(size(mat),find(mat==3));%FIND ALL THE ENTRIES THAT ARE EQUAL TO 3
%  ar=cell(size(i));
%  for m=1:size(i,1)
%      ar{m}='<->'; 
%  end
%  ar=ar';
%  e={R{i};ar{:};R{j}}';
%  [nrows,ncols] = size(e);
% for row = 1:nrows
%     fprintf(fil,'%s %s %s\n',e{row,:});
% end
 




fclose(fil);

