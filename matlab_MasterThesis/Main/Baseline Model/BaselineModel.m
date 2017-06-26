clearvars;
currentfolder=pwd;
addpath(strcat(pwd,'\subprograms'));        % initialize subfolders

dataname='baseline'                         % name of the file tha is used to store the results
delete(strcat(currentfolder,'\data\',dataname,'.mat'))

%% define global variables
%exogenous model parameters
global kappa gamma psi rho ol_om lambda eta phi n1 n2 theta mu_y sigma_y m
global n lambda_h m_h

%endogenous variables
global WAS WBS fac_sig sigma sigma_om fac_sharpe muMr mu_om Pi mu r
global JA JB JderA JderB JderderA JderderB JdiffA JdiffB JdiffdiffA JdiffdiffB
global F Fder Fderder Fdiff Fdiffdiff 

%variables for stationary density
global PDFomega omnew

%approximation parameters
global omega A B T Tder Tderder cprime_coeffmat Nnodes Npol BCfac ODEfac BCpow ODEpow

%dynamic monetary policy parameters
global mum sigmam fwguid_thresh 
tic

%% ****************************************************
% parameters of the baseline model
gamma(1)        =1.5;    %risk aversion of type A
gamma(2)        =15;     %risk aversion of type B
psi             =3;      %elasticity of intertemporal substitution (EIS)
rho             =0.01;   %rate of time preference
kappa           =0.01;   %agent death rate
ol_om           =0.1;    %OverLine omega, population share of type A
mu_y            =0.02;   %endowment growth rate
sigma_y         =0.02;   %endowment volatility
lambda_h        =0.29;   %lambda hat, (lambda) over (one plus lambda), funding shock size
eta             =0.1;    %funding shock frequency
phi             =0.15;   %fire sale loss
m_h             =0.25;   %m hat, 1 over m, government bond liquidity services ratio
n1              =0;      %nominal rate policy 1 in percent
n2              =5;      %nominal rate policy 2 in percent

% parameters for the extensions to the model
alpha           =0.14;


%% oprions for solving the ODE
options = optimoptions('fsolve','MaxFunEvals',1000,'MaxIter',1000,'Display','iter','FindiffType','central'); %options for fsolve

temp=[n1 n2]/100;
%% solution
for N=1:2                           % iterate over two nominal rate regimes
n=temp(N);                          % specify the nominal rate regimes are

Npol        =30;
BCfac       =10;                    % how much importance is put on the boundary conditions (factor that multiplies with the error)
BCpow       =1;                     % take boundary cond to the power of ~.
ODEfac      =1;                     % multiply the error of the ODE being zero with ~
ODEpow      =1;                     % take error of ODE to the power of ~. for ~=2, we get MSQE of the ODE
rescale     =0.01;                  % rescale input values
smoothfactor=1;
startpols   =2;
startnodes  =100;

AB=[];
AB0=[0.8;0.1;0.5;0.2];

D = eye(4)*rescale;

[omega,T,Tder,Tderder,cprime_coeffmat]=Chebyshev(startpols,startnodes,0,1);
[AB,fval]=fsolve(@(AB)ODEs(D*AB,startpols,startnodes),AB0,options);

for j=3:(Npol)
    j
    n
    D = eye(j*2)*rescale;
    AB0=[AB(1:(j-1),1);0;AB(j:(2*(j-1)),1);0];
    [omega,T,Tder,Tderder,cprime_coeffmat]=Chebyshev(j,round(smoothfactor*j),0,1);
    [AB,fval]=fsolve(@(AB)ODEs(D*AB,j,round(smoothfactor*j)),AB0,options);
end

% for plotting and analysing the solution of the ODE, add the boundaries of 
% omega: omega=0 and omega=1
AddBounds

%% find the stationary density of omega
[PDFomega]=StatDens(100); 

%% monetary policy
[mum,sigmam]=detmonpol(alpha);                 %determine monetary policy: drift and volatility
savemyvars(N,currentfolder,dataname);
end


%% plot
load(strcat(currentfolder,'\data\',dataname,'.mat'));
%%
%pdf of omega
figure
plot(omnew,S.PDFomega)
title('omega')
grid on
grid minor

%%
%monetary policy
figure
subplot(2,2,1)
plot(omega,S.Pi)
title('\Pi')
grid on
grid minor

subplot(2,2,2)
plot(omega,S.Pi./(permute(S.omega,[1 3 2]).*S.WAS))
title('\Pi/(\omega w_s^A)')
ylim([0 0.4])
grid on
grid minor

subplot(2,2,3)
plot(omega,S.mum)
title('\mu_{M}')
ylim([-0.05 0.2])
grid on
grid minor

subplot(2,2,4)
plot(omega,S.sigmam)
title('\sigma_{M}')
ylim([-0.2 0.6])
grid on
grid minor


%%
%other plots from the paper
figure
subplot(3,3,1)
plot(omega,S.WAS)
title('w_A^s')
ylim([0 10])
grid on
grid minor

subplot(3,3,2)
plot(omega,S.WBS)
title('w_B^s')
ylim([0 1])
grid on
grid minor

subplot(3,3,3)
plot(omega,S.fac_sharpe.*S.sigma)
title('sharpe ratio')
ylim([0 0.3])
grid on
grid minor

subplot(3,3,4)
plot(omega,S.mu-S.r)
title('\mu-r')
ylim([0 0.006])
grid on
grid minor

subplot(3,3,5)
plot(omega,1./S.F)
title('P/Y')
ylim([110 170])
grid on
grid minor

subplot(3,3,6)
plot(omega,S.r)
title('r')
ylim([0.01 0.03])
grid on
grid minor

subplot(3,3,7)
plot(omega,S.JA)
title('J^A')
grid on
grid minor

subplot(3,3,8)
plot(omega,S.JB)
title('J^B')
grid off
grid on
grid minor

subplot(3,3,9)
plot(omega,S.sigma)
title('sigma')
ylim([0.02 0.028])
grid off
grid on
grid minor

toc
