function [ normal ] = calcNormal( depth )
    [u,v,w]=surfnorm(depth); 
    normal_x=uint8((u+1)*128-1);
    normal_y=uint8((v+1)*128-1);
    normal_z=uint8((w+1)*128-1);
    normal=uint8(zeros([size(depth,1) size(depth,2) 3]));normal(:,:,1)=normal_x;normal(:,:,2)=normal_y;normal(:,:,3)=normal_z;
end

