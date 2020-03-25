%% put subjects together
%
%% Anodal, 10 washout cycles
clear all
close all
cd('D:\mine\lab\projects\motor learning with tDCS\data');
subj_name={'gongwei','jiangyangjin','hujingyi','zhaosihan','linjiahao','yelei','liyiye','xuezixuan','sunpengpeng','tangqi','liyang','douxinyu'};
%     'youfangyi','molonghua','niwenqing','wangzongrui','xuyue','luoyi','yuxiaohan','linling','haochenqi','wangping','wanghao','mayuhui','shenyuxiang','ningke','lifei'};

load([subj_name{2} '_day1']);
nTrials = sum(trials_index);


rawData = NaN(length(subj_name),nTrials,800,size(savedData,3)); % --- 1-2:x,y;3:time;4:Distance;5:velocity
trialInfo = NaN(length(subj_name),nTrials,8); % --- 1:direction; 2:trial index; 3:startStep; 4:endStep; 5: valid_time 6:endDistance; 7:max speed  8: degree at pv


expInfo.subj_name = subj_name;

endData = NaN(length(subj_name),trialsNum,4); % --- 1:2??the position of end point 3: angle 4:distance
peakData = NaN(length(subj_name),trialsNum,5); % --- 1:2??the position of pk point 3:angle  4:distance  5:velocity
% skip = NaN(length(subj_name),trialsNum); % --- skip trials
MoveTime=NaN(length(subj_name),trialsNum);
RT=NaN(length(subj_name),trialsNum);
trialEndStep=NaN(length(subj_name),trialsNum);
trialBeginStep=NaN(length(subj_name),trialsNum);
trialBegStep=NaN(length(subj_name),trialsNum);
TimePeak=NaN(length(subj_name),trialsNum);
IfOutlier=zeros(length(subj_name),trialsNum);%---normal:0, outlier:1

for subj_i = 1:length(subj_name)
    clear file_name save* test_direction
    file_name = [subj_name{subj_i} '_day1'];
    load(file_name);
    trialInfo(subj_i,:,1) = test_direction;
    trialInfo(subj_i,:,2) = session_iPerTrial;
    skipTrials=[];
    % --- get the position end point
    for trial_i = 1:nTrials
        if isempty(find(skipTrials == trial_i, 1))
            clear temp*
            
            
            
            [C,S] = max(savedData(trial_i,1:trialsEndStep(trial_i),5));
            peakData(subj_i,trial_i,1:2) = savedData(trial_i,S,6:7);
            peakData(subj_i,trial_i,6) = savedData(trial_i,S,3);   % PV??????????
            peakData(subj_i,trial_i,5) = C;
            peakData(subj_i,trial_i,4) = sqrtm((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))^2+((squeeze(peakData(subj_i,trial_i,2))-startingPos_scr(1,2)))^2);
            trialEndStep(subj_i,trial_i)=trialsEndStep(trial_i);
            
            trialBeginStep(subj_i,trial_i)=find(savedData(trial_i,:,5)>0.01*peakData(subj_i,trial_i,5)& savedData(trial_i,:,4)>8 ,1);
            if trialEndStep(subj_i,trial_i)>1 && trialBeginStep(subj_i,trial_i)>1
                MoveTime(subj_i,trial_i)=savedData(trial_i,trialEndStep(subj_i,trial_i),3)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
                %             MoveTime(subj_i,trial_i)=savedData(trial_i,trialsEndStep(trial_i),3)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
                
                RT(subj_i,trial_i)=savedData(trial_i,trialBeginStep(subj_i,trial_i),3)-savedData(trial_i,1,3);
                TimePeak(subj_i,trial_i)=peakData(subj_i,trial_i,6)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
            end;
            if  MoveTime(subj_i,trial_i)>=0.3
                %                 MoveTime(subj_i,trial_i)=NaN;
                %                 RT(subj_i,trial_i)=NaN;
                %                 TimePeak(subj_i,trial_i)=NaN;
                IfOutlier(subj_i,trial_i)=1;
            end;
            
            %             if  MoveTime(subj_i,trial_i)>=1
            %                 MoveTime(subj_i,trial_i)=NaN;
            %                 RT(subj_i,trial_i)=NaN;
            %                 TimePeak(subj_i,trial_i)=NaN;
            %             end;
            %
            %             if  RT(subj_i,trial_i)<=0.1 || RT(subj_i,trial_i)>=6
            %                 MoveTime(subj_i,trial_i)=NaN;
            %                 RT(subj_i,trial_i)=NaN;
            %                 TimePeak(subj_i,trial_i)=NaN;
            %             end;
            
            
            if squeeze((peakData(subj_i,trial_i,2)-startingPos_scr(1,2)))>=0
                if squeeze((peakData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0   % ????????
                    peakData(subj_i,trial_i,3) = acos((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4)))*180/pi;
                else  % ????????
                    peakData(subj_i,trial_i,3) = (pi-acos(abs(squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                end;
            else
                if squeeze((peakData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0   % ????????
                    peakData(subj_i,trial_i,3) = (2*pi-acos((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                else  % ????????
                    peakData(subj_i,trial_i,3) = (pi+acos(abs(squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                end;
            end;
            trialInfo(subj_i,trial_i,8) = peakData(subj_i,trial_i,3);
            trialInfo(subj_i,trial_i,3)= find(savedData(trial_i,:,4)>5,1);
            trialInfo(subj_i,trial_i,4)=trialsEndStep(trial_i);
            trialInfo(subj_i,trial_i,5) = savedData(trial_i, trialsEndStep(trial_i),3)- savedData(trial_i,trialInfo(subj_i,trial_i,3),3);  % valid time
            trialInfo(subj_i,trial_i,6) = savedData(trial_i, trialsEndStep(trial_i),4);  % endpoint distance
            trialInfo(subj_i,trial_i,7) = max(savedData(trial_i,trialInfo(subj_i,trial_i,3):trialsEndStep(trial_i),4));  % --- max speed
            
            endData(subj_i,trial_i,1:2) = savedData(trial_i,trialsEndStep(trial_i),6:7);
            endData(subj_i,trial_i,4) = sqrtm((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))^2+((squeeze(endData(subj_i,trial_i,2))-startingPos_scr(1,2)))^2);
            if squeeze((endData(subj_i,trial_i,2)- startingPos_scr(1,2)))>=0
                if squeeze((endData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0
                    endData(subj_i,trial_i,3) = acos((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4)))*180/pi;
                    
                else
                    endData(subj_i,trial_i,3) = (pi-acos(abs(squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                end;
            else
                if squeeze((endData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0
                    endData(subj_i,trial_i,3) = (2*pi-acos((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                    
                else
                    endData(subj_i,trial_i,3) = (pi+acos(abs(squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                end;
            end;
            
            
        end;    %  if isempty
        
        
    end; % for trial
    rawData(subj_i,:,:,:) = savedData(:,1:800,:);
    trialInfo(subj_i,skipTrials,:) = NaN;
    rawData(subj_i,skipTrials,:,:) = NaN;
    
end; % for subj

clear fileName;
fileName = ['GR_subj' num2str(length(subj_name)) '_day1_a'];
save(fileName,'rawData','trialInfo','expInfo','endData','peakData','MoveTime','RT','TimePeak','IfOutlier');
% day2
clear all
close all
cd('D:\mine\lab\projects\motor learning with tDCS\data');
subj_name={'gongwei','jiangyangjin','hujingyi','zhaosihan','linjiahao','yelei','liyiye','xuezixuan','sunpengpeng','tangqi','liyang','douxinyu'};

load([subj_name{1} '_day2']);
nTrials = sum(trials_index);


rawData = NaN(length(subj_name),nTrials,800,size(savedData,3)); % --- 1-2:x,y;3:time;4:Distance;5:velocity
trialInfo = NaN(length(subj_name),nTrials,8); % --- 1:direction; 2:trial index; 3:startStep; 4:endStep; 5: valid_time 6:endDistance; 7:max speed  8: degree at pv


expInfo.subj_name = subj_name;

endData = NaN(length(subj_name),trialsNum,4); % --- 1:2??the position of end point 3: angle 4:distance
peakData = NaN(length(subj_name),trialsNum,5); % --- 1:2??the position of pk point 3:angle  4:distance  5:velocity
% skip = NaN(length(subj_name),trialsNum); % --- skip trials
MoveTime=NaN(length(subj_name),trialsNum);
RT=NaN(length(subj_name),trialsNum);
trialEndStep=NaN(length(subj_name),trialsNum);
trialBeginStep=NaN(length(subj_name),trialsNum);
trialBegStep=NaN(length(subj_name),trialsNum);
TimePeak=NaN(length(subj_name),trialsNum);
IfOutlier=zeros(length(subj_name),trialsNum);%---normal:0, outlier:1

for subj_i = 1:length(subj_name)
    clear file_name save* test_direction
    file_name = [subj_name{subj_i} '_day2'];
    load(file_name);
    trialInfo(subj_i,:,1) = test_direction;
    trialInfo(subj_i,:,2) = session_iPerTrial+max(session_iPerTrial);%！！！！day2 session start from 5
    skipTrials=[];
    % --- get the position end point
    for trial_i = 1:nTrials
        if isempty(find(skipTrials == trial_i, 1))
            clear temp*
            
            
            
            [C,S] = max(savedData(trial_i,1:trialsEndStep(trial_i),5));
            peakData(subj_i,trial_i,1:2) = savedData(trial_i,S,6:7);
            peakData(subj_i,trial_i,6) = savedData(trial_i,S,3);   % PV??????????
            peakData(subj_i,trial_i,5) = C;
            peakData(subj_i,trial_i,4) = sqrtm((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))^2+((squeeze(peakData(subj_i,trial_i,2))-startingPos_scr(1,2)))^2);
            trialEndStep(subj_i,trial_i)=trialsEndStep(trial_i);
            
            trialBeginStep(subj_i,trial_i)=find(savedData(trial_i,:,5)>0.01*peakData(subj_i,trial_i,5)& savedData(trial_i,:,4)>8 ,1);
            if trialEndStep(subj_i,trial_i)>1 && trialBeginStep(subj_i,trial_i)>1
                MoveTime(subj_i,trial_i)=savedData(trial_i,trialEndStep(subj_i,trial_i),3)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
                %             MoveTime(subj_i,trial_i)=savedData(trial_i,trialsEndStep(trial_i),3)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
                
                RT(subj_i,trial_i)=savedData(trial_i,trialBeginStep(subj_i,trial_i),3)-savedData(trial_i,1,3);
                TimePeak(subj_i,trial_i)=peakData(subj_i,trial_i,6)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
            end;
            if  MoveTime(subj_i,trial_i)>=0.3
                %                 MoveTime(subj_i,trial_i)=NaN;
                %                 RT(subj_i,trial_i)=NaN;
                %                 TimePeak(subj_i,trial_i)=NaN;
                IfOutlier(subj_i,trial_i)=1;
            end;
            
            %             if  MoveTime(subj_i,trial_i)>=1
            %                 MoveTime(subj_i,trial_i)=NaN;
            %                 RT(subj_i,trial_i)=NaN;
            %                 TimePeak(subj_i,trial_i)=NaN;
            %             end;
            %
            %             if  RT(subj_i,trial_i)<=0.1 || RT(subj_i,trial_i)>=6
            %                 MoveTime(subj_i,trial_i)=NaN;
            %                 RT(subj_i,trial_i)=NaN;
            %                 TimePeak(subj_i,trial_i)=NaN;
            %             end;
            
            
            if squeeze((peakData(subj_i,trial_i,2)-startingPos_scr(1,2)))>=0
                if squeeze((peakData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0   % ????????
                    peakData(subj_i,trial_i,3) = acos((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4)))*180/pi;
                else  % ????????
                    peakData(subj_i,trial_i,3) = (pi-acos(abs(squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                end;
            else
                if squeeze((peakData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0   % ????????
                    peakData(subj_i,trial_i,3) = (2*pi-acos((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                else  % ????????
                    peakData(subj_i,trial_i,3) = (pi+acos(abs(squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                end;
            end;
            trialInfo(subj_i,trial_i,8) = peakData(subj_i,trial_i,3);
            trialInfo(subj_i,trial_i,3)= find(savedData(trial_i,:,4)>5,1);
            trialInfo(subj_i,trial_i,4)=trialsEndStep(trial_i);
            trialInfo(subj_i,trial_i,5) = savedData(trial_i, trialsEndStep(trial_i),3)- savedData(trial_i,trialInfo(subj_i,trial_i,3),3);  % valid time
            trialInfo(subj_i,trial_i,6) = savedData(trial_i, trialsEndStep(trial_i),4);  % endpoint distance
            trialInfo(subj_i,trial_i,7) = max(savedData(trial_i,trialInfo(subj_i,trial_i,3):trialsEndStep(trial_i),4));  % --- max speed
            
            endData(subj_i,trial_i,1:2) = savedData(trial_i,trialsEndStep(trial_i),6:7);
            endData(subj_i,trial_i,4) = sqrtm((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))^2+((squeeze(endData(subj_i,trial_i,2))-startingPos_scr(1,2)))^2);
            if squeeze((endData(subj_i,trial_i,2)- startingPos_scr(1,2)))>=0
                if squeeze((endData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0
                    endData(subj_i,trial_i,3) = acos((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4)))*180/pi;
                    
                else
                    endData(subj_i,trial_i,3) = (pi-acos(abs(squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                end;
            else
                if squeeze((endData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0
                    endData(subj_i,trial_i,3) = (2*pi-acos((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                    
                else
                    endData(subj_i,trial_i,3) = (pi+acos(abs(squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                end;
            end;
            
            
        end;    %  if isempty
        
        
    end; % for trial
    rawData(subj_i,:,:,:) = savedData(:,1:800,:);
    trialInfo(subj_i,skipTrials,:) = NaN;
    rawData(subj_i,skipTrials,:,:) = NaN;
    
end; % for subj

clear fileName;
fileName = ['GR_subj' num2str(length(subj_name)) '_day2_a'];
save(fileName,'rawData','trialInfo','expInfo','endData','peakData','MoveTime','RT','TimePeak','IfOutlier');
% put 2 days together
clear all;
fileName='GR_subj12';
load([fileName '_day1_a']);

raw1=rawData;
trial1=trialInfo;
exp1=expInfo;
end1=endData;
peak1=peakData;
MT1=MoveTime;
RT1=RT;
TP1=TimePeak;
OT1=IfOutlier;

load([fileName '_day2_a']);
% load Gradual_subj4_day2
raw2=rawData;
trial2=trialInfo;
exp2=expInfo;
end2=endData;
peak2=peakData;
MT2=MoveTime;
RT2=RT;
TP2=TimePeak;
OT2=IfOutlier;

rawData=[raw1 raw2];
trialInfo=[trial1 trial2];
expInfo=exp1;%names are the same
endData=[end1 end2];
peakData=[peak1 peak2];
MoveTime=[MT1 MT2];
RT=[RT1 RT2];
TimePeak=[TP1 TP2];
IfOutlier=[OT1 OT2];


fileName = [fileName '_a'];
save(fileName,'rawData','trialInfo','expInfo','endData','peakData','MoveTime','RT','TimePeak','IfOutlier');
%% Anodal, 20 washout cycles
%  day1
clear all
close all
cd('D:\mine\lab\projects\motor learning with tDCS\data');
% subj_name={'youfangyi','hangwenjie','molonghua','niwenqing','wangzongrui','xuyue','luoyi','yuxiaohan','linling','haochenqi','wangping','wanghao','mayuhui','shenyuxiang','ningke','lifei'};
subj_name={'youfangyi','molonghua','niwenqing','wangzongrui','xuyue','luoyi','yuxiaohan','linling','haochenqi','wangping','wanghao','mayuhui','shenyuxiang','ningke','lifei'};

load([subj_name{2} '_day1']);
nTrials = sum(trials_index);


rawData = NaN(length(subj_name),nTrials,800,size(savedData,3)); % --- 1-2:x,y;3:time;4:Distance;5:velocity
trialInfo = NaN(length(subj_name),nTrials,8); % --- 1:direction; 2:trial index; 3:startStep; 4:endStep; 5: valid_time 6:endDistance; 7:max speed  8: degree at pv


expInfo.subj_name = subj_name;

endData = NaN(length(subj_name),trialsNum,4); % --- 1:2??the position of end point 3: angle 4:distance
peakData = NaN(length(subj_name),trialsNum,5); % --- 1:2??the position of pk point 3:angle  4:distance  5:velocity
% skip = NaN(length(subj_name),trialsNum); % --- skip trials
MoveTime=NaN(length(subj_name),trialsNum);
RT=NaN(length(subj_name),trialsNum);
trialEndStep=NaN(length(subj_name),trialsNum);
trialBeginStep=NaN(length(subj_name),trialsNum);
trialBegStep=NaN(length(subj_name),trialsNum);
TimePeak=NaN(length(subj_name),trialsNum);
IfOutlier=zeros(length(subj_name),trialsNum);%---normal:0, outlier:1

for subj_i = 1:length(subj_name)
    clear file_name save* test_direction
    file_name = [subj_name{subj_i} '_day1'];
    load(file_name);
    trialInfo(subj_i,:,1) = test_direction;
    trialInfo(subj_i,:,2) = session_iPerTrial;
    skipTrials=[];
    % --- get the position end point
    for trial_i = 1:nTrials
        if isempty(find(skipTrials == trial_i, 1))
            clear temp*
            
            
            
            [C,S] = max(savedData(trial_i,1:trialsEndStep(trial_i),5));
            peakData(subj_i,trial_i,1:2) = savedData(trial_i,S,6:7);
            peakData(subj_i,trial_i,6) = savedData(trial_i,S,3);   % PV??????????
            peakData(subj_i,trial_i,5) = C;
            peakData(subj_i,trial_i,4) = sqrtm((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))^2+((squeeze(peakData(subj_i,trial_i,2))-startingPos_scr(1,2)))^2);
            trialEndStep(subj_i,trial_i)=trialsEndStep(trial_i);
            
            trialBeginStep(subj_i,trial_i)=find(savedData(trial_i,:,5)>0.01*peakData(subj_i,trial_i,5)& savedData(trial_i,:,4)>8 ,1);
            if trialEndStep(subj_i,trial_i)>1 && trialBeginStep(subj_i,trial_i)>1
                MoveTime(subj_i,trial_i)=savedData(trial_i,trialEndStep(subj_i,trial_i),3)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
                %             MoveTime(subj_i,trial_i)=savedData(trial_i,trialsEndStep(trial_i),3)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
                
                RT(subj_i,trial_i)=savedData(trial_i,trialBeginStep(subj_i,trial_i),3)-savedData(trial_i,1,3);
                TimePeak(subj_i,trial_i)=peakData(subj_i,trial_i,6)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
            end;
            if  MoveTime(subj_i,trial_i)>=0.3
                %                 MoveTime(subj_i,trial_i)=NaN;
                %                 RT(subj_i,trial_i)=NaN;
                %                 TimePeak(subj_i,trial_i)=NaN;
                IfOutlier(subj_i,trial_i)=1;
            end;
            
            %             if  MoveTime(subj_i,trial_i)>=1
            %                 MoveTime(subj_i,trial_i)=NaN;
            %                 RT(subj_i,trial_i)=NaN;
            %                 TimePeak(subj_i,trial_i)=NaN;
            %             end;
            %
            %             if  RT(subj_i,trial_i)<=0.1 || RT(subj_i,trial_i)>=6
            %                 MoveTime(subj_i,trial_i)=NaN;
            %                 RT(subj_i,trial_i)=NaN;
            %                 TimePeak(subj_i,trial_i)=NaN;
            %             end;
            
            
            if squeeze((peakData(subj_i,trial_i,2)-startingPos_scr(1,2)))>=0
                if squeeze((peakData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0   % ????????
                    peakData(subj_i,trial_i,3) = acos((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4)))*180/pi;
                else  % ????????
                    peakData(subj_i,trial_i,3) = (pi-acos(abs(squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                end;
            else
                if squeeze((peakData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0   % ????????
                    peakData(subj_i,trial_i,3) = (2*pi-acos((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                else  % ????????
                    peakData(subj_i,trial_i,3) = (pi+acos(abs(squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                end;
            end;
            trialInfo(subj_i,trial_i,8) = peakData(subj_i,trial_i,3);
            trialInfo(subj_i,trial_i,3)= find(savedData(trial_i,:,4)>5,1);
            trialInfo(subj_i,trial_i,4)=trialsEndStep(trial_i);
            trialInfo(subj_i,trial_i,5) = savedData(trial_i, trialsEndStep(trial_i),3)- savedData(trial_i,trialInfo(subj_i,trial_i,3),3);  % valid time
            trialInfo(subj_i,trial_i,6) = savedData(trial_i, trialsEndStep(trial_i),4);  % endpoint distance
            trialInfo(subj_i,trial_i,7) = max(savedData(trial_i,trialInfo(subj_i,trial_i,3):trialsEndStep(trial_i),4));  % --- max speed
            
            endData(subj_i,trial_i,1:2) = savedData(trial_i,trialsEndStep(trial_i),6:7);
            endData(subj_i,trial_i,4) = sqrtm((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))^2+((squeeze(endData(subj_i,trial_i,2))-startingPos_scr(1,2)))^2);
            if squeeze((endData(subj_i,trial_i,2)- startingPos_scr(1,2)))>=0
                if squeeze((endData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0
                    endData(subj_i,trial_i,3) = acos((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4)))*180/pi;
                    
                else
                    endData(subj_i,trial_i,3) = (pi-acos(abs(squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                end;
            else
                if squeeze((endData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0
                    endData(subj_i,trial_i,3) = (2*pi-acos((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                    
                else
                    endData(subj_i,trial_i,3) = (pi+acos(abs(squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                end;
            end;
            
            
        end;    %  if isempty
        
        
    end; % for trial
    rawData(subj_i,:,:,:) = savedData(:,1:800,:);
    trialInfo(subj_i,skipTrials,:) = NaN;
    rawData(subj_i,skipTrials,:,:) = NaN;
    
end; % for subj

clear fileName;
fileName = ['GR_subj' num2str(length(subj_name)) '_day1_a'];
save(fileName,'rawData','trialInfo','expInfo','endData','peakData','MoveTime','RT','TimePeak','IfOutlier');

% day2
clear all
close all
cd('D:\mine\lab\projects\motor learning with tDCS\data');
% subj_name={'youfangyi','hangwenjie','molonghua','niwenqing','wangzongrui','xuyue','luoyi','yuxiaohan','linling','haochenqi','wangping','wanghao','mayuhui','shenyuxiang','ningke','lifei'};
subj_name={'youfangyi','molonghua','niwenqing','wangzongrui','xuyue','luoyi','yuxiaohan','linling','haochenqi','wangping','wanghao','mayuhui','shenyuxiang','ningke','lifei'};

load([subj_name{1} '_day2']);
nTrials = sum(trials_index);


rawData = NaN(length(subj_name),nTrials,800,size(savedData,3)); % --- 1-2:x,y;3:time;4:Distance;5:velocity
trialInfo = NaN(length(subj_name),nTrials,8); % --- 1:direction; 2:trial index; 3:startStep; 4:endStep; 5: valid_time 6:endDistance; 7:max speed  8: degree at pv


expInfo.subj_name = subj_name;

endData = NaN(length(subj_name),trialsNum,4); % --- 1:2??the position of end point 3: angle 4:distance
peakData = NaN(length(subj_name),trialsNum,5); % --- 1:2??the position of pk point 3:angle  4:distance  5:velocity
% skip = NaN(length(subj_name),trialsNum); % --- skip trials
MoveTime=NaN(length(subj_name),trialsNum);
RT=NaN(length(subj_name),trialsNum);
trialEndStep=NaN(length(subj_name),trialsNum);
trialBeginStep=NaN(length(subj_name),trialsNum);
trialBegStep=NaN(length(subj_name),trialsNum);
TimePeak=NaN(length(subj_name),trialsNum);
IfOutlier=zeros(length(subj_name),trialsNum);%---normal:0, outlier:1

for subj_i = 1:length(subj_name)
    clear file_name save* test_direction
    file_name = [subj_name{subj_i} '_day2'];
    load(file_name);
    trialInfo(subj_i,:,1) = test_direction;
    trialInfo(subj_i,:,2) = session_iPerTrial+max(session_iPerTrial);%！！！！day2 session start from 5
    skipTrials=[];
    % --- get the position end point
    for trial_i = 1:nTrials
        if isempty(find(skipTrials == trial_i, 1))
            clear temp*
            
            
            
            [C,S] = max(savedData(trial_i,1:trialsEndStep(trial_i),5));
            peakData(subj_i,trial_i,1:2) = savedData(trial_i,S,6:7);
            peakData(subj_i,trial_i,6) = savedData(trial_i,S,3);   % PV??????????
            peakData(subj_i,trial_i,5) = C;
            peakData(subj_i,trial_i,4) = sqrtm((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))^2+((squeeze(peakData(subj_i,trial_i,2))-startingPos_scr(1,2)))^2);
            trialEndStep(subj_i,trial_i)=trialsEndStep(trial_i);
            
            trialBeginStep(subj_i,trial_i)=find(savedData(trial_i,:,5)>0.01*peakData(subj_i,trial_i,5)& savedData(trial_i,:,4)>8 ,1);
            if trialEndStep(subj_i,trial_i)>1 && trialBeginStep(subj_i,trial_i)>1
                MoveTime(subj_i,trial_i)=savedData(trial_i,trialEndStep(subj_i,trial_i),3)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
                %             MoveTime(subj_i,trial_i)=savedData(trial_i,trialsEndStep(trial_i),3)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
                
                RT(subj_i,trial_i)=savedData(trial_i,trialBeginStep(subj_i,trial_i),3)-savedData(trial_i,1,3);
                TimePeak(subj_i,trial_i)=peakData(subj_i,trial_i,6)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
            end;
            if  MoveTime(subj_i,trial_i)>=0.3
                %                 MoveTime(subj_i,trial_i)=NaN;
                %                 RT(subj_i,trial_i)=NaN;
                %                 TimePeak(subj_i,trial_i)=NaN;
                IfOutlier(subj_i,trial_i)=1;
            end;
            
            %             if  MoveTime(subj_i,trial_i)>=1
            %                 MoveTime(subj_i,trial_i)=NaN;
            %                 RT(subj_i,trial_i)=NaN;
            %                 TimePeak(subj_i,trial_i)=NaN;
            %             end;
            %
            %             if  RT(subj_i,trial_i)<=0.1 || RT(subj_i,trial_i)>=6
            %                 MoveTime(subj_i,trial_i)=NaN;
            %                 RT(subj_i,trial_i)=NaN;
            %                 TimePeak(subj_i,trial_i)=NaN;
            %             end;
            
            
            if squeeze((peakData(subj_i,trial_i,2)-startingPos_scr(1,2)))>=0
                if squeeze((peakData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0   % ????????
                    peakData(subj_i,trial_i,3) = acos((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4)))*180/pi;
                else  % ????????
                    peakData(subj_i,trial_i,3) = (pi-acos(abs(squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                end;
            else
                if squeeze((peakData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0   % ????????
                    peakData(subj_i,trial_i,3) = (2*pi-acos((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                else  % ????????
                    peakData(subj_i,trial_i,3) = (pi+acos(abs(squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                end;
            end;
            trialInfo(subj_i,trial_i,8) = peakData(subj_i,trial_i,3);
            trialInfo(subj_i,trial_i,3)= find(savedData(trial_i,:,4)>5,1);
            trialInfo(subj_i,trial_i,4)=trialsEndStep(trial_i);
            trialInfo(subj_i,trial_i,5) = savedData(trial_i, trialsEndStep(trial_i),3)- savedData(trial_i,trialInfo(subj_i,trial_i,3),3);  % valid time
            trialInfo(subj_i,trial_i,6) = savedData(trial_i, trialsEndStep(trial_i),4);  % endpoint distance
            trialInfo(subj_i,trial_i,7) = max(savedData(trial_i,trialInfo(subj_i,trial_i,3):trialsEndStep(trial_i),4));  % --- max speed
            
            endData(subj_i,trial_i,1:2) = savedData(trial_i,trialsEndStep(trial_i),6:7);
            endData(subj_i,trial_i,4) = sqrtm((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))^2+((squeeze(endData(subj_i,trial_i,2))-startingPos_scr(1,2)))^2);
            if squeeze((endData(subj_i,trial_i,2)- startingPos_scr(1,2)))>=0
                if squeeze((endData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0
                    endData(subj_i,trial_i,3) = acos((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4)))*180/pi;
                    
                else
                    endData(subj_i,trial_i,3) = (pi-acos(abs(squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                end;
            else
                if squeeze((endData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0
                    endData(subj_i,trial_i,3) = (2*pi-acos((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                    
                else
                    endData(subj_i,trial_i,3) = (pi+acos(abs(squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                end;
            end;
            
            
        end;    %  if isempty
        
        
    end; % for trial
    rawData(subj_i,:,:,:) = savedData(:,1:800,:);
    trialInfo(subj_i,skipTrials,:) = NaN;
    rawData(subj_i,skipTrials,:,:) = NaN;
    
end; % for subj

clear fileName;
fileName = ['GR_subj' num2str(length(subj_name)) '_day2_a'];
save(fileName,'rawData','trialInfo','expInfo','endData','peakData','MoveTime','RT','TimePeak','IfOutlier');
% put 2 days together
clear all;
fileName='GR_subj15';
load([fileName '_day1_a']);

raw1=rawData;
trial1=trialInfo;
exp1=expInfo;
end1=endData;
peak1=peakData;
MT1=MoveTime;
RT1=RT;
TP1=TimePeak;
OT1=IfOutlier;

load([fileName '_day2_a']);
% load Gradual_subj4_day2
raw2=rawData;
trial2=trialInfo;
exp2=expInfo;
end2=endData;
peak2=peakData;
MT2=MoveTime;
RT2=RT;
TP2=TimePeak;
OT2=IfOutlier;

rawData=[raw1 raw2];
trialInfo=[trial1 trial2];
expInfo=exp1;%names are the same
endData=[end1 end2];
peakData=[peak1 peak2];
MoveTime=[MT1 MT2];
RT=[RT1 RT2];
TimePeak=[TP1 TP2];
IfOutlier=[OT1 OT2];


fileName = [fileName '_a'];
save(fileName,'rawData','trialInfo','expInfo','endData','peakData','MoveTime','RT','TimePeak','IfOutlier');


%% Sham, 10 washout cycles
%day1
clear all
close all
cd('D:\mine\lab\projects\motor learning with tDCS\data');
subj_name={'shizihan','chenxinguang','zhangxia','yeyongqing','yangqianling','lijing','guoqiaomin','linqingqing','liujiading','wenzihui','chengquan','maoyanding','limengqi'};

load([subj_name{2} '_day1']);
nTrials = sum(trials_index);


rawData = NaN(length(subj_name),nTrials,800,size(savedData,3)); % --- 1-2:x,y;3:time;4:Distance;5:velocity
trialInfo = NaN(length(subj_name),nTrials,8); % --- 1:direction; 2:trial index; 3:startStep; 4:endStep; 5: valid_time 6:endDistance; 7:max speed  8: degree at pv


expInfo.subj_name = subj_name;

endData = NaN(length(subj_name),trialsNum,4); % --- 1:2??the position of end point 3: angle 4:distance
peakData = NaN(length(subj_name),trialsNum,5); % --- 1:2??the position of pk point 3:angle  4:distance  5:velocity
% skip = NaN(length(subj_name),trialsNum); % --- skip trials
MoveTime=NaN(length(subj_name),trialsNum);
RT=NaN(length(subj_name),trialsNum);
trialEndStep=NaN(length(subj_name),trialsNum);
trialBeginStep=NaN(length(subj_name),trialsNum);
trialBegStep=NaN(length(subj_name),trialsNum);
TimePeak=NaN(length(subj_name),trialsNum);
IfOutlier=zeros(length(subj_name),trialsNum);%---normal:0, outlier:1

for subj_i = 1:length(subj_name)
    clear file_name save* test_direction
    file_name = [subj_name{subj_i} '_day1'];
    load(file_name);
    trialInfo(subj_i,:,1) = test_direction;
    trialInfo(subj_i,:,2) = session_iPerTrial;
    skipTrials=[];
    % --- get the position end point
    for trial_i = 1:nTrials
        if isempty(find(skipTrials == trial_i, 1))
            clear temp*
            
            
            
            [C,S] = max(savedData(trial_i,1:trialsEndStep(trial_i),5));
            peakData(subj_i,trial_i,1:2) = savedData(trial_i,S,6:7);
            peakData(subj_i,trial_i,6) = savedData(trial_i,S,3);   % PV??????????
            peakData(subj_i,trial_i,5) = C;
            peakData(subj_i,trial_i,4) = sqrtm((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))^2+((squeeze(peakData(subj_i,trial_i,2))-startingPos_scr(1,2)))^2);
            trialEndStep(subj_i,trial_i)=trialsEndStep(trial_i);
            
            trialBeginStep(subj_i,trial_i)=find(savedData(trial_i,:,5)>0.01*peakData(subj_i,trial_i,5)& savedData(trial_i,:,4)>8 ,1);
            if trialEndStep(subj_i,trial_i)>1 && trialBeginStep(subj_i,trial_i)>1
                MoveTime(subj_i,trial_i)=savedData(trial_i,trialEndStep(subj_i,trial_i),3)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
                %             MoveTime(subj_i,trial_i)=savedData(trial_i,trialsEndStep(trial_i),3)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
                
                RT(subj_i,trial_i)=savedData(trial_i,trialBeginStep(subj_i,trial_i),3)-savedData(trial_i,1,3);
                TimePeak(subj_i,trial_i)=peakData(subj_i,trial_i,6)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
            end;
            if  MoveTime(subj_i,trial_i)>=0.3
                %                 MoveTime(subj_i,trial_i)=NaN;
                %                 RT(subj_i,trial_i)=NaN;
                %                 TimePeak(subj_i,trial_i)=NaN;
                IfOutlier(subj_i,trial_i)=1;
            end;
            
            %             if  MoveTime(subj_i,trial_i)>=1
            %                 MoveTime(subj_i,trial_i)=NaN;
            %                 RT(subj_i,trial_i)=NaN;
            %                 TimePeak(subj_i,trial_i)=NaN;
            %             end;
            %
            %             if  RT(subj_i,trial_i)<=0.1 || RT(subj_i,trial_i)>=6
            %                 MoveTime(subj_i,trial_i)=NaN;
            %                 RT(subj_i,trial_i)=NaN;
            %                 TimePeak(subj_i,trial_i)=NaN;
            %             end;
            
            
            if squeeze((peakData(subj_i,trial_i,2)-startingPos_scr(1,2)))>=0
                if squeeze((peakData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0   % ????????
                    peakData(subj_i,trial_i,3) = acos((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4)))*180/pi;
                else  % ????????
                    peakData(subj_i,trial_i,3) = (pi-acos(abs(squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                end;
            else
                if squeeze((peakData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0   % ????????
                    peakData(subj_i,trial_i,3) = (2*pi-acos((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                else  % ????????
                    peakData(subj_i,trial_i,3) = (pi+acos(abs(squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                end;
            end;
            trialInfo(subj_i,trial_i,8) = peakData(subj_i,trial_i,3);
            trialInfo(subj_i,trial_i,3)= find(savedData(trial_i,:,4)>5,1);
            trialInfo(subj_i,trial_i,4)=trialsEndStep(trial_i);
            trialInfo(subj_i,trial_i,5) = savedData(trial_i, trialsEndStep(trial_i),3)- savedData(trial_i,trialInfo(subj_i,trial_i,3),3);  % valid time
            trialInfo(subj_i,trial_i,6) = savedData(trial_i, trialsEndStep(trial_i),4);  % endpoint distance
            trialInfo(subj_i,trial_i,7) = max(savedData(trial_i,trialInfo(subj_i,trial_i,3):trialsEndStep(trial_i),4));  % --- max speed
            
            endData(subj_i,trial_i,1:2) = savedData(trial_i,trialsEndStep(trial_i),6:7);
            endData(subj_i,trial_i,4) = sqrtm((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))^2+((squeeze(endData(subj_i,trial_i,2))-startingPos_scr(1,2)))^2);
            if squeeze((endData(subj_i,trial_i,2)- startingPos_scr(1,2)))>=0
                if squeeze((endData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0
                    endData(subj_i,trial_i,3) = acos((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4)))*180/pi;
                    
                else
                    endData(subj_i,trial_i,3) = (pi-acos(abs(squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                end;
            else
                if squeeze((endData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0
                    endData(subj_i,trial_i,3) = (2*pi-acos((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                    
                else
                    endData(subj_i,trial_i,3) = (pi+acos(abs(squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                end;
            end;
            
            
        end;    %  if isempty
        
        
    end; % for trial
    rawData(subj_i,:,:,:) = savedData(:,1:800,:);
    trialInfo(subj_i,skipTrials,:) = NaN;
    rawData(subj_i,skipTrials,:,:) = NaN;
    
end; % for subj

clear fileName;
fileName = ['GR_subj' num2str(length(subj_name)) '_day1_s'];
save(fileName,'rawData','trialInfo','expInfo','endData','peakData','MoveTime','RT','TimePeak','IfOutlier');

% day2
clear all
close all
cd('D:\mine\lab\projects\motor learning with tDCS\data');
subj_name={'shizihan','chenxinguang','zhangxia','yeyongqing','yangqianling','lijing','guoqiaomin','linqingqing','liujiading','wenzihui','chengquan','maoyanding','limengqi'};

load([subj_name{1} '_day2']);
nTrials = sum(trials_index);


rawData = NaN(length(subj_name),nTrials,800,size(savedData,3)); % --- 1-2:x,y;3:time;4:Distance;5:velocity
trialInfo = NaN(length(subj_name),nTrials,8); % --- 1:direction; 2:trial index; 3:startStep; 4:endStep; 5: valid_time 6:endDistance; 7:max speed  8: degree at pv


expInfo.subj_name = subj_name;

endData = NaN(length(subj_name),trialsNum,4); % --- 1:2??the position of end point 3: angle 4:distance
peakData = NaN(length(subj_name),trialsNum,5); % --- 1:2??the position of pk point 3:angle  4:distance  5:velocity
% skip = NaN(length(subj_name),trialsNum); % --- skip trials
MoveTime=NaN(length(subj_name),trialsNum);
RT=NaN(length(subj_name),trialsNum);
trialEndStep=NaN(length(subj_name),trialsNum);
trialBeginStep=NaN(length(subj_name),trialsNum);
trialBegStep=NaN(length(subj_name),trialsNum);
TimePeak=NaN(length(subj_name),trialsNum);
IfOutlier=zeros(length(subj_name),trialsNum);%---normal:0, outlier:1

for subj_i = 1:length(subj_name)
    clear file_name save* test_direction
    file_name = [subj_name{subj_i} '_day2'];
    load(file_name);
    trialInfo(subj_i,:,1) = test_direction;
    trialInfo(subj_i,:,2) = session_iPerTrial+max(session_iPerTrial);%！！！！day2 session start from 5
    skipTrials=[];
    % --- get the position end point
    for trial_i = 1:nTrials
        if isempty(find(skipTrials == trial_i, 1))
            clear temp*
            
            
            
            [C,S] = max(savedData(trial_i,1:trialsEndStep(trial_i),5));
            peakData(subj_i,trial_i,1:2) = savedData(trial_i,S,6:7);
            peakData(subj_i,trial_i,6) = savedData(trial_i,S,3);   % PV??????????
            peakData(subj_i,trial_i,5) = C;
            peakData(subj_i,trial_i,4) = sqrtm((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))^2+((squeeze(peakData(subj_i,trial_i,2))-startingPos_scr(1,2)))^2);
            trialEndStep(subj_i,trial_i)=trialsEndStep(trial_i);
            
            trialBeginStep(subj_i,trial_i)=find(savedData(trial_i,:,5)>0.01*peakData(subj_i,trial_i,5)& savedData(trial_i,:,4)>8 ,1);
            if trialEndStep(subj_i,trial_i)>1 && trialBeginStep(subj_i,trial_i)>1
                MoveTime(subj_i,trial_i)=savedData(trial_i,trialEndStep(subj_i,trial_i),3)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
                %             MoveTime(subj_i,trial_i)=savedData(trial_i,trialsEndStep(trial_i),3)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
                
                RT(subj_i,trial_i)=savedData(trial_i,trialBeginStep(subj_i,trial_i),3)-savedData(trial_i,1,3);
                TimePeak(subj_i,trial_i)=peakData(subj_i,trial_i,6)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
            end;
            if  MoveTime(subj_i,trial_i)>=0.3
                %                 MoveTime(subj_i,trial_i)=NaN;
                %                 RT(subj_i,trial_i)=NaN;
                %                 TimePeak(subj_i,trial_i)=NaN;
                IfOutlier(subj_i,trial_i)=1;
            end;
            
            %             if  MoveTime(subj_i,trial_i)>=1
            %                 MoveTime(subj_i,trial_i)=NaN;
            %                 RT(subj_i,trial_i)=NaN;
            %                 TimePeak(subj_i,trial_i)=NaN;
            %             end;
            %
            %             if  RT(subj_i,trial_i)<=0.1 || RT(subj_i,trial_i)>=6
            %                 MoveTime(subj_i,trial_i)=NaN;
            %                 RT(subj_i,trial_i)=NaN;
            %                 TimePeak(subj_i,trial_i)=NaN;
            %             end;
            
            
            if squeeze((peakData(subj_i,trial_i,2)-startingPos_scr(1,2)))>=0
                if squeeze((peakData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0   % ????????
                    peakData(subj_i,trial_i,3) = acos((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4)))*180/pi;
                else  % ????????
                    peakData(subj_i,trial_i,3) = (pi-acos(abs(squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                end;
            else
                if squeeze((peakData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0   % ????????
                    peakData(subj_i,trial_i,3) = (2*pi-acos((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                else  % ????????
                    peakData(subj_i,trial_i,3) = (pi+acos(abs(squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                end;
            end;
            trialInfo(subj_i,trial_i,8) = peakData(subj_i,trial_i,3);
            trialInfo(subj_i,trial_i,3)= find(savedData(trial_i,:,4)>5,1);
            trialInfo(subj_i,trial_i,4)=trialsEndStep(trial_i);
            trialInfo(subj_i,trial_i,5) = savedData(trial_i, trialsEndStep(trial_i),3)- savedData(trial_i,trialInfo(subj_i,trial_i,3),3);  % valid time
            trialInfo(subj_i,trial_i,6) = savedData(trial_i, trialsEndStep(trial_i),4);  % endpoint distance
            trialInfo(subj_i,trial_i,7) = max(savedData(trial_i,trialInfo(subj_i,trial_i,3):trialsEndStep(trial_i),4));  % --- max speed
            
            endData(subj_i,trial_i,1:2) = savedData(trial_i,trialsEndStep(trial_i),6:7);
            endData(subj_i,trial_i,4) = sqrtm((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))^2+((squeeze(endData(subj_i,trial_i,2))-startingPos_scr(1,2)))^2);
            if squeeze((endData(subj_i,trial_i,2)- startingPos_scr(1,2)))>=0
                if squeeze((endData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0
                    endData(subj_i,trial_i,3) = acos((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4)))*180/pi;
                    
                else
                    endData(subj_i,trial_i,3) = (pi-acos(abs(squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                end;
            else
                if squeeze((endData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0
                    endData(subj_i,trial_i,3) = (2*pi-acos((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                    
                else
                    endData(subj_i,trial_i,3) = (pi+acos(abs(squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                end;
            end;
            
            
        end;    %  if isempty
        
        
    end; % for trial
    rawData(subj_i,:,:,:) = savedData(:,1:800,:);
    trialInfo(subj_i,skipTrials,:) = NaN;
    rawData(subj_i,skipTrials,:,:) = NaN;
    
end; % for subj

clear fileName;
fileName = ['GR_subj' num2str(length(subj_name)) '_day2_s'];
save(fileName,'rawData','trialInfo','expInfo','endData','peakData','MoveTime','RT','TimePeak','IfOutlier');
% put 2 days together
clear all;
fileName='GR_subj13';
load([fileName '_day1_s']);

raw1=rawData;
trial1=trialInfo;
exp1=expInfo;
end1=endData;
peak1=peakData;
MT1=MoveTime;
RT1=RT;
TP1=TimePeak;
OT1=IfOutlier;

load([fileName '_day2_s']);
% load Gradual_subj4_day2
raw2=rawData;
trial2=trialInfo;
exp2=expInfo;
end2=endData;
peak2=peakData;
MT2=MoveTime;
RT2=RT;
TP2=TimePeak;
OT2=IfOutlier;

rawData=[raw1 raw2];
trialInfo=[trial1 trial2];
expInfo=exp1;%names are the same
endData=[end1 end2];
peakData=[peak1 peak2];
MoveTime=[MT1 MT2];
RT=[RT1 RT2];
TimePeak=[TP1 TP2];
IfOutlier=[OT1 OT2];


fileName = [fileName '_s'];
save(fileName,'rawData','trialInfo','expInfo','endData','peakData','MoveTime','RT','TimePeak','IfOutlier');
%% Sham, 20 washout cycles
% day1 
clear all
close all
cd('D:\mine\lab\projects\motor learning with tDCS\data');
% subj_name={'lifangwen','luoaoxuan','zhangdongliang','zhangyuhan','wuyuxuan','xiesisi','zhangdapeng','hanxiangli','yuanchen'};
subj_name={'lifangwen','luoaoxuan','zhangdongliang','zhangyuhan','wuyuxuan','xiesisi','hanxiangli','yuanchen',...
'zhangxinqi','chengfanfan','wangdingding','lixinxin','wangguangying','wangyuxuan','xiemingchen','liujie','yangxu'};

load([subj_name{2} '_day1']);
nTrials = sum(trials_index);


rawData = NaN(length(subj_name),nTrials,800,size(savedData,3)); % --- 1-2:x,y;3:time;4:Distance;5:velocity
trialInfo = NaN(length(subj_name),nTrials,8); % --- 1:direction; 2:trial index; 3:startStep; 4:endStep; 5: valid_time 6:endDistance; 7:max speed  8: degree at pv


expInfo.subj_name = subj_name;

endData = NaN(length(subj_name),trialsNum,4); % --- 1:2??the position of end point 3: angle 4:distance
peakData = NaN(length(subj_name),trialsNum,5); % --- 1:2??the position of pk point 3:angle  4:distance  5:velocity
% skip = NaN(length(subj_name),trialsNum); % --- skip trials
MoveTime=NaN(length(subj_name),trialsNum);
RT=NaN(length(subj_name),trialsNum);
trialEndStep=NaN(length(subj_name),trialsNum);
trialBeginStep=NaN(length(subj_name),trialsNum);
trialBegStep=NaN(length(subj_name),trialsNum);
TimePeak=NaN(length(subj_name),trialsNum);
IfOutlier=zeros(length(subj_name),trialsNum);%---normal:0, outlier:1

for subj_i = 1:length(subj_name)
    clear file_name save* test_direction
    file_name = [subj_name{subj_i} '_day1'];
    load(file_name);
    trialInfo(subj_i,:,1) = test_direction;
    trialInfo(subj_i,:,2) = session_iPerTrial;
    skipTrials=[];
    % --- get the position end point
    for trial_i = 1:nTrials
        if isempty(find(skipTrials == trial_i, 1))
            clear temp*
            
            
            
            [C,S] = max(savedData(trial_i,1:trialsEndStep(trial_i),5));
            peakData(subj_i,trial_i,1:2) = savedData(trial_i,S,6:7);
            peakData(subj_i,trial_i,6) = savedData(trial_i,S,3);   % PV??????????
            peakData(subj_i,trial_i,5) = C;
            peakData(subj_i,trial_i,4) = sqrtm((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))^2+((squeeze(peakData(subj_i,trial_i,2))-startingPos_scr(1,2)))^2);
            trialEndStep(subj_i,trial_i)=trialsEndStep(trial_i);
            
            trialBeginStep(subj_i,trial_i)=find(savedData(trial_i,:,5)>0.01*peakData(subj_i,trial_i,5)& savedData(trial_i,:,4)>8 ,1);
            if trialEndStep(subj_i,trial_i)>1 && trialBeginStep(subj_i,trial_i)>1
                MoveTime(subj_i,trial_i)=savedData(trial_i,trialEndStep(subj_i,trial_i),3)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
                %             MoveTime(subj_i,trial_i)=savedData(trial_i,trialsEndStep(trial_i),3)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
                
                RT(subj_i,trial_i)=savedData(trial_i,trialBeginStep(subj_i,trial_i),3)-savedData(trial_i,1,3);
                TimePeak(subj_i,trial_i)=peakData(subj_i,trial_i,6)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
            end;
            if  MoveTime(subj_i,trial_i)>=0.3
                %                 MoveTime(subj_i,trial_i)=NaN;
                %                 RT(subj_i,trial_i)=NaN;
                %                 TimePeak(subj_i,trial_i)=NaN;
                IfOutlier(subj_i,trial_i)=1;
            end;
            
            %             if  MoveTime(subj_i,trial_i)>=1
            %                 MoveTime(subj_i,trial_i)=NaN;
            %                 RT(subj_i,trial_i)=NaN;
            %                 TimePeak(subj_i,trial_i)=NaN;
            %             end;
            %
            %             if  RT(subj_i,trial_i)<=0.1 || RT(subj_i,trial_i)>=6
            %                 MoveTime(subj_i,trial_i)=NaN;
            %                 RT(subj_i,trial_i)=NaN;
            %                 TimePeak(subj_i,trial_i)=NaN;
            %             end;
            
            
            if squeeze((peakData(subj_i,trial_i,2)-startingPos_scr(1,2)))>=0
                if squeeze((peakData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0   % ????????
                    peakData(subj_i,trial_i,3) = acos((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4)))*180/pi;
                else  % ????????
                    peakData(subj_i,trial_i,3) = (pi-acos(abs(squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                end;
            else
                if squeeze((peakData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0   % ????????
                    peakData(subj_i,trial_i,3) = (2*pi-acos((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                else  % ????????
                    peakData(subj_i,trial_i,3) = (pi+acos(abs(squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                end;
            end;
            trialInfo(subj_i,trial_i,8) = peakData(subj_i,trial_i,3);
            trialInfo(subj_i,trial_i,3)= find(savedData(trial_i,:,4)>5,1);
            trialInfo(subj_i,trial_i,4)=trialsEndStep(trial_i);
            trialInfo(subj_i,trial_i,5) = savedData(trial_i, trialsEndStep(trial_i),3)- savedData(trial_i,trialInfo(subj_i,trial_i,3),3);  % valid time
            trialInfo(subj_i,trial_i,6) = savedData(trial_i, trialsEndStep(trial_i),4);  % endpoint distance
            trialInfo(subj_i,trial_i,7) = max(savedData(trial_i,trialInfo(subj_i,trial_i,3):trialsEndStep(trial_i),4));  % --- max speed
            
            endData(subj_i,trial_i,1:2) = savedData(trial_i,trialsEndStep(trial_i),6:7);
            endData(subj_i,trial_i,4) = sqrtm((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))^2+((squeeze(endData(subj_i,trial_i,2))-startingPos_scr(1,2)))^2);
            if squeeze((endData(subj_i,trial_i,2)- startingPos_scr(1,2)))>=0
                if squeeze((endData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0
                    endData(subj_i,trial_i,3) = acos((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4)))*180/pi;
                    
                else
                    endData(subj_i,trial_i,3) = (pi-acos(abs(squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                end;
            else
                if squeeze((endData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0
                    endData(subj_i,trial_i,3) = (2*pi-acos((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                    
                else
                    endData(subj_i,trial_i,3) = (pi+acos(abs(squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                end;
            end;
            
            
        end;    %  if isempty
        
        
    end; % for trial
    rawData(subj_i,:,:,:) = savedData(:,1:800,:);
    trialInfo(subj_i,skipTrials,:) = NaN;
    rawData(subj_i,skipTrials,:,:) = NaN;
    
end; % for subj

clear fileName;
fileName = ['GR_subj' num2str(length(subj_name)) '_day1_s'];
% save(fileName,'rawData','trialInfo','expInfo','endData','peakData','MoveTime','RT','TimePeak','IfOutlier');
save(fileName,'trialInfo','expInfo','endData','peakData','MoveTime','RT','TimePeak','IfOutlier');

%  day2
clear all
close all
cd('D:\mine\lab\projects\motor learning with tDCS\data');
% subj_name={'lifangwen','luoaoxuan','zhangdongliang','zhangyuhan','wuyuxuan','xiesisi','zhangdapeng','hanxiangli','yuanchen'};
subj_name={'lifangwen','luoaoxuan','zhangdongliang','zhangyuhan','wuyuxuan','xiesisi','hanxiangli','yuanchen',...
'zhangxinqi','chengfanfan','wangdingding','lixinxin','wangguangying','wangyuxuan','xiemingchen','liujie','yangxu'};
load([subj_name{1} '_day2']);
nTrials = sum(trials_index);


rawData = NaN(length(subj_name),nTrials,800,size(savedData,3)); % --- 1-2:x,y;3:time;4:Distance;5:velocity
trialInfo = NaN(length(subj_name),nTrials,8); % --- 1:direction; 2:trial index; 3:startStep; 4:endStep; 5: valid_time 6:endDistance; 7:max speed  8: degree at pv


expInfo.subj_name = subj_name;

endData = NaN(length(subj_name),trialsNum,4); % --- 1:2??the position of end point 3: angle 4:distance
peakData = NaN(length(subj_name),trialsNum,5); % --- 1:2??the position of pk point 3:angle  4:distance  5:velocity
% skip = NaN(length(subj_name),trialsNum); % --- skip trials
MoveTime=NaN(length(subj_name),trialsNum);
RT=NaN(length(subj_name),trialsNum);
trialEndStep=NaN(length(subj_name),trialsNum);
trialBeginStep=NaN(length(subj_name),trialsNum);
trialBegStep=NaN(length(subj_name),trialsNum);
TimePeak=NaN(length(subj_name),trialsNum);
IfOutlier=zeros(length(subj_name),trialsNum);%---normal:0, outlier:1

for subj_i = 1:length(subj_name)
    clear file_name save* test_direction
    file_name = [subj_name{subj_i} '_day2'];
    load(file_name);
    trialInfo(subj_i,:,1) = test_direction;
    trialInfo(subj_i,:,2) = session_iPerTrial+max(session_iPerTrial);%！！！！day2 session start from 5
    skipTrials=[];
    % --- get the position end point
    for trial_i = 1:nTrials
        if isempty(find(skipTrials == trial_i, 1))
            clear temp*
            
            
            
            [C,S] = max(savedData(trial_i,1:trialsEndStep(trial_i),5));
            peakData(subj_i,trial_i,1:2) = savedData(trial_i,S,6:7);
            peakData(subj_i,trial_i,6) = savedData(trial_i,S,3);   % PV??????????
            peakData(subj_i,trial_i,5) = C;
            peakData(subj_i,trial_i,4) = sqrtm((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))^2+((squeeze(peakData(subj_i,trial_i,2))-startingPos_scr(1,2)))^2);
            trialEndStep(subj_i,trial_i)=trialsEndStep(trial_i);
            
            trialBeginStep(subj_i,trial_i)=find(savedData(trial_i,:,5)>0.01*peakData(subj_i,trial_i,5)& savedData(trial_i,:,4)>8 ,1);
            if trialEndStep(subj_i,trial_i)>1 && trialBeginStep(subj_i,trial_i)>1
                MoveTime(subj_i,trial_i)=savedData(trial_i,trialEndStep(subj_i,trial_i),3)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
                %             MoveTime(subj_i,trial_i)=savedData(trial_i,trialsEndStep(trial_i),3)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
                
                RT(subj_i,trial_i)=savedData(trial_i,trialBeginStep(subj_i,trial_i),3)-savedData(trial_i,1,3);
                TimePeak(subj_i,trial_i)=peakData(subj_i,trial_i,6)-savedData(trial_i,trialBeginStep(subj_i,trial_i),3);
            end;
            if  MoveTime(subj_i,trial_i)>=0.3
                %                 MoveTime(subj_i,trial_i)=NaN;
                %                 RT(subj_i,trial_i)=NaN;
                %                 TimePeak(subj_i,trial_i)=NaN;
                IfOutlier(subj_i,trial_i)=1;
            end;
            
            %             if  MoveTime(subj_i,trial_i)>=1
            %                 MoveTime(subj_i,trial_i)=NaN;
            %                 RT(subj_i,trial_i)=NaN;
            %                 TimePeak(subj_i,trial_i)=NaN;
            %             end;
            %
            %             if  RT(subj_i,trial_i)<=0.1 || RT(subj_i,trial_i)>=6
            %                 MoveTime(subj_i,trial_i)=NaN;
            %                 RT(subj_i,trial_i)=NaN;
            %                 TimePeak(subj_i,trial_i)=NaN;
            %             end;
            
            
            if squeeze((peakData(subj_i,trial_i,2)-startingPos_scr(1,2)))>=0
                if squeeze((peakData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0   % ????????
                    peakData(subj_i,trial_i,3) = acos((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4)))*180/pi;
                else  % ????????
                    peakData(subj_i,trial_i,3) = (pi-acos(abs(squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                end;
            else
                if squeeze((peakData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0   % ????????
                    peakData(subj_i,trial_i,3) = (2*pi-acos((squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                else  % ????????
                    peakData(subj_i,trial_i,3) = (pi+acos(abs(squeeze(peakData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(peakData(subj_i,trial_i,4))))*180/pi;
                end;
            end;
            trialInfo(subj_i,trial_i,8) = peakData(subj_i,trial_i,3);
            trialInfo(subj_i,trial_i,3)= find(savedData(trial_i,:,4)>5,1);
            trialInfo(subj_i,trial_i,4)=trialsEndStep(trial_i);
            trialInfo(subj_i,trial_i,5) = savedData(trial_i, trialsEndStep(trial_i),3)- savedData(trial_i,trialInfo(subj_i,trial_i,3),3);  % valid time
            trialInfo(subj_i,trial_i,6) = savedData(trial_i, trialsEndStep(trial_i),4);  % endpoint distance
            trialInfo(subj_i,trial_i,7) = max(savedData(trial_i,trialInfo(subj_i,trial_i,3):trialsEndStep(trial_i),4));  % --- max speed
            
            endData(subj_i,trial_i,1:2) = savedData(trial_i,trialsEndStep(trial_i),6:7);
            endData(subj_i,trial_i,4) = sqrtm((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))^2+((squeeze(endData(subj_i,trial_i,2))-startingPos_scr(1,2)))^2);
            if squeeze((endData(subj_i,trial_i,2)- startingPos_scr(1,2)))>=0
                if squeeze((endData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0
                    endData(subj_i,trial_i,3) = acos((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4)))*180/pi;
                    
                else
                    endData(subj_i,trial_i,3) = (pi-acos(abs(squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                end;
            else
                if squeeze((endData(subj_i,trial_i,1)-startingPos_scr(1,1)))>=0
                    endData(subj_i,trial_i,3) = (2*pi-acos((squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                    
                else
                    endData(subj_i,trial_i,3) = (pi+acos(abs(squeeze(endData(subj_i,trial_i,1))-startingPos_scr(1,1))/squeeze(endData(subj_i,trial_i,4))))*180/pi;
                end;
            end;
            
            
        end;    %  if isempty
        
        
    end; % for trial
    rawData(subj_i,:,:,:) = savedData(:,1:800,:);
    trialInfo(subj_i,skipTrials,:) = NaN;
    rawData(subj_i,skipTrials,:,:) = NaN;
    
end; % for subj

clear fileName;
fileName = ['GR_subj' num2str(length(subj_name)) '_day2_s'];
% save(fileName,'rawData','trialInfo','expInfo','endData','peakData','MoveTime','RT','TimePeak','IfOutlier');
save(fileName,'trialInfo','expInfo','endData','peakData','MoveTime','RT','TimePeak','IfOutlier');

% put 2 days together
clear all;
fileName='GR_subj17';
load([fileName '_day1_s']);

% raw1=rawData;
trial1=trialInfo;
exp1=expInfo;
end1=endData;
peak1=peakData;
MT1=MoveTime;
RT1=RT;
TP1=TimePeak;
OT1=IfOutlier;

load([fileName '_day2_s']);
% load Gradual_subj4_day2
% raw2=rawData;
trial2=trialInfo;
exp2=expInfo;
end2=endData;
peak2=peakData;
MT2=MoveTime;
RT2=RT;
TP2=TimePeak;
OT2=IfOutlier;

% rawData=[raw1 raw2];
trialInfo=[trial1 trial2];
expInfo=exp1;%names are the same
endData=[end1 end2];
peakData=[peak1 peak2];
MoveTime=[MT1 MT2];
RT=[RT1 RT2];
TimePeak=[TP1 TP2];
IfOutlier=[OT1 OT2];


fileName = [fileName '_s'];
save(fileName,'trialInfo','expInfo','endData','peakData','MoveTime','RT','TimePeak','IfOutlier');
