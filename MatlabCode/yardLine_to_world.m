% Inputs: yrdLine
% Outputs: wrldPoints

% Purpose:  Takes yard line
%           Returns the X, Y coordinates of 2 world points for the line

function wrldPoints = yardLine_to_world(yrdLine)
    yrdDis = 10.795; %mm
    fldWidth = 622.3; %mm

    offset = (yrdLine > 0) * (50) + (yrdLine <= 0) * (-50);
    Xcord = yrdDis*(-yrdLine+offset);
    wrldPoints = [Xcord,0; Xcord,-fldWidth];
end