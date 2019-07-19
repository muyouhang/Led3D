function [ mask ] = normalizeSize( image )
    if ndims(image)==3
        channel=size(image,1);
        width=size(image,2);
        height=size(image,3);
    elseif ndims(image)==2
        channel=1;
        width=size(image,1);
        height=size(image,2);
    end
    length=max(width,height);
    mask=zeros([channel length length]);
    
    mask(:,uint8((length-width)/2)+1:(uint8((length-width)/2)+width),uint8((length-height)/2)+1:uint8((length-height)/2)+height)=image;
    mask=squeeze(mask);
end

