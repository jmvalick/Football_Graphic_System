% Inputs: cameraParams, imagePointsCal, yrdLines, img
% Outputs: outImage

% Purpose:  Takes parameters from UI
%           Takes image points of scrimage and first down lines
%           Finds masks to filter out objects that are not the green field
%           and white lines
%           Draws lines based on image points and final mask

function [outImage] = first_and_ten(cameraParams, imagePointsCal, yrdLines, img)

    imagePoints = world_to_image(cameraParams, imagePointsCal, yrdLines);

    % Image mask of only green values
    greenThreshold = [50, 255]; 
    whiteThreshold = 100; 
    differenceThreshold = 75;
    %fieldMask = (img(:,:,2) >= greenThreshold(1) & img(:,:,2) <= greenThreshold(2)) & ...
    %        (img(:,:,1) < img(:,:,2)) & (img(:,:,3) < img(:,:,2)) | ...
    %        (img(:,:,1) >= whiteThreshold & img(:,:,2) >= whiteThreshold & img(:,:,3) >= whiteThreshold);
    fieldMask = (img(:,:,2) >= img(:,:,1) & img(:,:,2) >= img(:,:,3)) | ...
                (img(:,:,1) >= whiteThreshold & img(:,:,2) >= whiteThreshold & img(:,:,3) >= whiteThreshold & ...
                 abs(img(:,:,1)-img(:,:,2)) < differenceThreshold & abs(img(:,:,2)-img(:,:,3)) < differenceThreshold & abs(img(:,:,1)-img(:,:,3)) < differenceThreshold);

    % Draw lines
    numPoints = size(imagePoints, 1);
    [height, width, ~] = size(img);
    lines = ones(height, width, 3);
    for i = 1:2:numPoints
        if mod(i-1, 4) == 0
            color = 'blue';
        else
            color = 'yellow';
        end
        
        % Draw the line on linedImage
        lines = insertShape(lines, 'Line', [imagePoints(i,:), imagePoints(i+1,:)], 'Color', color, 'LineWidth', 35, 'Opacity', 1);
    end
    lines = uint8(lines * 255);

    % Threshold the grayscale image to create a binary mask
    threshold = 0.95;
    lineMask = lines(:,:,1) < threshold | lines(:,:,2) < threshold | lines(:,:,3) < threshold;
    
    % Combine green and line mask
    finalMask = min(lineMask, fieldMask);

    % Replace the values in linedImage with those from lines where finalMask is true
    linedImage = img;
    opacity = 0.65;
    for i = 1:height
        for j = 1:width
            if finalMask(i,j)==1
                linedImage(i,j,:) = (1-opacity) * double(linedImage(i,j,:)) + opacity * double(lines(i,j,:));
            end
        end
    end

    outImage = linedImage;

     disp("Lines Drawn");
end 