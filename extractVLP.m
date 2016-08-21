function [final] = hello(imageName)
    rgbImage=imread(imageName);

    grayImage=rgb2gray(rgbImage);
 
    threshold = graythresh(grayImage);
   
    binaryImage=im2bw(grayImage, threshold);

    se = strel('disk',5);
    se4 = strel('disk',8);
    open = imopen(binaryImage,se);

    close = imclose(open, se);
    NoiseRemovedImage = bwareaopen(close, 5000);

    edgeDetect = edge(NoiseRemovedImage, 'sobel');
    edgeDetect = imdilate(edgeDetect,se4);

    edgeDetect = imdilate(edgeDetect,se4);
    edgeDetect = imfill(edgeDetect, 'holes');
    edgeDetect = imclearborder(edgeDetect,8);
    
    final = grayImage .* uint8(edgeDetect);
end


