function positionScreen = convert_reg(para , positionIntuos)
%positionIntuosScreen=convert_reg(para,positionIntuos)
%positionIntuos and positionIntuosScreen are n*2 matries, and positionIntuos(:,1) is
%x-value,positionIntuos(:,2) is y-value.para is 2*3 matrix.
%example:para=[a1 b1 c1;a2 b2 c2],positionIntuos=[x y],
%then positionIntuosScreen=[a1x+b1y+c1 a2x+b2y+c2]
rect=[0 0 1440 900];
% tab_coord=[1730,208; 3040,208; 1730,995; 3040,995];  % 左下，右下，左上，右上
tab_coord=[5,5; 48763,5; 5,30475; 48763,30475];  % 左下，右下，左上，右上

startingPos_tab = [(tab_coord(1,1)+tab_coord(2,1))/2 (tab_coord(1,2)+tab_coord(3,2))/2];
startingPos_scr = [rect(3)/2 rect(4)/2];
positionScreen = (positionIntuos-startingPos_tab) .* para + startingPos_scr;

