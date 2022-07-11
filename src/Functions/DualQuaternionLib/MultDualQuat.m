function [s] = MultDualQuat(dq1,dq2)

    dq1_real = dq1(1:4);
    dq1_dual = dq1(5:8);
    dq2_real = dq2(1:4);
    dq2_dual = dq2(5:8);
    
    s_real = MultQuat(dq1_real,dq2_real);
    s_dual = MultQuat(dq1_real,dq2_dual) + MultQuat(dq1_dual,dq2_real);

    s = [s_real; s_dual];

end

% %Minha:
%     dq1_real = dq1(1:4);
%     dq1_dual = dq1(5:8);
%     dq2_real = dq2(1:4);
%     dq2_dual = dq2(5:8);
%     
%     s_real = MultQuat(dq1_real,dq2_real);
%     s_dual = MultQuat(dq1_real,dq2_dual) + MultQuat(dq1_dual,dq2_real);
% 
%     s = [s_real; s_dual];

%%pela do André:
%  a0 = dq1(1);
%      a1 = dq1(2);
%      a2 = dq1(3);
%      a3 = dq1(4);
%      a4 = dq1(5);
%      a5 = dq1(6);
%      a6 = dq1(7);
%      a7 = dq1(8);
%      
%      b0 = dq2(1);
%      b1 = dq2(2);
%      b2 = dq2(3);
%      b3 = dq2(4);
%      b4 = dq2(5);
%      b5 = dq2(6);
%      b6 = dq2(7);
%      b7 = dq2(8);
%   
%      r1 = a0*b0-b1*a1-b3*a3-b2*a2;
%      ri = a0*b1+b0*a1+b3*a2-b2*a3;
%      rj = b2*a0-b3*a1+b0*a2+b1*a3;
%      rk = b3*a0+b2*a1-b1*a2+b0*a3;
%      re =  -b7*a3 - b6*a2 - b5*a1 - b4*a0 - b3*a7 - b2*a6 - b1*a5 - b0*a4;
%      rie =  b7*a2 - b6*a3 + b5*a0 - b4*a1 + b3*a6 - b2*a7 - b1*a4 + b0*a5;
%      rje = -b7*a1 + b6*a0 + b5*a3 - b4*a2 - b3*a5 - b2*a4 + b1*a7 + b0*a6;
%      rke =  b7*a0 + b6*a1 - b5*a2 - b4*a3 - b3*a4 + b2*a5 - b1*a6 + b0*a7;
%      
%      s=[r1;ri;rj;rk;re;rie;rje;rke]





%Pelo cara que eu achei num artigo:
%      w0 = dq1(1);
%      x0 = dq1(2);
%      y0 = dq1(3);
%      z0 = dq1(4);
%      w0e = dq1(5);
%      x0e = dq1(6);
%      y0e = dq1(7);
%      z0e = dq1(8);
%      
%      w1 = dq2(1);
%      x1 = dq2(2);
%      y1 = dq2(3);
%      z1 = dq2(4);
%      w1e = dq2(5);
%      x1e = dq2(6);
%      y1e = dq2(7);
%      z1e = dq2(8);
%      
%      s(1) = [w0*w1 - x0*x1 - y0*y1 - z0*z1];
%      s(2) = [x0*w1 + w0*x1 + y0*z1 - z0*y1];
%      s(3) = [y0*w1 + w0*y1 + z0*x1 - x0*z1];
%      s(4) = [z0*w1 + w0*z1 + x0*y1 - y0*x1];
%      s(5) = [w0*w1e + w0e*w1 - x0*x1e - x0e*x1 - y0*y1e - y0e*y1 - z0*z1e - z0e*z1];
%      s(6) = [w0*x1e + w0e*x1 + x0*w1e + x0e*w1 + y0*z1e + y0e*z1 - z0*y1e - z0e*y1];
%      s(7) = [w0*y1e + w0e*y1 - x0*z1e - x0e*z1 + y0*w1e + y0e*w1 + z0*x1e + z0e*x1];
%      s(8) = [w0*z1e + w0e*z1 + x0*y1e + x0e*y1 - y0*x1e - y0e*x1 + z0*z1e + z0e*w1];
%     
%      s=s'