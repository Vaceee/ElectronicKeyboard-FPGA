clc
img=imread('K08.png');
fid=fopen('K8.coe','w');
fprintf(fid, 'memory_initialization_radix=16;\n');
fprintf(fid, 'memory_initialization_vector=\n');

m = size(img);  
for i = 1:m(1)
    for j = 1:m(2)
        %RGB
        fprintf(fid, '%X%X%X,\n',    bitshift(img(i,j,1),-4), ...  % R
                                    bitshift(img(i,j,2),-4), ...  % G
                                    bitshift(img(i,j,3),-4));     % B
    end
end

fseek(fid, -2, 1); % ',' to ';'
fprintf(fid, ';');

fclose(fid);

%bitshift(img(i,j,1),-4), ...  % R
%bitshift(img(i,j,2),-4), ...  % G
%bitshift(img(i,j,3),-4));     % B