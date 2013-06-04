function state = plot_ga(options,state,flag,locations)
%   TRAVELING_SALESMAN_PLOT Custom plot function for traveling salesman.
%   STATE = TRAVELING_SALESMAN_PLOT(OPTIONS,STATE,FLAG,LOCATIONS) Plot city
%   LOCATIONS and connecting route between them. This function is specific
%   to the traveling salesman problem.

%   Copyright 2004-2006 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2012/08/21 00:26:36 $
hold on;
axis([-0.5 options.Generations+0.5 -0.1 1.2]);

global media;
global melhor;

geracao = state.Generation + 1;

melhor(geracao, 1) = min(state.Score);
media (geracao, 1) = mean(state.Score);

plot(linspace(1, geracao, geracao), melhor(1: geracao), 'rx-');
plot(linspace(1, geracao, geracao), media(1: geracao), 'bo-');

