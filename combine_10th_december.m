close all;
clear all;
clc;
r='D:\2_VMD_Dec2017\0_IMPLEMENTATION\NOISY_OUT\MSRA_NOISEFREE_COMBINED\'
 path1 = 'D:\2_VMD_Dec2017\0_IMPLEMENTATION\NOISY_OUT\MSRA_NOISEFREE_VMD_DMD\';
 path2='D:\2_VMD_Dec2017\0_IMPLEMENTATION\NOISY_OUT\msradmd\'
images=dir(strcat(path1,'*.jpg'));
images1=dir(strcat(path2,'*.jpg'));
imagegt=dir(strcat(path1,'*.png'));
for ks=1:numel(images)
   file_name=images(ks).name;
    I=strcat(path1,file_name);
    vmd=imread(I);
    file_name=images1(ks).name;
    I=strcat(path2,file_name);
    dmd=imread(I);
%   img=imresize(img,[250,250]);
% %     imagegt=dir(strcat(path1,'*.png'))
    file_name=imagegt(ks).name;
    Ig=strcat(path1,file_name);
    gt=imread(Ig);
    gt=imresize(gt,[250,250]);

% vmd=imread('D:\2_VMD_Dec2017\0_IMPLEMENTATION\NOISY_OUT\7_VMD_DMD\5\seg1.jpg');
% dmd=imread('D:\2_VMD_Dec2017\0_IMPLEMENTATION\NOISY_OUT\6_DMD\5g_.5\seg1.jpg');
vmd=imresize(vmd,size(dmd));
if entropy(dmd)<1
    out1=vmd
else
% figure;imshow(vmd);title('vmd');
% figure;imshow(dmd);title('dmd');
bw=im2bw(dmd);
bw1 = bwareaopen(bw,250,4);
bw2 = imfill(bw1,8,'holes');
% bw2 = imsharpen(bw2);
se = strel('disk',22);
closeBW = imclose(bw2,se);
% figure, imshow(closeBW)

% out=round(mean(vmd(:)));
% figure;imshow(bw);
% figure;imshow(bw1);figure;imshow(bw2);
out1=vmd.*uint8(closeBW);
end
figure;imshow(out1);
%  final1=morphSmooth(out1,10);figure;imshow( final1);
  final1 = enhanceContrast(double(out1), .04);figure;imshow( final1);
  
  imwrite(gt,[r,strcat('seg', num2str(ks)),'.png']); 
 imwrite(final1,[r,strcat('seg', num2str(ks)),'.jpg']); 

end
  