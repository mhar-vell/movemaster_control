function [p_final] = RotQuat(p, axis, theta)
    %Função que realiza a rotação do ponto "p" ao longo do eixo "axis" relacionado à origem em "theta" radianos.
    
    %p e axis são vetores tridimensionais [x; y; z].
    
    %theta deve estar em radianos.
    
    %A função converte internamente a representação do ponto p para o espaço dos quatérnios: [w; x; y; z], sendo que w = 0 para representar um objeto tridimensional.
    %Esta conversão é feita para alinhar a dimensão das matrizes.
    
    %A função retorna p_final, sendo este o ponto rotacionado no formato [x; y; z].
    
    %A rotação pode ser feita a partir um eixo arbitrário, não apenas a partir dos três eixos principais. Caso haja a combinação de mais de um termo da variável
    %"axis", a função garante que será aplicada a projeção destes valores nos eixos principais, ou seja, o vetor é normalizado para ||axis|| = 1.
    
    %A rotação aplicada é a ativa, pré-multiplicando o ponto p pelo operador de rotação g e pós-multiplicando pelo conjugado de g: p' = gpg*.
    
    p = [0; p];
    
    [g, g_conj] = make_g(axis, theta);
    
    r = MultQuat(MultQuat(g, p), g_conj);
    
    p_final = r(2:4);
    
end