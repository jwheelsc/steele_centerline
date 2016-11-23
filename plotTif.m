% lsI = cellstr(ls('E:\surge_project\p062_r017_nc2tif\*_vv_*'))
%%
clc
clear variables
close all
vpA = []

%%% read in the landsat 8 image
% iL8 = imread('E:\surge_project\LC80620172013248LGN00_B8.TIF');
load('center.mat')

folderStr_63 = 'E:\surge_project\p063_r017\'
lsNames_63 = cellstr(ls([folderStr_63 '*_016_*.nc']));
lsNamesTif_63 = cellstr(ls([folderStr_63 '*_016_*.tif']));
for i = 1:length(lsNames_63)

    fName_63{i} = [folderStr_63 lsNames_63{i}];
    fNameTif_63{i}  = [folderStr_63 lsNamesTif_63{i}]; 
    
end
folderStr_62 = 'E:\surge_project\p062_r017\'
lsNames_62 = cellstr(ls([folderStr_62 '*_016_*.nc']));
lsNamesTif_62 = cellstr(ls([folderStr_62 '*_016_*.tif']));
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

for i = 1:length(fName)
% for i = 31

    fName = fNameA{i};
    fNameTif = fNameTifA{i}; 

    vv = ncread(fName,'vv_masked');
%     vv = flipud(vv);
%     vv = fliplr(vv);
    vv = vv';
    ncdisp(fName,'vv_masked')

    [X,cmap] = geotiffread(fNameTif);

    xArr = linspace(cmap.XWorldLimits(1),cmap.XWorldLimits(2),length(X(1,:,1)))
    yArr = linspace(cmap.YWorldLimits(2),cmap.YWorldLimits(1),length(X(:,1,1)))

    xRange = [530000 557000]
    yRange = [6770000 6799000]

    elXLw = find(abs(xArr-xRange(1))<1000)
    xl = elXLw(end)
    elXUp = find(abs(xArr-xRange(2))<1000)
    xu = elXUp(end)
    elYLw = find(abs(yArr-yRange(1))<1000)
    yl = elYLw(end)
    elYUp = find(abs(yArr-yRange(2))<1000)
    yu = elYUp(end)
%     xx = [1:length(vv(1,:))]
%     yy = [1:length(vv(:,1))]
%     close all
%     figure
%     ih = imagesc(xArr,yArr,(vv))
%     xlim([xArr(xl) xArr(xu)])
%     ylim([yArr(yl) yArr(yu)])
%     colorbar
%     caxis([0 7])
%     set(gca,'xdir','reverse')
%     hold on
%     plot(centerline(:,1),centerline(:,2),'r+')
    
    clML = [];
    for j = 1:length(centerline(:,1))

        px = centerline(j,1);
        py = centerline(j,2);
        p1 = find(abs(xArr-px)<150);
        clML(j,1) = p1;
        p2 = find(abs(yArr-py)<150);
        clML(j,2) = p2;

    end
    clMLu = unique(clML,'rows');
    keyboard
%     hold on
%     plot(xArr(clMLu(:,1)),yArr(clMLu(:,2)),'ro')
% %     hold on
% %     plot(xArr(clMLu(:,1)),yArr(clMLu(:,2)),'ro')
%     pause(0.1)
    
    
    for j = 1:length(clMLu(:,1))
        vp(j) = vv(clMLu(j,2),clMLu(j,1));
    end
%     figure(100)
% %     hold on
%     plot(vp,'.')
%     ylim([0 15])
    vpA(i,:) = vp;  

%     pause(1)
    
end

return

%%
clML = []
for i = 1:length(centerline(:,1))

    px = centerline(i,1)
    py = centerline(i,2)
    p1 = find(abs(xArr-px)<150)
    clML(i,1) = p1
    p2 = find(abs(yArr-py)<150)
    clML(i,2) = p2
    
end
clMLu = unique(clML,'rows')

%%
for i = 1:length(clMLu(:,1))

    vp(i) = vv(clMLu(i,2),clMLu(i,1));
    
end
figure
plot(vp,'o')

