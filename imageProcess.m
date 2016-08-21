function [imageMatrix] = imageProcess(imageName)
    grayScaledImage = extractVLP(imageName);

    %% Automatically sets best level of varying intensities
    threshold = graythresh(grayScaledImage);

    %% Binary image in 0's and 1's; 0 -> Black and 1 -> White
    binaryImage=im2bw(grayScaledImage, 0.5);

    se = strel('disk',5);

    open = imopen(binaryImage,se);
    close = imclose(open, se);

    %% Removes objects < 30px
    NoiseRemovedImage = bwareaopen(close, 30);
 
    %% Noise removal using median filter
    [a, b]= size(NoiseRemovedImage);
    NoiseRemovedImage = bwareaopen(NoiseRemovedImage, floor((a/15)*(b/15)));
    NoiseRemovedImage = medfilt2(NoiseRemovedImage);
    temp = NoiseRemovedImage;

    for ii=1:size(temp,1)
         if(ii <= 870) && (ii >= 820)
             temp(ii,:) = 1;
         end
    end

    % important to place ~ sign
    region=regionprops(~temp,'BoundingBox');
    
    bb = vertcat(region(:).BoundingBox);
    nsize = size(region,1);
    thresh = size(temp,2) - 5;
     
    for ii=nsize:-1:1
        widthb = bb(ii,3);
        heightb = bb(ii,4);

        if (widthb < thresh) || (heightb <= 110)
            region(ii) = [];
        end
    end


    bb = vertcat(region(:).BoundingBox);
    nsize = size(region,1);
     
    for ii=1:nsize
        for jj = 1:10
            top = int16(bb(ii,2));
            bottom = int16(bb(ii,2) + bb(ii,4));
            temp(bottom+jj-1,:) = 0;
            if ii > 1
                temp(top-jj,:) = 0;
            end
        end
    end
    
    row_segment = cell(1, nsize);

%     figure
%     imshow(~temp);
    
    for ii = 1:nsize
        wb = bb(ii,3);
        hb = bb(ii,4);

        row_segment{ii}= imcrop(temp, [bb(ii,1) bb(ii,2) wb hb]);

    end

    LabeledImage = cell(1, nsize);
    No_of_LabeledImage = zeros(1,nsize);
    matrixSize = 0;

    for ii=1:nsize
         %% Label connected components
        [LabeledImage{ii}, No_of_LabeledImage(ii)]=bwlabel(row_segment{ii});
        matrixSize = matrixSize + No_of_LabeledImage(ii);
    end

    imageMatrix = zeros(matrixSize,400);
    totalRow = 0;

    for loop = 1:nsize

        %% Measure properties of image regions into a rectangular box
        propied=regionprops(LabeledImage{loop},'BoundingBox');
        propbb = vertcat(propied(:).BoundingBox);
        discNum = 1;
        discard = zeros(1,size(propied,1));

        for ii=size(propied,1):-1:1
            widthp = propbb(ii,3);

            if (widthp > 2000)
                propied(ii) = [];
                discard(discNum) = ii;
                discNum = discNum + 1;
            end
        end

        %% Plotting Bounding Box
        sizes = size(propied,1);

%         for n=1:sizes
%             rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
%         end

        f = No_of_LabeledImage(loop);

        for n=1:f
          totalRow = totalRow + n;
          checkVal = find(discard == n);
          if(checkVal)
              continue;
          end
          [r,c] = find(LabeledImage{loop}==n);
          width = max(c) - min(c);
          height = max(r) - min(r);
          cropImage = imcrop(~row_segment{loop}, [min(c) min(r) width height]);

          %% Removes circles or dots having dimensions 150x150px or less
          size_width = size(cropImage, 1);
          size_height = size(cropImage, 2);
          if (size_width <= 150) || (size_height <= 150)
                continue;
          end

          cropImage = imresize(cropImage, [20 20]);
          imageMatrix(totalRow,:) = reshape(cropImage,[],400);

%           figure
%           imshow(reshape(imageMatrix(totalRow,:),20,20));

        end
    end

    imageMatrix( ~any(imageMatrix,2), : ) = [];  %rows
end
