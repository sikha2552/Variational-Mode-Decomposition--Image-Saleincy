function final1= DMD(img)
 sm1=color_aug_29_ohm(img);
 sm1=imfilter(sm1, fspecial('gaussian', [3,3], .25));
 sm1=(sm1-min(sm1(:)))./(max(sm1(:))-min(sm1(:)));
%   figure;imshow(sm1);title('color_normalized');
%sm2=sal_intensity(img);
  
%   figure;imshow(sm2);title('intensity');
% sm2=(sm2-min(sm2(:)))./(max(sm2(:))-min(sm2(:)));
% sm2=imclearborder(sm2);
 
%   figure;imshow(sm2);title('intensity_normalized');
  final=sm1;
   final=(final-min(final(:)))./(max(final(:))-min(final(:)));
% final=max(sm1,sm2);
%   figure;imshow(final);title('final');
  final1=morphSmooth(final,5);
%   figure;imshow(final1);title('morph_smoothed');
  final1 = enhanceContrast(final1, 20);