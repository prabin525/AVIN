
function [imageMatrix] = imageProcess(imageName)
    rgbImage = imread(imageName);
    figure
    imshow(rgbImage);

    grayScaledImage = rgb2gray(rgbImage);

    %% Automatically sets best level of varying intensities
    threshold = graythresh(grayScaledImage); 

    %% Binary image in 0's and 1's; 0 -> Black and 1 -> White
    binaryImage = im2bw(grayScaledImage, threshold);

    %% Removes objects < 5000px
    NoiseRemovedImage = bwareaopen(binaryImage, 5000);
    %NoiseRemovedImage = bwmorph(bnw, 'thin',Inf);

    [a, b]= size(NoiseRemovedImage);

    NoiseRemovedImage = bwareaopen(binaryImage, floor((a/15)*(b/15)));
    %NoiseRemovedImage(1:floor(.9*a),1:2)=1;
    %NoiseRemovedImage(a:-1:(a-20),b:-1:(b-2))=1;

    %NoiseRemovedImage = bwmorph(bnw, 'thin',Inf);
    NoiseRemovedImage = medfilt2(NoiseRemovedImage);

    figure
    imshow(~NoiseRemovedImage);

    %% Label connected components
    [LabeledImage, No_of_LabeledImage]=bwlabel(NoiseRemovedImage);

    %figure
    %imshow(label2rgb(LabeledImage));

    %figure
    %imtool(LabeledImage, []);

    %% Measure properties of image regions into a rectangular box
    propied=regionprops(LabeledImage,'BoundingBox', 'Extrema', 'Centroid');

    %% Plotting Bounding Box
    sizes = size(propied,1);

    for n=1:sizes
       rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
    end


    %% Objects extraction with cropped and resized to 20x20px
    %cropImage = zeros(1,No_of_LabeledImage);
    %cropImage={};
    tic;
    %resizedImage = cell(1, No_of_LabeledImage);
    imageMatrix = zeros(No_of_LabeledImage,400);

    for n=1:No_of_LabeledImage
      [r,c] = find(LabeledImage==n);
      width = max(c) - min(c);
      height = max(r) - min(r);
      cropImage = imcrop(~NoiseRemovedImage, [min(c) min(r) width, height]);

      %% Removes circles or dots having dimensions 150x150px or less
      size_width = size(cropImage, 1);
      size_height = size(cropImage, 2);
      if (size_width <= 150) || (size_height <= 150)
            continue;
      end

      cropImage = imresize(cropImage, [20 20]);
      %resizedImage{n}= cropImage;
      imageMatrix(n,:) = reshape(cropImage,[],400);

      figure
      imshow(reshape(imageMatrix(n,:),20,20));
      
    end
    toc;
    
    imageMatrix( ~any(imageMatrix,2), : ) = [];  %rows
    %imageMatrix( :, ~any(imageMatrix,1) ) = [];  %columns
end





