% Centro do objeto

%Leitura dos sensores
%clc;
clearvars xg yg ag dg eg s s_1 s_2 s_3 s_4 s_5 s_6 s_7 s_8 s_9;
clearvars sn sn_1 sn_2 sn_3 sn_4 sn_5 sn_6 sn_7 sn_8 sn_9;
clearvars mg3 mg4 mg mov ms ms3 ms4 mt;
clearvars zm_s1 zm_s2 zm_s3 zm_s4 zm_s5 zm_s6 zm_s7 zm_s8 zm_s9;
%close all;

scandata = rosmessage('std_msgs/Float32');
sensor1 = rossubscriber('/sensor1');
sensor2 = rossubscriber('/sensor2');
sensor3 = rossubscriber('/sensor3');
sensor4 = rossubscriber('/sensor4');
sensor5 = rossubscriber('/sensor5');
sensor6 = rossubscriber('/sensor6');
sensor7 = rossubscriber('/sensor7');
sensor8 = rossubscriber('/sensor8');
sensor9 = rossubscriber('/sensor9');

%definindo pontos zeros da mesa
for i=1:1:9
    s(1) = receive(sensor1, 5);
    s(2) = receive(sensor2, 5);
    s(3) = receive(sensor3, 5);
    s(4) = receive(sensor4, 5);
    s(5) = receive(sensor5, 5);
    s(6) = receive(sensor6, 5);
    s(7) = receive(sensor7, 5);
    s(8) = receive(sensor8, 5);
    s(9) = receive(sensor9, 5);
        for j=1:1:9
        sensores(i,j) = s(j).Data;
    end
zm_s1 = min(sensores(:,9));
zm_s2 = min(sensores(:,7));
zm_s3 = min(sensores(:,8));
zm_s4 = min(sensores(:,5));
zm_s5 = min(sensores(:,6));
zm_s6 = min(sensores(:,3));
zm_s7 = min(sensores(:,4));
zm_s8 = min(sensores(:,1));
zm_s9 = min(sensores(:,2));
end

objeto = 0;
mov = 0;
cont=0;
xg=-2;
xg0=0;
yg=0;
ag=2;
bg=9;
cg=0;
dg=9;
eg=0;
t2=0;
t3=0;
t4=0;
zm=6;

disp("*******Zeros definidos*******");
disp("*******Coloque o objeto no ponto desejado*******");
pause(3);

while (objeto == 0)
    s_1 = receive(sensor9, 5);  sn(1) = s_1.Data;
    s_2 = receive(sensor7, 5);  sn(2) = s_2.Data;
    s_3 = receive(sensor8, 5);  sn(3) = s_3.Data;
    s_4 = receive(sensor5, 5);  sn(4) = s_4.Data;
    s_5 = receive(sensor6, 5);  sn(5) = s_5.Data;
    s_6 = receive(sensor3, 5);  sn(6) = s_6.Data;
    s_7 = receive(sensor4, 5);  sn(7) = s_7.Data;
    s_8 = receive(sensor1, 5);  sn(8) = s_8.Data;
    s_9 = receive(sensor2, 5);  sn(9) = s_9.Data;

    if ((zm_s1>sn(1) || zm_s2>sn(2) || zm_s3>sn(3)) && mov==0)
        mov = 3;
        xg=0;
        %objeto = 1;
        for k=1:1:9
            ms3(k,:) = [sn(k) xg yg msg.Set2 msg.Set3 msg.Set4];
            mg = k;
            mt(mg,:) = [sn(k) xg yg msg.Set2 msg.Set3 msg.Set4];
            t2=msg.Set2;
            t3=msg.Set3;
            t4=msg.Set4;
        end
    end
    pause(1);
    %while ((mov == 1) && ((zm_s1>sn(1)  && zm_s7>sn(7)) || (zm_s3>sn(3) && zm_s6>sn(6) && zm_s9>sn(9))))
    while ((mov == 3) && ((zm_s1>sn(1) || zm_s2>sn(2) || zm_s3>sn(3)) || (zm_s7>sn(7) || zm_s8>sn(8) || zm_s9>sn(9))))    
        disp("*******Objeto a direita*******");
        %pause(1);
        t2 = t2 -4;
        t3 = t3 + 5;
        msg.Set2 = t2;
        msg.Set3 = t3;
        send(pub,msg);
        pause(1)
        xg = xg + 1;
        yg = yg + 1;
        ag = ag +1;
        s_1 = receive(sensor9, 5);  sn(1) = s_1.Data; zm_s1=zm_s1-10
        s_2 = receive(sensor7, 5);  sn(2) = s_2.Data; zm_s2=zm_s2-10
        s_3 = receive(sensor8, 5);  sn(3) = s_3.Data; zm_s3=zm_s3-10
        s_4 = receive(sensor5, 5);  sn(4) = s_4.Data; zm_s4=zm_s4-10;
        s_5 = receive(sensor6, 5);  sn(5) = s_5.Data; zm_s5=zm_s5-10;
        s_6 = receive(sensor3, 5);  sn(6) = s_6.Data; zm_s6=zm_s6-10;
        s_7 = receive(sensor4, 5);  sn(7) = s_7.Data; zm_s7=zm_s7-10;
        s_8 = receive(sensor1, 5);  sn(8) = s_8.Data; zm_s8=zm_s8-10;
        s_9 = receive(sensor2, 5);  sn(9) = s_9.Data; zm_s9=zm_s9-10;

        for l=1:1:9
            mg3=dg+l;
            mg = dg +l;
            ms3(mg3,:) = [sn(l) xg yg msg.Set2 msg.Set3 msg.Set4];
            mt(mg,:) = [sn(l) xg yg msg.Set2 msg.Set3 msg.Set4];

        end
        dg = dg+9;
        
        %objeto = 1;

    end
    disp("*******Fim do objeto a direita*******");
        mov = 4;
        
        %while ((mov == 2) && (( (xg0<xg)) ||(zm_s1>sn(1) && zm_s7>sn(7)) || (zm_s3>sn(3) && zm_s6>sn(6) && zm_s9>sn(9))))
        while ((mov == 4) && (( (xg0<xg)) ||(zm_s1>sn(1) || zm_s2>sn(2) || zm_s3>sn(3)) || (zm_s7>sn(7) || zm_s8>sn(8) || zm_s9>sn(9))))    
        disp("*******Objeto a esquerda*******");
        t2 = t2 +4;
        if (xg <=0)
            t3 = t3 - 8;
            t4 = t4 + 5;
            zm_s1=zm_s1-zm; zm_s2=zm_s2-zm; zm_s3=zm_s3-zm;
            zm_s4=zm_s4-zm; zm_s5=zm_s5-zm; zm_s6=zm_s6-zm;
            zm_s7=zm_s7-zm 
            zm_s8=zm_s8-zm 
            zm_s9=zm_s9-zm
        else
            t3 = t3 - 5;
            t4 = msg.Set4;
            zm_s1=zm_s1+10; zm_s2=zm_s2+10; zm_s3=zm_s3+10;
            zm_s4=zm_s4+10; zm_s5=zm_s5+10; zm_s6=zm_s6+10;
            zm_s7=zm_s7+10; zm_s8=zm_s8+10; zm_s9=zm_s9+10;
        end
        msg.Set2 = t2;
        msg.Set3 = t3;
        msg.Set4 = t4;
        send(pub,msg);
        pause(1)
        xg = xg - 1;
        yg = yg - 1;
        ag = ag +1;
        s_1 = receive(sensor9, 5);  sn(1) = s_1.Data; 
        s_2 = receive(sensor7, 5);  sn(2) = s_2.Data; 
        s_3 = receive(sensor8, 5);  sn(3) = s_3.Data; 
        s_4 = receive(sensor5, 5);  sn(4) = s_4.Data; 
        s_5 = receive(sensor6, 5);  sn(5) = s_5.Data; 
        s_6 = receive(sensor3, 5);  sn(6) = s_6.Data; 
        s_7 = receive(sensor4, 5);  sn(7) = s_7.Data; 
        s_8 = receive(sensor1, 5);  sn(8) = s_8.Data; 
        s_9 = receive(sensor2, 5);  sn(9) = s_9.Data; 

        for l=1:1:9
            mg4=eg+l;
            mg = dg +l;
            ms4(mg4,:) = [sn(l) xg yg msg.Set2 msg.Set3 msg.Set4];
            mt(mg,:) = [sn(l) xg yg msg.Set2 msg.Set3 msg.Set4];

        end
        eg = eg + 9;
        dg = dg + 9;
        %mov = 2;
        objeto = 1;

    end
    disp("*******Fim do objeto a esquerda*******");    
end

disp("*******Centralizando objeto em x*******");
        cx2 = median(mt(:,4))
        cx3 = median(mt(:,5))
        cx4 = median(mt(:,6))
        msg.Set3 = cx3
        msg.Set4 = cx4
        send(pub,msg);
        pause(1)
        msg.Set2 = cx2
        send(pub,msg);
        pause(1)

%while ab<=50 && ac<50

%    s(3) = receive(sensor3, 5);
%    s(7) = receive(sensor7, 5);
%    ab = s(3).Data
%    ac = s(7).Data
%end


disp("*******Simulação Encerrada*******");