clear all;
clc;

w = warning ('off','all');

options = gaoptimset;
options = gaoptimset(options,'PopulationType', 'custom');
options = gaoptimset(options,'Generations', 20);
options = gaoptimset(options,'PopulationSize', 10);
options = gaoptimset(options,'CreationFcn', @create_robo);
options = gaoptimset(options,'SelectionFcn', @selectionroulette);
options = gaoptimset(options,'CrossoverFcn', @crossover_robo);
options = gaoptimset(options,'MutationFcn', @mutate_robo);
options = gaoptimset(options,'Display', 'off');
options = gaoptimset(options,'UseParallel', 'always');

[x,fval,exitflag,output,population,score] = ga(@fitness_robo,37,options);