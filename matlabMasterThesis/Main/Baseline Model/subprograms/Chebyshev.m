function [omega,T,Tder,Tderder,cprime_coeffmat]=Chebyshev(Npol,Nnodes,a,b) 
T=[];
Tder=[];
Tderder=[];
omega=[];
%% Npol stands for the number of the highest order chebyshev polynomial
%  Nnodes stands for the number of nodes
% symbolic and trigonometric definitions also work but are slower than the
% default recurrence relation based definition

%% symbolic solution, just for checking purposes bc too slow
% N=3
% syms Tdersim Tdiffsim Tderdersim OMEGAsim Xsim Tsim
% tic
% %Xsim=2*OMEGAsim-1;        %change of variables, in order to transform it to the interval [0,1]
% Tsim(1)=1;
% Tsim(2)=Xsim;
% for k=1:N            %compute the polynomials T(omega) in front of the a_i's  %CAREFUL, here polynomials start with k=1
%     Xsim=2*OMEGAsim-1;
%     if k>2
%         Tsim(k)=collect(2*Xsim*Tsim(k-1)-Tsim(k-2));%create chebyshev polynomials;
%     end
%     Tdersim(k)=simplify(diff(Tsim(k),OMEGAsim)); %COMPUTE DERIVATIVES DIFFERENTLY!
%     Tderdersim(k)=simplify(diff(Tdersim(k),OMEGAsim));
% end
% 
% omega=[];                       %somehow omega needs to be cleared explicitly
% T=[];
% Tder=[];
% Tderder=[];
% for j=1:N
%     omega(j)=0.5+0.5*cos((2*j-1)/(2*N)* pi );         %create chebyshev nodes (stützstellen)
%     OMEGAsim=omega(j);
%     T(j,:)=vpa(subs(Tsim));
%     Tder(j,:)=vpa(subs(Tdersim));
%     Tderder(j,:)=vpa(subs(Tderdersim));
% end
% toc
% % tic




%% create nodes
%% chebyshev nodes for chebyshev zeros
for j=1:Nnodes
    omega(Nnodes-j+1)=0.5*(a+b)+0.5*(b-a)*cos((2*j-1)/(2*Nnodes)* pi );         %create chebyshev nodes (stützstellen)
end
%% chebyshev nodes for chebyshev extremas
% for j=1:Nnodes
%     omega(Nnodes-j+1)=0.5*(a+b)+0.5*(b-a)*cos((j*pi)/(Nnodes) );         %create chebyshev nodes (stützstellen)
% end
% omega(1)=0.00001;
%% aequidistant nodes 
% epsilon=0.01
% omega=linspace(epsilon,1-epsilon,Nnodes);
%% nodes that take into account that values close to omega=0 are more volatile
% epsilon=0.2;
% for j=1:Nnodes
% omega(j)=1-(sin(j/(Nnodes+epsilon)*pi/2+pi/2));
% end

%% create chebyshev polynomials with recurrence relation very fast routine, but not exact
% tic
% x_adj       =2/(b-a);
% const_adj   =-(b+a)/(b-a);
% Tcheb=zeros(Npol,Npol);
% Tcheb(1,1)=1;
% if Npol>1
%     Tcheb(2,1:2)=[const_adj x_adj];
%     for j=3:Npol
%         Tcheb(j,2:j)=Tcheb(j-1,1:j-1)*2*x_adj;
%         Tcheb(j,1:j-1)=Tcheb(j,1:j-1)+Tcheb(j-1,1:j-1)*2*const_adj;
%         Tcheb(j,1:j-2)=Tcheb(j,1:j-2)-Tcheb(j-2,1:j-2);
%     end
% end
% 
% Tchebder=[];
% if Npol>1
%     for j=2:Npol
%         Tchebder(:,j-1)=Tcheb(:,j)*(j-1);
%     end
%     Tchebder(:,Npol)=0;
% elseif Npol<2
%     Tchebder=zeros(Npol,Npol);
% end
% 
% Tchebderder=[];
% if Npol>2
%     for j=3:Npol
%         Tchebderder(:,j-2)=Tchebder(:,j-1)*(j-2);
%     end
%     Tchebderder(:,Npol)=0;
% elseif Npol<3
%     Tchebderder=zeros(Npol,Npol);
% end
% 
% matomega=[];
% for j=1:Nnodes
% for k=1:Npol
%     matomega(k,j)=omega(j)^(k-1);
% end
% end
% T        =(Tcheb*matomega)';
% Tder     =(Tchebder*matomega)';
% Tderder  =(Tchebderder*matomega)';

%% trigonometric formula to create chebyshev polynomials
for j=1:Nnodes
for k=1:Npol
    n           =k-1;
    x           =(omega(j)*2-1);
    T(j,k)      =cos(n*acos(x));
    Tder(j,k)   =(2*n*sin(n*acos(x)))/(sqrt(1-(x)^2));
    if isnan(Tder(j,k))
        Tder(j,k)=0;
    end
    Tder(:,1)=0;
    Tderder(j,k)=(4*n*(x)*sin(n*acos(x)))/((1-(x)^2)^(3/2))-(4*n^2 *cos(n*acos(x)))/(1-x^2);
    if isnan(Tderder(j,k))
        Tderder(j,k)=0;
    end
    Tderder(:,(1:2))=0;
end
end

%% find the coefficients c' for the derivative
cprime_coeffmat=[];
cprime_coeffmat=zeros(Npol+1,Npol);                     %because of matlab dimensions, index is shifted by+1
for j=1:(Npol-2)                        
   cprime_coeffmat(Npol-j,:)=cprime_coeffmat(Npol-j+2,:);
   cprime_coeffmat(Npol-j,Npol-j+1)=2*2/(b-a)*(Npol-j);
end
cprime_coeffmat(1,:)=cprime_coeffmat(3,:)./2;           %last element needs to be divided by two
cprime_coeffmat(1,2)=2*2/(b-a)*(1)/2;
cprime_coeffmat(Npol+1,:)=[];

end