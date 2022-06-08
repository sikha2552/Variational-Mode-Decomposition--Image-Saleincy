function [XLow XSparse]= DMDsvd(Y)
nF = size(Y,2)
vF=Y;
X1 = vF(:,1:nF-1);
X2 = vF(:,2:nF);

[U, E, V] = svd(X1, 'econ');
disp('1 reached')
Stild = U' * X2 * V * pinv(E);
[EigVec, EigVal] = eig(Stild)
omega = log(EigVal);
Omega = exp(omega);
Psi = U * EigVec;
b = pinv(Psi)*X1(:, 1);
%XDMDt = Psi * Omega * b;

omegaD = abs(diag(omega));
LowRank = exp(min(omegaD));

%XDMD = zeros(height * width, nF - 1);


for t = 1:nF 
    XDMD(:, t) = Psi * Omega.^t * b;
end
disp('2 reached')
%XLow = zeros(height * width, nF - 1);

for t = 1 :nF 
        XLow(:, t) = Psi * LowRank.^t * b;
end
disp('3 reached')
XLow = abs(XLow);
XSparse = abs(XDMD - XLow);
end