%% load data
clear
currentfolder=pwd
parentfolder=fileparts(currentfolder)
dataname='robustinterest'
load(strcat(parentfolder,'\Baseline Model\data\saveprecise\',dataname,'.mat'));

%% plot characteristics
lw = 1.5;      % LineWidth

set(0,'defaultLineLineWidth',lw);   % set the default line width to lw

for i=1:6                           % transition from red to black
    fac=(1-(i-1)/5);
    co(i,:)=[0.8500    0.3250    0.0980]*fac;
end;

set(0,'defaultAxesColorOrder',co,'DefaultAxesLineStyleOrder','-');

set(0,'defaulttextinterpreter','latex') %set latex interpreter as default

%% define variables for plotting
omnewtemp=permute(S.omnew,[1 3 2]);
omnew=omnewtemp(1,:);

omegatemp=permute(S.omega,[1 3 2]);
omega=omegatemp(1,:);

% %% four plots in one figure
% left        = 100;
% bottom      = 100;
% height      = 600;
% width       = 750;
% position    = [ left bottom width height];
% set(0, 'DefaultFigurePosition', position);
% 
% %monetary policy
% figure
% subplot(2,2,1)
% plot(omega,S.Pi)
% title({'Liquidity supply','over aggregate wealth $\Pi$'})
% xlabel('$\omega$')
% grid on
% grid minor
% 
% subplot(2,2,2)
% plot(omega,S.Pi./(permute(S.omega,[1 3 2]).*S.WAS))
% title({'Liquidity supply','over bank assets $\Pi/(\omega w_s^A)$'})
% ylim([0 0.4])
% xlabel('$\omega$')
% grid on
% grid minor
% 
% subplot(2,2,3)
% plot(omega,S.mum)
% title({'Open market operations','drift $\mu_{M}$'})
% ylim([-0.05 0.2])
% xlabel('$\omega$')
% grid on
% grid minor
% 
% subplot(2,2,4)
% plot(omega,S.sigmam)
% title({'Open market operations','loading $\sigma_{M}$'})
% ylim([-0.2 0.6])
% xlabel('$\omega$')
% grid on
% grid minor


%% nine plots in one figure
left        = 100;
bottom      = 100;
height      = 750;
width       = 750;
position    = [ left bottom width height];
set(0, 'DefaultFigurePosition', position);


figure
subplot(3,3,1)
plot(omega,S.WAS)
title({'Banks risky asset','portfolio share $w_A^s$'})
%ylim([0 10])
xlabel('$\omega$')
grid on
grid minor

subplot(3,3,2)
plot(omega,S.WBS)
title({'Depositors risky asset','portfolio share $w_B^s$'})
%ylim([0 1])
xlabel('$\omega$')
grid on
grid minor

subplot(3,3,3)
plot(omega,S.fac_sharpe.*S.sigma)
title('Sharpe ratio $(\mu-r)/\sigma$')
%ylim([0 0.3])
xlabel('$\omega$')
grid on
grid minor

subplot(3,3,4)
plot(omega,S.mu-S.r)
title('Risk premium $\mu-r$')
ylim([0 0.006])
xlabel('$\omega$')
grid on
grid minor

subplot(3,3,5)
plot(omega,1./S.F)
title('Valuation ratio $P/Y$')
ylim([115 165])
xlabel('$\omega$')
grid on
grid minor

subplot(3,3,6)
plot(omega,S.r)
title('Real rate $r$')
%ylim([0.01 0.03])
xlabel('$\omega$')
grid on
grid minor

subplot(3,3,7)
plot(omega,S.sigma)
title('Return volatility $\sigma$')
%ylim([0.02 0.028])
xlabel('$\omega$')
grid off
grid on
grid minor

subplot(3,3,8:9)
plot(omnew,S.PDFomega)
title('Stationary density of $\omega$')
ylim([0 70])
xlabel('$\omega$')
grid on
grid minor

tightfig;

print('RNmultiple','-dpdf')

%% create the benchmark matrix
omegatemp=permute(S.omega,[1 3 2]);
omega=omegatemp(1,:);

vol = 0.15      % assumed stock market volatility

%% truncate variables
% the first index in the structure field must correspond to the benchmark
% economy

% number is the number of checked parameterizations plus 1 for the
% benchmark
number=6;
 
l = 0.15; % lower truncation value of omega
h = 0.5;  % higher truncation value of omega

lowi  =find(l ==sort([omega l]));   % index to which's left the lower truncation area starts
highi =find(h ==sort([omega h]))-1; % index from which the higher truncation area starts

muMr        =[];
fac_sharpe  =[];
F           =[];
r           =[];
sigma       =[];

for i=1:number                               % empty all arrays
    muMr(i,:)       =[ [] S.muMr(i,(lowi:highi),1) [] ];
    fac_sharpe(i,:) =[ [] S.fac_sharpe(i,(lowi:highi),1) []];
    F(i,:)          =[ [] S.F(i,(lowi:highi),1) []];
    r(i,:)          =[ [] S.r(i,(lowi:highi),1) []];
    sigma(i,:)      =[ [] S.sigma(i,(lowi:highi),1) []];
end


%% qualitative assessment


for i=2:number                   % compare solution vectors to benchmark economy
    riskpremiumQ(i)      =any(muMr(1,:)>muMr(i,:));
    sharperatioQ(i)      =any(fac_sharpe(1,:)>fac_sharpe(i,:));
    valuationratioQ(i)   =any(F(1,:)>F(i,:));
    realrateQ(i)         =any(r(1,:)<r(i,:));
    returnvolaQ(i)       =any(sigma(1,:)<sigma(i,:));
end

%% quantitative assessment

%% set cubic spline objects for finding values at the mean
for i=1:number                       % compute values for the different parameterizations and the benchmark
  pp_facsharpe            =csaps(omega,S.fac_sharpe(i,:,1).*S.sigma(i,:,1),1);      % aufpassen fac_sharpe ist nicht die sharpe ratio
  pp_valuationratio       =csaps(omega,1./S.F(i,:,1),1);            %cubic spline interpolation object
  pp_riskpremium          =csaps(omega,S.muMr(i,:,1),1);            %cubic spline interpolation object
  riskpremium(i)          =ppval(pp_riskpremium,S.muomstar(i));
  equitypremium(i)        =round(ppval(pp_facsharpe,S.muomstar(i))*vol*1000)/10;
  valuationratio(i)       =ppval(pp_valuationratio,S.muomstar(i));
end

%% find values at the mean
for i=2:number                       % compute values for the different parameterizations
  rdRiskPremium(i)           =round((riskpremium(1)-riskpremium(i))/riskpremium(1)*1000)/10;
  rdValuationRatio(i)        =round((valuationratio(1)-valuationratio(i))/valuationratio(1)*1000)/10;                 %cubic spline interpolation object
end

%% create latex table as a string

% strings for variables in the table
% qualitative vars
rpstr='L';        % risk premium string
srstr='L';        % sharpe ratio string
vrstr='H';        % valuation ratio string depends on EIS
rrstr='H';        % real rate string
rvstr='H';        % return volatility string
% quantitative vars
epstr='4 - 7';        % equity premium string
rdrpstr='';      % relative difference risk premium string
rdvrstr='';      % relative difference valuation ratio string
mosstr='';          % mean of stationary omega distribution
sosstr='';          % vola of stationary omega distribution

% notation strings
csstr='c';         

% fill strings for different vectors
for i=1:number
csstr   =[csstr 'c'];
rpstr   =[rpstr ' & ' num2str(riskpremiumQ(i))];         % risk premium string
srstr   =[srstr ' & ' num2str(sharperatioQ(i))];         % sharpe ratio string
vrstr   =[vrstr ' & ' num2str(valuationratioQ(i))];      % valuation ratio string depends on EIS
rrstr   =[rrstr ' & ' num2str(realrateQ(i))];            % real rate string
rvstr   =[rvstr ' & ' num2str(returnvolaQ(i))];           % return volatility string
epstr   =[epstr ' & ' num2str(equitypremium(i))];        % equity premium string
rdrpstr =[rdrpstr ' & ' num2str(rdRiskPremium(i))];      % relative difference risk premium string
rdvrstr =[rdvrstr ' & ' num2str(rdValuationRatio(i))];   % relative difference valuation ratio string
mosstr  =[mosstr ' & ' num2str(round(S.muomstar(i)*100)/100)];             % mean of stationary omega distribution
sosstr  =[sosstr ' & ' num2str(round(S.sigmaomstar(i)*1000)/1000)];          % vola of stationary omega distribution
end

table=['\begin{table}[!h] ' char(13) ... % char(13) is linebreak
'\small' char(13)...
'\begin{center}' char(13)...
'\begin{tabular}{l' csstr '}' char(13)...
'\hline \hline' char(13)...
'\multicolumn{' num2str(number+2) '}{c}{\textbf{Qualitative Assessment}}\\' char(13)...
'\\[-2ex]   Variable    			& Benchmark &\multicolumn{' num2str(number-1) '}{c}{Different nominal rates}\\' char(13)...
'\\[-2ex]' char(13)...
'    			& & 0 & 1 & 2 & 3 & 4 & 5\\' char(13)...
'\hline' char(13)...
'Risk premium 			    		&' rpstr '\\' char(13)...
'Sharpe ratio						&' srstr '\\' char(13)...
'Valuation ratio	for EIS$>1$		&' vrstr '\\' char(13)...
'Real rate							&' rrstr '\\' char(13)...
'Return volatility 					&' rvstr '\\' char(13)...
'\hline' char(13)...
'\multicolumn{' num2str(number+2) '}{c}{\textbf{Quantitative Assessment}}\\' char(13)...
'\hline' char(13)...
'Equity premium in $\%$						    &' epstr '\\' char(13)...
'$\Delta\%$ risk premium                        &' rdrpstr '\\' char(13)...
'$\Delta\%$ valuation ratio                     &' rdvrstr '\\' char(13)...
'$\mo^*$                                        &' mosstr '\\' char(13)...
'$\so^*$                                        &' sosstr '\\' char(13)...	
'\hline' char(13)...
'\end{tabular}' char(13)...
'\end{center}' char(13)...
'\caption[]{\textbf{Benchmark Comparison for different nominal Rates. }TEXT} \label{ta:benchmarnominalrates}' char(13)...
'\end{table}' char(13)...
'\normalsize'];