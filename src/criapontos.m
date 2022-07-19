% cria varios pontos para pegar peca de um lugar e colocar em outro

function [data, desenho] = criapontos(peca, pos_inicial, pos_final, last_desenho)

fora = 200;
alto = 178;
medio = 165;
baixo = 152;
pino1 = -133;
pino2 = -43;
pino3 = 47;
pino4 = 137;

if pos_inicial > 0 && pos_inicial <= 3
    pinoi = pino1;
elseif pos_inicial >= 4 && pos_inicial <= 6
    pinoi = pino2;
elseif pos_inicial >= 7 && pos_inicial <= 9
    pinoi = pino3;
elseif pos_inicial >= 10 && pos_inicial <= 12
    pinoi = pino4;
end

if pos_final > 0 && pos_final <= 3
    pinof = pino1;
elseif pos_final >= 4 && pos_final <= 6
    pinof = pino2;
elseif pos_final >= 7 && pos_final <= 9
    pinof = pino3;
elseif pos_final >= 10 && pos_final <= 12
    pinof = pino4;
end

if pos_inicial == 1 || pos_inicial == 4 || pos_inicial == 7 || pos_inicial == 10
    alturai = baixo;
elseif pos_inicial == 2 || pos_inicial == 5 || pos_inicial == 8 || pos_inicial == 11
    alturai = medio;
elseif pos_inicial == 3 || pos_inicial == 6 || pos_inicial == 9 || pos_inicial == 12
    alturai = alto;
end

if pos_final == 1 || pos_final == 4 || pos_final == 7 || pos_final == 10
    alturaf = baixo;
elseif pos_final == 2 || pos_final == 5 || pos_final == 8 || pos_final == 11
    alturaf = medio;
elseif pos_final == 3 || pos_final == 6 || pos_final == 9 || pos_final == 12
    alturaf = alto;
end


data = [pinoi fora;
        pinoi alturai;  %pick
        pinoi fora;
        pinof fora;
        pinof alturaf;
        pinof fora;];   %place

desenho = last_desenho;
desenho(peca) = pos_final;
