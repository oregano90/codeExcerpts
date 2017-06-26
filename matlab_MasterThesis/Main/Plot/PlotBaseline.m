%% load data
clear
currentfolder=pwd
parentfolder=fileparts(currentfolder)
dataname='baseline'
load(strcat(parentfolder,'\Baseline Model\data\saveprecise\',dataname,'.mat'));

%% plot characteristics
lw = 1.5;      % LineWidth

set(0,'defaultLineLineWidth',lw);   % set the default line width to lw

co = [0.8500    0.3250    0.0980;0 0 0]; %red and black
set(0,'defaultAxesColorOrder',co,'DefaultAxesLineStyleOrder','-|--|:|-.');

set(0,'defaulttextinterpreter','latex') %set latex interpreter as default

%% define variables for plotting
omnewtemp=permute(S.omnew,[1 3 2]);
omnew=omnewtemp(1,:);

omegatemp=permute(S.omega,[1 3 2]);
omega=omegatemp(1,:);

%% overhaul numerical inaccuracies
S.PDFomega(:,(1:19))=0;

%% start to produce different plots
%% one plot in one figure
left        = 100;
bottom      = 100;
height      = 300;
width       = 600;
position    = [ left bottom width height];
set(0, 'DefaultFigurePosition', position);
set(0, 'DefaultFigurePaperPosition', position);

%% pdf of omega
figure

[h] = plot(omnew,S.PDFomega);
title({'Stationary density of $\omega$'})
ylim([0 75])
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
xlabel('$\omega$')
grid on
grid minor
tightfig;

print('Bstatomega','-dpdf')

%% effectiveriskaversion
figure 

h=plot(omega,S.fac_sharpe)
title({'Effective risk aversion $(\mu-r)/\sigma^2$'})
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
xlabel('$\omega$')
grid on
grid minor
tightfig;

print('Beffectiveriskaversion','-dpdf')


%% inflation
figure

h=plot(omega,S.n(1,1)-S.r(1,:),omega,S.n(2,1)-S.r(2,:))
title('Inflation')
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
xlabel('$\omega$')
grid on
grid minor
tightfig;

print('Binflation','-dpdf')



%% two plots in one figure
left        = 100;
bottom      = 100;
height      = 300;
width       = 750;
position    = [ left bottom width height];
set(0, 'DefaultFigurePosition', position);
set(0, 'DefaultFigurePaperPosition', position);

%% Js
figure
subplot(1,2,1)
h=plot(omega,S.JA)
title('$J^A$')
ylim([0 0.015])
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
xlabel('$\omega$')
grid on
grid minor

subplot(1,2,2)
h=plot(omega,S.JB)
title('$J^B$')
ylim([0 0.015])
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
xlabel('$\omega$')
grid on
grid minor
tightfig;

print('Bjs','-dpdf')


%% riskyassetshares
figure

subplot(1,2,1)
h=plot(omega,S.WAS)
title('Banks risky asset portfolio share $w_A^s$')
ylim([0 10])
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
xlabel('$\omega$')
grid on
grid minor

subplot(1,2,2)
h=plot(omega,S.WBS)
title('Depositors risky asset portfolio share $w_B^s$')
ylim([0 1])
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
xlabel('$\omega$')
grid on
grid minor
tightfig;

print('Briskyassetshares','-dpdf')


%% sharperisk
figure

subplot(1,2,1)
h=plot(omega,S.fac_sharpe.*S.sigma)
title('Sharpe ratio $(\mu-r)/\sigma$')
ylim([0 0.3])
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
xlabel('$\omega$')
grid on
grid minor

subplot(1,2,2)
h=plot(omega,S.mu-S.r)
title('Risk premium $\mu-r$')
ylim([0 0.006])
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
xlabel('$\omega$')
grid on
grid minor
tightfig;

print('Bsharperisk','-dpdf')



%% valuereal
figure

subplot(1,2,1)
h=plot(omega,1./S.F)
title('Valuation ratio $P/Y$')
ylim([110 170])
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
xlabel('$\omega$')
grid on
grid minor

subplot(1,2,2)
h=plot(omega,S.r)
title('Real rate $r$')
ylim([0.01 0.03])
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
xlabel('$\omega$')
grid on
grid minor
tightfig;

print('Bvaluereal','-dpdf')


%% returndriftvola
figure 

subplot(1,2,1)
h=plot(omega,S.mu)
title({'Return drift $\mu$'})
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
xlabel('$\omega$')
grid on
grid minor

subplot(1,2,2)
h=plot(omega,S.sigma)
title('Return Volatility $\sigma$')
ylim([0.02 0.028])
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
xlabel('$\omega$')
grid on
grid minor
tightfig;

print('Breturndriftvola','-dpdf')



%% four plots in one figure
left        = 100;
bottom      = 100;
height      = 600;
width       = 750;
position    = [ left bottom width height];
set(0, 'DefaultFigurePosition', position);

%monetary policy
figure
subplot(2,2,1)
h=plot(omega,S.Pi)
title({'Liquidity supply','over aggregate wealth $\Pi$'})
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
xlabel('$\omega$')
grid on
grid minor

subplot(2,2,2)
h=plot(omega,S.Pi./(permute(S.omega,[1 3 2]).*S.WAS))
title({'Liquidity supply','over bank assets $\Pi/(\omega w_s^A)$'})
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
xlabel('$\omega$')
ylim([0 0.4])
grid on
grid minor

subplot(2,2,3)
h=plot(omega,S.mum)
title({'Open market operations','drift $\mu_{M}$'})
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
xlabel('$\omega$')
ylim([-0.05 0.2])
grid on
grid minor

subplot(2,2,4)
h=plot(omega,S.sigmam)
title({'Open market operations','loading $\sigma_{M}$'})
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
xlabel('$\omega$')
ylim([-0.2 0.6])
grid on
grid minor
tightfig;

print('Bmonetarypol','-dpdf')

