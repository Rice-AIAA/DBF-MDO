function [geo] = GetGeometryfromGUI(root, tip, wing, cruise, engine, hplot, output, airfoildata)
% Get parameters from the GUI and create geometry structure "geo"
% Gets the user defined parameters from the GUI
% Performs limited error checking and sets boolean to tell ExecCalc to continue or not

%Clear clock
%set(output.calctime,'String','----');

%Set wing geometry from values from GUI
geo.t0 = clock; %Start time
geo.b = (wing.span)/3.281;  %Convert to meters
geo.c_r = root.chord/3.281;  %Convert to meters
geo.taper = tip.chord/root.chord;
geo.i_r = root.angle*pi/180;   %Convert to radians
geo.twist = (tip.angle-root.angle)*pi/180;  %Convert to radians
geo.dih = wing.dihedral*pi/180; %Convert to radians
geo.root = airfoildata{1}{root.airfoil};
geo.tip = airfoildata{1}{tip.airfoil};
geo.alpha = (wing.AOA)*pi/180; %Convert to radians
geo.V = cruise.velocity*0.5144; %Convert knots to m/s
[geo.density, geo.a geo.visc] = StandardAtmosphere(cruise.altitude);
geo.M = geo.V/geo.a;
geo.S_Sref = (cruise.wettedarea);  %Dimensionless
geo.cf = (cruise.skinfriction);  %Dimensionless
geo.ns = (wing.ns);
geo.nc = (wing.nc);
geo.sweep = (wing.sweep)*pi/180;  %Convert to radians
geo.S = 0.5*(geo.c_r + geo.c_r*geo.taper)*geo.b;  %Square meters
geo.c_av = 0.5*(geo.c_r + geo.c_r*geo.taper);  %Meters
geo.Re_r = geo.V*geo.density*geo.c_r/geo.visc; %Reynolds number at root
geo.Re_t = geo.V*geo.density*geo.c_r*geo.taper/geo.visc; %Reynolds number at root
geo.rootindex = root.airfoil;      %index to selected root airfoil
geo.tipindex = tip.airfoil;         %index to selected tip airfoil
geo.propefficiency = (engine.propeffic);  %from Anderson, Aircraft Performance and Design
geo.propSFC = engine.SFC*1.657e-6; % convert lb fuel/hp-hr to m^-1 Wikipedia (Specific Fuel Consumption)
geo.jetTSFC = engine.TSFC/3600; %convert to lb fuel per lb-s thrust; Anderson, Aircraft Performance and Design pg. 299
geo.emptyweight = cruise.weight*4.44;%Convert weight from lbf to N
geo.fueldens = 0.840*1e3; %(kg/m^3) Density of Jet A-1 at 15deg C (Wikipedia)
geo.wingfuel = engine.wingfuel/100;  %Percent of wing dedicated to carrying fuel
geo.withinconstraints = 1; % Set boolean flag stating that all geometry is within constraints

%Set the selected type of engine
% if get(engine.panel,'SelectedObject')==engine.prop
    geo.engine = 'prop';
% elseif get(engine.panel,'SelectedObject')==engine.jet
%     geo.engine = 'jet';
% else
%     geo.engine = 0;
% end

%Set initial output
geo.taper;
wing.taper = geo.taper;
wing.twist = geo.twist;
root.Re = round(geo.Re_r/1e3)/1e3;
tip.Re = round(geo.Re_t/1e3)/1e3;
cruise.density = round(geo.density*1000)/1000;
cruise.viscosity = round(geo.visc*10000000)/10000000;
cruise.mach = round(geo.M*100)/100;

%Limited error checking
if geo.sweep < 80*pi/180  %If sweep < 80 deg
    %set(wing.sweep,'ForegroundColor','black')
else
    %set(wing.sweep,'ForegroundColor','red')
    %ZeroOutput(output)
    geo.withinconstraints = 0; % User defined geometry is not within constraints
end
if geo.dih < 80*pi/180  %If dihedral < 80 deg
    %set(wing.dihedral,'ForegroundColor','black')
else
    %set(wing.dihedral,'ForegroundColor','red')
    %ZeroOutput(output)
    geo.withinconstraints = 0; % User defined geometry is not within constraints
end
if geo.M < 0.65  %If M < 0.65
    %set(cruise.mach,'ForegroundColor','black')
else
    %set(cruise.mach,'ForegroundColor','red')
    %ZeroOutput(output)
    geo.withinconstraints = 0; % User defined geometry is not within constraints
end

