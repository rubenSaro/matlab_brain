function []=Matrix2Tetrad_Pseudo(mat,outputfile)

%modification of the original Matrix2Tetrad for pseudoempirical data, the
%thing that changed was the variables labels.
%Create a general version, where the user input a list of labels, and those
%are used to generate the Tetrad graph.

%Convert a graph in matrix form into a list of corresponding edges.
%
%INPUT 
% mat -- a matrix encoding the graph. direction goes row to column
% mat(1,2) = 1 =>  X1 --> X2
%outputfile -- the name for the output txt file that will contain the edges
% goes inside quotations eg. 'tetradgraph'
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

name=[outputfile,'.txt'];
fil= fopen(name, 'w');

fprintf(fil,'%s\n','Graph Nodes:');
% for k=1:size(mat,1)
% l{k}=strcat('X',num2str(k)); end;

if size(mat,1) == 3
         l = {'X','Y','Z'};
    elseif size(mat,1) == 2
         l = {'Y','Z'};
    elseif size(mat,1) == 4
       l = {'X','Y','Z','W'}; 
end


labels=strjoin(l,',');
fprintf(fil,'%s\n\n',labels);

fprintf(fil,'%s\n','Graph Edges:');

%To get the directed egdes, ie. (1,2)=1
 [i,j]=ind2sub(size(mat),find(mat==1)); %FIND ALL THE ENTRIES THAT ARE EQUAL TO 1
 ar=cell(size(i));
 for m=1:size(i,1)
     ar{m}='-->'; 
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

