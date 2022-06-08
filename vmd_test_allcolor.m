close all;
clear all;
clc;
img = imread('D:\2_VMD_Dec2017\0_IMPLEMENTATION\data\im1.jpg');
img=imresize(img,[100,100]);
img=imnoise(img,'gaussian',.2);
figure;imshow(img);title('noisy image');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%Channel Seperation%%%%%%%%%%%%%
% img=colorspace('RGB->lab',img);
R=img(:,:,1);G=img(:,:,2);B=img(:,:,3);
[Ny,Nx,Nc] = size(img);
%%%%%%%%%%%%%%%%%%%%%%%%%%VMD%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% parameters:
alpha = 10000;       % bandwidth constraint
tau = 0;         % Lagrangian multipliers dual ascent time step
K = 15;              % number of modes
DC = 1;             % includes DC part (first mode at DC)
init = 1;           % initialize omegas randomly, may need multiple runs!
tol = K*10^-6;      % tolerance (for convergence)
[ur, u_hatr, omega_r] = VMD_2D(R, alpha, tau, K, DC, init, tol);
[ug, u_hatg, omega_g] = VMD_2D_1(G, alpha, tau, K, DC, init, tol);
[ub, u_hatb, omega_b] = VMD_2D_2(B, alpha, tau, K, DC, init, tol);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j=1;i=1;
EN1=zeros(3,2);
for k=1:size(ur,3)
  %figure('Name', ['Mode #' num2str(k)]);
EN1(j,2)=entropy(ur(:,:,k));
EN1(i,1)=k;
i=i+1;
j=j+1;
end
EN1=sortrows(EN1,2);

j=1;i=1;
EN2=zeros(3,2);
for k=1:size(ug,3)
  %figure('Name', ['Mode #' num2str(k)]);
EN2(j,2)=entropy(ug(:,:,k));
EN2(i,1)=k;
i=i+1;
j=j+1;
end
EN2=sortrows(EN2,2);
j=1;i=1;
EN3=zeros(3,2);
for k=1:size(ug,3)
  %figure('Name', ['Mode #' num2str(k)]);
EN3(j,2)=entropy(ub(:,:,k));
EN3(i,1)=k;
i=i+1;
j=j+1;
end
EN3=sortrows(EN3,2);
[m n]=size(R);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 r=(ur(:, :,EN1(1,1))+ur(:, :,EN1(2,1))+ur(:, :,EN1(3,1)));  figure; imshow(r,[]);
 g=(ub(:, :,EN2(1,1))+ug(:, :,EN2(2,1))+ug(:, :,EN2(3,1)));  figure; imshow(g,[]);
 b=(ub(:, :,EN3(1,1))+ub(:, :,EN3(2,1))+ub(:, :,EN3(3,1)));  figure; imshow(b,[]);
 r= uint8(255 * mat2gray(r)); figure;imshow(r);
 g= uint8(255 * mat2gray(g)); figure;imshow(g);
 b= uint8(255 * mat2gray(b)); figure;imshow(b);
RGB = cat(3,r,g,b);
%lab=colorspace('RGB->lab',RGB);
U = -0.14713 * r - 0.28886 * g + 0.436 * b; % U component
V = 0.615 * r - 0.51499 * g - 0.10001 * b; % V component
YCBCR = rgb2ycbcr(RGB);
cb=YCBCR(:,:,2);
cr=YCBCR(:,:,3);
cform = makecform('srgb2lab', 'AdaptedWhitePoint', whitepoint('d65'));
lab = applycform(RGB,cform);
a= double(lab(:,:,2));
b= double(lab(:,:,3));
figure;imshow(a,[])

x1=[b(:),double(V(:)),double(cr(:)),double(g(:))];
 x1=x1(:,[2 1 4 3]);
x2=[a(:),double(U(:)),double(cb(:)),];
% x2=x2(:,[2 1 4 3]);
[sp1, low1]=dmdcompute(x1,m,n);
figure;imshow(sp1,[]);
figure;imshow(sp2,[])
[sp2 low2]=dmdcompute(x2,m,n);
% smap=DMD(RGB);
% figure;imshow(smap);

