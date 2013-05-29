function pop = create_robo(NVARS,FitnessFcn,options)
%   POP = CREATE_PERMUTATION(NVARS,FITNESSFCN,OPTIONS) creates a population
%  of permutations POP each with a length of NVARS. 
%
%   The arguments to the function are 
%     NVARS: Number of variables 
%     FITNESSFCN: Fitness function 
%     OPTIONS: Options structure used by the GA

%   Copyright 2004-2007 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2012/08/21 00:25:37 $

totalPopulationSize = sum(options.PopulationSize);
n = NVARS;
pop = cell(totalPopulationSize,1);
for i = 1:totalPopulationSize
    pop{i} = randi(7, n, 1);
end
