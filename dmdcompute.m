function[low sp]=dmdcompute(x,m,n)
[xLow xSparse]= DMDsvd(x);
 low=zeros(m,n);
 sp=zeros(m,n);
% % %  %-----------------------RESHAPE-----------------------------------------%
 for i=1:size(xSparse,2)
  lo(:,:,i)=  reshape(xLow(:,i), [m, n]);
  low=low+lo(:,:,i);
  %figure;imshow(lo(:,:,i),[]);title(strcat(num2str(i),'low'));
end
%figure;imshow(low,[]);title('lo alone');
for i=1:size(xSparse,2)
  o(:,:,i)=  reshape(xSparse(:,i), [m, n]);
  sp=sp+o(:,:,i);
 %figure;imshow(o(:,:,i),[]);title(strcat(num2str(i),'sparse'));
end
%figure;imshow(sp,[]);title('sparse alone');
end