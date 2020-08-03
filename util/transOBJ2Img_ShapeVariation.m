%本代码所进行的数据扩增，不包含姿态变化，仅在正面姿态下进行。
%包含更小的人脸区域，添加噪声
%parpool(12);
input_root='E:\Dataset\lock3dface\OBJ';
subdirs=dir(input_root);
depth_outdir='E:\Dataset\lock3dface\Depth\';
normal_outdir='E:\Dataset\lock3dface\Normal\';
type='_ShapeVariation';
img_size=128;
for i=3:length(subdirs)
%     if ~strcmp(subdirs(i).name,'NUO')
%         continue
%     end
    persondirs=dir([input_root '/' subdirs(i).name]);
    variation=[subdirs(i).name type];
    if ~exist([depth_outdir variation])
       mkdir([depth_outdir variation]);
    end
    if ~exist([normal_outdir variation])
       mkdir([normal_outdir variation]);
    end
    for j=3:length(persondirs)
        objlist=dir([input_root '/' subdirs(i).name '/' persondirs(j).name]);
        disp([input_root '/' subdirs(i).name '/' persondirs(j).name]);
        if ~exist([depth_outdir variation '/' persondirs(j).name])
           mkdir([depth_outdir variation '/' persondirs(j).name]);
        end
        if ~exist([normal_outdir variation '/' persondirs(j).name])
           mkdir([normal_outdir variation '/' persondirs(j).name]);
        end
        clear objs;
        oi=1;
        for o=3:10:length(objlist)
            objs(oi)=objlist(o);
            oi=oi+1;
        end
        parfor k=1:length(objs)
        %for k=3:length(objlist)
            vertex=readOBJ([input_root '/' subdirs(i).name '/' persondirs(j).name '/' objs(k).name]);
            if size(vertex,2)<2000
                continue;
            end
            [depth,mask]=calcDepthAndNormal(vertex,1,1,1,0);
            if size(depth,1)<50
                continue;
            end
            % 原图
            depth_source=trans2NormalizeValue(depth,[0,255]);%imshow(uint8(depth));
            depth_source=trans2NormalizeSize(depth_source);
            normal_source=calcNormal(depth_source);%imshow(uint8(normal));
            depth_source=imresize(depth_source,[img_size img_size]);
            normal_source=imresize(normal_source,[img_size img_size]);
            
            
            imwrite(uint8(depth_source),[depth_outdir variation '\' persondirs(j).name '\' strrep(objs(k).name,'.obj' ,'.jpg')]);
            imwrite(uint8(normal_source),[normal_outdir variation '\' persondirs(j).name '\' strrep(objs(k).name,'.obj' ,'.jpg')]);
            %     添加噪声
            [ depth_noise,normal_noise ] = noise( depth,mask,'gaussian',0,0.00002 );
            depth_noise=imresize(depth_noise,[img_size img_size]);
            normal_noise=imresize(normal_noise,[img_size img_size]);
            imwrite(uint8(depth_noise),[depth_outdir variation '\' persondirs(j).name '\' strrep(objs(k).name,'.obj' ,'_noise.jpg')]);
            imwrite(uint8(normal_noise),[normal_outdir variation '\' persondirs(j).name '\' strrep(objs(k).name,'.obj' ,'_noise.jpg')]); 
            %     缩小面部区域
            scale=1.1;
            [depth_shrink,normal_shrink]=shrink(depth,mask,scale);
            depth_shrink=imresize(depth_shrink,[img_size img_size]);
            normal_shrink=imresize(normal_shrink,[img_size img_size]);
            imwrite(uint8(depth_shrink),[depth_outdir variation '\' persondirs(j).name '\' strrep(objs(k).name,'.obj' ,'_shrink.jpg')]);
            imwrite(uint8(normal_shrink),[normal_outdir variation '\' persondirs(j).name '\' strrep(objs(k).name,'.obj' ,'_shrink.jpg')]); 
        end
    end
end