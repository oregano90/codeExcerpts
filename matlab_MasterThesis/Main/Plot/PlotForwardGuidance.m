%% load data
clear
currentfolder=pwd
parentfolder=fileparts(currentfolder)
dataname='ForwardGuidance'
load(strcat(parentfolder,'\Baseline Model\data\saveprecise\',dataname,'.mat'));

Ziffer='FG';

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

%% start to produce different plots
%% one plot in one figure
left        = 100;
bottom      = 100;
height      = 300;
width       = 600;
position    = [ left bottom width height];
set(0, 'DefaultFigurePosition', position);
set(0, 'DefaultFigurePaperPosition', position);


%% two plots in one figure
left        = 100;
bottom      = 100;
height      = 300;
width       = 750;
position    = [ left bottom width height];
set(0, 'DefaultFigurePosition', position);
set(0, 'DefaultFigurePaperPosition', position);


%% forward guidance plots also shown in the paper
figure
subplot(1,2,1)
h=plot(omega,(permute(S.n,[1 3 2]))')
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
title('Nominal rate policies')
xlabel('$\omega$')
ylim([-0.02 0.08])
grid on
grid minor

subplot(1,2,2)
h=plot(omega,(S.F(1,:,:)./S.F(2,:,:))')
set(h(1), 'LineStyle', '-');
title('Ratio of prices $P_{fg}/P_0$')
xlabel('$\omega$')
grid on
grid minor
tightfig;

print([Ziffer 'main'],'-dpdf')

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
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
title({'Banks risky asset','portfolio share $w_A^s$'})
%ylim([0 10])
xlabel('$\omega$')
grid on
grid minor

subplot(3,3,2)
h=plot(omega,S.WBS)
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
title({'Depositors risky asset','portfolio share $w_B^s$'})
%ylim([0 1])
xlabel('$\omega$')
grid on
grid minor

subplot(3,3,3)
h=plot(omega,S.fac_sharpe.*S.sigma)
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
title('Sharpe ratio $(\mu-r)/\sigma$')
%ylim([0 0.3])
xlabel('$\omega$')
grid on
grid minor

subplot(3,3,4)
h=plot(omega,S.mu-S.r)
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
title('Risk premium $\mu-r$')
ylim([0 0.006])
xlabel('$\omega$')
grid on
grid minor

subplot(3,3,5)
h=plot(omega,1./S.F)
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
title('Valuation ratio $P/Y$')
ylim([115 165])
xlabel('$\omega$')
grid on
grid minor

subplot(3,3,6)
h=plot(omega,S.r)
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
title('Real rate $r$')
%ylim([0.01 0.03])
xlabel('$\omega$')
grid on
grid minor

subplot(3,3,7)
h=plot(omega,S.sigma)
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
title('Return volatility $\sigma$')
%ylim([0.02 0.028])
xlabel('$\omega$')
grid off
grid on
grid minor

subplot(3,3,8:9)
h=plot(omnew,S.PDFomega)
set(h(1), 'LineStyle', '-');
set(h(2), 'LineStyle', '--');
title('Stationary density of $\omega$')
ylim([0 32])
xlabel('$\omega$')
grid on
grid minor

tightfig;

print([Ziffer 'multiple'],'-dpdf')

