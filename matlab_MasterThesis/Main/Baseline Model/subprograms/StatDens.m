function [y]=StatDens(n) %finds the stationary density of the state variable using the kolomogorov forward equation
%n is the number of points of the approximation grid

global kappa ol_om omega sigma_om mu_om omnew                     
options = optimoptions('fsolve','MaxFunEvals',10000000,'MaxIter',10000000,'Display','iter','FindiffType','central'); %options for fsolve

%% first, compute the necessary functions
mu                               =diag(omega.*(1-omega))*mu_om+kappa*(ol_om-omega');
sigma                            =diag(omega.*(1-omega))*sigma_om;
sigma                            =sigma.^2;                  %use the squared term in order to avoid the second derivative in the KFE

%% define the functions on a "finer" grid by interpolating it with cubic splines
%create cubic spline objects in order to find the function values very fast
smoothparam     =0.99999;                          %indicates how much approximation there is. 1 stands for exact cubic splines. <1 stands for assuming that the original data is noisy.

pp_mu           =csaps(omega,mu,smoothparam);      %cubic spline interpolation object
pp_muder        =fnder(pp_mu,1);                   %first derivative
pp_sigma        =csaps(omega,sigma,smoothparam);   %cubic spline interpolation object
pp_sigmader     =fnder(pp_sigma,1);                %first derivative
pp_sigmaderder  =fnder(pp_sigma,2);                %second derivative

A0              =zeros(n,1);                       %initial guess
omnew           =linspace(0,1,n);                  %define finer approximation grid (as distribution function will change more rapidly)
steps2          =2/(n-1);

mu              =ppval(pp_mu,omnew)';              %obtain the function values of the spline objects
muder           =ppval(pp_muder,omnew)';
sigma           =ppval(pp_sigma,omnew)';
sigmader        =ppval(pp_sigmader,omnew)';
sigmaderder     =ppval(pp_sigmaderder,omnew)';

%% solve for the values of the distribution function
A               =fsolve(@(A)fw_kolmo(A,mu,sigma,sigmader,omnew,steps2),A0,options);
y               =A;
end


function Y=fw_kolmo(A,mu,sigma,sigmader,omnew,steps2) %computes the value of the forward kolmogorov equation using central difference approximation for the derivatives
PDF             =A;
PDFder          =FirstDer(PDF',omnew,steps2,0,0)';

pp              =csaps(omnew,PDF,1);                                %cubic spline interpolation in order to integrate
Densitycond     =(diff(fnval(fnint(pp),[0 1]))-1)*1;                %integral over the domain
KFE             =(PDF).*(-mu+0.5*sigmader)+(PDFder).*(0.5*sigma);   %by integrating the KFE, it can be shown that a stationary distribution implies that this expression is zero 
Y               =[KFE;Densitycond];                                 %add the boundary condition
end