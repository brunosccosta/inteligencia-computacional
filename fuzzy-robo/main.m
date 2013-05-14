clear all;
close all;
clc;

w = warning ('off','all');

centro_x_robo = 10;
centro_y_robo = 15:10:85;
angulo_robo = -90:22.5:90;
n = 100;

sucessos = zeros(length(centro_y_robo), length(angulo_robo));
distancia_sucesso = zeros(length(centro_y_robo), length(angulo_robo));
distancia_sucesso_quadrado = zeros(length(centro_y_robo), length(angulo_robo));
distancia_fracasso = zeros(length(centro_y_robo), length(angulo_robo));
distancia_fracasso_quadrado = zeros(length(centro_y_robo), length(angulo_robo));

% metricas
media_distancia_sucesso = zeros(length(centro_y_robo), length(angulo_robo));
media_distancia_fracasso = zeros(length(centro_y_robo), length(angulo_robo));

variancia_distancia_sucesso = zeros(length(centro_y_robo), length(angulo_robo));
variancia_distancia_fracasso = zeros(length(centro_y_robo), length(angulo_robo));

for y=1:length(centro_y_robo)
    for angulo=1:length(angulo_robo)
        for i=1:n
            fprintf(1, 'Passo: %d -- iteracao: %d\n', y*angulo, i);
            [sucesso, distancia] = robo(centro_x_robo, centro_y_robo(y), angulo_robo(angulo), 0);
            if sucesso
                sucessos(y, angulo) = sucessos(y, angulo) + 1;
                distancia_sucesso(y, angulo) = distancia_sucesso(y, angulo) + distancia;
                distancia_sucesso_quadrado(y, angulo) = distancia_sucesso_quadrado(y, angulo) + (distancia*distancia);
            else
                distancia_fracasso(y, angulo) = distancia_fracasso(y, angulo) + distancia;
                distancia_fracasso_quadrado(y, angulo) = distancia_fracasso_quadrado(y, angulo) + (distancia*distancia);
            end
        end
        
        
        if sucessos(y, angulo) == 0
            media_distancia_sucesso(y, angulo) = 0;
        else
            media_distancia_sucesso(y, angulo) = distancia_sucesso(y, angulo) / sucessos(y, angulo);
        end
        
        if sucessos(y, angulo) < 2
            variancia_distancia_sucesso(y, angulo) = 0;
        else
            variancia_distancia_sucesso(y, angulo) = distancia_sucesso_quadrado(y, angulo) / (sucessos(y, angulo) - 1);
            variancia_distancia_sucesso(y, angulo) = variancia_distancia_sucesso(y, angulo) - ( (distancia_sucesso(y, angulo) * distancia_sucesso(y, angulo)) / ( sucessos(y, angulo) * (sucessos(y, angulo) - 1) ) );
        end
        
        fracassos = n - sucessos(y, angulo);
        if fracassos == 0
            media_distancia_fracasso(y, angulo) = 0;
        else
            media_distancia_fracasso(y, angulo) = distancia_fracasso(y, angulo) / fracassos;
        end
        
        if fracassos < 2
            variancia_distancia_fracasso(y, angulo) = 0;
        else
            variancia_distancia_fracasso(y, angulo) = distancia_fracasso_quadrado(y, angulo) / (fracassos - 1);
            variancia_distancia_fracasso(y, angulo) = variancia_distancia_fracasso(y, angulo) - ( (distancia_fracasso(y, angulo) * distancia_fracasso(y, angulo)) / ( fracassos * (fracassos - 1) ) );
        end
        
        %sucessos(y, angulo) = sucessos(y, angulo) / n;
    end
end

porcentagem_sucesso = sucessos ./ 100;

dp_sucesso = real(sqrt(variancia_distancia_sucesso));
dp_fracasso = real(sqrt(variancia_distancia_fracasso));