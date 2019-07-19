
addpath('util');
landmark_path='simple/label/infrared/001_Kinect_FE_1INFRARED.txt';
color_path='simple/data/color/001_Kinect_FE_1COLOR/01.jpg';
depth_path='simple/data/depth/001_Kinect_FE_1DEPTH/01.png';
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
figure(7),imshow(uint8(normalizeSize(normalizeValue(depth))));
normal = calcNormal(uint8(normalizeSize(depth)));
figure(8),imshow(normal);

