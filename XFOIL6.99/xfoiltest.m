function xfoiltest

pol = xfoil('NACA24012',-10:0.1:20,5e5,0.08,'oper iter 100','oper/vpar n 9');
% Plot the results
figure; 
subplot(2,2,1);
plot(pol.CD,pol.CL); xlabel('C_D'); ylabel('C_L'); title(pol.name);
subplot(2,2,2);
plot(pol.alpha,pol.CL); xlabel('alpha [\circ]'); ylabel('C_L'); title(pol.name);
subplot(2,2,3);
plot(pol.alpha,pol.Cm); xlabel('alpha [\circ]'); ylabel('C_M'); title(pol.name);
subplot(2,2,4);
plot(pol.Top_xtr,pol.CL); xlabel('Xtr Top'); ylabel('C_L'); title(pol.name);
end