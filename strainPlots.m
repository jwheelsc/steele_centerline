
clc
clear variables
close all
vpA = []
dvpA = []
% Fcrop = []
% not_i_16 = [5,7,8,9,10,24,25,26,36,43,44,48,50,52,54]
not_i_32 = [4,5,7,9,10,11,12,28,31,39,46,49,51,57]
keep_i_32 = [16,22,32,35,37,38,43,44,45,52,54,56,58,60,61,62,63]

%%% read in the landsat 8 image
% iL8 = imread('F:\surge_project\LC80630172015133LGN00_B8.TIF');
load('center.mat')
load('contC.mat')
load('GlLims.mat')
load('cSeas.mat')
load('cLAll.mat')
load('sf1M.mat')
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


%%
close all
f1 = figure('units','normalized','outerposition',[0 0 1 1])
fs = 10

count = 1

for ii = 1:length(keep_i_32)
    i = keep_i_32(ii)
% for i= 60
%     
    fName = fNameA{i};
    fNameTif = fNameTifA{i}; 

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
   
%     subplot(1,2,1)
%     imagesc(xArr,yArr,(vv))
%     xlim([xArr(xl) xArr(xu)])
%     ylim([yArr(yl) yArr(yu)])
%     c = colorbar
%     c.Label.String = 'm/d'
%     caxis([0 10])
% %     alpha(ih,'0.1')
%     ylabel('UTM northing')
%     xlabel('UTM easting')
%     set(gca,'xdir','reverse')
%     set(gca,'fontsize',fs)
%     hold on 
%     plot(OL2(:,1),OL2(:,2),'r')
%     hold on
%     plot(centerline(:,1),centerline(:,2),'r+')

%     vx = ncread(fName,'vx_masked');
%     vx = vx';
%     
%     figure
%     imagesc(xArr,yArr,(vx))
%     xlim([xArr(xl) xArr(xu)])
%     ylim([yArr(yl) yArr(yu)])
%     c = colorbar
%     c.Label.String = 'm/d'
%     caxis([0 10])
% %     alpha(ih,'0.1')
%     ylabel('UTM northing')
%     xlabel('UTM easting')
%     set(gca,'xdir','reverse')
%     set(gca,'fontsize',fs)
% %     hold on 
% %     plot(OL2(:,1),OL2(:,2),'r')
% %     hold on
% %     plot(centerline(:,1),centerline(:,2),'r+')

    vx = ncread(fName,'vx_masked');
    vx = vx';
    dxA = diff(xArr);
    dxM = repmat(dxA,length(vx(:,1)),1);
    xMid = xArr(1:end-1)+(dxA/2);
    dudx = (vx(:,2:end)-vx(:,1:end-1))./dxM;
    dudxA = (dudx(1:end-1,:)+dudx(2:end,:))/2;

    vy = ncread(fName,'vy_masked');
    vy = vy';
    dyA = diff(yArr);
    dyM = repmat(dyA',1,length(vx(1,:)));
    yMid = yArr(1:end-1)+(dyA/2);
    dvdy = (vy(2:end,:)-vy(1:end-1,:))./dyM;

    dvdyA = (dvdy(:,1:end-1)+dvdy(:,2:end))/2;

    dwdz = -(dudxA+dvdyA);

    %%
    subplot(1,2,1)
    imagesc(xMid,yMid,dwdz)
    colormap jet
    caxis([-2e-3 2.5e-3])
    cb = colorbar
    cb.Label.String = 'vertical strain rate'
    xRange = [530000 557000];
    yRange = [6770000 6799000];
    xlabel('UTM easting')
    ylabel('UTM northing')

    elXLw = find(abs(xMid-xRange(1))<1000);
    xl = elXLw(end);
    elXUp = find(abs(xMid-xRange(2))<1000);
    xu = elXUp(end);
    elYLw = find(abs(yMid-yRange(1))<1000);
    yl = elYLw(end);
    elYUp = find(abs(yMid-yRange(2))<1000);
    yu = elYUp(end);
    set(gca,'xdir','reverse')

    xlim([xMid(xl) xMid(xu)])
    ylim([yMid(yl) yMid(yu)])


    clML = [];
    for j = 1:length(centerAll(:,1))

        px = centerAll(j,1);
        py = centerAll(j,2);
        p1 = find(abs(xMid-px)<150.2);
        p1 = p1(end)
        clML(j,1) = p1;
        p2 = find(abs(yMid-py)<150.2);
        clML(j,2) = p2;

    end
%     clMLu = unique(clML,'rows');
    clMLu = clML
    
    vp = []
    dvp = []
    for j = 1:length(clMLu(:,1))
        xEl = clMLu(j,1);
        yEl = clMLu(j,2);
        xC = xMid(xEl);
        yC = yMid(yEl);
        if ii == 1
        hold on
        plot(xC,yC,'r+')
        end
        vp(j) = dwdz(yEl,xEl);

        dcC = cC-[xC,yC];
        dC = sqrt(sum(dcC.^2,2));
        min_dCel = find(dC==min(dC));
        dvp(j) = ccD(min_dCel);

    end
% return
    sp2 = subplot(1,2,2)
    day1 = str2num(fName(55:57));
    fracD = day1/365;
    elSB = ceil(fracD*seasB);
    elSBA(count) = elSB;
    colorB = seas(elSB,:);
    plot(dvp,vp,'ko','markerfacecolor',colorB)
    ylim([-2e-3 2.5e-3])
    xlim([0 40000])
    grid on
    title(['path ' fName(38:40) ' row ' fName(42:44) ' -- from ' fName(50:53) '-' fName(55:57) ' to ' fName(59:62) '-' fName(64:66) '---i = ' num2str(i)])
    set(gca,'fontsize',fs)
    pr = str2num(fName(39:40))
%     difLvp = length(vp)
%     if difLvp>83
%         ddv = difLvp-83
%         vpN = find(isnan(vp))
%         vp(vpN(1:ddv)) = []
%         dvp(vpN(1:ddv)) = []
%     end
    vpA(count,:) = vp; 
    dvpS(count,:) = dvp;
%     if pr == 63
%         vpA63(count,:) = vp; 
%         dvpS63(count,:) = dvp;
%     elseif pr == 62
%         vpA62(count,:) = vp; 
%         dvpS2(count,:) = dvp;   
%     end
    pause(.1)
    ylabel('Vertical strain rate (m/d)')
    xlabel('Centerline distance (m)')
    colormap(sp2,winter)
    cb2 = colorbar
    %     cb2.TickLabels = []
    cb2.Ticks = [0 1]
    cb2.TickLabels = {'Winter','Summer'}
    hold on
    plot(get(gca,'xlim'),[0 0],'k')
    
    count = count+1
    
%     sf1 = imfreehand()
%     sf1A{i} = sf1.getPosition
%     save('sf1M.mat','sf1A')
%     
%     sf = sf1A{i}
%     if isempty(sf)==0
%         hold on
%         plot(sf(:,1),sf(:,2),'b')
%     end
%     savePDFfunction(f1,['F:\surge_project\code\figures\strain_32\' fName(38:66)])
    sp2.NextPlot = 'ReplaceChildren';

end


return

%%
namArr = namArr(keep_i_32)
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
save('strain_32.mat','dvpSs','vpAs','namArr')
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
caxis([-2e-3 2.5e-3])
% xlim([0 35000])
ylabel('Day since Jan 01 - 2013')
xlabel('Centerline distance (m)')
cb = colorbar
cb.Label.String = 'Vertical strain rate (1/d)'
set(gca,'fontsize',18)
title('Steele glacier dwdz from 32 day pairs')
savePDFfunction(f2,'F:\surge_project\code\figures\strain_32')



%%

close all
f3 = surf(jDay,x1,vpAs')
xlabel('Day')
ylabel('Centerline distance (m)')
zlabel('Vertical strain rate (1/day)')
grid on
view([-170 45])
hold on
yl = get(gca,'ylim')
plot([365 365],yl,'r')
hold on
plot([365*2 365*2],yl,'r')
hold on
plot([365*3 365*3],yl,'r')
zlim(([-2e-3 2.5e-3]))
savefig('F:\surge_project\code\figures\strain_32_surface')
%%


delDay = jDay(2:end)-jDay(1:end-1)

timeArr = [delDay 32]*(1/(16*4))
f3=figure
for i = 1:length(keep_i_32)
    ii = keep_i_32(i)
    fName = fNameA{i};
    colorB = seas(elSBA(i),:);
    plot(dvpSs(i,:),vpAs(i,:),'ko','markerfacecolor',colorB)
    ylim(([-2e-3 2.5e-3]))
    xlim([10000 40000])
    grid on
    colormap 'winter'
    cb2 = colorbar
    cb2.Ticks = [0 1]
    cb2.TickLabels = {'Winter','Summer'}
    xlabel('Centerline distance (m)')
    ylabel('strain (1/d)')
    set(gca,'fontsize',18)
    title(['path ' fName(38:40) ' row ' fName(42:44) ' -- from ' fName(50:53) '-' fName(55:57) ' to ' fName(59:62) '-' fName(64:66)])
    savePDFfunction(f3,['F:\surge_project\code\figures\strain_32_dt\' fName(38:66)])
%     pause(timeArr(i))
    
end
