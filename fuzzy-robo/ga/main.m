clear all;
clc;

w = warning ('off','all');

geracoes = 30;

global media;
global melhor;

media = zeros(geracoes,1);
melhor = zeros(geracoes,1);

options = gaoptimset;
options = gaoptimset(options,'PopulationType', 'custom');
options = gaoptimset(options,'Generations', geracoes);
options = gaoptimset(options,'PopulationSize', 20);
options = gaoptimset(options,'CreationFcn', @create_robo);
options = gaoptimset(options,'SelectionFcn', @selectionroulette);
options = gaoptimset(options,'CrossoverFcn', @crossover_robo);
options = gaoptimset(options,'MutationFcn', @mutate_robo);
options = gaoptimset(options,'PlotFcn', @plot_ga);
options = gaoptimset(options,'Display', 'iter');
options = gaoptimset(options,'UseParallel', 'always');

[x,fval,exitflag,output,population,score] = ga(@fitness_robo,37,options);