% savedData = NaN(trialsNum,stepsNum,5);  % 1-2:Marker坐标xy; 3:运动时间;
% 4:实际运动距离（距中心点距离）; 5:速度（按实际运动距离计算）6-7:Marker坐标(pixel)
% rawData = NaN(length(subj_name),nTrials,800,size(savedData,3)); % --- 1-2:x,y;3:time;4:Distance;5:velocity
% trialInfo = NaN(length(subj_name),nTrials,8); % --- 1:direction; 2:trial
% index; 3:startStep; 4:endStep; 5: valid_time 6:endDistance; 7:max speed
% 8: degree at pv; 9: endStep as velocity=0
%
% endData = NaN(length(subj_name),trialsNum,4); % --- 1:2??the position of end point 3: angle 4:distance
% peakData = NaN(length(subj_name),trialsNum,5); % --- 1:2??the position of pk point 3:angle  4:distance  5:velocity

clear all;
close all;
clc
cd('D:\mine\lab\projects\motor learning with tDCS\data');

%% trajectory figure, 8 trials in a subplot
% Anodal
subj_name={'yangmeiyu','zhangyunpeng','wengyi','lintingwei','chenghao','yinyongsheng','jiangchuanzhen','zhaozhao','tianyixue','zhanglixue','reyili',...
    'jiaomengyao','wulahati','jinlinfang','yuzhuo','fengchenglong','liyueyang','tianrun','lida','zhouyifan','zhangmengyu','lilanjing','huangningning','zhongzhe','liujiajia','xushuai','liunengsheng','chenchen','wanghan','yangyurun','tangwei','sunshuyu','huangyongyin','zhukaiyu','zhounuannuan','luning','chenshutian','lianjunhan','wanglu','yunhao','shixiaoqi','xieliangwei'};
%-----------2 days

% Sham
% subj_name={'baohan','zhouqian','zhangkexin','lvhaifeng','chenying','zhangxue','wanghaodong','xuxinze','xiexiaoyang','wuxiaoxiao',...
%-----------one day
%     'zhangyuhang','lixiaofeng','liuzan','aizemujiang','guanye','yanghaibing','weiyukai','yaoyifan','fangchen','zhouxinjie','maoxingtai','bike','chenruiyi','liuzhu','zhouminxuan',...
%     'caowenzhen','liujiawei','xieyunchao','nican','xingchen','yubinglin','zhanglinqi','wangke','panjianwei','tangrui','chencaixia','zuoyou','xingtianyue','shenyuhe','chentinghui','zhangyuxue','yishu','jianhuiyan','guyangyang'};
subj_i=8;
load([subj_name{subj_i} '_day1']);
rot_angle=30;
handPos=[cos(0-rot_angle/180*pi),sin(0-rot_angle/180*pi);cos(pi/4-rot_angle/180*pi),sin(pi/4-rot_angle/180*pi); cos(pi/2-rot_angle/180*pi),sin(pi/2-rot_angle/180*pi);...
    cos(3*pi/4-rot_angle/180*pi),sin(3*pi/4-rot_angle/180*pi);cos(pi-rot_angle/180*pi),sin(pi-rot_angle/180*pi);cos(5*pi/4-rot_angle/180*pi),sin(5*pi/4-rot_angle/180*pi);cos(3*pi/2-rot_angle/180*pi),sin(3*pi/2-rot_angle/180*pi)...
    ;cos(7*pi/4-rot_angle/180*pi),sin(7*pi/4-rot_angle/180*pi)];
handPos_scr = handPos .* T2Sdist .*screen + repmat(startingPos_scr,Target_num,1);

for trial_i=1:80
    figure(ceil(trial_i/80));
    subplot(2,5,ceil((trial_i-floor(trial_i/80))/8));
    EndStep(subj_i,trial_i)=sum((~isnan(squeeze(savedData(trial_i,:,6)))).*(squeeze(savedData(trial_i,:,6))~=0));
    plot(squeeze(savedData(trial_i,1:EndStep(subj_i,trial_i),6)),...
        squeeze(savedData(trial_i,1:EndStep(subj_i,trial_i),7)));hold on;
    axis equal;
end;
%% speed smooth, figure
fileName='GR_Sham_all_30';
% fileName='GR_Anodal_all_27';
% fileName='EC_Sham_all_41';
% fileName='EC_Anodal_all_42';

load(fileName);
for subj_i=1%:size(expInfo.subj_name,2)
    clear savedData;
    load([expInfo.subj_name{subj_i} '_day1']);
    for trial_i=1%:trialsNum
        %                 figure(subj_i*100+ceil(trial_i/10));
        %                 subplot(2,4,mod(trial_i,8)+1);
        % subplot(2,5,trial_i);
        % figure(ceil(trial_i/10));
        % subplot(2,5,trial_i);
        EndStep(subj_i,trial_i)=sum((~isnan(squeeze(savedData(trial_i,:,6)))).*(squeeze(savedData(trial_i,:,6))~=0));
        [b,a]=butter(4,0.1,'low');
        distance=squeeze(savedData(trial_i,1:EndStep(subj_i,trial_i),4));
        t=squeeze(savedData(trial_i,1:EndStep(subj_i,trial_i),3));
        % plot(diff(t));hold on;
        
        filtdis = filtfilt(b,a,distance);
        deltat=diff(t);
        gap=find(diff(t)>0.05);
        for gap_i=1:length(gap)
            t(gap(gap_i)+1:end)=t(gap(gap_i)+1:end)-deltat(gap(gap_i))+mean(deltat(deltat<0.05));
            % plot(t);hold on;
        end;
        filtt=filtfilt(b,a,t);
        plot(diff(filtdis)./diff(filtt));hold on;
        filtsp = diff(filtdis)./diff(filtt);
        %         filtsp = filtfilt(b,a,diff(filtdis)./diff(filtt));
        
        %         plot(savedData(trial_i,1:EndStep(subj_i,trial_i),5));hold on;
        %         plot(filtsp);hold on;
        %         [C,S]=max(filtsp);
        %         newpeakData(subj_i,trial_i,1:2) = savedData(trial_i,S,6:7);
        %         newpeakData(subj_i,trial_i,6) = savedData(trial_i,S,3);   % time
        %         newpeakData(subj_i,trial_i,5) = C;
        %         newpeakData(subj_i,trial_i,4) = sqrtm((squeeze(newpeakData(subj_i,trial_i,1))-startingPos_scr(1,1))^2+((squeeze(newpeakData(subj_i,trial_i,2))-startingPos_scr(1,2)))^2);
        %         if squeeze((newpeakData(subj_i,trial_i,2)-startingPos_scr(1,2)))>=0
        %             if squeeze((newpeakData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0   % ????????
        %                 newpeakData(subj_i,trial_i,3) = acos((squeeze(newpeakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newpeakData(subj_i,trial_i,4)))*180/pi;
        %             else  % ????????
        %                 newpeakData(subj_i,trial_i,3) = (pi-acos(abs(squeeze(newpeakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newpeakData(subj_i,trial_i,4))))*180/pi;
        %             end;
        %         else
        %             if squeeze((newpeakData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0   % ????????
        %                 newpeakData(subj_i,trial_i,3) = (2*pi-acos((squeeze(newpeakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newpeakData(subj_i,trial_i,4))))*180/pi;
        %             else  % ????????
        %                 newpeakData(subj_i,trial_i,3) = (pi+acos(abs(squeeze(newpeakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newpeakData(subj_i,trial_i,4))))*180/pi;
        %             end;
        %         end;
        %         if find(filtsp(S:EndStep(subj_i,trial_i))<0,1,'first')
        %             moveStop(subj_i,trial_i)=S+find(filtsp(S:EndStep(subj_i,trial_i))<0,1,'first');% the step before speed became smaller than 0
        %         else
        %             moveStop(subj_i,trial_i)=EndStep(subj_i,trial_i);
        %             NoZero(subj_i,trial_i)=1;
        %         end;
        %         newendData(subj_i,trial_i,1:2) = savedData(trial_i,moveStop(subj_i,trial_i),6:7);
        %         newendData(subj_i,trial_i,4) = sqrtm((squeeze(newendData(subj_i,trial_i,1))-startingPos_scr(1,1))^2+((squeeze(newendData(subj_i,trial_i,2))-startingPos_scr(1,2)))^2);
        %         if squeeze((newendData(subj_i,trial_i,2)- startingPos_scr(1,2)))>=0
        %             if squeeze((newendData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0
        %                 newendData(subj_i,trial_i,3) = acos((squeeze(newendData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newendData(subj_i,trial_i,4)))*180/pi;
        %             else
        %                 newendData(subj_i,trial_i,3) = (pi-acos(abs(squeeze(newendData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newendData(subj_i,trial_i,4))))*180/pi;
        %             end;
        %         else
        %             if squeeze((newendData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0
        %                 newendData(subj_i,trial_i,3) = (2*pi-acos((squeeze(newendData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newendData(subj_i,trial_i,4))))*180/pi;
        %             else
        %                 newendData(subj_i,trial_i,3) = (pi+acos(abs(squeeze(newendData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newendData(subj_i,trial_i,4))))*180/pi;
        %             end;
        %         end;
        %         plot(squeeze(savedData(trial_i,1:EndStep(subj_i,trial_i),5)));hold on;
        %         plot(squeeze(savedData(trial_i,:,5)));hold on;
        %         plot(squeeze(savedData(trial_i,:,6)),...
        %             squeeze(savedData(trial_i,:,7)));hold on;
        %         plot(squeeze(savedData(trial_i,1:EndStep(subj_i,trial_i),6)),...
        %             squeeze(savedData(trial_i,1:EndStep(subj_i,trial_i),7)));hold on;
        pause;
        clf;
    end;
end;

%% speed smooth, new peak and end calculation
clear all;
% linear regression using butter
% fileName='GR_Sham_all_30';
fileName='GR_Anodal_all_27';
% fileName='EC_Sham_all_41';
% fileName='EC_Anodal_all_42';

load(fileName);
newpeakData=nan(size(expInfo.subj_name,2),960*2,8);% --- 1:2??the position of end point 3: angle 4:distance 5:velocity 6:time
newendData=nan(size(expInfo.subj_name,2),960*2,6);% --- 1:2??the position of end point 3: angle 4:distance 5:time
EndStep=nan(size(expInfo.subj_name,2),960*2);
moveStop=nan(size(expInfo.subj_name,2),960*2);
NoZero=nan(size(expInfo.subj_name,2),960*2);
for subj_i=1:size(expInfo.subj_name,2)
    clear savedData;
    load([expInfo.subj_name{subj_i} '_day1']);
    for trial_i=1:trialsNum
        %         figure(ceil(trial_i/80));
        %         subplot(2,5,ceil((trial_i-floor(trial_i/80))/8));
        % subplot(2,5,trial_i);
        % figure(ceil(trial_i/10));
        % subplot(2,5,trial_i);
        EndStep(subj_i,trial_i)=sum((~isnan(squeeze(savedData(trial_i,:,6)))).*(squeeze(savedData(trial_i,:,6))~=0));
        %         newendData(subj_i,trial_i,1:2)=squeeze(savedData(trial_i,EndStep(subj_i,trial_i),6:7));
        [b,a]=butter(4,0.1,'low');
        %         filtsp = filtfilt(b,a,squeeze(savedData(trial_i,1:EndStepd2(subj_i,trial_i),5)));
%         plot(squeeze(savedData(trial_i,:,5)));hold on;
%         plot(filtsp);hold on;

        distance=squeeze(savedData(trial_i,1:EndStep(subj_i,trial_i),4));
        t=squeeze(savedData(trial_i,1:EndStep(subj_i,trial_i),3));
        % plot(diff(t));hold on;
        
        filtdis = filtfilt(b,a,distance);
        deltat=diff(t);
        gap=find(diff(t)>0.05);
        if gap
        for gap_i=1:length(gap)
            t(gap(gap_i)+1:end)=t(gap(gap_i)+1:end)-deltat(gap(gap_i))+mean(deltat(deltat<0.05));
            % plot(t);hold on;
        end;
        end;
        filtt=filtfilt(b,a,t);
%         plot(diff(filtdis)./diff(filtt));hold on;
        filtsp = diff(filtdis)./diff(filtt);
        [C,S]=max(filtsp);
        newpeakData(subj_i,trial_i,1:2) = savedData(trial_i,S,6:7);
        newpeakData(subj_i,trial_i,6) = savedData(trial_i,S,3);   % time
        newpeakData(subj_i,trial_i,5) = C;
        newpeakData(subj_i,trial_i,4) = sqrtm((squeeze(newpeakData(subj_i,trial_i,1))-startingPos_scr(1,1))^2+((squeeze(newpeakData(subj_i,trial_i,2))-startingPos_scr(1,2)))^2);
        if squeeze((newpeakData(subj_i,trial_i,2)-startingPos_scr(1,2)))>=0
            if squeeze((newpeakData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0   % ????????
                newpeakData(subj_i,trial_i,3) = acos((squeeze(newpeakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newpeakData(subj_i,trial_i,4)))*180/pi;
            else  % ????????
                newpeakData(subj_i,trial_i,3) = (pi-acos(abs(squeeze(newpeakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newpeakData(subj_i,trial_i,4))))*180/pi;
            end;
        else
            if squeeze((newpeakData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0   % ????????
                newpeakData(subj_i,trial_i,3) = (2*pi-acos((squeeze(newpeakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newpeakData(subj_i,trial_i,4))))*180/pi;
            else  % ????????
                newpeakData(subj_i,trial_i,3) = (pi+acos(abs(squeeze(newpeakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newpeakData(subj_i,trial_i,4))))*180/pi;
            end;
        end;
%         if find(filtsp(S:EndStep(subj_i,trial_i))<0,1,'first')
%             moveStop(subj_i,trial_i)=S+find(filtsp(S:EndStep(subj_i,trial_i))<0,1,'first');% the step before speed became smaller than 0
%         else
%             moveStop(subj_i,trial_i)=EndStep(subj_i,trial_i);
%             NoZero(subj_i,trial_i)=1;
%         end;
                if find(filtsp(S:end)<0,1,'first')
            moveStop(subj_i,trial_i)=S+find(filtsp(S:end)<0,1,'first');% the step before speed became smaller than 0
        else
            moveStop(subj_i,trial_i)=EndStep(subj_i,trial_i);
            NoZero(subj_i,trial_i)=1;
        end;
        newendData(subj_i,trial_i,1:2) = savedData(trial_i,moveStop(subj_i,trial_i),6:7);
        newendData(subj_i,trial_i,4) = sqrtm((squeeze(newendData(subj_i,trial_i,1))-startingPos_scr(1,1))^2+((squeeze(newendData(subj_i,trial_i,2))-startingPos_scr(1,2)))^2);
        if squeeze((newendData(subj_i,trial_i,2)- startingPos_scr(1,2)))>=0
            if squeeze((newendData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0
                newendData(subj_i,trial_i,3) = acos((squeeze(newendData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newendData(subj_i,trial_i,4)))*180/pi;
            else
                newendData(subj_i,trial_i,3) = (pi-acos(abs(squeeze(newendData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newendData(subj_i,trial_i,4))))*180/pi;
            end;
        else
            if squeeze((newendData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0
                newendData(subj_i,trial_i,3) = (2*pi-acos((squeeze(newendData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newendData(subj_i,trial_i,4))))*180/pi;
            else
                newendData(subj_i,trial_i,3) = (pi+acos(abs(squeeze(newendData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newendData(subj_i,trial_i,4))))*180/pi;
            end;
        end;
        %         plot(squeeze(savedData(trial_i,1:EndStep(subj_i,trial_i),5)));hold on;
        %         plot(squeeze(savedData(trial_i,:,5)));hold on;
        %         plot(squeeze(savedData(trial_i,:,6)),...
        %             squeeze(savedData(trial_i,:,7)));hold on;
        %         plot(squeeze(savedData(trial_i,1:EndStep(subj_i,trial_i),6)),...
        %             squeeze(savedData(trial_i,1:EndStep(subj_i,trial_i),7)));hold on;
        
    end;
end;
% day2 data

newpeakDatad2=nan(size(expInfo.subj_name,2),960,8);% --- 1:2??the position of end point 3: angle 4:distance 5:velocity 6:time
newendDatad2=nan(size(expInfo.subj_name,2),960,6);% --- 1:2??the position of end point 3: angle 4:distance 5:time
EndStepd2=nan(size(expInfo.subj_name,2),960);
moveStopd2=nan(size(expInfo.subj_name,2),960);
NoZerod2=nan(size(expInfo.subj_name,2),960);

for subj_i=1:size(expInfo.subj_name,2)
    clear savedData;
    load([expInfo.subj_name{subj_i} '_day2']);
    for trial_i=1:trialsNum
        %         figure(ceil(trial_i/80));
        %         subplot(2,5,ceil((trial_i-floor(trial_i/80))/8));
        % subplot(2,5,trial_i);
        % figure(ceil(trial_i/10));
        % subplot(2,5,trial_i);
        EndStepd2(subj_i,trial_i)=sum((~isnan(squeeze(savedData(trial_i,:,6)))).*(squeeze(savedData(trial_i,:,6))~=0));
        [b,a]=butter(4,0.1,'low');
%         filtsp = filtfilt(b,a,squeeze(savedData(trial_i,1:EndStepd2(subj_i,trial_i),5)));
%         plot(squeeze(savedData(trial_i,:,5)));hold on;
%         plot(filtsp);hold on;
        distance=squeeze(savedData(trial_i,1:EndStepd2(subj_i,trial_i),4));
        t=squeeze(savedData(trial_i,1:EndStepd2(subj_i,trial_i),3));
%         plot(diff(t));hold on;
        filtdis = filtfilt(b,a,distance);
        deltat=diff(t);
        gap=find(diff(t)>0.05);
        if gap
        for gap_i=1:length(gap)
            t(gap(gap_i)+1:end)=t(gap(gap_i)+1:end)-deltat(gap(gap_i))+mean(deltat(deltat<0.05));
            % plot(t);hold on;
        end;
        end;
        filtt=filtfilt(b,a,t);
%         plot(diff(filtdis)./diff(filtt));hold on;
        filtsp = diff(filtdis)./diff(filtt);
        [C,S]=max(filtsp);
        newpeakDatad2(subj_i,trial_i,1:2) = savedData(trial_i,S,6:7);
        newpeakDatad2(subj_i,trial_i,6) = savedData(trial_i,S,3);   % time
        newpeakDatad2(subj_i,trial_i,5) = C;
        newpeakDatad2(subj_i,trial_i,4) = sqrtm((squeeze(newpeakDatad2(subj_i,trial_i,1))-startingPos_scr(1,1))^2+((squeeze(newpeakDatad2(subj_i,trial_i,2))-startingPos_scr(1,2)))^2);
        if squeeze((newpeakDatad2(subj_i,trial_i,2)-startingPos_scr(1,2)))>=0
            if squeeze((newpeakDatad2(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0   % ????????
                newpeakDatad2(subj_i,trial_i,3) = acos((squeeze(newpeakDatad2(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newpeakDatad2(subj_i,trial_i,4)))*180/pi;
            else  % ????????
                newpeakDatad2(subj_i,trial_i,3) = (pi-acos(abs(squeeze(newpeakDatad2(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newpeakDatad2(subj_i,trial_i,4))))*180/pi;
            end;
        else
            if squeeze((newpeakDatad2(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0   % ????????
                newpeakDatad2(subj_i,trial_i,3) = (2*pi-acos((squeeze(newpeakDatad2(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newpeakDatad2(subj_i,trial_i,4))))*180/pi;
            else  % ????????
                newpeakDatad2(subj_i,trial_i,3) = (pi+acos(abs(squeeze(newpeakDatad2(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newpeakDatad2(subj_i,trial_i,4))))*180/pi;
            end;
        end;
        if find(filtsp(S:end)<0,1,'first')
            moveStopd2(subj_i,trial_i)=S+find(filtsp(S:end)<0,1,'first');% the step before speed became smaller than 0
        else
            moveStopd2(subj_i,trial_i)=EndStepd2(subj_i,trial_i);
            NoZerod2(subj_i,trial_i)=1;
        end;
        newendDatad2(subj_i,trial_i,1:2) = savedData(trial_i,moveStopd2(subj_i,trial_i),6:7);
        newendDatad2(subj_i,trial_i,4) = sqrtm((squeeze(newendDatad2(subj_i,trial_i,1))-startingPos_scr(1,1))^2+((squeeze(newendDatad2(subj_i,trial_i,2))-startingPos_scr(1,2)))^2);
        if squeeze((newendDatad2(subj_i,trial_i,2)- startingPos_scr(1,2)))>=0
            if squeeze((newendDatad2(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0
                newendDatad2(subj_i,trial_i,3) = acos((squeeze(newendDatad2(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newendDatad2(subj_i,trial_i,4)))*180/pi;
            else
                newendDatad2(subj_i,trial_i,3) = (pi-acos(abs(squeeze(newendDatad2(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newendDatad2(subj_i,trial_i,4))))*180/pi;
            end;
        else
            if squeeze((newendDatad2(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0
                newendDatad2(subj_i,trial_i,3) = (2*pi-acos((squeeze(newendDatad2(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newendDatad2(subj_i,trial_i,4))))*180/pi;
            else
                newendDatad2(subj_i,trial_i,3) = (pi+acos(abs(squeeze(newendDatad2(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(newendDatad2(subj_i,trial_i,4))))*180/pi;
            end;
        end;
    end;
end;
newpeakData(:,961:end,:)=newpeakDatad2;% --- 1:2??the position of end point 3: angle 4:distance 5:velocity 6:time
newendData(:,961:end,:)=newendDatad2;% --- 1:2??the position of end point 3: angle 4:distance 5:time
EndStep(:,961:end)=EndStepd2;
moveStop(:,961:end)=moveStopd2;
NoZero(:,961:end)=NoZerod2;

save(fileName,'newpeakData','newendData','EndStep','moveStop','NoZero','-append');
%% speed profile-filt time and position
for trial_i=11
    %         figure(ceil(trial_i/80));
    %         subplot(2,5,ceil((trial_i-floor(trial_i/80))/8));
    % subplot(2,5,trial_i);
    figure(trial_i);
    EndStep(trial_i)=sum((~isnan(squeeze(savedData(trial_i,:,6)))).*(squeeze(savedData(trial_i,:,6))~=0));
    distance=squeeze(savedData(trial_i,1:EndStep(trial_i),4));
    t=squeeze(savedData(trial_i,1:EndStep(trial_i),3));
    % plot(diff(t));hold on;
    [b,a]=butter(4,0.1,'low');
    filtdis = filtfilt(b,a,distance);
    deltat=diff(t);
    t(find(diff(t)>0.05)+1:end)=t(find(diff(t)>0.05)+1:end)-deltat(diff(t)>0.05)+mean(deltat(diff(t)<0.05));
    % plot(t);hold on;
    filtt=filtfilt(b,a,t);
    % plot(distance);hold on;
    % plot(filtdis);hold on;
    % plot(diff(distance));hold on;
    % plot(diff(filtdis));hold on;
    % plot(t);hold on;
    % plot(filtt);hold on;
    % plot(diff(t));hold on;
    % plot(diff(filtt));hold on;
    % plot(diff(distance)./diff(t));hold on;
    plot(diff(filtdis)./diff(filtt));hold on;
    
end;
