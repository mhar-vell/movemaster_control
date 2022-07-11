function [DQ] = DH2DQ(alpha, a, theta, d)
%Converte tabela de parâmetros DH para a notação em DQ.

DQ = zeros(8,length(alpha));

for i = 1 : length(alpha)

    %Parcela rotacional.
    DQ(1,i)= cos(alpha(i)/2)*cos(theta(i)/2);
    DQ(2,i)= sin(alpha(i)/2)*cos(theta(i)/2);
    DQ(3,i)= sin(alpha(i)/2)*sin(theta(i)/2);
    DQ(4,i)= cos(alpha(i)/2)*sin(theta(i)/2);
    
    %Parcela translacional.
    DQ(5,i)= - (a(i)/2)*DQ(2,i) - (d(i)/2)*DQ(4,i);
    DQ(6,i)=   (a(i)/2)*DQ(1,i) - (d(i)/2)*DQ(3,i);
    DQ(7,i)=   (a(i)/2)*DQ(4,i) + (d(i)/2)*DQ(2,i);
    DQ(8,i)= - (a(i)/2)*DQ(3,i) + (d(i)/2)*DQ(1,i);
    
end

end

