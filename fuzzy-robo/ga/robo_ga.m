function [sucessos media_distancia_sucesso media_distancia_fracasso] = robo_ga(fis)
% Testa o fis dado e obtem as métricas desejadas

centro_x_robo = 10;
centro_y_robo = 15:20:85;
angulo_robo = -90:45:90;
n = 10;

sucessos = zeros(length(centro_y_robo), length(angulo_robo));
distancia_sucesso = zeros(length(centro_y_robo), length(angulo_robo));
distancia_fracasso = zeros(length(centro_y_robo), length(angulo_robo));

% metricas
media_distancia_sucesso = zeros(length(centro_y_robo), length(angulo_robo));
media_distancia_fracasso = zeros(length(centro_y_robo), length(angulo_robo));

for y=1:length(centro_y_robo)
    for angulo=1:length(angulo_robo)
        for i=1:n
            [sucesso, distancia] = robo(centro_x_robo, centro_y_robo(y), angulo_robo(angulo), fis);
            if sucesso
                sucessos(y, angulo) = sucessos(y, angulo) + 1;
                distancia_sucesso(y, angulo) = distancia_sucesso(y, angulo) + distancia;
            else
                distancia_fracasso(y, angulo) = distancia_fracasso(y, angulo) + distancia;
            end
        end
        
        
        if sucessos(y, angulo) == 0
            media_distancia_sucesso(y, angulo) = 0;
        else
            media_distancia_sucesso(y, angulo) = distancia_sucesso(y, angulo) / sucessos(y, angulo);
        end
        
        fracassos = n - sucessos(y, angulo);
        if fracassos == 0
            media_distancia_fracasso(y, angulo) = 0;
        else
            media_distancia_fracasso(y, angulo) = distancia_fracasso(y, angulo) / fracassos;
        end
    end
end