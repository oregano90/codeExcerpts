function WAS=FindWAS(omega,JdiffA,JdiffB,Fdiff) %should be Nx1
global gamma psi lambda
global sigma_y m n

div_gapsi(1)=(1-gamma(1))/(1-psi);
div_gapsi(2)=(1-gamma(2))/(1-psi);
lnmsig=lambda*diag(n)/(m*sigma_y^2);

I       =1-2*diag(omega)*Fdiff+diag(omega.^2)*Fdiff.^2;
II      =2*diag(omega)*Fdiff-2*diag(omega.^2)*Fdiff.^2;
III     =diag(omega.^2)*Fdiff.^2;

Term2   =diag(omega)*(div_gapsi(1).*JdiffA-div_gapsi(2).*JdiffB);

X       = diag(1-omega)/gamma(2)*(lnmsig*I+Term2)-1;
Y       = omega'+diag(1-omega)/gamma(2)*(gamma(1)+lnmsig*II-Term2);
Z       = diag(1-omega)/gamma(2)*(lnmsig*III);

if n~=0
    WAS     =(-Y+sqrt((Y.^2-4*diag(X)*Z)))./(2*Z);
else
    WAS    =-X./Y;          %PLEASE CHECK THIS AGAIN LATER
end

end

%idee, find was-1 und vergleiche...