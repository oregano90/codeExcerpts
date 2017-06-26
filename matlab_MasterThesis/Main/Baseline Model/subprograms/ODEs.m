function y=ODEs(AB,Npol,Nnodes) %solves(24), AB is a stacked vector 2Nx1 first, N agent A equations, then N agent B equations
global kappa gamma psi rho ol_om lambda theta mu_y sigma_y m n lambda_h m_h
global omega A B T cprime_coeffmat BCfac ODEfac BCpow ODEpow
global WAS WBS fac_sig sigma sigma_om fac_sharpe muMr mu_om Pi mu r 
global JA JB JderA JderB JderderA JderderB JdiffA JdiffB  JdiffdiffA JdiffdiffB
global F Fder Fderder Fdiff Fdiffdiff

%% definitions later used
lambda          =(lambda_h)/(1-lambda_h);
m               =1/m_h;
theta           =[];
theta(:,1)      =n'.*m_h;
theta(:,2)      =0;
div_gapsi(1)    =(1-gamma(1))/(1-psi);
div_gapsi(2)    =(1-gamma(2))/(1-psi);
facom           =diag(omega.*(1-omega));

%% first, solve for the endogenous variables that are the same for both agents:
A           =AB(1:Npol,1);
B           =AB((1+Npol):(2*Npol),1);

%% set up J-terms
JA          =T*A;
JB          =T*B;

%% for derivatives of two possible ways:
%taking the derivative in the polynomial
% JderA       =Tder*A;
% JderB       =Tder*B;
% JderderA    =Tderder*A;
% JderderB    =Tderder*B;

%adjusting the coefficients
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
JdiffdiffA  =JderderA./JA;
JdiffdiffB  =JderderB./JB;

%% F Functions
F           =diag(omega)*JA+diag(1-omega)*JB;
Fder        =JA-JB+diag(omega)*JderA+diag(1-omega)*JderB;
Fderder     =2*(JderA-JderB)+diag(omega)*JderderA+diag(1-omega)*JderderB;
Fdiff       =Fder./F;
Fdiffdiff   =Fderder./F;

%% Find risky asset share of agent A
WAS         =real(FindWAS(omega,JdiffA,JdiffB,Fdiff));

%% Determine the other endogenous variables
WBS         =(1-diag(omega)*WAS)./(1-omega)';                       %portfolio share of risky asset for agent B
fac_sig     =diag(1./(1-omega))*(WAS-1);                            %sigma_omega/sigma
sigma       =sigma_y./(1+diag(omega)*diag(Fdiff)*(WAS-1));          
sigma_om    =diag(fac_sig)*sigma;                                   %sigma omega
fac_sharpe  =WBS*gamma(2)-div_gapsi(2)*diag(fac_sig)*facom*JdiffB;  %fac_sharpe=(mu-r)/(sigma^2). notice that this is not really the sharpe ratio, as it uses not volatility but variance. I just call it sharpe ratio as it is a frequently used term and is similar to the sharpe ratio.
muMr        =diag(sigma.^2)*fac_sharpe;                             %muMr means $mu-r$
mu_om       =diag(fac_sig)*muMr-lambda*diag(n)/m*(WAS-1)-(JA-JB)-diag(sigma_om)*sigma; %mu_omega
Pi          =lambda*diag(omega)*(WAS-1);                                  %liquidity

%now decompose \mu, to make it more understandable
I           =kappa*(ol_om-omega')+facom*(mu_om+sigma_om*sigma_y);   %note that there is a misprint in the paper: the term "kappa(overline(omega)-omega)" is missing
II          =facom.^2*diag(sigma_om.^2)*(Fdiff.^2-0.5*Fdiffdiff);

mu          =mu_y+F-diag(Fdiff)*I+II;
r           =mu-muMr;                                               %real interest rate (deposit rate)

%% boundary conditions
BC                 =FindBCs(Npol,Nnodes,cprime_coeffmat); %gives a 4x1 matrix with the first two entries being the boundary conds for agent A and the third and fourth entry being the boundary conds for agent B, first for omega=0, then for omega=1

%y=[(ODE(1,JA,JdiffA,JdiffdiffA,WAS)-ODE(2,JB,JdiffB,JdiffdiffB,WBS)).^2;(ODE(1,JA,JdiffA,JdiffdiffA,WAS)+ODE(2,JB,JdiffB,JdiffdiffB,WBS)).^2;BC((1:2),1).^2;BC((3:4),1).^2];
y=[ODE(1,JA,JdiffA,JdiffdiffA,WAS).^(ODEpow)*ODEfac+BC(1,1).^(BCpow)*BCfac+BC(2,1).^(BCpow)*BCfac;ODE(2,JB,JdiffB,JdiffdiffB,WBS).^(ODEpow)*ODEfac+BC(3,1).^(BCpow)*BCfac+BC(4,1).^(BCpow)*BCfac];
end


function y=ODE(i,Ji,Jidiff,Jidiffdiff,WiS)

global omega kappa gamma psi rho ol_om lambda theta m n
global sigma sigma_om mu_om Pi r

O       =-rho-kappa;
I       =1/psi*Ji;
II      =(1-1/psi)*(r+lambda*theta(:,i)+diag(n)/m*Pi);
III     =-(1/psi)*(kappa*(diag(ol_om-omega))+diag(omega.*(1-omega))*diag(mu_om))*Jidiff;
IV      =-(1/(psi*2))*diag((omega.*(1-omega)).^2)*diag(sigma_om.^2)*(Jidiffdiff+Jidiff.^2*(psi-gamma(i))/(1-psi));
V       =((1-1/psi)/2)*gamma(i)*diag(sigma.^2)*WiS.^2;              %* gamma(i), as gamma(i) is not squared

y       =((O+I+II+III+IV+V));
end