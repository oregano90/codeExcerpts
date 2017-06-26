function AddBounds %add the values at omega=0 and omega=1, as they were not directly needed in the approximation before
global kappa gamma psi ol_om lambda mu_y sigma_y m n
global omega A B T cprime_coeffmat Npol
global WAS WBS fac_sig sigma sigma_om fac_sharpe muMr mu_om Pi mu r 
global JA JB JderA JderB JderderA JderderB JdiffA JdiffB  JdiffdiffA JdiffdiffB
global F Fder Fderder Fdiff Fdiffdiff

if not(isscalar(n))
    n  =[n(1),n,n(length(n))];                                 %wichtig für dynamic monetary policys
end

WBS=[1;WBS;(gamma(1)+lambda*n(length(n))/(m*sigma_y^2))/gamma(2)];
WAS=[(gamma(2)-lambda*n(1)/(m*sigma_y^2))/gamma(1);WAS;1];
numb=length(WAS);

omega=[0,omega,1];
x=[];
for k=1:Npol
    ncheb     =k-1;
    x         =(omega*2-1);
    Tnew(:,k) =[cos(ncheb*acos(x(1,1)));T(:,k);cos(ncheb*acos(x(1,numb)))];
end
T=Tnew;

JA          =T*A;
JB          =T*B;
cprimeA     =cprime_coeffmat*A;     %adjusted coefficients for derivative of chebyshev approximated function
cprimeB     =cprime_coeffmat*B;
cprimeprimeA=cprime_coeffmat*cprimeA;
cprimepriemB=cprime_coeffmat*cprimeB;
JderA       =T*cprimeA;
JderB       =T*cprimeB;
JderderA    =T*cprimeprimeA;
JderderB    =T*cprimepriemB;
JdiffA      =JderA./JA;
JdiffB      =JderB./JB;

JdiffA      =JderA./JA;
JdiffB      =JderB./JB;
JdiffdiffA  =JderderA./JA;
JdiffdiffB  =JderderB./JB;

F           =diag(omega)*JA+diag(1-omega)*JB;
Fder        =JA-JB+diag(omega)*JderA+diag(1-omega)*JderB;
Fderder     =2*(JderA-JderB)+diag(omega)*JderderA+diag(1-omega)*JderderB;
Fdiff       =Fder./F;
Fdiffdiff   =Fderder./F;

div_gapsi(1)=(1-gamma(1))/(1-psi);
div_gapsi(2)=(1-gamma(2))/(1-psi);
facom       =diag(omega.*(1-omega));

fac_sig     =WAS-WBS;
sigma       =[sigma_y;sigma;sigma_y];
sigma_om    =diag(fac_sig)*sigma;
fac_sharpe  =WBS*gamma(2)-div_gapsi(2)*diag(fac_sig)*facom*JdiffB;  %CAREFUL! fac_sharpe=(mu-r)/(sigma^2). notice that this is not really the sharpe ratio, as it uses not volatility but variance. I just call it sharpe ratio as it is a frequently used term and is similar to the sharpe ratio.
muMr        =diag(sigma.^2)*fac_sharpe;     %muMr means $mu-r$
mu_om       =diag(fac_sig)*muMr-lambda*diag(n)/m*(WAS-1)-(JA-JB)-diag(sigma_om)*sigma;
Pi          =lambda*diag(omega)*(WAS-1);


%now decompose \mu, to make it more understandable
I           =kappa*(ol_om-omega')+facom*(mu_om+sigma_om*sigma_y);
II          =facom.^2*diag(sigma_om.^2)*(Fdiff.^2-0.5*Fdiffdiff);  %Nx1

mu=mu_y+F-diag(Fdiff)*I+II;
r=mu-muMr;
end