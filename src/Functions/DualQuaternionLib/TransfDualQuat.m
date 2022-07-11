function [r] = TransfDualQuat(p, axis, theta, transl, order)
    %Função que realiza a transformação do ponto "p", rotacionando ao longo do eixo "axis" relacionado à origem em "theta" radianos e transladando "transl" unidades.
    
    %p, axis e transl são vetores tridimensionais [x; y; z].
    
    %theta deve estar em radianos.
    
    %A função converte internamente a representação de transl para o espaço dos quatérnios: [w; x; y; z], sendo que w = 0 para representar um objeto tridimensional.
    %Esta conversão é feita para alinhar a dimensão das matrizes.
    
    %A função converte internamente a representação de p para o espaço dos quatérnios duais: [a; b; c; d; w; x; y; z], sendo que a = 1, b = c = d = w = 0 para representar um objeto tridimensional.
    %Esta conversão é feita para alinhar a dimensão das matrizes.
    
    %A função retorna p_final, sendo este o ponto rotacionado e transladado no formato [x; y; z].
    
    %A transformação aplicada é a ativa, pré-multiplicando o ponto p pelo operador de transformação h e pós-multiplicando pelo conjugado de h: p' = hph*.
    
    p_init = [1; 0; 0; 0; 0; p];
    
    [h,h_conj] = make_h(axis,theta, transl, order);
    
    r = MultDualQuat(MultDualQuat(h, p_init),h_conj);
    
end