function cropped_image = amazing_race_segmenter(imName)
% read in file
im = imread(imName);

% crop image
imCrop = im(323:356,144:500,:);

finalSeg = im2bw(imCrop,graythresh(imCrop)*1.5);
cropped_image = bwmorph(finalSeg,'skel');

% imCrop(:,:,1) = double(imCrop(:,:,1)).*skelIm;
% imCrop(:,:,2) = double(imCrop(:,:,2)).*skelIm;
% imCrop(:,:,3) = double(imCrop(:,:,3)).*skelIm;
% imshow(skelIm);

% IMPORTANT NOTE: uncomment/add code about removal of small noisy components


% % gray scale image and histogram equalization
% J = im2double(histeq(rgb2gray(im)));
% % basic thresholding
% P = J > 0.8;
% % get the connected components
% CC = bwconncomp(P);
% objs = CC.NumObjects;
% 
% % remove small components - these are either noise or disconnected
% % components
% markDel = zeros(objs,1);
% for iter = 1 : objs
%     if size(CC.PixelIdxList{iter},1) < 20 || size(CC.PixelIdxList{iter},1)...
%             > 200
%         markDel(iter) = 1;
%     end
% end
% 
% CC.PixelIdxList(markDel == 1) = [];
% CC.NumObjects = objs - sum(markDel);
% 
% newPixList = [];
% imNew = zeros(CC.ImageSize);
% % recreate the image
% for iter = 1 : CC.NumObjects
%     newPixList = [newPixList; CC.PixelIdxList{iter}];
% end
% imNew(newPixList) = 1;
% 
% % get only the skeleton
% imNew = bwmorph(imNew,'skel');
% 
% [vertStrk, horzStrk] = strokeCalc(imNew);

% L = bwlabel(imNew);
% rgbIm = label2rgb(L);
% figure; imshow(rgbIm);
%

% imwrite(rgbIm,'colorimage.tif');

end



% function cntr = diag_stroke(pixList)
% cntr = 0; continueCtr = 0;
% for iter = 1 : size(pixList,1) - 1
%     if abs(pixList(iter+1,2) - pixList(iter,2)) == 1 && ...
%             abs(pixList(iter+1,1) - pixList(iter,1)) == 1
%         continueCtr = continueCtr + 1;
%     else
%         if continueCtr >= 4
%             cntr = cntr + 1;
%         end
%         continueCtr = 0;
%     end
% end
% end
