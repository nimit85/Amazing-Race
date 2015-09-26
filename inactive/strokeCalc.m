function [Vstr, Hstr] = strokeCalc(imNew)
% input to function is the binary skeletonized image

% use regionprops to get images/binary matrices for connected regions 
CC = bwconncomp(imNew);
stats = regionprops(CC,'Image');

% Filters
% horizontal strokes
hFilt = [-1 2 -1]'; % hFilt = [1 2 1; 0 0 0; -1 -2 -1]; % also possible
vFilt = hFilt';

Vstr = zeros(size(stats,1),1); Hstr = zeros(size(stats,1),1);
for iter = 1 : size(stats,1)
    imshow(stats(iter).Image);
    
    % vertical strokes
    vStrokes = conv2(double(stats(iter).Image),vFilt,'same');
    vStrokes(vStrokes < 0) = 0;
    vStrokes(vStrokes > 0) = 1;
    Vstr(iter) = vert_stroke(vStrokes);
    
    % horizontal strokes
    hStrokes = conv2(double(stats(iter).Image),hFilt,'same');
    hStrokes(hStrokes < 0) = 0;
    hStrokes(hStrokes > 0) = 1;
    Hstr(iter) = horz_stroke(hStrokes);
    
    % find diagonal strokes
    % Dstr = diag_stroke(APix);
end

% L = bwlabel(imNew);
% rgbIm = label2rgb(L);
% figure; imshow(rgbIm);
%

% imwrite(rgbIm,'colorimage.tif');

end

function cntr = vert_stroke(vStrokes)
% find all instances of 4 consecutive 1s - indicator of vert line
vert4s = conv2(vStrokes,[1 1 1 1]','same');
vert4s(vert4s < 4) = 0;
vert4s(vert4s == 4) = 1; % convert to [0 1] values for diff
diffV = diff(vert4s); % diff across rows to find consecutive 1s
cntr = numel(find(diffV == 1));
end

function cntr = horz_stroke(hStrokes)
% find all instances of 4 consecutive 1s - indicator of horz line
horz4s = conv2(hStrokes,[1 1 1 1],'same');
horz4s(horz4s < 4) = 0;
horz4s(horz4s == 4) = 1; % convert to [0 1] values for diff
diffH = diff(horz4s,1,2); % diff across columns to find consecutive 1s
cntr = numel(find(diffH == 1));
end