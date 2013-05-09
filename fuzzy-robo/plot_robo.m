function plot_robo(x, y, angulo, raio)
% Desenha o robo na tela
% 	plot_robo(x,y, phi)
%
%  x = posicao do robo no mundo
%  y = posicao do robo no mundo
%  angulo = angulo do robo com a horizontal
%  raio = raio do robo
rectangle('Position',[x - raio y - raio 2*raio 2*raio],'Curvature',[1,1],'LineStyle',':','EdgeColor','r');
plot(x, y, 'r+');
plot([x x + cos(angulo * pi / 180) * raio], [y y + sin(angulo * pi / 180) * raio], 'k');


