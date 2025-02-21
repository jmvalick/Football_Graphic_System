% Inputs: cameraParams, imagePointsCal, yrdLines
% Outputs: imagePoints

% Purpose:  Takes parameters from UI
%           Estimates extrinsics
%           Finds world points of defined yard lines
%           Returns Image points of scrimage and yard lines

function [imagePoints] = world_to_image(cameraParams, imagePointsCal, yrdLines)
    % Params
    yrdDis = 10.795; %mm
    fldWidth = 622.3; %mm

    % Estimate Extrinsics
    imagePoints = imagePointsCal;
    undistortedPoints = undistortPoints(imagePoints,cameraParams);
    worldPoints = [yardLine_to_world(yrdLines(1)); yardLine_to_world(yrdLines(2))];

    extriniscs = estimateExtrinsics(undistortedPoints,worldPoints,cameraParams.Intrinsics);

    % Get Intrinsics
    intrinsics = cameraParams.Intrinsics;
       
    % Get postions of line of scrimage and first down
    scrimLine = yrdLines(3);
    scrimPoints = yardLine_to_world(scrimLine);
    scrimPoints = [scrimPoints(1,:), 0; scrimPoints(2,:), 0];
    
    firstLine = yrdLines(4);
    offset = (scrimLine > 0) * (50) + (scrimLine <= 0) * (-50);
    firstXcord = yrdDis*(-scrimLine+offset+firstLine);
    firstPoints = [firstXcord,0,0; firstXcord,-fldWidth,0];
    
    lineWorldPoints = [scrimPoints; firstPoints];

    % Image points
    imagePoints = world2img(lineWorldPoints, extriniscs, intrinsics, ApplyDistortion=true);

    disp('Image Points: ');
    disp(imagePoints);
end

