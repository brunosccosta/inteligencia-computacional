function score = fitness_robo(x)
%TRAVELING_SALESMAN_FITNESS  Custom fitness function for TSP. 
%   SCORES = TRAVELING_SALESMAN_FITNESS(X,DISTANCES) Calculate the fitness 
%   of an individual. The fitness is the total distance traveled for an
%   ordered set of cities in X. DISTANCE(A,B) is the distance from the city
%   A to the city B.

%   Copyright 2004-2007 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2012/08/21 00:26:35 $

gene = x{1};
fis = readfis('funcoes');

for i=1:size(gene,1),
    fis.rule(i).consequent = gene(i);
end

[sucessos media_distancia_sucesso media_distancia_fracasso] = robo_ga(fis);
numero_testes = (10 * size(sucessos,1) * size(sucessos,2));
total_sucessos = 20 - sum(sum(media_distancia_sucesso == 0));
total_fracassos = 20 - sum(sum(media_distancia_fracasso == 0));

fracao_sucessos = sum(sum(sucessos)) / numero_testes;

if total_sucessos > 0
    media_global_distancia_sucesso = sum(sum(media_distancia_sucesso)) / total_sucessos;
else
    media_global_distancia_sucesso = 0;
end

if total_fracassos > 0
    media_global_distancia_fracasso = sum(sum(media_distancia_fracasso)) / total_fracassos;
else
    media_global_distancia_fracasso = 0;
end

if fracao_sucessos == 0
    score = 1;
else
    score = 0.7*(1 - fracao_sucessos) + 0.2*(media_global_distancia_sucesso / 200) + ...
        0.1*(1 - (media_global_distancia_fracasso / 200));
end

%fprintf(1, '\tFinal do individuo. Fracao_sucessos: %.2f. media_global_distancia_sucesso: %.2f. media_global_distancia_fracasso: %.2f. Score %.2f\n', ...
%        fracao_sucessos, media_global_distancia_sucesso, media_global_distancia_fracasso, score);