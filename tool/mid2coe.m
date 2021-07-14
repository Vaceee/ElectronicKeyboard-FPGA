clc
fmid=fopen('Radetzky.mid','rb');
fcoe=fopen('Radetzky.coe','w');
fprintf(fcoe, 'memory_initialization_radix=16;\n');
fprintf(fcoe, 'memory_initialization_vector=\n');

data=fread(fmid);
m = size(data);  
for i = 1:m(1)
    fprintf(fcoe, '%02X',data(i));
    if mod(i,2)==0
        fprintf(fcoe, ',\n');
    end
end


fclose(fcoe);

%bitshift(img(i,j,1),-4), ...  % R
%bitshift(img(i,j,2),-4), ...  % G
%bitshift(img(i,j,3),-4));     % B