%% Analysis of CD3 Zeta Mouse Gillespie Data
% Lara Clemens - lclemens@uci.edu

clear all;
close all;

%% Initialize

% initialization switch for which model we're inspecting
saveTF = 0;
spacing = 2; % 0 = CD3Zeta, 1 = EvenSites 2 = CD3Epsilon
%control = 0; % 0 = no control, 1 = control
membrane = 1; % 0 for membrane off, 1 for membrane on
model = 4; % 1 = stiffening, 2 = electrostatics, 3 = multiple binding - ibEqual, 4 = CD3 Epsilon electrostatics
save1 = 0; % save only ProbVSSequence plot
phos = 0; % 1 = phosphorylation, 0 = dephosphorylation

%% 

savefilefolder = '~/Documents/Papers/MultisiteDisorder/Figures';

switch (spacing)
    case 0
        iSiteSpacing = 'CD3Zeta';
    case 1
        iSiteSpacing = 'EvenSites';
    case 2
        iSiteSpacing = 'CD3Epsilon';
end

if (membrane)
    membraneState = 'On';
else
    membraneState = 'Off';
end

if (phos)
    phosDirection = 'Phos';
else
    phosDirection = 'Dephos';
end

switch (model)
    
    case 1
        
        % find files
        filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/1.LocalStructuring/';
        filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/3.Gillespie/Irreversible/',phosDirection,'/CatFiles'];
        filetitle = strcat('Gillespie',iSiteSpacing,'Membrane',num2str(membrane));
        
        %
        locationTotal = 6;
        sweep = -1:1:5; % includes control
        sweepParameter = 'StiffenRange';
        
        xlabelModel = 'Range of Stiffening';
        units = '(Kuhn lengths)';
        
        % create location to save figures
        savefilesubfolder = ['1.LocalStructuring/',iSiteSpacing,'/Membrane',membraneState,'/',phosDirection,'/Sequence'];
        
        % figure parameters
        lw = 2;
        ms = 10;
        colors = flipud(cool(9));
        legendlabels = {'No Stiffening', 'StiffenRange = 0','StiffenRange = 1','StiffenRange = 2','StiffenRange = 3','StiffenRange = 4','StiffenRange = 5','StiffenRange = 6','StiffenRange = 7','StiffenRange = 8','StiffenRange = 9','StiffenRange = 10'};
        legendlabelsAbbrev = {'None', '0','1','2','3','4','5','6','7','8','9','10'};
        
        
    case 2
      
        % find files
        filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/2.MembraneAssociation/';
        filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/3.Gillespie/Irreversible/',phosDirection,'/CatFiles'];
        filetitle = strcat('Gillespie',iSiteSpacing,'MembraneAssociation');
        
        %
        locationTotal = 6;
        sweep = 0:2:20; % includes control
        sweepParameter = 'EP0';
        
        % create location to save figures
        savefilesubfolder = ['2.MembraneAssociation/',iSiteSpacing,'/Membrane',membraneState,'/',phosDirection,'/Sequence'];
        
        % figure parameters
        lw = 2;
        ms = 10;
        colors = parula(11);
        legendlabelsAbbrev = {'0','1','2','3','4','5','6','7','8','9','10'};
        legendlabels = {['EP0', num2str(sweep)]};
        
        xlabelModel = 'EP0';
        units = 'kBT'; 
        
    case 3
        
        filefolder = '~/Documents/Papers/MultisiteDisorder/Data';
        filesubfolder = strcat(iSiteSpacing,'_','MultipleBindingMembrane',membraneState);
        
        filetitle = strcat('Gillespie',iSiteSpacing,'Membrane',num2str(membrane));
        sweepParameter = 'irLigand';
        
        legendlabels = {'irLigand = 1','irLigand = 2','irLigand = 3','irLigand = 4','irLigand = 5','irLigand = 6','irLigand = 7','irLigand = 8','irLigand = 9','irLigand = 10','irLigand = 11','irLigand = 12','irLigand = 13','irLigand = 14'};
        legendlabelsAbbrev = 1:14;
        
        locationTotal = 6;
        sweep = 1:1:14;
        
        xlabelModel = 'Radius of Binding Ligand';
        units = '(Kuhn lengths)';
        %
        % create location to save figures
        savefilesubfolder = strcat(filesubfolder,'/GillespiePlots');
        
        colors = cool(20);
        
     case 4
      
        % find files
        filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/2.MembraneAssociation/';
        filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/TwoSites/3.Gillespie/Irreversible/',phosDirection,'/CatFiles'];
        filetitle = strcat('Gillespie',iSiteSpacing,'MembraneAssociation');
        
        %
        locationTotal = 2;
        sweep = 0:2:20; % includes control
        sweepParameter = 'EP0';
        
        % create location to save figures
        savefilesubfolder = ['2.MembraneAssociation/',iSiteSpacing,'/Membrane',membraneState,'/',phosDirection,'/Sequence'];
        
        % figure parameters
        lw = 2;
        ms = 10;
        colors = parula(11);
        legendlabelsAbbrev = {'0','1','2','3','4','5','6','7','8','9','10'};
        legendlabels = {['EP0', num2str(sweep)]};
        
        xlabelModel = 'EP0';
        units = 'kBT'; 
        
end


%% Read Files
path = zeros(factorial(locationTotal),1);
avgTime = zeros(factorial(locationTotal),size(sweep,2)+1);
probability = zeros(factorial(locationTotal),size(sweep,2)+1);

for s=1:length(sweep)
   
    clear M;
    
    % set up filename
    if (sweep(s)==-1)
        filename = strcat(filetitle,'.Control.AllData');
    else
        filename = strcat(filetitle,sweepParameter,'.',num2str(sweep(s)),'.AllData');
    end
    
    % read in file
    M = dlmread(fullfile(filefolder,filesubfolder,filename));

    % create list of permutations of numbers 1-6
    permutations = perms(1:locationTotal);
    
    % create permutation strings then convert to number
    for j=1:factorial(locationTotal)
        permString = '';
        for k=1:locationTotal
            permString = strcat(permString,num2str(permutations(j,k)));
        end
        path(factorial(locationTotal)-(j-1)) = str2num(permString);
    end
    
    % attach path to each so becomes vector e.g. [path, avgTime]
    avgTime(:,1) = path(:);
    probability(:,1) = path(:);
    
    
    j=1;
    for k=1:size(M,1)-1
        while ((M(k+1,1) ~= path(j)) && j<=factorial(locationTotal))
            j=j+1;
        end
        probability(j,s+1) = M(k+1,4);
        avgTime(j,s+1) = M(k+1,5);
        j=j+1;
    end
    
end

%% Create matrices to be read by 'Bar' command

% want either just 654321 and 123456 or also Max and Min

sequentialAvgTime = zeros(2,size(sweep,2)+1);
sequentialProbability = zeros(2,size(sweep,2)+1);


sequentialAvgTime(1,:) = avgTime(1,:);
sequentialProbability(1,:) = probability(1,:);

sequentialAvgTime(2,:) = avgTime(factorial(locationTotal),:);
sequentialProbability(2,:) = probability(factorial(locationTotal),:);


%% Create bar graphs
switch (model)
    case 4
        sequence = {'12','21'};
    otherwise
        sequence = {'123456','654321'};
end

%% Plot Probability versus Sequence - No Labels

ax=figure(2); clf; box on; hold on;
b=bar(sequentialProbability(:,2:end));
w = (length(sequentialProbability)-1);
for l=1:length(sequentialProbability)-1
    b(l).FaceColor = colors(l,:);
    b(l).EdgeColor = colors(l,:);
end
% print reference line
hline = refline([0 1/factorial(locationTotal)]);
hline.Color = 'k';
hline.LineWidth = 2.5;
hline.LineStyle = '--';

% axis labels
set(gca,'xtick',[1,2]);
set(gca,'xticklabel',[]);
switch (model)
    case 1
        if(phos)
            ylim([0 0.012]);
        else
            ylim([0 0.012]);
        end
    case 2
        if(phos)
            ylim([0 0.016]);
            yticks([0 0.002 0.004 0.006 0.008 0.01 0.012 0.014 0.016]);
        else
            ylim([0 4*10^(-3)]);
            yticks(10.^(-3).*[0 0.5 1 1.5 2 2.5 3 3.5 4]);
        end
    case 3
    case 4
end
set(gca,'yticklabel',[]);

% print position and labels
pos = get(gca, 'position');
set(gcf,'units','inches','position',[1,1,3,3]); set(gca,'units','inches','position',[0.5,0.5,1.9,1.9]);
%set(gca,'units','inches','position',[0.5,0.5,1.7,1.2]);

if (save1)
    % % save figure
    savefiletitle = 'ProbVSSequence';
    saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'fig');
    print('-painters',fullfile(savefilefolder,savefilesubfolder,savefiletitle),'-depsc');
%     saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'epsc');
end

%% Plot Probability versus Sequence - Labels

ax=figure(20); clf; box on; hold on;
b=bar(sequentialProbability(:,2:end));
w = (length(sequentialProbability)-1);
for l=1:length(sequentialProbability)-1
    b(l).FaceColor = colors(l,:);
    b(l).EdgeColor = colors(l,:);
end
% print reference line
hline = refline([0 1/factorial(locationTotal)]);
hline.Color = 'k';
hline.LineWidth = 2.5;
hline.LineStyle = '--';

% axis labels
set(gca,'xtick',[1 2]);
set(gca,'xticklabel',sequence);
xlabel1 = 'Sequence';
ylabel1 = 'Probability';
title1 = 'Probability vs Sequence';
switch (model)
    case 1
        if(phos)
            ylim([0 0.012]);
        else
            ylim([0 0.012]);
        end
    case 2
        if(phos)
            ylim([0 0.016]);
            yticks([0 0.002 0.004 0.006 0.008 0.01 0.012 0.014 0.016]);
        else
            ylim([0 4*10^(-3)]);
            yticks(10.^(-3).*[0 0.5 1 1.5 2 2.5 3 3.5 4]);
        end
    case 3
    case 4
end

% print position and labels
pos = get(gcf, 'position');
set(gcf,'units','centimeters','position',[1,4,40,30]);
set(gca,'FontName','Arial','FontSize',30);
xlabel(xlabel1,'FontName','Arial','FontSize',24);
ylabel(ylabel1,'FontName','Arial','FontSize',24);
title(title1,'FontName','Arial','FontSize',24);

% colorbar
switch (model)
    case 1
        set(gcf,'Colormap',cool)
        colormap cool;
        h = colorbar;
        h = colorbar('Ticks',[0 7/9],'TickLabels',{'',''},'YDir','Reverse');
        set(h,'ylim',[0 7/9]);
    case 2
        set(gcf,'Colormap',parula)
        colormap parula;
        h = colorbar;
        h = colorbar('Ticks',[0 1],'TickLabels',{'',''});
        set(h,'ylim',[0 1]);
end

%legend(horzcat(legendlabels,{'Random Probability = 1/720'}),'Location','northwest');
if (save1)
    % % save figure
    savefiletitle = 'ProbVSSequenceLabels';
    saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'fig');
    print('-painters',fullfile(savefilefolder,savefilesubfolder,savefiletitle),'-depsc');
    %saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'epsc');
end

%% Create Sorted Graphs
% removes association with path once sorted for plot purposes (i.e. x-axis
% is rank, not sequence)
% want to be able to know which one is 123456, 654321

sortedAvgTimeSweep = zeros(factorial(locationTotal),size(sweep,2));
sequenceRankAvgTime = zeros(2,size(sweep,2));
sequenceRankAvgTimeMemToTail = zeros(2,size(sweep,2));
sequenceRankAvgTimeTailToMem = zeros(2,size(sweep,2));

sortedProbabilitySweep = zeros(factorial(locationTotal),size(sweep,2));
sequenceRankProbability = zeros(2,size(sweep,2));


for s = 1:size(sweep,2)
    % AVERAGE TIME
    %initialize
    preSortAvgTime = zeros(factorial(locationTotal),2);
    sortedAvgTime = zeros(factorial(locationTotal),2);
    
    % collect path and avgTime data one column at a time, sort, pull out
    % data for 123456, 654321
    preSortAvgTime(:,1) = path;
    preSortAvgTime(:,2) = avgTime(:,s+1);
    sortedAvgTime = sortrows(preSortAvgTime,2);
    
    % what is this one for?
    sequenceRankAvgTime(1,s) = find(sortedAvgTime(:,1)==str2num(sequence{1}));
    sequenceRankAvgTime(2,s) = find(sortedAvgTime(:,1)==str2num(sequence{2}));
    
    % collect location in sequenceRankAvgTime of 123456, 654321
    sequenceRankAvgTimeMemToTail(1,s) = find(sortedAvgTime(:,1)==str2num(sequence{1}));
    sequenceRankAvgTimeTailToMem(1,s) = find(sortedAvgTime(:,1)==str2num(sequence{2}));
    
    % collect average time
    sequenceRankAvgTimeMemToTail(2,s) = sortedAvgTime(sequenceRankAvgTimeMemToTail(1,s),2);
    sequenceRankAvgTimeTailToMem(2,s) = sortedAvgTime(sequenceRankAvgTimeTailToMem(1,s),2);
    
    sortedAvgTimeSweep(:,s) = sortedAvgTime(:,2);
    
    
    %PROBABILITY
    preSortProbability = zeros(factorial(locationTotal),2);
    sortedProbability = zeros(factorial(locationTotal),2);
    
    preSortProbability(:,1) = path;
    preSortProbability(:,2) = probability(:,s+1);
    sortedProbability = sortrows(preSortProbability,2);
    sequenceRankProbability(1,s) = find(sortedProbability(:,1)==str2num(sequence{1}));
    sequenceRankProbability(2,s) = find(sortedProbability(:,1)==str2num(sequence{2}));
    
    sequenceRankProbabilityMemToTail(1,s) = find(sortedProbability(:,1)==str2num(sequence{1}));
    sequenceRankProbabilityTailToMem(1,s) = find(sortedProbability(:,1)==str2num(sequence{2}));
    
    sequenceRankProbabilityMemToTail(2,s) = sortedProbability(sequenceRankProbabilityMemToTail(1,s),2);
    sequenceRankProbabilityTailToMem(2,s) = sortedProbability(sequenceRankProbabilityTailToMem(1,s),2);
    
    
    sortedProbabilitySweep(:,s) = sortedProbability(:,2);
    
end
%% Plot Probability vs Rank
figure(41); clf;

for s = 1:size(sweep,2)

    figure(41); hold on; box on;
    plot(1:1:factorial(locationTotal),sortedProbabilitySweep(:,s),'-k','LineWidth',lw);
end


markerlabels = {['Sequence = ',sequence{1}],['Sequence = ',sequence{2}]};
legendlabelswithmarkers = horzcat(legendlabels,markerlabels)

figure(41); hold on;
plot(sequenceRankProbabilityMemToTail(1,:),sequenceRankProbabilityMemToTail(2,:),'xk','LineWidth',lw,'MarkerSize',ms);
plot(sequenceRankProbabilityTailToMem(1,:),sequenceRankProbabilityTailToMem(2,:),'ok','LineWidth',lw,'MarkerSize',ms);
plot([1 factorial(locationTotal)],[1/factorial(locationTotal) 1/factorial(locationTotal)],'--k','LineWidth',2);
xlabel1 = 'Rank';
ylabel1 = 'Probability';
title1 = 'Probability vs Rank';
pos = get(gcf, 'position');
set(gcf,'units','centimeters','position',[1,4,40,30]);
set(gca,'FontName','Arial','FontSize',24);
xlabel(xlabel1,'FontName','Arial','FontSize',24);
ylabel(ylabel1,'FontName','Arial','FontSize',24);
title(title1,'FontName','Arial','FontSize',24);
legend(horzcat(legendlabelswithmarkers,{['Random Probability = 1/',num2str(factorial(locationTotal))]}),'Location','northwest');

if (saveTF)
    % % save figure
    savefiletitle = 'ProbVSRank';
    saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'fig');
    saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'epsc');
end