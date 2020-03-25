%% reletive angle to target calculation

clear all
% close all
% cd('D:\mine\lab\projects\motor learning with tDCS\data');

% fileName='GR_Sham_all_30';
fileName='GR_Anodal_all_27';
% fileName='EC_Sham_all_41';
% fileName='EC_Anodal_all_42';

% fileName='EC_subj41_s';

load(fileName);
% blockNum=[10 10 40 40 10 10 10 40 4010];
targetDeg = [0 45 90 135 180 225 270 315];
trialNum=8;

fontType = 'Times New Roman';
tickFontSize = 16;
lableFontSize = 24;
titleFontSize = 28;
figure(2);
% set(gcf,'outerposition',get(0,'screensize'));
colorArray={'b','c','g','k','b','c','r','k'};
Slow=0.3;
for subj_i = 1:length(expInfo.subj_name)
    
    % --- calculate relatie angle error
    direction = squeeze(trialInfo(subj_i,:,1));
    target_angle = (direction - 1).*45;
    rel_angle = squeeze(endData(subj_i,:,3)) - target_angle;
    % large deviation for direction 1 is actually negative deviation
    rel_angle(find(direction ==1 & rel_angle>180)) = rel_angle(find(direction ==1 & rel_angle>180)) - 360;
    % large negative deivation for direction 8 is actually postive deviation
    rel_angle(find(direction ==8 & rel_angle<-180)) = rel_angle(find(direction ==8 & rel_angle<-180)) + 360;
    %large positive deviation for direction 2 is actually negative deviation
    rel_angle(find(direction ==2 & rel_angle>180)) = rel_angle(find(direction ==2 & rel_angle>180)) - 360;
    endData(subj_i,:,5) = rel_angle;
    endData(subj_i,:,6) = rel_angle>90 | rel_angle<-90;
    
    rel_angle = squeeze(peakData(subj_i,:,3)) - target_angle;
    % large deviation for direction 1 is actually negative deviation
    rel_angle(find(direction ==1 & rel_angle>180)) = rel_angle(find(direction ==1 & rel_angle>180)) - 360;
    % large negative deivation for direction 8 is actually postive deviation
    rel_angle(find(direction ==8 & rel_angle<-180)) = rel_angle(find(direction ==8 & rel_angle<-180)) + 360;
    %large positive deviation for direction 2 is actually negative deviation
    rel_angle(find(direction ==2 & rel_angle>180)) = rel_angle(find(direction ==2 & rel_angle>180)) - 360;
    peakData(subj_i,:,7) = rel_angle;
    peakData(subj_i,:,8) = (rel_angle>90) | (rel_angle<-90);
    
    direction_temp = squeeze(trialInfo(subj_i,:,1));
    
    for dir_i=1:8
        %     title(num2str(subj_i));
        subplot(8,2,dir_i.*2-1);
        plot(squeeze(endData(subj_i,find(direction_temp==dir_i),3)),'b.','MarkerSize',10);
        hold on;
        %     plot(squeeze(peakData(subj_i,find(direction_temp==dir_i),3)),'r.','MarkerSize',10);
        %time outlier marked as green dot
        plot(find(ismember(find(direction_temp==dir_i),find(MoveTime(subj_i,:)>Slow&direction_temp==dir_i))==1),...
            squeeze(endData(subj_i,find(MoveTime(subj_i,:)>Slow&direction_temp==dir_i),3)),'g.','MarkerSize',10);
        %     plot(find(ismember(find(direction_temp==dir_i),find(MoveTime(subj_i,:)>Slow&direction_temp==dir_i))==1),...
        %         squeeze(peakData(subj_i,find(MoveTime(subj_i,:)>Slow&direction_temp==dir_i),3)),'c.','MarkerSize',10);
        
        title(['subj ' num2str(subj_i) ' dir ' num2str(dir_i)]);
        
        subplot(8,2,dir_i.*2)
        plot(squeeze(endData(subj_i,find(direction_temp==dir_i),5)),'b.','MarkerSize',10);
        hold on;
        %     plot(squeeze(peakData(subj_i,find(direction_temp==dir_i),7)),'r.','MarkerSize',10);
        %time outlier marked as green dot
        plot(find(ismember(find(direction_temp==dir_i),find(MoveTime(subj_i,:)>Slow&direction_temp==dir_i))==1),...
            squeeze(endData(subj_i,find(MoveTime(subj_i,:)>Slow&direction_temp==dir_i),5)),'g.','MarkerSize',10);
        %         plot(find(ismember(find(direction_temp==dir_i),find(MoveTime(subj_i,:)>Slow&direction_temp==dir_i))==1),...
        %         squeeze(peakData(subj_i,find(MoveTime(subj_i,:)>Slow&direction_temp==dir_i),7)),'c.','MarkerSize',10);
        title(['subj ' num2str(subj_i) ' dir ' num2str(dir_i)]);
    end;
    
        pause;
    clf;
    
end;
save(fileName,'endData','expInfo','IfOutlier','MoveTime','peakData','RT','TimePeak','trialInfo');