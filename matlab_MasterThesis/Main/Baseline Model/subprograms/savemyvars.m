function savemyvars(i,parentfolder,dataname) %saves the variables of the solved model
%exogenous model parameters
global kappa gamma psi rho ol_om lambda eta phi theta mu_y sigma_y m
global n lambda_h m_h

%endogenous variables
global WAS WBS fac_sig sigma sigma_om fac_sharpe muMr mu_om Pi mu r
global JA JB JderA JderB JderderA JderderB JdiffA JdiffB JdiffdiffA JdiffdiffB
global F Fder Fderder Fdiff Fdiffdiff PDFomega omnew

%approximation parameters
global omega A B T Tder Tderder cprime_coeffmat Nnodes Npol BCfac ODEfac BCpow ODEpow

%dynamic monetary policy parameters
global mum sigmam fwguid_thresh

if exist(strcat(parentfolder,'\data\',dataname,'.mat'))
    load(strcat(parentfolder,'\data\',dataname,'.mat'))
end

%% save the pdf of the stationary density as a matlab probability density object:

PDFomega(PDFomega<0)       =0;                         % exclude negative values
PDFomegatemp               = round(PDFomega*100000);   % create a frequency that is of integer value
S.pd(i,:,:)                = fitdist(omnew','Kernel','width',0.0012,'Frequency',PDFomegatemp);      %approximate the function using a kernel density distribution with a bandwidth of 0.0012
S.muomstar(i,:,:)          = mean(S.pd(i,:,:));        % mean of stationary density of omega
S.sigmaomstar(i,:,:)       = sqrt(var(S.pd(i,:,:)));   % vola of stationary density of omega
%% if we wanted to plot the stationary density approximation
% y=pdf(S.pd,omnew);
% figure
% plot(omnew,y,omnew,PDFomega)

%% other variables

S.kappa(i,:,:)             =kappa;
S.gamma(i,:,:)             =gamma;
S.psi(i,:,:)               =psi;
S.rho(i,:,:)               =rho;
S.ol_om(i,:,:)             =ol_om;
S.lambda(i,:,:)            =lambda;
S.eta(i,:,:)               =eta;
S.phi(i,:,:)               =phi;
S.theta(i,:,:)             =theta;
S.mu_y(i,:,:)              =mu_y;
S.sigma_y(i,:,:)           =sigma_y;
S.m(i,:,:)                 =m;
S.n(i,:,:)                 =n;
S.lambda_h(i,:,:)          =lambda_h;
S.m_h(i,:,:)               =m_h;

S.WAS(i,:,:)               =WAS;
S.WBS(i,:,:)               =WBS;
S.fac_sig(i,:,:)           =fac_sig;
S.sigma(i,:,:)             =sigma;
S.sigma_om(i,:,:)          =sigma_om;
S.fac_sharpe(i,:,:)        =fac_sharpe;
S.muMr(i,:,:)              =muMr;
S.mu_om(i,:,:)             =mu_om;
S.Pi(i,:,:)                =Pi;
S.mu(i,:,:)                =mu;
S.r(i,:,:)                 =r;
S.JA(i,:,:)                =JA;
S.JB(i,:,:)                =JB;
S.JderA(i,:,:)             =JderA;
S.JderB(i,:,:)             =JderB;
S.JderderA(i,:,:)          =JderderA;
S.JderderB(i,:,:)          =JderderB;
S.JdiffA(i,:,:)            =JdiffA;
S.JdiffB(i,:,:)            =JdiffB;
S.JdiffdiffA(i,:,:)        =JdiffdiffA;
S.JdiffdiffB(i,:,:)        =JdiffdiffB;
S.F(i,:,:)                 =F;
S.Fder(i,:,:)              =Fder;
S.Fderder(i,:,:)           =Fderder;
S.Fdiff(i,:,:)             =Fdiff;
S.Fdiffdiff(i,:,:)         =Fdiffdiff;
S.PDFomega(i,:,:)          =PDFomega;
S.omnew(i,:,:)             =omnew;

S.omega(i,:,:)             =omega;
S.A(i,:,:)                 =A;
S.B(i,:,:)                 =B;
S.T(i,:,:)                 =T;
S.Tder(i,:,:)              =Tder;
S.Tderder(i,:,:)           =Tderder;
S.cprime_coeffmat(i,:,:)   =cprime_coeffmat;
S.Nnodes(i,:,:)            =Nnodes;
S.Npol(i,:,:)              =Npol;
S.BCfac(i,:,:)             =BCfac;
S.ODEfac(i,:,:)            =ODEfac;
S.BCpow(i,:,:)             =BCpow;
S.ODEpow(i,:,:)            =ODEpow;

S.mum(i,:,:)               =mum;
S.sigmam(i,:,:)            =sigmam;
S.fwguid_threshmat(i,:,:)  =fwguid_thresh;

S.i                        =i;

save(strcat(parentfolder,'\data\',dataname,'.mat'),'S')
end
