function [g, g_conj] = make_g(axis, theta)
    %Função que cria o operador de rotação quaterniônica, retornando g e o conjugado de g: [g, g_conj]

    g = [cos(theta/2); sin(theta/2).*axis];
    g_conj = [g(1); -g(2:4)];
    
end