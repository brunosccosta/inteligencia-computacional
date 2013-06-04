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
fracao_sucessos = sum(sum(sucessos)) / numero_testes;
media_global_distancia_sucesso = sum(sum(media_distancia_sucesso)) / numero_testes;
media_global_distancia_fracasso = sum(sum(media_distancia_fracasso)) / numero_testes;

score = 0.6*(1 - fracao_sucessos) + 0.2*(media_global_distancia_sucesso / 2) + ...
    0.2*(1 - (media_global_distancia_fracasso / 200));

%fprintf(1, '\t\tFinal do individuo. Fracao_sucessos: %.2f. media_global_distancia_sucesso: %.2f. media_global_distancia_fracasso: %.2f. Score %.2f\n', ...
%        fracao_sucessos, media_global_distancia_sucesso, media_global_distancia_fracasso, score);