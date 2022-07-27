sqrt(sumsqr(diff(theta_save(:,1))));

joint = 1;

plot(diff(theta_save(:,joint)))
hold on
plot(diff(theta_save2(:,joint)))
plot(diff(theta_save3(:,joint)))