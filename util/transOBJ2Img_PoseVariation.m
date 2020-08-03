% 姿态变换
%parpool(15);
input_root='E:\Dataset\lock3dface\OBJ';
subdirs=dir(input_root);
depth_outdir='E:\Dataset\lock3dface\Depth\';
normal_outdir='E:\Dataset\lock3dface\Normal\';
type='_PoseVariation';
degree=20;degree_1=40;degree_2=60;
rotation=[[0,0,0];
          [0,degree/180*pi,0];[0,-degree/180*pi,0];[degree/180*pi,0,0];[-degree/180*pi,0,0];
          [0,degree_1/180*pi,0];[0,-degree_1/180*pi,0];
          [0,degree_2/180*pi,0];[0,-degree_2/180*pi,0]];
rotation_type={'nu',...
    'yaw=20','yaw=-20','pitch=20','pitch=-20',...
    'yaw=40','yaw=-40',...
    'yaw=60','yaw=-60',};
img_size=128;
for i=3:length(subdirs)
    if strcmp(subdirs(i).name,'PS')
        continue
    end  
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
        for k=3:10:length(objlist)
            face_vertex=readOBJ([input_root '/' subdirs(i).name '/' persondirs(j).name '/' objlist(k).name]);
            parfor r_i =1:size(rotation,1)
                %点云角度旋转
                vertex=(face_vertex'*RotationMatrix(rotation(r_i,1),rotation(r_i,2),rotation(r_i,3)))';
                [depth,mask]=calcDepthAndNormal(vertex,1,1,1,0);
                if size(depth,1)<50
                    continue;
                end
                depth=trans2NormalizeValue(depth,[0,255]);%imshow(uint8(depth));
                depth=trans2NormalizeSize(depth);mask=trans2NormalizeSize(mask);
                normal=calcNormal(depth);%imshow(uint8(normal));
                
                depth=imresize(depth,[img_size img_size]);
                normal=imresizec(normal,[img_size img_size]);
                imwrite(uint8(depth),[depth_outdir variation '\' persondirs(j).name '\' strrep(objlist(k).name,'.obj' ,['_' rotation_type{r_i}]) '.jpg']);
                imwrite(uint8(normal),[normal_outdir variation '\' persondirs(j).name '\' strrep(objlist(k).name,'.obj' ,['_' rotation_type{r_i}]) '.jpg']);
            end
        end
    end
end