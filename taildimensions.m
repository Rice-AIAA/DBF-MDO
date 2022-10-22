
A1 = 0.8333; % vertical tail aera
A2 = 1.75/2; % horizontal tail area for one side
y = 11/12; % rudder/horizontal base
c = (3/4)*y; % rudder tip chord
b = (3/4)*y; % horizontal tail tip chord
z = 2*A1/(y+c); % rudder height
x = 2*A2/(y+b); % 1/2 horizontal tail width
yString = num2str(y*12);
cString = num2str(c*12);
bString = num2str(b*12);
zString = num2str(z*12);
xString = num2str(x*12);
output = ['y: ', yString, ' b: ', bString, ' c: ', cString, ' z: ', zString, ' x: ', xString]



