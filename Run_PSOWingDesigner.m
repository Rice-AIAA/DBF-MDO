



clear
close all



global runcount     % counter to count the evaluations, defined in Run*.m
global pvector1     % a vector of actual L/D performace, from preoutput
global pvector2     % a vector of the cost function, from output
global XINarray1    % array of "as given" XINdec vector for each evaluation
global textbit1     % text that goes into the mesh and cfg filenames
global iplot        % set iplot=1 to make figures
global ifast        % set ifast=1 to run fast and skip some checks
global numruns      % numruns=PRPopSize.*PRNumGens
global icostwith    % cost function options
       



disp('  ')
PER_Code='Run_PSOWingDesigner.m';
PER_Date='092222';

runcount=0;
iplot=1;   % iplot=0 means to limit the number of plots generated --------
ifast=0;   % ifast=1 means to skip some checking steps to run faster






disp(' ****************** ')
disp(['Running script ',PER_Code])
disp('  ')
textbit1=input('Enter text segment for use in all filenames (test1) ','s');

if isempty(textbit1)==1
    disp('* setting textbit1 to default string    test1')
    textbit1='test1';
end
dotfig='.fig';
dotbmp='.bmp';
dotmat='.mat';





% 6/22/17 added new input for icostwith variable
%disp(' ****************** ')
%disp('icostwith variable options')

%icostwith=input('Enter cost function option (1) ');
% 1/3/13 default added for this term
%if isempty(icostwith)==1
%    disp('* setting icostwith to default value of 1')
    icostwith=1;
%end


    options=psooptimset;
% set the size of each population
    disp('   ')
    PRPopSize=input('Enter size of each generation (30) ');
% 12/29/12 default added
    if isempty(PRPopSize)==1
       disp('* setting PRPopSize to default value of 30')
       PRPopSize=30;
    end
    options.PopulationSize=PRPopSize;
%end  % end of "if irestart==0" block
% 9/7/16 end

disp('   ')
PRNumGens=input('Enter number of generations (20) ');

if isempty(PRNumGens)==1
    disp('* setting PRNumGens to default value of 20')
    PRNumGens=20;
end

options.Generations=PRNumGens;
maxevals=PRPopSize.*PRNumGens;
numruns=PRPopSize.*PRNumGens;


options.ConstrBoundary='reflect';
options.UseParallel='never';
options.Display='diagnose';
options.PlotFcns=@psoplotbestf;


timeatstart=clock

   

maxevals=0;
numruns=0;

inpop = rand(1,6);
figure(5)
bar(1,0)
hold on
plot([0 2],[PRPopSize PRPopSize],'k-')
title('Searching for Viable Initial Population')
ylabel('Number of Viable Solutions Found Thus Far')
axis([0 2 0 round(1.05*PRPopSize)])
view(2)
iplot=0;  % possible place to set iplot=1 or iplot=2 for initial pop plots
for i=1:(100*PRPopSize)  % BIG NUMBER of attempts, usually get a 10% return

      XINdec = rand(1,6);
    

    dumout=fun_PSOWingDesigner(XINdec); 
    
    dum=size(inpop);
    if dumout<77776 && dum(1)<PRPopSize  
        inpopold=inpop;
        inpop=[XINdec; inpopold];
        figure(5)
        dumsize=size(inpop);
        bar(1,dumsize(1))
        hold on
        plot([0 2],[PRPopSize PRPopSize],'k-')
        title('Searching for Viable Initial Population')
        ylabel('Number of Viable Solutions Found Thus Far')
        axis([0 2 0 round(1.05*PRPopSize)])
        pause(0.5)
    end
    if dum(1)==PRPopSize
        break
    end
end
if i==100*PRPopSize
    disp(' could not find an initial population')
    stopped
end
% 11/19/17 use the newly found inital population
options.InitialPopulation=inpop;
maxevals=PRPopSize.*PRNumGens;
numruns=PRPopSize.*PRNumGens;
clear XINarray1
global XINarray1
clear pvector1
global pvector1
clear pvector2
global pvector2
runcount=0;  % reset runcount to 0 after finding the initial population
% 10/17/16 end
close(5)

% 9/7/16 end
iplot=0;  % reset to zero before running PSO


disp('  ')
disp(' Initial Population Found, Starting Optimizer')
disp('  ')


disp('---')
disp('options as run')
options
disp('---')
disp('   ')


numvar = 6;

varmin=zeros(1,numvar);
varmax=ones(1,numvar);


[XINdec,fval,exitflag,output,population,scores]=pso(@fun_PSOWingDesigner,...
    numvar,[],[],[],[],varmin,varmax,[],options);



timeatend=clock


% post-optimization call for the best p and t in temp.mat, for later reading
iplot=1;

% 5/18/start, change from
%outputdum=fun_PSOoptSHBody_5v_STL_Ax(XINdec);  % disabled 5/18/22
% to
outputdum=fun_PSOWingDesigner(XINdec);  % new 6/15/22
% 5/18/22 end



saveas(gcf,figname1)

disp('*********************************************************')
disp('  ')
disp(' best answers')
disp([' best XINdec= ',num2str(XINdec)])
disp([' best cost function value= ',num2str(fval)])

% 10/13/16 start, added new "autosave" feature
fileout=[textbit1,dotmat];
save(fileout)

dt_YMDHMS=timeatend-timeatstart

disp('  ')
disp('******')
disp(' Note: if you ended the optimization early, you must edit the')
% 5/18 start, change from
% to
disp(' *__XINout_PSOoptSHBody_BC468_STL.txt file and change the value for PRNumGens')
% 5/18 end
disp('  ')
disp(' Run Completed!')
disp('  ')

