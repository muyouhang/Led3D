
addpath('util');
landmark_path='sample/label/infrared/001_Kinect_FE_1INFRARED.txt';
color_path='sample/data/color/001_Kinect_FE_1COLOR/01.jpg';
depth_path='sample/data/depth/001_Kinect_FE_1DEPTH/01.png';
color_face = imread(color_path);    figure(2),imshow(color_face);  
depth_face = imread(depth_path);    figure(3),imshow(depth_face,[500,800]);    

landmark = readLandmark(landmark_path);
nose_tip = calcNTP(landmark);

imgSize = [180, 180];
roi=depth_face(nose_tip(2)-imgSize(1)/2 +1:nose_tip(2)+imgSize(1)/2 ,nose_tip(1)-imgSize(2)/2 +1:nose_tip(1)+imgSize(2)/2);
figure(4),imshow(roi,[500,800]);

reSize=360;
roi_face = imresize(roi,[reSize,reSize]);

pc_template=zeros(3,reSize*reSize);
pc_template(1,:) = floor((0:(reSize*reSize-1)) /reSize)+1;
pc_template(2,:) = mod(0:(reSize*reSize-1),reSize)+1;
pc_template(3,:) = roi_face(:);
figure(5),pcshow(pointCloud(pc_template'));

r=100;
xo=double(reSize/2); yo=double(reSize/2);  
zo=double(median(median(roi_face(xo-10:xo+10,yo-10:yo+10))));
pc_template(3,((xo-pc_template(2,:)).*(xo-pc_template(2,:))+(yo-pc_template(1,:)).*(yo-pc_template(1,:))+(zo-pc_template(3,:)).*(zo-pc_template(3,:)))>r*r)=0;
pc_face=pc_template(:,pc_template(3,:)>0);
figure(6),pcshow(pointCloud(pc_face'));

[depth,mask] = calcDepthAndNormal(pc_face,1,1);
depth=normalizeValue(depth);%imshow(uint8(depth));
depth=normalizeSize(depth);

figure(7),imshow(uint8(depth));
normal = calcNormal(uint8(depth));
figure(8),imshow(normal);
depth=imresize(depth,[img_size img_size]);
normal=imresize(normal,[img_size img_size]);


imwrite(uint8(depth),'result/depth.jpg');
imwrite(uint8(normal),'result/normal.jpg');

pc_face=pcdenoise(pointCloud(pc_face'));
selected_pc=pc_face.Location';%max(selected_pc(3,:)),min(selected_pc(3,:))
fid = fopen('result/face.obj','wt');
fprintf(fid, 'v %d %d %.2f\n',selected_pc);
fclose(fid);


%----------------------------------------------------------------------------------------
face_vertex=readOBJ('result/face.obj');
type='PoseVariation';
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

for r_i =1:size(rotation,1)
    vertex=(face_vertex'*RotationMatrix(rotation(r_i,1),rotation(r_i,2),rotation(r_i,3)))';
    [depth,mask]=calcDepthAndNormal(vertex,1,1);
    if size(depth,1)<50
        continue;
    end
    depth=normalizeValue(depth);%imshow(uint8(depth));
    depth=normalizeSize(depth);mask=normalizeSize(mask);
    normal=calcNormal(depth);%imshow(uint8(normal));

    depth=imresize(depth,[img_size img_size]);
    normal=imresize(normal,[img_size img_size]);
    imwrite(uint8(depth),['result/' rotation_type{r_i} '.jpg']);
    imwrite(uint8(normal),['result/' rotation_type{r_i} '.jpg']);
end
%--------------------------------------------------------------------------------
type='ShapeVariation';
[depth,mask]=calcDepthAndNormal(pc_face.Location',1,1);
%     Shape Jittering
[ depth_noise,normal_noise ] = noise( depth,mask,'gaussian',0,0.00002 );
depth_noise=imresize(depth_noise,[img_size img_size]);
normal_noise=imresize(normal_noise,[img_size img_size]);
imwrite(uint8(depth_noise),'result/depth_Jittering.jpg');
imwrite(uint8(normal_noise),'result/normal_Jittering.jpg'); 
%     Shape Scaling
scale=1.1;
[depth_shrink,normal_shrink]=shrink(depth,mask,scale);
depth_shrink=imresize(depth_shrink,[img_size img_size]);
normal_shrink=imresize(normal_shrink,[img_size img_size]);
imwrite(uint8(depth_shrink),'result/depth_Scaling.jpg');
imwrite(uint8(normal_shrink),'result/normal_Scaling.jpg');