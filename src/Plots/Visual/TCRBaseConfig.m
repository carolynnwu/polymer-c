%% Plot TCR base configurations


baseSepDistance = [5,17]; % Kuhn lengths
NFIL = 6;
ms = 10;
xm=6;
ym=6;
colors_fil = [0.7 0 0; 0 0.5 0.8; 0 0.5 0; 0 0.8 0; 0.7 0 0.7; 1 0 0]
lw = 3;

for bSD = 1:length(baseSepDistance)
    for nf=1:1:NFIL
        rBase.x(bSD,nf)= sqrt(baseSepDistance(bSD).^2 + 2.5.^2) * cos( floor(nf/2)*(2*pi/3) + (-1)^(nf)*atan( 2.5/baseSepDistance(bSD)) );
        rBase.y(bSD,nf)= sqrt(baseSepDistance(bSD).^2 + 2.5.^2) * sin( floor(nf/2)*(2*pi/3) + (-1)^(nf)*atan( 2.5/baseSepDistance(bSD)) );
        rBase.z(bSD,nf)= 0;
    end
end



%% Plot base configurations

figure(1); clf; hold on; box on;
for nf=1:1:NFIL
    plot(rBase.x(1,nf).*0.3,rBase.y(1,nf).*0.3,'x','MarkerSize',ms,'Color',colors_fil(nf,:),'LineWidth',lw);
end
xlim([-xm,xm]);
ylim([-ym,ym]);
set(gcf,'Position',[1 1 400 400]);
xlabel('x (nm)','FontName','Arial','FontSize',18);
ylabel('y (nm)','FontName','Arial','FontSize',18);

figure(2); clf; hold on; box on;
for nf=1:1:NFIL
    plot(rBase.x(2,nf).*0.3,rBase.y(2,nf).*0.3,'x','MarkerSize',ms,'Color',colors_fil(nf,:),'LineWidth',lw);
end
xlim([-xm,xm]);
ylim([-ym,ym]);
set(gcf,'Position',[1 1 400 400]);
xlabel('x (nm)','FontName','Arial','FontSize',18);
ylabel('y (nm)','FontName','Arial','FontSize',18);


i1=3
i2=6

sqrt((rBase.x(1,i1)-rBase.x(1,i2)).^2+(rBase.y(1,i1)-rBase.y(1,i2)).^2)

i1 = 2
i2 = 5
sqrt((rBase.x(1,i1)-rBase.x(1,i2)).^2+(rBase.y(1,i1)-rBase.y(1,i2)).^2)


i1 = 1
i2 = 4
sqrt((rBase.x(1,i1)-rBase.x(1,i2)).^2+(rBase.y(1,i1)-rBase.y(1,i2)).^2)


i1 = 1
i2 = 6
sqrt((rBase.x(1,i1)-rBase.x(1,i2)).^2+(rBase.y(1,i1)-rBase.y(1,i2)).^2)

i1 = 2
i2 = 3
sqrt((rBase.x(1,i1)-rBase.x(1,i2)).^2+(rBase.y(1,i1)-rBase.y(1,i2)).^2)

i1 = 4
i2 = 5
sqrt((rBase.x(1,i1)-rBase.x(1,i2)).^2+(rBase.y(1,i1)-rBase.y(1,i2)).^2)