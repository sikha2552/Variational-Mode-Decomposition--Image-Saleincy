  function color_sal=color_aug_29_ohm(img)
% close all;
% clear all;
% clc;
% path ='Y:\RESULTS\0_ACHANTA';
%  path1 = strcat(path,'\0_FINAL\');
% r='Y:\DMD\DMD_test\29_thaugust_omm\color\'
% images=dir(strcat(path1,'*.jpg'))
% 
% img=imread('Y:\RESULTS\0_ACHANTA\0_FINAL\im1.jpg');
% for ks=1:numel(images)
%     
%    
%     file_name=images(ks).name;
%     I=strcat(path1,file_name);
%     img=imread(I);
      img=imresize(img,[250,250]);
%    
%      imagegt=dir(strcat(path1,'*.png'))
%          file_name=imagegt(ks).name;
%     Ig=strcat(path1,file_name);
%     gt=imread(Ig);
%     gt=imresize(gt,[250,250]);
% 
%--------------------YUV component--------------------------------------%
R=img(:,:,1);
G=img(:,:,2);
B=img(:,:,3);
U = -0.14713 * R - 0.28886 * G + 0.436 * B; % U component
V = 0.615 * R - 0.51499 * G - 0.10001 * B; % V component
YCBCR = rgb2ycbcr(img);
cb=YCBCR(:,:,2);
cr=YCBCR(:,:,3);
cform = makecform('srgb2lab', 'AdaptedWhitePoint', whitepoint('d65'));
lab = applycform(img,cform);
a= double(lab(:,:,2));
b= double(lab(:,:,3));
 [m n]=size(cb);
d1=b+double(V)+double(cr);
%figure;imshow(d1,[]);title('d1');
d2=a+double(U)+double(cb);
% figure;imshow(d2,[]);title('d2');
d12=(abs(d1-d2)).^2;

% % % %------------------------------------------------------------------------%
% % % %------------------------------------------------------------------------%
x1=[b(:),double(V(:)),double(cr(:)),double(G(:))];
 x1=x1(:,[2 1 4 3]);
x2=[a(:),double(U(:)),double(cb(:)),d1(:)];
x2=x2(:,[2 1 4 3]);
[sp1, low1]=dmdcompute(x1,m,n);
[sp2 low2]=dmdcompute(x2,m,n);
%               figure;subplot(1,2,1);imshow(sp1,[]);title('sparse1 B-V-CR');
%                  subplot(1,2,2);imshow(low1,[]);title('LOW B-V-CR');
%              figure;subplot(1,2,1);imshow(sp2,[]);title('sparse2 A-U-CB');
%                  subplot(1,2,2);imshow(low2,[]);title('LOW A-U-CB');
% % %  %--------------- NORMALIZE sparse and low-------------------------------------%
 
 sp1norm = (sp1 - min(sp1(:)))./(max(sp1(:)) - min(sp1(:)));
 sp2norm = (sp2 - min(sp2(:)))./(max(sp2(:)) - min(sp2(:)));
%               figure;subplot(1,2,1);imshow( sp1norm,[]);title('sparse1 normalized');
%             subplot(1,2,2);imshow(sp2norm ,[]);title('sparse2 normalized');
 l1norm = (low1 - min(low1(:)))./(max(low1(:)) - min(low1(:)));
 l2norm = (low2 - min(low2(:)))./(max(low2(:)) - min(low2(:)));
%             figure;subplot(1,2,1);imshow( l1norm,[]);title('low1 normalized');
%             subplot(1,2,2);imshow(l2norm ,[]);title('low2 normalized');
maxsp=(sp1norm+sp2norm);
%    figure;imshow(maxsp,[]);title('max sp');
maxlow=(l1norm+l2norm).^2;
% %     figure;subplot(1,2,1);imshow( maxsp,[]);title('sparse final');
% %          subplot(1,2,2);imshow(maxlow,[]);title('LOW final'); 
t1=mean(maxlow(:))
t2=mean(maxsp(:))
e1low=entropy(maxlow);
e2sp=entropy(maxsp);
% if t1>t2
  out=(maxsp-maxlow).^2;
  out=((out-mean(out(:)))/std(out(:)));
   final1=(sp2norm-mean(sp2norm(:)))/std(sp2norm(:));
    t=final1>(max(final1(:))/2);
    [B,L]= bwboundaries(t);
%    figure;imshow(final1);title('final');
  out=(final1).^2;
 % figure;imshow(out);title('out');
  color_sal=zeros(size(final1));
  x=L~=0;
  t1=out>mean(out(:))+1.1*std(out(:));
  t1=imclearborder(t1);
  [B1,L1]= bwboundaries(t1);
   x1=L1~=0;
   
  %figure;imshow(x);
  xn = double(x);
   xn1 = double(x1);
    for i=1:size(final1)
        for j=1:size(final1)
            if (xn(i,j)==1)||(xn1(i,j)==1)
                color_sal(i,j)=max(final1(i,j),out(i,j));                     
            else
                 color_sal(i,j)=final1(i,j);
            end
        end
    end
%     figure;imshow(color_sal);title('combined');
%  end
%  imwrite(color_sal,[r,strcat('seg', num2str(ks)),'.jpg']);
 %imwrite(gt,[r,strcat('seg', num2str(ks)),'.png']);

%  end
