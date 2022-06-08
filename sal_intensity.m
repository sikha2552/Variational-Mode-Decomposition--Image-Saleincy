 function sm= sal_intensity(img)
% img=imread('Y:\DMD\Imgs\235.jpg');
img=imresize(img,[250,250]);
R=img(:,:,1);
G=img(:,:,2);
B=img(:,:,3);
U = -0.14713 * R - 0.28886 * G + 0.436 * B; % U component
V = 0.615 * R - 0.51499 * G - 0.10001 * B; % V component
Y = 0.299 * R + 0.587 * G + 0.114 * B;
y1=(Y-mean(mean(Y))).^2;
cform = makecform('srgb2lab', 'AdaptedWhitePoint', whitepoint('d65'));
lab = applycform(img,cform);
l = double(lab(:,:,1));
l1=(l-mean(mean(l))).^2;
%---------------SVD COMPUTE---------------------------------------------
[m n]=size(l);
[lu ls lv]=svd(l);
x1=svd_decomp(lu,ls,lv,0);
  x1=x1(:,randperm(size(x1,2)));
[yu ys yv]=svd(double(Y));
x2=svd_decomp(yu, ys, yv,0);
  x2=x2(:,randperm(size(x2,2)));
[ur sr vr]=svd(double(R));
x3=svd_decomp(ur,sr,vr,0);
  x3=x3(:,randperm(size(x3,2)));
[ug sg vg]=svd(double(G));
x4=svd_decomp(ug,sg,vg,0);
  x4=x4(:,randperm(size(x4,2)));
xp=[x1 l1(:) x3 l1(:) ];
xq=[ x2 double(y1(:)) x4  ];
%---------------------------------DMD -------------------%
[sp1 low1]=dmdcompute(xp,m,n);
[sp2 low2]=dmdcompute(xq,m,n);
sp1norm = (sp1 - min(sp1(:)))./(max(sp1(:)) - min(sp1(:)));
sp2norm = (sp2 - min(sp2(:)))./(max(sp2(:)) - min(sp2(:)));
maxsp=(sp1norm+sp2norm).^1.5;
sm=maxsp.^2;
% sm = (maxsp - min(maxsp(:)))./(max(maxsp(:)) - min(maxsp(:)));
% figure;imshow(sm);
% out=sm;
% out=imfilter(out, fspecial('gaussian', [3,3], .25));
%  out=(out-min(out(:)))./(max(out(:))-min(out(:)));
%  figure;imshow(out);
%  final1=morphSmooth(out,20);
% final1 = enhanceContrast(final1, 10);
% figure;imshow(final1);title('final_out');