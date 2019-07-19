function [ image ] = normalizeValue(image)
    value_range=[0,255];
    bg_mask=(image==0); 
    if size(image(image~=0),1)>0
        image(bg_mask)=max(max(image(image~=0)));
    else
        image(bg_mask)=0;
    end
    %image=max(max(image))-image;
    min_value=min(min(image));
    image=image-min_value;
    max_value=max(max(image));
    image=image*((value_range(2)-value_range(1))/max_value);
    image=image+value_range(1);
    image(bg_mask)=0;
    %image=max(max(image))-image;
    image(bg_mask)=0;
end

