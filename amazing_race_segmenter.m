function cropped_image = amazing_race_segmenter(imName)
% read in file
im = imread(imName);

%Line where the capital letters of the names should top out at
top_row_ceil = 1;
%Line where the capital letters of the team names sit
top_row_floor = 12;

bottom_row_ceil_lower_case = 25;
bottom_row_ceil_upper_case = 22;
bottom_row_floor = 34;

low_size_threshold = 15;

% crop image
%imCrop = imfilter ( im(323:356,144:500,:), fspecial ( 'unsharp' ) );
imCrop = im(323:356,144:500,:);

% Characters are consistently found on the same 2 lines. The bottom of the bottom line 
% corresponds with the bottom on the image. The top of the top line is the top of the image. 
% There should be a space in between the lines. This FORCES that space (any white in the space
% was noise anyway)  
imCrop (top_row_floor + 1:bottom_row_ceil_upper_case - 1, 1:size(imCrop)(2), 1) = zeros(bottom_row_ceil_upper_case - 1 - top_row_floor, size(imCrop)(2));
imCrop (top_row_floor + 1:bottom_row_ceil_upper_case - 1, 1:size(imCrop)(2), 2) = zeros(bottom_row_ceil_upper_case - 1 - top_row_floor, size(imCrop)(2));
imCrop (top_row_floor + 1:bottom_row_ceil_upper_case - 1, 1:size(imCrop)(2), 3) = zeros(bottom_row_ceil_upper_case - 1 - top_row_floor, size(imCrop)(2));

if ( sum ( imCrop ) == 0 )
  cropped_image = zeros( size(imCrop)(1), size(imCrop)(2) );
  return
end

finalSeg = im2bw(imCrop,graythresh(imCrop)*1.5);
bwskel = bwmorph(finalSeg,'skel');

CC = bwconncomp(bwskel);

% IMPORTANT NOTE: uncomment/add code about removal of small noisy components

markDel = zeros(CC.NumObjects, 1);

for iter = 1:CC.NumObjects
    min_col = CC.ImageSize(2);
    max_col = 0;
    min_row = CC.ImageSize(1);
    max_row = 0;

    c_size = size(CC.PixelIdxList{iter});

    for i = 1:c_size(1)
        pix = CC.PixelIdxList{iter}(i);
        row = mod ( ( pix - 1 ), CC.ImageSize(1) ) + 1;
        col = floor ( ( pix - 1 ) / CC.ImageSize(1) ) + 1;

        if row < min_row
            min_row = row;
        end

        if row > max_row
	    max_row = row;
        end

        if col < min_col
    	    min_col = col;
        end

        if col > max_col
	    max_col = col;
        end
    end
    
	%Only keep capital name characters, capitol lower line characters, and lower case lower line characters
	  if ( !( ( min_row < top_row_ceil + 3 ) && ( max_row > top_row_floor - 3)) && !( ( (min_row < bottom_row_ceil_upper_case + 3) || ( min_row < bottom_row_ceil_lower_case + 3) ) && (max_row > bottom_row_floor - 3) ))
      markDel(iter) = 1;
    end    

	  %Remove components that are too wide (might loose a lot of
	  %characters)
	  %But comparison should be able to deal with a lot of this
	  %kind of noise
	  if ( max_col - min_col > 25 )
	     markDel(iter) = 1;
	     end
end

CC.PixelIdxList(markDel == 1) = [];
CC.NumObjects = CC.NumObjects - sum(markDel);

newPixList = [];
cropped_image = zeros(CC.ImageSize);
for iter = 1 : CC.NumObjects
    newPixList = [newPixList; CC.PixelIdxList{iter}];
end
cropped_image(newPixList) = 1;

% gray scale image and histogram equalization
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
