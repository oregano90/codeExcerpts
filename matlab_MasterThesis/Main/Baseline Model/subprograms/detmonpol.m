function [mum,sigmam]=detmonpol(alpha)
global kappa ol_om omega sigma_om mu_om F n r Pi
smoothparam     =0.99999;                          %indicates how much approximation there is. 1 stands for exact cubic splines. <1 stands for assuming that the original data is noisy.

mu              =diag(omega.*(1-omega))*mu_om+kappa*(ol_om-omega');
sigma           =diag(omega.*(1-omega))*sigma_om;


%% approximation of pi's first and second derivative using cubic splines
pp_pi           =csaps(omega,Pi,smoothparam);      %cubic spline interpolation object
pp_pider        =fnder(pp_pi,1); 
pp_piderder     =fnder(pp_pi,2); 
pi              =ppval(pp_pi,omega)';              %obtain the function values of the spline objects
pider           =ppval(pp_pider,omega)';
piderder        =ppval(pp_piderder,omega)';

%% drift and vola of Pi
mupi            =1./Pi.*(pider.*mu+0.5*piderder.*sigma.^2);
sigmapi         =1./Pi.*pider.*sigma;

%% drift and vola of monetary policy
mum     =n'-r+mu-F+1/alpha*(mupi+sigma.*sigmapi);
sigmam  =sigma+1/alpha*sigmapi;
end