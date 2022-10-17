% Made on Sept 27 by Nancy Lindsey

% This script is set up to calculate standard tail characteristics using
% one of two methods. The first is using inputs for the characteristics to
% calsulate Cht and Cvt–– this requires Sht and Svt to be inputs. The
% second method uses Cht and Cvt values as inputs (acquired using
% historical data) to calculate Sht and Svt

Lht = 27; % distance from cg estimate at wing to quarter-chord of horizontal tail (in)
Lvt = 4; % distance from cg estimate at wing to quarter-chord of vertical tail (in)
   
    % Comment out the next two lines if using method 2
%Sht = 200; % total planform area of the horizontal tail section in square inches
%Svt = 300; % exposed side area of vertical tail section in square inches

Sref = 864; % reference wing area in square inches
c = 7; % wing mean aerodynamic chord
b = 64; % wing span in inches

    % Comment out the next two lines if using method 2
%Cht = (Lht*Sht)/(c*Sref) % should be ~0.8
%Cvt = (Lvt*Svt)/(b*Sref) % should be ~0.07

    % Comment out the next six lines if using method 1
Cht = 0.8; 
Cvt = 0.07;
syms Sht
Sht = solve ((Cht == (Lht*Sht)/(c*Sref)), Sht)
syms Svt
Svt = solve ((Cvt == (Lvt*Svt)/(b*Sref)), Svt)

% Next, calculate tail weight
thickness = 0.5; % Tail thickness in inches
rho = 0.00462963; % Tail material density in pounds per cubic inch
volume = thickness*(Sht+Svt); % Tail volume in cubic inches
Wtail = rho*volume % Tail weight in pounds
