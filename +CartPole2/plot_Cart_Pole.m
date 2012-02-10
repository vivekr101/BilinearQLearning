function plot_Cart_Pole(xv,theta,action,v,td)


l=2;     %pole's Length for ploting it can be different from the actual length
x = 0;
pxg = [x+1 x-1 x-1 x+1 x+1];
pyg = [0.25 0.25 1.25 1.25 0.25];

pxp=[x x+l*sin(theta)];
pyp=[1.25 1.25+l*cos(theta)];

[pxw1,pyw1] = CartPole.plotcircle(x-0.5,0.125,0,0.125);
[pxw2,pyw2] = CartPole.plotcircle(x+0.5,0.125,0,0.125);

plot(pxg,pyg,'k-',pxw1,pyw1,'k',pxw2,pyw2,'k',pxp,pyp,'r')
axis([-6 6 0 6])
line([0 action/10],[3 3]);
text(-2,5,sprintf('%f\n%f\n%f',[theta, td, action]));

drawnow;