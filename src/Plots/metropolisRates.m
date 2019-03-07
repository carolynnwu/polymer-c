%% Script to create plot of 64 possible transitions versus site
clear all; close all;
folder = '~/Documents/PolymerGit/src/PolymerCode';
filename = 'OccupiediSitesMouse.txt';

M = dlmread(fullfile(folder,filename),'_');

calculatedRate = (M>0);
zeroRate = (M==0)

figure(1); clf; hold on; grid on;
for i=1:6
scatter(i,calculatedRate(:,i),'xr');
scatter(i,zeroRate(:,i),'xk');
end