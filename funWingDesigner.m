function [endingOutput] = funWingDesigner(wingSpan, wingDihedral, wingAOA, wingSweep, rootChord, rootAngle, rootAirfoil, tipChord, tipAngle, tipAirfoil)

%addpath 'C:\Users\anish\Documents\MATLAB\MECH 490 Research\PSO check\github_repo\WingDesignerver1.6'
airfoilstruct = parseNACAairfoildata;
%Perform regression on airfoilstruct data at multiple Re
airfoildata = PerformRegression(airfoilstruct);
hplot = true;
output = struct();

%wing structure
wing.span = wingSpan;
wing.dihedral = wingDihedral;
wing.AOA = wingAOA;
wing.ns = 17; %constant
wing.nc = 12; %constant
wing.sweep = wingSweep;

%root structure
root.chord = rootChord;
root.angle = rootAngle;
root.airfoil = rootAirfoil;

%tip structure
tip.chord = tipChord;
tip.angle = tipAngle;
tip.airfoil = tipAirfoil;  

%cruise structure
cruise.velocity = 52; %constant
cruise.altitude = 2200; %constant
cruise.wettedarea = 7; %constant
cruise.skinfriction = 0.004; %constant
cruise.weight = 15; %constant

%engine structure
engine.propeffic = 0.85;
engine.SFC = 0.49;
engine.TSFC = 0.69;
engine.wingfuel = 5;

[geo] = GetGeometryfromGUI(root, tip, wing, cruise, engine, hplot, output, airfoildata);
[panel, WingVolume]=DeterminePanelGeometry(geo,hplot);
[gamma, Fu_bar, Fv_bar, Fw_bar]=VortexStrength(panel,geo.dih);
[CL, u_U, v_U, w_U, l_t, l_s] = LiftCoeff(gamma, panel, geo, Fu_bar, Fv_bar, Fw_bar);
[y_cp] = SpanLoading(l_s, l_t, CL, geo, panel);
[CDi] = InducedDrag(gamma, geo, panel);
[CD0] = DetermineProfileDrag(airfoildata,geo,panel);
endingOutput = FinalOutput(CL, CDi, CD0, y_cp, geo, WingVolume, airfoildata, output);
end
