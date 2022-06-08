% Test script for 2D-VMD
% Authors: Konstantin Dragomiretskiy and Dominique Zosso
% {konstantin,zosso}@math.ucla.edu
% http://www.math.ucla.edu/~{konstantin,zosso}
% Initial release 2014-03-17 (c) 2014
%
% When using this code, please do cite our papers:
% -----------------------------------------------
% K. Dragomiretskiy, D. Zosso, Variational Mode Decomposition, IEEE Trans.
% on Signal Processing, 62(3):531-544, 2014. DOI:10.1109/TSP.2013.2288675
%
% K. Dragomiretskiy, D. Zosso, Two-Dimensional Variational Mode
% Decomposition, IEEE Int. Conf. Image Proc. (submitted). Preprint
% available here: ftp://ftp.math.ucla.edu/pub/camreport/cam14-16.pdf
%

%% preparations

close all;
clc;
clear all;


% Sample data
% % texture = load('texture.mat');
% % f = texture.f;
% R='D:\2_VMD_Dec2017\0_IMPLEMENTATION\MODES\mode5\'
% gt = imread('D:\2_VMD_Dec2017\0_IMPLEMENTATION\data\im110.png');

Img = imread('D:\2_VMD_Dec2017\0_IMPLEMENTATION\data\im31.jpg');
% Img=imnoise(Img,'gaussian',0,.5);
% imwrite(Img,'noisy.png');
 Img=imresize(Img,[250,250]);
%   gt=imresize(gt,[250,250]);
% ks=22;
% figure; imshow(Img);title('Original Image');
[Ny,Nx,Nc] = size(Img); 
tic
B = colorspace('RGB->Lab',Img);
% Img = B(:,:,3);
% figure; imshow((Img));title('b of Original Image');
% 
% f = Img;
% parameters:
alpha = 10000;       % bandwidth constraint
tau = 0;         % Lagrangian multipliers dual ascent time step
K =3;              % number of modes
DC = 1;             % includes DC part (first mode at DC)

init = 1;           % initialize omegas randomly, may need multiple runs!

tol = K*10^-6;      % tolerance (for convergence)
f=double(B(:,:,2));
%% run actual 2D VMD code

[u, u_hat, omega] = VMD_2D(f, alpha, tau, K, DC, init, tol);
% [ub, u_hatb, omegab] = VMD_2D(f1, alpha, tau, K, DC, init, tol);

j=1;i=1;
EN=zeros(3,2);
o=zeros(size(250,250));
for k=1:size(u,3)
 
  %colormap(gray)
  sm=uint8(255 * mat2gray(u(:,:,k)));
%sm=u(:,:,k);
  figure('Name', ['Mode #' num2str(k)]);
  imshow(sm);
%   o=o+sm;
%   imwrite(sm,[strcat( num2str(k)),'.png']);
%  %  imwrite(gt,[R,strcat('seg', num2str(ks)),'.png']);
% EN(j,2)=entropy(u(:,:,k));
% EN(i,1)=k;
% i=i+1;
% j=j+1;
end
  imagesc(sum(u,3));


% % % % % % EN=sortrows(EN,2);
% % % % % % 
% % % % % % [m n]=size(f);
% % % % % % 
% % % % % %  denoise=(u(:, :,EN(1,1))+u(:, :,EN(2,1))+u(:, :,EN(3,1)));  %figure; imshow(denoise)
% % % % % %        x=(denoise - min(denoise(:)))./(max(denoise(:)) - min(denoise(:)));
% % % % % %        out=imfilter(x, fspecial('gaussian', [3,3], .25));
% % % % % %       final1=morphSmooth(out,6);
% % % % % % final1 = enhanceContrast(final1, 12);
% % % % % % %  figure;imshow(final1);title('final_out color VMD');
% % % % % % 
% % % % % % x1=u(:, :,EN(1,1)); x2=u(:, :,EN(2,1));x3=u(:, :,EN(3,1)); 
% % % % % % %x4=u(:,:,4); x5=u(:,:,5);x6=u(:,:,6);
% % % % % % x1=x1(:);
% % % % % % x1=x1-min(x1)./(max(x1-min(x1)));
% % % % % % x2=x2(:);
% % % % % % x2=x2-min(x2)./(max(x2-min(x2)));
% % % % % % x3=x3(:);
% % % % % % x3=x3-min(x3)./(max(x3-min(x3)));
% % % % % % X=[x1,x2,x3];
% % % % % % [sp1, low1]=dmdcompute(X,m,n);
% % % % % % % figure;subplot(1,2,1);imshow(sp1,[]);title('sparse1 rgb');
% % % % % % %        subplot(1,2,2);imshow(low1,[]);title('LOW rgb');
% % % % % %        
% % % % % %        sp1out=(sp1 - min(sp1(:)))./(max(sp1(:)) - min(sp1(:)));
% % % % % %        out=imfilter( sp1out, fspecial('gaussian', [3,3], .25));
% % % % % %       final2=morphSmooth(out,6);
% % % % % %      final2 = enhanceContrast(final2, 12);
% % % % % % %           figure;imshow(final2);title('final_out sp1');
% % % % % %        time=toc
% % % % % %        imwrite(gt,[R,strcat('seg', num2str(ks)),'.png']); 
% % % % % % imwrite(final2,[R,strcat('seg', num2str(ks)),'.jpg']); 
% % % % % % 
% % % % % % %        sp2out=(sp2 - min(sp2(:)))./(max(sp2(:)) - min(sp2(:)));
% % % % % % %        out=imfilter( sp2out, fspecial('gaussian', [3,3], .25));
% % % % % % %       final1=morphSmooth(out,6);
% % % % % % %      final1 = enhanceContrast(final1, 12);
% % % % % % %           figure;imshow(final1);title('final_out color');
% % % % % % %           out_combined=max(final1,final2);
% % % % % % %           figure;imshow(out_combined);
