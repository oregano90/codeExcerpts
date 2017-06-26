%% install chebfun package
% unzip('https://github.com/chebfun/chebfun/archive/master.zip')
% movefile('chebfun-master', 'chebfun'), addpath(fullfile(cd,'chebfun')), savepath

lw = 1.5;      % LineWidth

% The properties we've been using in the figures
set(0,'defaultLineLineWidth',lw);   % set the default line width to lw



x=linspace(-1,1,200);
T=[]
for k=1:9
    n           =k-1;
    T(k,:)      =cos(n*acos(x));
end
z=zeros(length(x));

figure
hold on
co =          [0    0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840
    0/255    0/255   0/255]
set(groot,'defaultAxesColorOrder',co)
plot(x,T(1,:),x,T(2,:),x,T(3,:),x,T(4,:),x,T(5,:),x,T(6,:),x,T(7,:),x,T(8,:))
legend('T_0(x)','T_1(x)','T_2(x)','T_3(x)','T_4(x)','T_5(x)','T_6(x)','T_7(x)')
tightfig;

print -depsc chebyshevpols.eps
hold off