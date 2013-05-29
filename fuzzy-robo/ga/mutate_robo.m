function mutationChildren = mutate_robo(parents ,options,NVARS, ...
    FitnessFcn, state, thisScore,thisPopulation,mutationRate)
%   MUTATE_PERMUTATION Custom mutation function for traveling salesman.
%   MUTATIONCHILDREN = MUTATE_PERMUTATION(PARENTS,OPTIONS,NVARS, ...
%   FITNESSFCN,STATE,THISSCORE,THISPOPULATION,MUTATIONRATE) mutate the
%   PARENTS to produce mutated children MUTATIONCHILDREN.
%
%   The arguments to the function are 
%     PARENTS: Parents chosen by the selection function
%     OPTIONS: Options structure created from GAOPTIMSET
%     NVARS: Number of variables 
%     FITNESSFCN: Fitness function 
%     STATE: State structure used by the GA solver 
%     THISSCORE: Vector of scores of the current population 
%     THISPOPULATION: Matrix of individuals in the current population
%     MUTATIONRATE: Rate of mutation

%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2012/08/21 00:26:05 $

% Here we swap two elements of the permutation

fprintf(1, '\tMutate\n');

mutationChildren = cell(length(parents),1);
for i=1:length(parents)
    parent = thisPopulation{parents(i)};
    if mutationRate < rand
        mutationChildren{i} = parent;
        continue;
    end
    p1 = ceil((length(parent) -1) * rand);
    p2 = p1 + ceil((length(parent) - p1- 1) * rand);
    child = parent;
    child(p1:p2) = fliplr(child(p1:p2));
    mutationChildren{i} = child;
end