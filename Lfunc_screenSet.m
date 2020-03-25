% 本函数用于屏幕的设定
% 需要用到psychtoolbox

% =================== code ===================================
function [rect figureHandle] = Lfunc_screenSet
screens = Screen( 'Screens');
screenNumber = max( screens );
rect=Screen('Rect', screenNumber);
rect=[0 rect(2) rect(3)-rect(1) rect(4)];
figureHandle = figure('Position',rect,'ToolBar','no','MenuBar','no','Color',[0 0 0]);
axis([rect(1) rect(3) rect(2) rect(4)]);
c = gca;
set(c,'Position',[0 0 1 1]);
set(c,'XLimMode','manual','YLimMode','manual');
axis off;hold on;
end
% ============================================================
