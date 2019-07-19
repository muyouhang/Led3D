function [depth,mask] = calcDepthAndNormal(vertex,scale,Use_preprocess)
    if size(vertex,1)==3
        pc=vertex';
    else
        pc=vertex;
    end
    pc(:,3)=max(pc(:,3))-pc(:,3);
    point_cloud=pointCloud(pc);
    point_cloud=pcdenoise(point_cloud);
    vertex=point_cloud.Location()';
    depth=imrotate(dep(pc,uint8((max(pc(:,1))-min(pc(:,1)))*scale),uint8((max(pc(:,2))-min(pc(:,2))))*scale),-90,'bilinear');
    depth=medfilt2(depth,[3,3]);
    mask=depth;
    mask(depth>0)=255;
    imLabel=bwlabel(mask);
    stats=regionprops(imLabel,'Area');
    area=cat(1,stats.Area);
    index=find(area==max(area));
    img=ismember(imLabel,index);
    mask(img==1)=255;mask(img==0)=0;
    holes=mask;
    mask=imfill(mask,'holes');
    holes=mask-holes;
    if Use_preprocess    
        kernel=ones(9,9);
        dilate_holes=imdilate(holes,kernel);
        dilate_holes_depth=depth;dilate_holes_depth(dilate_holes==0)=0;
        dilate_holes_depth=imfill(dilate_holes_depth,'holes');
        dilate_holes_depth=ordfilt2(dilate_holes_depth,9,ones(3,3));
        dilate_holes_depth=medfilt2(dilate_holes_depth,[3,3]); 
        depth(dilate_holes==255)=dilate_holes_depth(dilate_holes==255);
        depth(mask==0)=0;
    end   

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
    depth=croped_face;
    croped_mask=mask(min_x:max_x,min_y:max_y);
    mask=croped_mask;    
end