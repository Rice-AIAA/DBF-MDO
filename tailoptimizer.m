function tailoptimizer
min_H = 1000; % min S_HT
min_V = 1000; % min S_VT
min_W = 1000; % min W
x0 = [3.5, min_H, min_V, min_W];
[x1]=fsolve(@tailfun, x0);
x = x1(1);
min_H = x1(2);
min_V = x1(3);
min_W = x1(4);
l_t=x;
disp(l_t);
hold on
n = 1;
x = 0.5:0.025:2;
for i = x
    %disp(i)
    %disp(min_H)
    disp(min_W)
    %disp(min_V)
    input = [i, min_H, min_V, min_W];
    [y(n), min_H, min_V, min_W] = tailfun(input);
    n = n+1;
end
plot(x,y);
title('Tail Weight vs. Wing to Tail Quarter Chord Distance');
xlabel('Tail Distance (ft)');
ylabel('Tail Weight (lb)');
disp(['S_HT min: ', num2str(min_H)])
disp(['S_VT min: ', num2str(min_V)])
disp(['W min: ', num2str(min_W)])
end

function [W, min_H, min_V, min_W] = tailfun(input)
x = input(1);
min_H = input(2);
min_V = input(3);
min_W = input(4);
b = 5; % wingspan
S_ref = 5.25; % surface area of wing
mac = 1.05; % mean aerodynamic chord
OD = 0.75/12; % OD of the boom
ID = OD - (2*0.075/12); % ID of the boom
rho_CF = 124.855; % density of carbon fiber
W_boom = ((OD^2)-(ID^2))*(x-0.75*mac-(4.29/12))*rho_CF; % weight of boom
C_HT = 0.5; %0.8
C_VT = 0.05; %0.07
S_HT=C_HT*mac*S_ref/x; % surface area of horizontal tail
S_VT=C_VT*b*S_ref/x; % surface area of vertical tail
S_T=S_HT+S_VT;
T_HT = 0.3/12; % thickness of horizontal tail
T_VT = 0.3/12; % thickness of vertical tail
rho_balsa = 8.55013; %lb per cubic inch
W_tail= 0.5*rho_balsa*((S_HT*T_HT)+(S_VT*T_VT)) % change
W=W_tail+W_boom;
if W < min_W
    min_H = S_HT;
    min_V = S_VT;
    min_W = W;
end
end