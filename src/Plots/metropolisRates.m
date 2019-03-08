%% Script to create plot of 64 possible transitions versus site
clear all; close all;
folder = '~/Documents/PolymerGit/src/PolymerCode';
filename = 'OccupiediSitesMouse.txt';

% state matrix - 0 or 1;
phosphoStates = dlmread(fullfile(folder,filename),'_');

states = 1:1:64;
sites = 1:1:6;

% figure(1); clf; hold on; grid on;
% for i=1:6
% scatter(i,calculatedRate(:,i),'xr');
% scatter(i,zeroRate(:,i),'xk');
% end

figure(1); clf;
heatmap(states,sites,phosphoStates');

figure(2); clf;
heatmap(sites,states,phosphoStates);

%% Use rates matrix - sorted by combination

folder = '/Volumes/GoogleDrive/My Drive/Papers/MultisiteDisorder/Data_Figures/1.LocalStructuring/CD3Zeta/MembraneOn/1.OcclusionProbabilities/CatFiles';
filename = 'CD3ZetaMembrane1StiffenRange.5.cat';
locationTotal = 6;
iSiteTotal = 6;
NFil = 1;
% state matrix - 0 or 1;
    
    % initialize 
    OccupiedLocations = zeros(2^locationTotal,1);
    OccupiedLocationsMatrix = zeros(2^locationTotal,locationTotal);
    POcc = zeros(2^locationTotal,locationTotal);
    PBind = zeros(2^locationTotal,locationTotal);

    %readData_TransitionMatrix(filefolder,filesubfolder,filename);
    
    M = dlmread(fullfile(folder,filename));

    OccupiedLocations = M(:,end);

    OccupiedLocationsMatrix(:,1:locationTotal) = M(:,(end-locationTotal):(end-1));

    % up to total number of iSites - 6 for mouse CD3Zeta
    siteCounter = 1;
    
    % starting index - 8+2*(locationTotal+1) is output only once, 6+2 takes
    % us to the correct index in the filament output
    ind = 8+2*(locationTotal+1)+6+2; 
    for nf = 1:NFil
        
        if(nf>1)
            ind = ind + (6 + 7*iSiteTotal(nf-1) + 2 + NFil + NFil);
        end
        
        for iy = 1:iSiteTotal(nf)
            POcc(:,siteCounter) = M(:,ind + 7*(iy-1));
            siteCounter = siteCounter + 1;
        end
    end
    PBind(:,1:locationTotal) = 1-POcc(:,1:locationTotal);
    

states = 1:1:64;
sites = 1:1:6;

PBindPlot = (1-POcc).*(1-phosphoStates);

figure(3); clf;
hm = heatmap(states,sites,PBindPlot');
hm.ColorLimits = [0 max(PBindPlot(PBindPlot > 0))];


figure(4); clf;
hm = heatmap(sites,states,PBindPlot);
hm.ColorLimits = [0 max(PBindPlot(PBindPlot > 0))];


% %% Use rates matrix - sorted by binary order
% 
% folder = '/Volumes/GoogleDrive/My Drive/Papers/MultisiteDisorder/Data_Figures/1.LocalStructuring/CD3Zeta/MembraneOn/2.TransitionMatrices/Phos/';
% filename = 'LocalStructuringCD3ZetaMembraneOn.Kinase.-1';
% 
% % state matrix - 0 or 1;
% phosphoStates = reshape(dlmread(fullfile(folder,filename),'_'),[6,64])';
% 
% states = 1:1:64;
% sites = 6:-1:1;
% 
% figure(5); clf;
% heatmap(states,sites,phosphoStates');
% 
% figure(6); clf;
% heatmap(sites,states,phosphoStates);