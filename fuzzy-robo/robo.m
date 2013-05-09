%Problema do Robô. Conforme http://equipe.nce.ufrj.br/adriano/ic/trabalho/t20131/lista2/2004_ISDA.pdf
%====================================================================================================
%Autores: Bruno Costa, Carla Moraes e Filipi Xavier
%Data: 02/05/2013
%====================================================================================================

%Limpando a memoria e a tela
clear all
clc

%DEBUG
debug = 1;

%Raio do Robô
raio_robo = 6;

%Raio dos Obstáculos
raio_obstaculo = 3;

%Número de Obstáculos
num_obstaculos = 10;

%Margem para iniciar os obstaculos
margem_obstaculo = 50;

%Domínio: [0,200]x[0,100]
yi = 0;
yf = 100;

xi = 0;
xf = 200;

delta = 2;

% carregando o fis
fis = readfis('funcoes');

%Posição Inicial do Robô: Lado esquerdo do domínio
centro_x_robo = raio_robo + 6; %robo encostado na extremidade esquerda do dominio 
centro_y_robo = randi(yf - 2*raio_robo,1,1) + raio_robo;

%Ângulo Phi Inicial: -180<= phi <=180
angulo_robo = randi(360,1,1) - 180;

%Montando o Domínio e o Robô
plot([0 1 1 0],[0 0 1 1]);
axis([xi xf yi yf]);
hold on;

plot_robo(centro_x_robo, centro_y_robo, angulo_robo, raio_robo);

x_obstaculo = zeros(num_obstaculos, 1);
y_obstaculo = zeros(num_obstaculos, 1);
%Montando os obstáculos
for i=1:num_obstaculos
    x_obstaculo(i) = randi(xf - 2*raio_obstaculo - margem_obstaculo,1,1) + raio_obstaculo + margem_obstaculo; %coordenada x do centro do obstaculo
    y_obstaculo(i) = randi(yf - 2*raio_obstaculo,1,1) + raio_obstaculo; %coordenada y do centro do obstaculo
    %distancias medidas do centro do robo ate o centro do obstaculo
    rectangle('Position',[x_obstaculo(i)-raio_obstaculo y_obstaculo(i)-raio_obstaculo 2*raio_obstaculo raio_obstaculo*2],'Curvature',[1,1],'EdgeColor','b');
    plot(x_obstaculo(i), y_obstaculo(i), 'b+'); 
end

distancias_minimas = [];
passo = 0;

while( ~((centro_x_robo - raio_robo < xi) || centro_x_robo > xf || (centro_y_robo + raio_robo > yf) || (centro_y_robo - raio_robo < 0)) )
    distancias = ones(num_obstaculos + 1, 1) * 220;
    for i=1:num_obstaculos
        bl1 = centro_y_robo - tan(angulo_robo * pi / 180)*centro_x_robo;
        bl2 = y_obstaculo(i) - tan(angulo_robo * pi / 180 + pi/2)*x_obstaculo(i);
        b = [bl1 bl2]';
        a = [1 -tan(angulo_robo * pi / 180); 1 -tan(angulo_robo * pi / 180 + pi/2)];
        Pint = a\b;

        x_intersection = Pint(2);
        y_intersection = Pint(1);

        %usamos o produto escalar para determinar se os obstaculos estão a
        %frente ou atras
        dot = [x_intersection - centro_x_robo; y_intersection - centro_y_robo]' * [cos(angulo_robo * pi / 180); sin(angulo_robo * pi / 180)];

        dist = pdist([x_intersection y_intersection; x_obstaculo(i) y_obstaculo(i)], 'Euclidean');

        if (dot > 0 && raio_robo + raio_obstaculo > dist)
            distancias(i) = pdist([x_obstaculo(i) y_obstaculo(i); centro_x_robo centro_y_robo], 'Euclidean');
        end
    end

    bl1 = centro_y_robo - tan(angulo_robo * pi / 180)*centro_x_robo;

    if angulo_robo > 0    
        bl2 = yf;
    else
        bl2 = 0;
    end
    b = [bl1 bl2]';
    a = [1 -tan(angulo_robo * pi / 180); 1 0];
    Pint = a\b;

    x_intersection = Pint(2);
    y_intersection = Pint(1);

    if x_intersection < 0
        x_intersection = 0;
        y_intersection = centro_y_robo - tan(angulo_robo * pi / 180)*centro_x_robo;
    end

    distancias(num_obstaculos + 1) = pdist([x_intersection y_intersection; centro_x_robo centro_y_robo], 'Euclidean');

    distancia_minima = min(distancias);
    
    output = evalfis([angulo_robo distancia_minima centro_y_robo], fis);

    %Calculo das novas posicoes
    %================================================================================
    angulo_robo = angulo_robo + output;
    if angulo_robo < -90
        angulo_robo = angulo_robo + 360;
    elseif angulo_robo > 270
        angulo_robo = angulo_robo - 360;
    end

    angulo_rad = (pi * angulo_robo)/180;
    centro_x_robo = centro_x_robo + delta*cos(angulo_rad);
    centro_y_robo = centro_y_robo + delta*sin(angulo_rad);

    plot_robo(centro_x_robo, centro_y_robo, angulo_robo, raio_robo);
    
    if (debug)
        fprintf(1, 'Angulo atual = %.2f\n', angulo_robo);
        fprintf(1, 'Posicao atual X = %.2f\n', centro_x_robo);
        fprintf(1, 'Posicao atual Y = %.2f\n', centro_y_robo);
        fprintf(1, 'Distancia minima = %.2f\n', distancia_minima);
        fprintf(1, 'Saida FIS = %.2f\n', output);
    end
    
    passo = passo + 1;
    distancias_minimas(passo) = distancia_minima;
    
    pause(0.1);
end