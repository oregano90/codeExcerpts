function Y=FindBCs(Npol,Nnodes,cprime_coeffmat) %should be Nx1
global kappa gamma psi rho ol_om lambda
global theta mu_y sigma_y m n A B
%% omega=0 is coded with the index 0, omega=1 with index 1


%% determine the chebyshev polynomials and nbound
omega =[0 1];
T     =[0;0];
Tder  =[0;0];
for k=1:Npol
    ncheb     =k-1;
    x         =(omega*2-1);
    T(:,k)    =cos(ncheb*acos(x'));
end

nbound          =[n(1),n(length(n))];                                 %wichtig für dynamic monetary policys

thetabound(:,1) =[theta(1,1);theta(length(n),1)];
thetabound(:,2) =[theta(1,2);theta(length(n),2)];

%% determine JA and JB
JA          =T*A;
JB          =T*B;
cprimeA     =cprime_coeffmat*A;     %adjusted coefficients for derivative of chebyshev approximated function
cprimeB     =cprime_coeffmat*B;
JderA       =T*cprimeA;
JderB       =T*cprimeB;
JdiffA      =JderA./JA;
JdiffB      =JderB./JB;

%% F terms

F           =diag(omega)*JA+diag(1-omega)*JB;
Fder        =JA-JB+diag(omega)*JderA+diag(1-omega)*JderB;
Fdiff       =Fder./F;

WAS=[];
WBS=[];

%% determine the boundary values for WAS and WBS
%omega=0 implies
WBS(1,1)=1;
WAS(1,1)=(gamma(2)-lambda.*nbound(1)./(m.*sigma_y^2))./gamma(1);
%omega=1 implies
WAS(2,1)=1;
WBS(2,1)=(gamma(1)+lambda*nbound(2)./(m*sigma_y^2))./gamma(2);

%% determine endogenous variables

fac_sig     =WAS-WBS;
sigma       =sigma_y*ones(2,1);
sigma_om    =diag(fac_sig)*sigma;
fac_sharpe  =WBS*gamma(2);  %CAREFUL! fac_sharpe=(mu-r)/(sigma^2). notice that this is not really the sharpe ratio, as it uses not volatility but variance. I just call it sharpe ratio as it is a frequently used term and is similar to the sharpe ratio.
muMr        =diag(sigma.^2)*fac_sharpe;     %muMr means $mu-r$
mu_om       =diag(fac_sig)*muMr-lambda*diag(nbound)/m*(WAS-1)-(JA-JB)-diag(sigma_om)*sigma;
Pi          =lambda*diag(omega)*(WAS-1);

%now decompose \mu, to make it more understandable
I           =kappa*(ol_om-omega');  %MAYBE WITHOUT THE TERM AFTER KAPPA %Nx1; plus the 'stationary term'??? kappa(overline(omega)-omega)?

mu=mu_y+F-diag(Fdiff)*I;
r=mu-muMr;

%% determine the ODE for A

O       =-rho-kappa;
I       =1/psi*JA;
II      =(1-1/psi)*(r+lambda*thetabound(:,1)+diag(nbound)/m*Pi);
III     =-(1/psi)*(kappa*(diag(ol_om-omega)))*JdiffA;
IV      =0;
V       =((1-1/psi)/2)*gamma(1)*diag(sigma.^2)*WAS.^2;             

Y((1:2),1)=((O+I+II+III+IV+V));

%% determine the ODE for B

O       =-rho-kappa;
I       =1/psi*JB;
II      =(1-1/psi)*(r+lambda*thetabound(:,2)+diag(nbound)/m*Pi);
III     =-(1/psi)*(kappa*(diag(ol_om-omega)))*JdiffB;
IV      =0;
V       =((1-1/psi)/2)*gamma(2)*diag(sigma.^2)*WBS.^2;             

Y((3:4),1)=((O+I+II+III+IV+V));