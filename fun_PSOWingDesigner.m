function output=fun_PSOWingDesigner(XINdec)
%

%
%
%

fun_PER_Code='fun_PSOWingDesigner.m';





global runcount     % counter to count the evaluations, defined in Run*.m
global pvector1     % a vector of actual L/D performace, from preoutput
global pvector2     % a vector of the cost function, from output
global XINarray1    % array of "as given" XINdec vector for each evaluation
global textbit1     % text that goes into the mesh and cfg filenames
global iplot        % set iplot=1 to make figures
global ifast        % set ifast=1 to run fast and skip some checks
global numruns      % numruns=PRPopSize.*PRNumGens
global icostwith    % cost function options, 1=min(CD), 2=max(L/D)
      

runcount=runcount+1;


if runcount==1
    XINarray1=XINdec;
else
    XINarray1=[XINarray1;XINdec];
end  % end of "if runcount==1" block


%

% convert XINDEC from 10 0-1 inputs
wingSpanMin = 4;
wingSpanMax = 6;
wingSpan = wingSpanMin + XINdec(1).*(wingSpanMax-wingSpanMin);

% wingDihedralMin = 0;
% wingDihedralMax = 30;
% wingDihedral = wingDihedralMin + XINdec(2).*(wingDihedralMax-wingDihedralMin);
wingDihedral = 0;

wingAOAMin = 0;
wingAOAMax = 10;
wingAOA = wingAOAMin + XINdec(2).*(wingAOAMax - wingAOAMin);

% wingSweepMin = 0;
% wingSweepMax = 30;
% wingSweep = wingSweepMin + XINdec(4).*(wingSweepMax - wingSweepMin);
wingSweep = 0;

rootChordMin = 0.1;
rootChordMax = 2;
rootChord = rootChordMin + XINdec(3).*(rootChordMax - rootChordMin);

rootAngleMin = 0;
rootAngleMax = 10;
rootAngle = rootAngleMin + XINdec(4).*(rootAngleMax - rootAngleMin);

rootAirfoilMin = 1;
rootAirfoilMax = 38;
rootAirfoil = round(rootAirfoilMin + XINdec(5).*(rootAirfoilMax - rootAirfoilMin));

% tipChordMin = 0.1;
% tipChordMax = 3;
% tipChord = tipChordMin + XINdec(8).*(tipChordMax - tipChordMin);
tipChord = rootChord * 0.35;

% tipAngleMin = 0;
% tipAngleMax = 30;
% tipAngle = tipAngleMin + XINdec(9).*(tipAngleMax - tipAngleMin);
tipAngle = rootAngle;

tipAirfoilMin = 1;
tipAirfoilMax = 38;
tipAirfoil = round(tipAirfoilMin + XINdec(6).*(tipAirfoilMax - tipAirfoilMin));

X = ['Wing span: ', num2str(wingSpan), '   Dihedral: ', num2str(wingDihedral), '   AOA: ', num2str(wingAOA), '   Root Chord: ', num2str(rootChord),'   Root Airfoil: ', num2str(rootAirfoil), '    Tip Chord: ', num2str(tipChord), '  Tip Airfoil: ', num2str(tipAirfoil)];
disp(X)


iplothere=0;

    [preOutput] = funWingDesigner(wingSpan, wingDihedral, wingAOA, wingSweep, rootChord, rootAngle, rootAirfoil, tipChord, tipAngle, tipAirfoil);
    
% define output
    output= preOutput.totaldrag/preOutput.lift + 0.001*preOutput.bendmoment
    
    if(preOutput.lift<15)
        output = output*100;
    end
    
    disp(['runcount= ',num2str(runcount),' out of ',num2str(numruns),...
        ' : output= ',num2str(output)])




textXIN=[textbit1,'_XINout_PSOWingDesigner.txt'];   % ----------------

bigstring=[num2str(output) ' ' num2str(XINdec(1)) ' ' num2str(XINdec(2)) ' ' num2str(XINdec(3))  ' ' num2str(XINdec(4)) ' ' num2str(XINdec(5)) ' ' num2str(XINdec(6))];


dlmwrite(textXIN,bigstring,'delimiter','','newline','pc','-append')

% 11/3/16 added conditional statement for pvectori updating
if numruns>0
    pvector1(runcount)=preOutput.totaldrag/preOutput.lift;  % actual L/D value, w/o punishments
    pvector2(runcount)=output;     % cost function for optimization
end

% 10/13/16 "auto-save" added
% clear any old versions of file "temp.mat" on the harddrive
dos('del fun_temp.mat');
% save current variables
save fun_temp.mat


