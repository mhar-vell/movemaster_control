function [h, h_conj, rot_axis] = make_h(axis, theta, transl, order)
    %Função que cria o operador de transformação dual-quaterniônica, retornando h e o conjugado de h: [h, h_conj].
    
    %axis deve ter formato [x; y; z] e ||axis|| = 1.
    
    %theta em radianos.
    
    %transl pode estar tanto no formato tridimensional [x; y; z] quanto no formato quaterniônico [0; x; y; z].
    
    if (length(transl) == 3)
        transl = [0; transl];
    end
    
    g = [cos(theta/2); sin(theta/2)*axis];
    g_conj = [g(1); -g(2:4)];
    
    if(order == 'RT') %Rotação seguida de translação.
        h = [g; MultQuat(transl/2, g)];
        h_conj = [g_conj; MultQuat(g_conj, transl/2)];
        rot_axis = quat2rotm(h(1:4)')*[0; 0; 1];
    else if (order == 'TR') %Translação seguida de rotação.
        h = [g; MultQuat(g, transl/2)];
        h_conj = [g_conj; MultQuat(transl/2, g_conj)];
        end
    end
    
end