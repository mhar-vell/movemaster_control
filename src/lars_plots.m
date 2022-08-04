load('trajetorias.mat')

sqrt(sumsqr(diff(theta_save(:,1))));
sum(abs(diff(theta_save(:,1))));

joint = 1;

plot(abs(diff(theta_save2(:,joint))),'r','LineWidth',2)
hold on
plot(abs(diff(theta_save3(:,joint))),'g','LineWidth',2)
plot(abs(diff(theta_save4(:,joint))),'y','LineWidth',2)
legend('Algorithm 1','Algorithm 2','Algorithm 3')
hold off

%plot(abs(diff(theta_save(:,2)))+abs(diff(theta_save(:,3)))...
%+abs(diff(theta_save(:,4))));
%hold on
%plot(abs(diff(theta_save2(:,2)))+abs(diff(theta_save2(:,3)))...
%+abs(diff(theta_save2(:,4))));
%plot(abs(diff(theta_save3(:,2)))+abs(diff(theta_save3(:,3)))...
%+abs(diff(theta_save3(:,4))));
%legend('Algorithm 1','Algorithm 2','Algorithm 3')