function Yderder=SecondDer(Y,X,Bound1,Bound2)        %approximates the first difference of a function Y with given X values based on (central) finite differences
N=length(Y);
Yderder=[];
Yderder=zeros(1,N);
for i=2:N-1
        Yderder(i)=((Y(i+1)-Y(i))/((X(i+1)-X(i)))+(Y(i)-Y(i-1))/(X(i)-X(i-1))) / ((X(i+1)-2*X(i)+X(i-1))/(2));
end
Yderder(1)=Bound1;
Yderder(N)=Bound2;
end