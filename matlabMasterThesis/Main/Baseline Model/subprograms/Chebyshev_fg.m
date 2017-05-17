function [omega,T,Tder,Tderder,cprime_coeffmat]=Chebyshev_fg(Npol,Nnodes,a,b,thresh) 
% chebyshev approximation setup for forward guidance --> better to use
% different nodes according to the specified threshold
T=[];
Tder=[];
Tderder=[];
omega=[];

%% create nodes
%% chebyshev nodes for chebyshev zeros
% nodes(1)   = round(Nnodes*thresh);      % nodes for low rate
% nodes(2)   = Nnodes-nodes(1);           % nodes for high rate
% 
% thresh
% atemp(1)=0;
% atemp(2)=thresh;
% btemp(1)=thresh;
% btemp(2)=1;
% for l=1:2    
%     for j=1:nodes(l)
%         omegatemp(l,nodes(l)-j+1)=0.5*(atemp(l)+btemp(l))+0.5*(btemp(l)-atemp(l))*cos((2*j-1)/(2*nodes(l))* pi );         %create chebyshev nodes (stützstellen)
%     end
% end
% omega=[omegatemp(1,1:nodes(1)),omegatemp(2,:)]
% thresh=0.3
% Nnodes=5
% a=0
% b=1
% omega=[]
% Nnodes=Nnodes-2;
%% chebyshev nodes for chebyshev extremas
for j=1:Nnodes
    omega(Nnodes-j+1)=0.5*(a+b)+0.5*(b-a)*cos((j*pi)/(Nnodes) );         %create chebyshev nodes (stützstellen)
end
omega(1)=0.00001;
% omega=sort([omega (thresh+0.001) (thresh-0.001)]);
% Nnodes=Nnodes+2;
% for j=1:Nnodes
%     omega(Nnodes-j+1)=0.5*(a+b)+0.5*(b-a)*cos((2*j-1)/(2*Nnodes)* pi );         %create chebyshev nodes (stützstellen)
% end


% omega(1)=999;
% omega=sort([omega (thresh+0.001) (thresh-0.001)]);
% omega(((length(omega)-1):length(omega)))=[];
% length(omega);

%% trigonometric formula to create chebyshev polynomials
for j=1:Nnodes
for k=1:Npol
    n           =k-1;
    x           =(omega(j)*2-1);
    T(j,k)      =cos(n*acos(x));
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