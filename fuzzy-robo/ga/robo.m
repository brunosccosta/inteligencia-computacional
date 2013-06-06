%Problema do Robô. Conforme http://equipe.nce.ufrj.br/adriano/ic/trabalho/t20131/lista2/2004_ISDA.pdf
%====================================================================================================
%Autores: Bruno Costa, Carla Moraes e Filipi Xavier
%Data: 02/05/2013
%====================================================================================================
function[sucesso distancia] = robo(centro_x_robo, centro_y_robo, angulo_robo, fis)
% Percorre o dominio e retorna as metricas
% 	robo(centro_x_robo, centro_y_robo, angulo_robo, debug)
%
%  centro_x_robo = posicao inicial do robo no mundo
%  centro_y_robo = posicao inicial do robo no mundo
%  angulo_robo = angulo inicial do robo com a horizontal
%  fis = regras

%Raio do Robô
raio_robo = 6;

%Raio dos Obstáculos
raio_obstaculo = 3;

%Número de Obstáculos
num_obstaculos = 5;

%Margem para iniciar os obstaculos
margem_obstaculo = 50;

%Domínio: [0,200]x[0,100]
yi = 0;
yf = 100;

xi = 0;
xf = 200;

delta = 1;

% usado para metricas de distancia
centro_x_robo_inicial = centro_x_robo;

x_obstaculo = zeros(num_obstaculos, 1);
y_obstaculo = zeros(num_obstaculos, 1);
%Montando os obstáculos
for i=1:num_obstaculos
    x_obstaculo(i) = randi(xf - 2*raio_obstaculo - margem_obstaculo,1,1) + raio_obstaculo + margem_obstaculo; %coordenada x do centro do obstaculo
    y_obstaculo(i) = randi(yf - 2*raio_obstaculo,1,1) + raio_obstaculo; %coordenada y do centro do obstaculo
end

passo = 0;
bateu = 0;
while( ~(centro_x_robo > xf) )
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
        
        dist_robo_obstaculo = pdist([centro_x_robo centro_y_robo; x_obstaculo(i) y_obstaculo(i)], 'Euclidean');
        if (dist_robo_obstaculo < raio_robo + raio_obstaculo)
            bateu = 1;
        end
    end

    if bateu
        break;
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
    centro_x_anterior = centro_x_robo;
    centro_x_robo = centro_x_robo + delta*cos(angulo_rad);
    centro_y_robo = centro_y_robo + delta*sin(angulo_rad);
    
    passo = passo + 1;
    
    if centro_x_anterior > centro_x_robo
        bateu = 1;
        break;
    end
    
    if (centro_y_robo + raio_robo > yf) || (centro_y_robo - raio_robo < 0)
        bateu = 1;
        break;
    end
end

if bateu
    sucesso = 0;
    distancia = xf - centro_x_robo;
else
    sucesso = 1;
    distancia = (passo * delta);
end