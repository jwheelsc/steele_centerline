% lsI = cellstr(ls('E:\surge_project\p062_r017_nc2tif\*_vv_*'))
%%
clc
clear variables
close all
vpA = []
% Fcrop = []
% not_i_16 = [5,7,8,9,10,24,25,26,36,43,44,48,50,52,54]
not_i_32 = [4,5,7,9,10,11,12,28,31,39,46,49,51,57]

%%% read in the landsat 8 image
% iL8 = imread('F:\surge_project\LC80630172015133LGN00_B8.TIF');
load('center.mat')
load('contC.mat')
load('GlLims.mat')
load('cSeas.mat')
seasB = length(seas(:,1))

cC = contCenter;
diffD = cC(2:end,:)-cC(1:end-1,:);
centerD = [0;sqrt(sum(diffD.^2,2))];
ccD = cumsum(centerD);

folderStr_63 = 'F:\surge_project\p063_r017\'
lsNames_63 = cellstr(ls([folderStr_63 '*_032_*.nc']));
lsNamesTif_63 = cellstr(ls([folderStr_63 '*_032_*.tif']));
for i = 1:length(lsNames_63)

    fName_63{i} = [folderStr_63 lsNames_63{i}];
    fNameTif_63{i}  = [folderStr_63 lsNamesTif_63{i}]; 
    
end
folderStr_62 = 'F:\surge_project\p062_r017\'
lsNames_62 = cellstr(ls([folderStr_62 '*_032_*.nc']));
lsNamesTif_62 = cellstr(ls([folderStr_62 '*_032_*.tif']));
for i = 1:length(lsNames_62)

    fName_62{i} = [folderStr_62 lsNames_62{i}];
    fNameTif_62{i}  = [folderStr_62 lsNamesTif_62{i}]; 
    
end
fName = [fName_62,fName_63];
fNameTif = [fNameTif_62,fNameTif_63];
for i = 1:length(fName)

    varN = fName{i};
    namArr{i} = varN(50:57);
    
end
[blank,elSrt] = sort(namArr);
fNameA = fName(elSrt);
fNameTifA = fNameTif(elSrt);

loopArr = 1:length(fName)
loopArr(not_i_32)=[] 


close all
f1 = figure('units','normalized','outerposition',[0 0 1 1])
fs = 10

count = 1

for ii = 1:length(loopArr)
    i = loopArr(ii);
% for i= 38
    
    fName = fNameA{i};
    fNameTif = fNameTifA{i}; 

    vv = ncread(fName,'vv_masked');
    vv = vv';
%     ncdisp(fName,'vv_masked')

    [X,cmap] = geotiffread(fNameTif);

    xArr = linspace(cmap.XWorldLimits(1),cmap.XWorldLimits(2),length(X(1,:,1)));
    yArr = linspace(cmap.YWorldLimits(2),cmap.YWorldLimits(1),length(X(:,1,1)));

    xRange = [530000 557000];
    yRange = [6770000 6799000];

    elXLw = find(abs(xArr-xRange(1))<1000);
    xl = elXLw(end);
    elXUp = find(abs(xArr-xRange(2))<1000);
    xu = elXUp(end);
    elYLw = find(abs(yArr-yRange(1))<1000);
    yl = elYLw(end);
    elYUp = find(abs(yArr-yRange(2))<1000);
    yu = elYUp(end);

    sp1 = subplot(1,2,1)
%     i8 = imagesc(xArr,yArr,iL8)
%     xlim([xArr(xl) xArr(xu)])
%     ylim([yArr(yl) yArr(yu)])
%     colormap gray
%     set(gca,'xdir','reverse')
%     hold on 
%     plot(OL2(:,1),OL2(:,2),'r')
%     return
    imagesc(xArr,yArr,(vv))
    xlim([xArr(xl) xArr(xu)])
    ylim([yArr(yl) yArr(yu)])
    c = colorbar
    c.Label.String = 'm/d'
    caxis([0 10])
%     alpha(ih,'0.1')
    ylabel('UTM northing')
    xlabel('UTM easting')
    set(gca,'xdir','reverse')
    set(gca,'fontsize',fs)

%     hold on
%     plot(centerline(:,1),centerline(:,2),'r+')
    
    clML = [];
    for j = 1:length(centerline(:,1))

        px = centerline(j,1);
        py = centerline(j,2);
        p1 = find(abs(xArr-px)<150.2);
        p1 = p1(end)
        clML(j,1) = p1;
        p2 = find(abs(yArr-py)<150);
        clML(j,2) = p2;

    end
    clMLu = unique(clML,'rows');
    hold on
    
    for j = 1:length(clMLu(:,1))
        xEl = clMLu(j,1);
        yEl = clMLu(j,2);
        xC = xArr(xEl);
        yC = yArr(yEl);
        subplot(1,2,1)
        hold on
        plot(xC,yC,'r+')
        vp(j) = vv(yEl,xEl);
        
        dcC = cC-[xC,yC];
        dC = sqrt(sum(dcC.^2,2));
        min_dCel = find(dC==min(dC));
        dvp(j) = ccD(min_dCel);
       
    end
%     sp1.NextPlot = 'ReplaceChildren';
    sp2 = subplot(1,2,2)
    day1 = str2num(fName(55:57));
    fracD = day1/365;
    elSB = ceil(fracD*seasB);
    elSBA(count) = elSB;
    colorB = seas(elSB,:);
    plot(dvp,vp,'ko','markerfacecolor',colorB)
    ylim([0 15])
    grid on
    title(['path ' fName(38:40) ' row ' fName(42:44) ' -- from ' fName(50:53) '-' fName(55:57) ' to ' fName(59:62) '-' fName(64:66) '---i = ' num2str(i)])
%     sp2.NextPlot = 'ReplaceChildren';

    set(gca,'fontsize',fs)

    vpA(count,:) = vp; 
    dvpS(count,:) = dvp;
    pause(.1)
    ylabel('Speed (m/d)')
    xlabel('Centerline distance (m)')
    colormap(sp2,winter)
    cb2 = colorbar
%     cb2.TickLabels = []
    cb2.Ticks = [0 1]
    cb2.TickLabels = {'Winter','Summer'}
%     savePDFfunction(f1,['F:\surge_project\code\figures\vel_32\' fName(38:66)])
   
%     Fcrop(i) = getframe(f1)
    count = count+1
%     pause(1)
    
end
return
% %%
% %% And finally to play the movie
% movie(f1,Fcrop,1,2,[0 0 0 0])
% % where f1 is a figure with the same size as the one in which the plot was made
% % and here 4 is the number of fram per second and F is the array of frames stored
% 
% %%
% % And to make an actual video
% Steele_center_16 = VideoWriter('Steele_center_16.avi');
% open(Steele_center_16)
% writeVideo(Steele_center_16,Fcrop)
% close(Steele_center_16)
% 
% return

%%
namArr(not_i_32) = []

for i = 1:length(namArr)
    
    v = namArr{i}
    year1(i) = str2num(v(1:4))
    day1(i) = str2num(v(6:8))

end

jDay = ((year1-2013)*365)+day1
[jDay,elS] = sort(jDay)


%%

[x1,els] = sort(dvpS(1,:))
dvpSs = dvpS(:,els)
vpAs = vpA(:,els)

%%
close all
f2 = figure
ih = imagesc(x1,jDay,vpAs)

xls = get(gca,'xlim')
hold on
plot([xls(1) xls(2)],[365 365],'r')
hold on
plot([xls(1) xls(2)],[365*2 365*2],'r')
hold on
plot([xls(1) xls(2)],[365*3 365*3],'r')
t = text(0.1,120,'2013')
t.Color = 'r'
t = text(0.1,365+30,'2014')
t.Color = 'r'
t = text(0.1,365*2+30,'2015')
t.Color = 'r'
t = text(0.1,365*3+30,'2016')
t.Color = 'r'
ylabel('Day since Jan 01 - 2013')
xlabel('Centerline distance (m)')
cb = colorbar
cb.Label.String = 'Speed (m/d)'
set(gca,'fontsize',18)
title('Steele glacier velocity from 32 day pairs')
% savePDFfunction(f2,'F:\surge_project\code\figures\vel_32')

%%

close all
f3 = surf(jDay,x1,vpAs')
xlabel('Day')
ylabel('Centerline distance (m)')
zlabel('Speed (m/day)')
grid on
view([-170 45])
hold on
yl = get(gca,'ylim')
plot([365 365],yl,'r')
hold on
plot([365*2 365*2],yl,'r')
hold on
plot([365*3 365*3],yl,'r')
% savefig('F:\surge_project\code\figures\vel_32_surface')
%%


delDay = jDay(2:end)-jDay(1:end-1)

timeArr = [delDay 32]*(1/(16*4))
f3=figure
for i = 1:length(loopArr)
    ii = loopArr(i)
    fName = fNameA{ii};
    colorB = seas(elSBA(i),:);
    plot(dvpSs(i,:),vpAs(i,:),'ko','markerfacecolor',colorB)
    ylim([0 15])
    xlim([0 45000])
    grid on
    colormap 'winter'
    cb2 = colorbar
    cb2.Ticks = [0 1]
    cb2.TickLabels = {'Winter','Summer'}
    xlabel('Centerline distance (m)')
    ylabel('Speeed (m/d)')
    set(gca,'fontsize',18)
    title(['path ' fName(38:40) ' row ' fName(42:44) ' -- from ' fName(50:53) '-' fName(55:57) ' to ' fName(59:62) '-' fName(64:66)])
    savePDFfunction(f3,['F:\surge_project\code\figures\vel_32_dt\' fName(38:66)])
%     pause(timeArr(i))
    
end




