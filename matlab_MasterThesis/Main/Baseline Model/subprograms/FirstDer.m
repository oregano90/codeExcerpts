function Yder=FirstDer(Y,X,steps2,Bound1,Bound2)        %approximates the first difference of a function Y with given X values based on (central) finite differences
N=length(Y);
Yder=[];
% Yder=zeros(1,N);
Yder(1)=Bound1;
for i=2:N-1
        Yder(i)=(Y(i+1)-Y(i-1))/(steps2);
end
%Yder(1)=Bound1;
Yder(N)=Bound2;
end
