function [ croped_face ] = roi( mask,depth )
    min_x=999;
    min_y=999;
    max_x=-999;
    max_y=-999;
   
    for xi=1:size(mask,1)
        for yi=1:size(mask,2)
            if mask(xi,yi)==255
                if min_x>xi
                    min_x=xi;
                end
                if max_x<xi
                    max_x=xi;
                end
                if min_y>yi
                    min_y=yi;
                end
                if max_y<yi
                    max_y=yi;
                end
            end
        end
    end
    croped_face=depth(min_x:max_x,min_y:max_y);
end

