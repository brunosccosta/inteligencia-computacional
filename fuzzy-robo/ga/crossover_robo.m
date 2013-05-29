function xoverKids  = crossover_robo(parents,options,NVARS, ...
    FitnessFcn,thisScore,thisPopulation)
%   CROSSOVER_PERMUTATION Custom crossover function for traveling salesman.
%   XOVERKIDS = CROSSOVER_PERMUTATION(PARENTS,OPTIONS,NVARS, ...
%   FITNESSFCN,THISSCORE,THISPOPULATION) crossovers PARENTS to produce
%   the children XOVERKIDS.
%
%   The arguments to the function are 
%     PARENTS: Parents chosen by the selection function
%     OPTIONS: Options structure created from GAOPTIMSET
%     NVARS: Number of variables 
%     FITNESSFCN: Fitness function 
%     STATE: State structure used by the GA solver 
%     THISSCORE: Vector of scores of the current population 
%     THISPOPULATION: Matrix of individuals in the current population

%   Copyright 2004 The MathWorks, Inc. 
%   $Revision: 1.1.6.2 $  $Date: 2012/08/21 00:25:38 $

fprintf(1, '\tCrossover\n');

nKids = length(parents)/2;
xoverKids = cell(nKids,1); % Normally zeros(nKids,NVARS);
index = 1;

for i=1:nKids
    parent = thisPopulation{parents(index)}; % Normally thisPopulation(parents(i),:)
    parent2 = thisPopulation{parents(index+1)}; % Normally thisPopulation(parents(i),:)
    p = ceil((length(parent) -1) * rand);
    
    child = parent;
    child(p+1:NVARS,1) = parent2(p+1:NVARS,1);
    
    xoverKids{i} = child;
    
    index = index + 2;
end