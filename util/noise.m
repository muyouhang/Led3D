function [ depth_noise,normal_noise ] = noise( depth,mask,type,mean,var )
    depth_noise = imnoise(depth/255.0,type,mean,var)*255.0; 
    depth_noise(mask==0)=0;
    depth_noise=normalizeValue(depth_noise);%imshow(uint8(depth));
    depth_noise=normalizeSize(depth_noise);
    normal_noise=calcNormal(depth_noise);%imshow(uint8(normal));
end

