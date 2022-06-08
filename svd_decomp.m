function x=svd_decomp(u,s,v,k)
c=0;
j=1;
for i=2:5 %try 6 for color
    
   c=c+s(i+k,i+k)*u(:,i+k)*v(:,i+k)';
  % x(:,j)=c(:);
 %figure;imshow(c,[]);title(strcat('r',num2str(i)));
%    j=j+1
   
end
% figure;imshow(c,[]);title(strcat('r',num2str(i)));
x(:,j)=c(:);
j=j+1;
c=0;
for i=2:10 %try 6 for color
    
   c=c+s(i+k,i+k)*u(:,i+k)*v(:,i+k)';
   %x(:,j)=c(:);
 %figure;imshow(c,[]);title(strcat('r',num2str(i)));
%    j=j+1
%    
end
% figure;imshow(c,[]);title(strcat('r',num2str(i)));
x(:,j)=c(:);
j=j+1;
c=0;
for i=2:15 %try 6 for color
    
   c=c+s(i+k,i+k)*u(:,i+k)*v(:,i+k)';
  % x(:,j)=c(:);
 %figure;imshow(c,[]);title(strcat('r',num2str(i)));
  % j=j+1
   
end
x(:,j)=c(:);
j=j+1;
c=0;
for i=2:20%try 6 for color
    
   c=c+s(i+k,i+k)*u(:,i+k)*v(:,i+k)';
   %x(:,j)=c(:);
 %figure;imshow(c,[]);title(strcat('r',num2str(i)));
%    j=j+1
   
end
x(:,j)=c(:);
j=j+1;
c=0;
for i=2:25%try 6 for color
    
   c=c+s(i+k,i+k)*u(:,i+k)*v(:,i+k)';
   %x(:,j)=c(:);
 %figure;imshow(c,[]);title(strcat('r',num2str(i)));
%    j=j+1
   
end
x(:,j)=c(:);
j=j+1;
c=0;
for i=3:30%try 6 for color
    
   c=c+s(i+k,i+k)*u(:,i+k)*v(:,i+k)';
   %x(:,j)=c(:);
 %figure;imshow(c,[]);title(strcat('r',num2str(i)));
%    j=j+1
   
end
x(:,j)=c(:);
j=j+1;

end