function [ vertex ] = readOBJ( filename )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
fid = fopen(filename);
if fid<0
    error(['Cannot open ' filename '.']);
end
vertex=[];
index=1;
while 1
    line=fgetl(fid);
    if ~ischar(line)
        break;
    end
    if ~isempty( findstr(line,'v')) && isempty( findstr(line,'nan')) && isempty( findstr(line,'#'))
        vertex(:,index) = (sscanf(line(3:end), '%f %f %f'));
        index=index+1;
    end
end
fclose(fid);
end

