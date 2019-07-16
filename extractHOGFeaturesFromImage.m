function [features] = extractHOGFeaturesFromImage(img, cellSize)
    if numel(size(img))>=3  
        img = rgb2gray(img);
    end
    img = imbinarize(img);
    features= extractHOGFeatures(img,'CellSize',cellSize);
end

