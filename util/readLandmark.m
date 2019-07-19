function [ landmarks ] = readLandmark( file_path )
    fid_landmark=fopen(file_path,'r');
    str_landmark=textscan(fid_landmark,'%s');str_landmark=str_landmark{1};
    landmarks=zeros(2,5);% x,y
    for i=1:2:10
        s=regexp(str_landmark{i},':','split');
        landmarks(1,(i-1)/2+1)=str2num(s{2});
    end
    for i=2:2:10
        s=regexp(str_landmark{i},':','split');
        landmarks(2,i/2)=str2num(s{2});
    end
    fclose(fid_landmark);
end

