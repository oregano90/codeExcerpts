%% load data
clear
currentfolder=pwd
parentfolder=fileparts(currentfolder)
dataname='mutliplechanges'
load(strcat(parentfolder,'\Baseline Model\data\saveprecise\',dataname,'.mat'));

%% plot characteristics
lw = 1.5;                                   % LineWidth

set(0,'defaultLineLineWidth',lw);           % set the default line width to lw
co = [0.8500    0.3250    0.0980;0 0 0];    %red and black

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

%%
% %monetary policy
% figure
% subplot(2,2,1)
% plot(omega,S.Pi((down:up),:))
% title('\Pi')
% grid on
% grid minor
% 
% helpomega=permute(S.omega,[1 3 2])
% subplot(2,2,2)
% plot(omega,S.Pi((down:up),:)./helpomega((down:up),:).*S.WAS((down:up),:))
% title('\Pi/(\omega w_s^A)')
% ylim([0 0.4])
% grid on
% grid minor
% 
% subplot(2,2,3)
% plot(omega,S.mum((down:up),:))
% title('\mu_{M}')
% ylim([-0.05 0.2])
% grid on
% grid minor
% 
% subplot(2,2,4)
% plot(omega,S.sigmam((down:up),:))
% title('\sigma_{M}')
% ylim([-0.2 0.6])
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
h=plot(omega,S.WAS)
title({'Banks risky asset','portfolio share $w_A^s$'})
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
ylim([0 2])
xlabel('$\omega$')
grid on
grid minor

subplot(3,3,2)
h=plot(omega,S.WBS)
title({'Depositors risky asset','portfolio share $w_B^s$'})
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
ylim([0 1])
xlabel('$\omega$')
grid on
grid minor

subplot(3,3,3)
h=plot(omega,S.fac_sharpe.*S.sigma)
title('Sharpe ratio $(\mu-r)/\sigma$')
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
%ylim([0 0.3])
xlabel('$\omega$')
grid on
grid minor

subplot(3,3,4)
h=plot(omega,S.mu-S.r)
title('Risk premium $\mu-r$')
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
ylim([0 0.0025])
xlabel('$\omega$')
grid on
grid minor

subplot(3,3,5)
h=plot(omega,1./S.F)
title('Valuation ratio $P/Y$')
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
%ylim([115 165])
xlabel('$\omega$')
grid on
grid minor

subplot(3,3,6)
h=plot(omega,S.r)
title('Real rate $r$')
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
%ylim([0.01 0.03])
xlabel('$\omega$')
grid on
grid minor

subplot(3,3,7)
h=plot(omega,S.sigma)
title('Return volatility $\sigma$')
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
%ylim([0.02 0.028])
xlabel('$\omega$')
grid off
grid on
grid minor

subplot(3,3,8:9)
h=plot(omnew,S.PDFomega)
title('Stationary density of $\omega$')
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
%ylim([0 70])
xlabel('$\omega$')
grid on
grid minor

tightfig;

print('multiplechanges','-dpdf')

%print(['RGB_' num2str(j)],'-dpdf')











%% create the benchmark matrix
omegatemp=permute(S.omega,[1 3 2]);
omega=omegatemp(1,:);

vol = 0.15      % assumed stock market volatility

%% truncate variables
% the first index in the structure field must correspond to the benchmark
% economy

% number is the number of checked parameterizations plus 1 for the
% benchmark
J     =1;
number=J*2;


l = 0.15; % lower truncation value of omega
h = 0.5;  % higher truncation value of omega

lowi  =find(l ==sort([omega l]));   % index to which's left the lower truncation area starts
highi =find(h ==sort([omega h]))-1; % index from which the higher truncation area starts


muMr        =[];
fac_sharpe  =[];
F           =[];
r           =[];
sigma       =[];

for i=1:number                               
    muMr(i,:)       =[S.muMr(i,(lowi:highi),1)];
    fac_sharpe(i,:) =[S.fac_sharpe(i,(lowi:highi),1)];
    F(i,:)          =[S.F(i,(lowi:highi),1)];
    r(i,:)          =[S.r(i,(lowi:highi),1)];
    sigma(i,:)      =[S.sigma(i,(lowi:highi),1)];
end
%% set cubic spline objects for finding values at the mean
for i=1:number                       % compute values for the different parameterizations and the benchmark
  pp_facsharpe            =csaps(omega,S.fac_sharpe(i,:,1).*S.sigma(i,:,1),1);      % aufpassen fac_sharpe ist nicht die sharpe ratio
  pp_valuationratio       =csaps(omega,1./S.F(i,:,1),1);            %cubic spline interpolation object
  pp_riskpremium          =csaps(omega,S.muMr(i,:,1),1);            %cubic spline interpolation object
  riskpremium(i)          =ppval(pp_riskpremium,S.muomstar(i));
  equitypremium(i)        =round(ppval(pp_facsharpe,S.muomstar(i))*vol*1000)/10;
  valuationratio(i)       =ppval(pp_valuationratio,S.muomstar(i));
end

% strings for variables in the table
% qualitative vars
rpstr='L';        % risk premium string
srstr='L';        % sharpe ratio string
vrstr1='L';
vrstr2='H';        % valuation ratio string depends on EIS
rrstr='H';        % real rate string
rvstr='H';        % return volatility string
% quantitative vars
ephstr='4 - 7';        % equity premium string
eplstr='4 - 7';        % equity premium string
rdrpstr='$-$';      % relative difference risk premium string
rdvrstr='$+$';      % relative difference valuation ratio string
moshstr='';          % mean of stationary omega distribution
moslstr='';          % mean of stationary omega distribution
soshstr='';          % vola of stationary omega distribution
soslstr='';          % vola of stationary omega distribution

% notation strings
csstr='c';     



for j=1:J
up      =j*2;
down    =j*2-1;

%% qualitative assessment
% compare solution vectors to benchmark economy
riskpremiumQ(up)      =any(muMr(down,:)>muMr(up,:));
sharperatioQ(up)      =any(fac_sharpe(down,:)>fac_sharpe(up,:));
valuationratioQ1(up)   =any(F(down,:)<F(up,:));
valuationratioQ2(up)   =any(F(down,:)>F(up,:));
realrateQ(up)         =any(r(down,:)<r(up,:));
returnvolaQ(up)       =any(sigma(down,:)<sigma(up,:));

%% quantitative assessment
%% find values at the mean
% compute values for the different parameterizations

rdRiskPremium(down)           =-999;
rdValuationRatio(down)        =-999;
rdRiskPremium(up)           =round((riskpremium(down)-riskpremium(up))/riskpremium(down)*1000)/10;
rdValuationRatio(up)        =round((valuationratio(down)-valuationratio(up))/valuationratio(down)*1000)/10;                 %cubic spline interpolation object

%% create latex table as a string

    

% fill strings for different vectors

csstr   =[csstr 'c'];
rpstr   =[rpstr ' & ' num2str(riskpremiumQ(up))];         % risk premium string
srstr   =[srstr ' & ' num2str(sharperatioQ(up))];         % sharpe ratio string
vrstr1   =[vrstr1 ' & ' num2str(valuationratioQ1(up))];      % valuation ratio string depends on EIS
vrstr2   =[vrstr2 ' & ' num2str(valuationratioQ2(up))];      % valuation ratio string depends on EIS
rrstr   =[rrstr ' & ' num2str(realrateQ(up))];            % real rate string
rvstr   =[rvstr ' & ' num2str(returnvolaQ(up))];           % return volatility string
ephstr   =[ephstr ' & ' num2str(equitypremium(up))];        % equity premium string
eplstr   =[eplstr ' & ' num2str(equitypremium(down))];        % equity premium string
rdrpstr =[rdrpstr ' & ' num2str(rdRiskPremium(up))];      % relative difference risk premium string
rdvrstr =[rdvrstr ' & ' num2str(rdValuationRatio(up))];   % relative difference valuation ratio string
moshstr  =[moshstr ' & ' num2str(round(S.muomstar(up)*100)/100)];             % mean of stationary omega distribution
moslstr  =[moslstr ' & ' num2str(round(S.muomstar(down)*100)/100)];             % mean of stationary omega distribution
soshstr  =[soshstr ' & ' num2str(round(S.sigmaomstar(up)*1000)/1000)];          % vola of stationary omega distribution
soslstr  =[soslstr ' & ' num2str(round(S.sigmaomstar(down)*1000)/1000)];          % vola of stationary omega distribution
end

table=['\begin{table}[!h] ' char(13) ... % char(13) is linebreak
'\small' char(13)...
'\begin{center}' char(13)...
'\begin{tabular}{l' csstr '}' char(13)...
'\hline \hline' char(13)...
'\multicolumn{' num2str(j+2) '}{c}{\textbf{Qualitative Assessment, $\mathbf{n_h=5\%}$}}\\' char(13)...
'\\[-2ex]   Variable    			& Benchmark &\multicolumn{' num2str(j-1) '}{c}{Different EIS}\\' char(13)...
'\\[-2ex]' char(13)...
'    			& & 0.3 \\' char(13)...
'\hline' char(13)...
'Risk premium 			    		&' rpstr '\\' char(13)...
'Sharpe ratio						&' srstr '\\' char(13)...
'Valuation ratio, EIS$<1$           &' vrstr1 '\\' char(13)...
'Valuation ratio, EIS$>1$           &' vrstr2 '\\' char(13)...
'Real rate							&' rrstr '\\' char(13)...
'Return volatility 					&' rvstr '\\' char(13)...
'\hline' char(13)...
'\multicolumn{' num2str(j+2) '}{c}{\textbf{Quantitative Assessment}}\\' char(13)...
'\hline' char(13)...
'$\%$ eq premium, $n_h=5\%$					    &' ephstr '\\' char(13)...
'$\%$ eq premium, $n_h=0\%$					    &' eplstr '\\' char(13)...
'$\Delta\%$ risk premium                        &' rdrpstr '\\' char(13)...
'$\Delta\%$ valuation ratio                     &' rdvrstr '\\' char(13)...
'$\mu_{\omega , h}^*$                                        &' moshstr '\\' char(13)...
'$\mu_{\omega , l}^*$                                       &' moslstr '\\' char(13)...
'$\sigma_{\omega , h}^*$                                        &' soshstr '\\' char(13)...	
'$\sigma_{\omega , l}^*$                                       &' soslstr '\\' char(13)...	
'\hline' char(13)...
'\end{tabular}' char(13)...
'\end{center}' char(13)...
'\caption[]{\textbf{Benchmark Comparison for different $\mathbf{\gb}$''' 's with $\mathbf{n_h=5\%}$ and $\mathbf{n_l=0\%}$. }TEXT} \label{ta:benchmark_psi}' char(13)...
'\end{table}' char(13)...
'\normalsize'];
