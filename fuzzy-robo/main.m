clear all;
close all;
clc;

w = warning ('off','all');

centro_x_robo = 10;
centro_y_robo = 15:10:85;
angulo_robo = -90:22.5:90;
n = 10;

sucessos = zeros(length(centro_y_robo), length(angulo_robo));
distancia_sucesso = zeros(length(centro_y_robo), length(angulo_robo));
distancia_fracasso = zeros(length(centro_y_robo), length(angulo_robo));

for y=1:length(centro_y_robo)
    parfor angulo=1:length(angulo_robo)
        for i=1:n
            fprintf(1, 'Passo: %d -- iteracao: %d\n', y*angulo, i);
            [sucesso, distancia] = robo(centro_x_robo, centro_y_robo(y), angulo_robo(angulo), 0);
            if sucesso
                sucessos(y, angulo) = sucessos(y, angulo) + 1;
                distancia_sucesso(y, angulo) = distancia_sucesso(y, angulo) + distancia;
            else
                distancia_fracasso(y, angulo) = distancia_fracasso(y, angulo) + distancia;
            end
        end
        
        if sucessos(y, angulo) == 0
            distancia_sucesso(y, angulo) = 0;
        else
            distancia_sucesso(y, angulo) = distancia_sucesso(y, angulo) / sucessos(y, angulo);
        end
        
        if sucessos(y, angulo) == n
            distancia_fracasso(y, angulo) = 0;
        else
            distancia_fracasso(y, angulo) = distancia_fracasso(y, angulo) / (n - sucessos(y, angulo));
        end
        
        sucessos(y, angulo) = sucessos(y, angulo) / n;
    end
end