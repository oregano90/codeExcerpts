%% load data
clear
currentfolder=pwd
parentfolder=fileparts(currentfolder)
dataname='GreenspanPut'
load(strcat(parentfolder,'\Baseline Model\data\saveprecise\',dataname,'.mat'));

Ziffer='GP';

%% plot characteristics
lw = 1.5;      % LineWidth

set(0,'defaultLineLineWidth',lw);   % set the default line width to lw

co = [0 0 0;0.8500    0.3250    0.0980]; %red and black
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

valuationratio1       =1./S.F(1,:,1);   
valuationratio2       =1./S.F(2,:,1);

diffvalue       = valuationratio1-valuationratio2;
pp_diffvalue    =csaps(omega,diffvalue,0.99999);
der_diffvalue   =fnder(pp_diffvalue);
zeros=fnzeros(der_diffvalue)

figure

plot(omega,ppval(der_diffvalue,omega),zeros(1,1),ppval(der_diffvalue,zeros(1,1)),'ko');
title('Comparative price increase $\frac{\partial(F_0^{-1}-F_{gp}^{-1})}{\partial \omega}$')
xlabel('$\omega$')
grid on;
grid minor

tightfig;

print([Ziffer 'supplementaryderivative'],'-dpdf')

%% two plots in one figure
left        = 100;
bottom      = 100;
height      = 300;
width       = 750;
position    = [ left bottom width height];
set(0, 'DefaultFigurePosition', position);
set(0, 'DefaultFigurePaperPosition', position);


%% supplementary plots
figure
subplot(1,2,1)
h=plot(omega,S.mu-S.r)
set(h(2), 'LineStyle', '-');
set(h(1), 'LineStyle', '--');
title('Risk premium $\mu-r$')
ylim([0.004 0.0065])
xlabel('$\omega$')
grid on
grid minor

subplot(1,2,2)
h=plot(omega,S.sigma)
set(h(2), 'LineStyle', '-');
set(h(1), 'LineStyle', '--');
title('Volatility of return sigma')
ylim([0.019 0.025])
xlabel('$\omega$')
grid off
grid on
grid minor

tightfig;


print([Ziffer 'supplementary'],'-dpdf')

%% four plots in one figure
left        = 100;
bottom      = 100;
height      = 600;
width       = 750;
position    = [ left bottom width height];
set(0, 'DefaultFigurePosition', position);

%% greenspan put plots also shown in the paper
figure
subplot(2,2,1)
h=plot(omega,(permute(S.n,[1 3 2])))
set(h(2), 'LineStyle', '-');
set(h(1), 'LineStyle', '--');
title('Nominal rate policies')
ylim([-0.02 0.08])
xlabel('$\omega$')
grid on
grid minor

subplot(2,2,2)
h=plot(omega,1./S.F)
set(h(2), 'LineStyle', '-');
set(h(1), 'LineStyle', '--');
title('Valuation ratio P/Y')
ylim([110 160])
xlabel('$\omega$')
grid on
grid minor

subplot(2,2,3:4)
hold off
h=plot(omnew,S.PDFomega,zeros(1,1),ppval(der_diffvalue,zeros(1,1)),'ko')
set(h(2), 'LineStyle', '-');
set(h(1), 'LineStyle', '--');
title('Stationary density of $\omega$')
ylim([0 22])
xlabel('$\omega$')
grid on
grid minor

tightfig;


print([Ziffer 'main'],'-dpdf')

zeros(1,1)
y2=cdf(S.pd(2,:,:),zeros(1,1))






