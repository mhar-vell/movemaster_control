function [ok, received, config] = statusMovemaster(sub)
    ok = false;
    while ~ok
        check_ok = 0;
        for i = 1 : length(sub)
            received(i) = receive(sub(i),20);
            if received(i).IsDone
                check_ok = check_ok + 1;
                joints(i) = received(i).IsDone;
%                 fprintf('%d, \n',joints(i));
            end
%             fprintf('\n');
        end      
        
        if check_ok == length(sub)
            ok = true;
        end
    end
    
    for i = 1 : length(sub)
        config(i,1) = deg2rad(received(i).PulseCount);
    end
end

