close all;
clear all;
clc;
clc;
R='D:\2_VMD_Dec2017\0_IMPLEMENTATION\NOISY_OUT\7_VMD_DMD\3\'
disp('select the folder ')
path = uigetdir;
 path1 = strcat(path,'\data\');
images=dir(strcat(path1,'*.jpg'));
imagegt=dir(strcat(path1,'*.png'));

for ks=1:3
    ks
    file_name=images(ks).name;
    I=strcat(path1,file_name);
    img=imread(I);
    img=imresize(img,[150,150]);
        img=imnoise(img,'gaussian',.3);
    file_name=imagegt(ks).name;
    Ig=strcat(path1,file_name);
    gt=imread(Ig);
    gt=imresize(gt,[250,250]);
  [Ny,Nx,Nc] = size(img);
  
B = colorspace('RGB->Lab',img);
% figure;imshow(B(:,:,1),[]);
%%%%%%%%%%%VMD%%%%%%%%%%%%%%%%%%%%%

% parameters:    
alpha = 10000;       % bandwidth constraint
tau = 0;         % Lagrangian multipliers dual ascent time step
K = 15;              % number of modes
DC = 1;             % includes DC part (first mode at DC)
init = 1;           % initialize omegas randomly, may need multiple runs!
tol = K*10^-6;      % tolerance (for convergence)
a=B(:,:,2);
b=B(:,:,3);
[ua, u_hata, omega_a] = VMD_2D(a, alpha, tau, K, DC, init, tol);
[ub, u_hatb, omega_b] = VMD_2D_1(b, alpha, tau, K, DC, init, tol);

j=1;i=1;
EN1=zeros(3,2);
for k=1:size(ua,3)
  %figure('Name', ['Mode #' num2str(k)]);
EN1(j,2)=entropy(ua(:,:,k));
EN1(i,1)=k;
i=i+1;
j=j+1;
end
EN1=sortrows(EN1,2);

j=1;i=1;
EN2=zeros(3,2);
for k=1:size(ua,3)
  %figure('Name', ['Mode #' num2str(k)]);
EN2(j,2)=entropy(ub(:,:,k));
EN2(i,1)=k;
i=i+1;
j=j+1;
end
EN2=sortrows(EN2,2);
[m n]=size(a);
%%%%%%%%%%%%%%%%%%%%DENOISE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 denoise1=(ua(:, :,EN1(1,1))+ua(:, :,EN1(2,1))+ua(:, :,EN1(3,1)));  %figure; imshow(denoise1,[])
 denoise2=(ub(:, :,EN2(1,1))+ub(:, :,EN2(2,1))+ub(:, :,EN2(3,1))); % figure; imshow(denoise2,[])
if entropy(denoise1)>entropy(denoise2)
    denoise=denoise1;
else
    denoise=denoise2;
end
x=(denoise - min(denoise(:)))./(max(denoise(:)) - min(denoise(:)));
out=imfilter(x, fspecial('gaussian', [3,3], .25));
final1=morphSmooth(out,6);
final1 = enhanceContrast(final1, 12);
% figure;imshow(final1);title('final_out color VMD');
 %%%%%%%%%%%%%%CALCULATE DMD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ua1=ua(:,:,1);ua2=ua(:, :,EN1(2,1));ua3=ua(:, :,EN1(3,1));
ub1=ub(:,:,1);ub2=ua(:, :,EN1(2,1));ub3=ua(:, :,EN1(3,1))

ua1=ua1(:); ua2=ua2(:);ua3=ua3(:);
ub1=ub1(:);ub2=ub2(:);ub3=ub3(:);

if entropy(denoise1)>entropy(denoise2)
    X=[final1(:),ua1,ua2,ua3,denoise1(:)];
    t=1
else
     X=[final1(:),ub2,ub1,denoise2(:)];
     t=0
end

[sp1, low1]=dmdcompute(X,m,n);
% figure;subplot(1,2,1);imshow(sp1,[]);title('sparse1 rgb');
%        subplot(1,2,2);imshow(low1,[]);title('LOW rgb');

smap=max(sp1,final1);
% figure;imshow(smap,[]);
out=imfilter(smap, fspecial('gaussian', [3,3], .25));
% figure;imshow(out,[]);
vmd_dmd = enhanceContrast(out, .02);
%figure;imshow(vmd_dmd,[]);title('final_out ');
ou = uint8(255 * mat2gray(vmd_dmd));
 imwrite(ou,[R,strcat('seg',num2str(ks)),'.jpg']); 
 imwrite(gt,[R,strcat('seg', num2str(ks)),'.png']); 
ks=ks+1
end
