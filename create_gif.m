clear all

list = ls('/Volumes/Jeff HD/surge_project/strain_overlay/all_walsh/')

list1 = sort(strsplit(list))
list1 = list1(2:end)
% here is the output filname
filename = ['/Volumes/Jeff HD/surge_project/strain_overlay_all_walsh.gif']

% here i calculate the approximate interval based on average of 30.46 days
% per month

for i = 1:length(list1)
    
    a = list1{i}
    dyear(i) = (str2num(a(1:4))-13)*365
    dday(i) =  (str2num(a(5:7)))
    timeArr(i) = (dyear(i)+dday(i))
    
end

timeArr = ([timeArr(2:end)-timeArr(1:end-1) 200]/365)*2


% here is a loop where I stitch the images together
for i = 1:length(list1)
    imStr = ['/Volumes/Jeff HD/surge_project/strain_overlay/all_walsh/' list1{i}]
    % read in the image
    [A1,map] = imread(imStr);
%     A = A1(60:540,152:670,:); #all steele
%     A = A1(60:540,105:720,:); # upper walsh
    A = A1(161:442,105:720,:);
    % define the position of the text box
    position = [700 59];
    % insert the text box
%      A = insertText(A,position,cellstr(list1{i}(1:7)),'FontSize',24,'BoxColor','red','BoxOpacity',0.4);
    % convert the image to RGB
    [Im cmap] = rgb2ind(A, 256);
    % append and write the png to a .gif
	if i == 1;
		imwrite(Im,cmap,filename,'gif','LoopCount',Inf,'DelayTime',timeArr(i));
	else
		imwrite(Im,cmap,filename,'gif','WriteMode','append','DelayTime',timeArr(i));
	end
end