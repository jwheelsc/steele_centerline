%% read in the band 8 geotiff
clear variables
close all
    [X8,cmap] = geotiffread('E:\surge_project\LC80620172013248LGN00_B8.TIF');
    %%
    xArr8 = linspace(cmap.XWorldLimits(1),cmap.XWorldLimits(2),length(X8(1,:)));
    yArr8 = linspace(cmap.YWorldLimits(2),cmap.YWorldLimits(1),length(X8(:,1)));

    xRange = [530000 557000];
    yRange = [6770000 6799000];

    elXLw = find(abs(xArr8-xRange(1))<1000);
    xl8 = elXLw(end);
    elXUp = find(abs(xArr8-xRange(2))<1000);
    xu8 = elXUp(end);
    elYLw = find(abs(yArr8-yRange(1))<1000);
    yl8 = elYLw(end);
    elYUp = find(abs(yArr8-yRange(2))<1000);
    yu8 = elYUp(end);
    
    imagesc(xArr8,yArr8,X8)
    xlim([xArr8(xl8) xArr8(xu8)])
    ylim([yArr8(yl8) yArr8(yu8)])
    colormap gray
    set(gca,'xdir','reverse')
