load('trajetorias.mat')

sqrt(sumsqr(diff(theta_save(:,1))));
sum(abs(diff(theta_save(:,1))));

joint = 1;

plot(diff(theta_save(:,joint)),'b','LineWidth',2)
hold on
plot(diff(theta_save2(:,joint)),'r','LineWidth',2)
plot(diff(theta_save3(:,joint)),'g','LineWidth',2)
legend('Algorithm 1','Algorithm 2','Algorithm 3')