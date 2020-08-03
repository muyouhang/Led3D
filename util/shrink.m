function [ depth_shrink,normal_shrink ] = shrink( depth,mask,scale )
%Àı–°»À¡≥«¯”Ú
    mask_shrink=zeros(uint8(size(mask,1)*scale),uint8(size(mask,2)*scale));
    mask_shrink((uint8((size(mask_shrink,1)-size(mask,1))/2)+1):uint8((size(mask_shrink,1)+size(mask,1))/2),(uint8((size(mask_shrink,2)-size(mask,2))/2)+1):uint8((size(mask_shrink,2)+size(mask,2))/2))=mask;
    mask_shrink=uint8(imresize(mask_shrink,size(mask)));
    depth_shrink=depth;
    depth_shrink(mask_shrink==0)=0;%imshow(uint8(depth));
    depth_shrink=roi(mask_shrink,depth_shrink);
    mask_shrink=roi(mask_shrink,mask_shrink);
    depth_shrink=normalizeValue(depth_shrink);%imshow(uint8(depth));
    depth_shrink=normalizeSize(depth_shrink);
    normal_shrink=calcNormal(depth_shrink);%imshow(uint8(normal));
end

