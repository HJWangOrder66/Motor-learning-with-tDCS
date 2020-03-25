%%Rotation_fMRI__Continous feedback_shooting task_4
%%targets_�ϰ�������_ok_circle����
%%baseline 5 NF 10 errorclamp 40 NF 40 veridical 10
%% initialization
clear;
close all;
clc;
cd('D:\Lab\WHJ\gradual+tDCS');


%% screen set
[rect, figureHandle] = Lfunc_screenSet;

intos=100;  % ÿ����Լ�������굥λ  487.7*304.8mm
% screen= input('��������Ļÿ���׶�Ӧ������'); % 410*258mm (1440*900 pix)   3.5 ÿ����Լ��������
screen= 3.5; % 410*258mm (1440*900 pix)   3.5 ÿ����Լ��������

para =screen./intos;

w = Screen('OpenWindow', 0, 0, [0 0 30 30]);
WinTabMex(0,w,0);	% Initialize driver, connect itp to window ��wPtr��
pause(2);
[old, new] = WinTabMex(4, 1);     % �ı�Buffer��С����Ϊ1PTB-INFO: Will use beamposition query for accurate Flip time stamping.


%% subject and experiment information
promptParameters = {'Subject Name', 'Age', 'Gender (F or M?)','Handedness (L or R)','Stimulus','Condition'};
defaultParameters = {'Noname', '20','F', 'R','a','EC'};
Subinfo = inputdlg(promptParameters, 'Subject Info ', 1, defaultParameters);
%% sound set
sound_ready = wavread('notify.wav');
sound_urge = wavread('ding.wav');
sound_arrive = wavread('chimes.wav');
sound_goback = wavread('ringout.wav');
sound_wrong = wavread('ringin.wav');
%% Define Plot Items
startSize=round((screen*5)*4/(tan(72*pi/180)-tan(18*pi/180)));
targetSize=round((screen*3)*4/(tan(72*pi/180)-tan(18*pi/180)));
successSize=round((screen*3)*4/(tan(72*pi/180)-tan(18*pi/180)));
cursorSize=round((screen*2.5)*4/(tan(72*pi/180)-tan(18*pi/180)));

startPointH = plot(0,0,'go','MarkerFaceColor','g','MarkerSize',startSize,'visible','off');
TargetPointH = plot(0,0,'ro','MarkerFaceColor','r','MarkerSize',targetSize,'visible','off');
SuccessH = plot(0,0,'ro','MarkerFaceColor','r','MarkerSize',successSize,'visible','off');
cursorH = plot(0,0,'go','MarkerFaceColor','g','MarkerSize',cursorSize,'visible','off');
doubleH = plot(0,0,'go','MarkerFaceColor','g','MarkerSize',cursorSize,'visible','off');
ReturnCircleH=plot(0,0,'wo','MarkerFaceColor','none','MarkerSize',1,'visible','off');
%% Define Experiment Condition
T2Sdist = 50;          % distance between target and startpoint according to coda (mm)
prepareTime = 0.2;        % ����ʼ�㸽������0.8���Ŀ�������
Target_num = 8;
visibleTolerance = 5;     % �����ƫ��ľ���4mm
startMoveTolerance=T2Sdist/6;
minBias = 30; % �ھ���ʼ��50mm����
endSpeed = 1;  % �����ٶ�С��0.1cm/s = 1mm/sʱ���ж��˶�����
returnTime = 1;  % ����ʱ�䣨���¼һ�����ݣ�
erge_signal = 0;
bonus = 0;  % ���ν���
totalBonus = 0;     % �ܽ���
numberLinReg = 12;     % �����ٶ�ʱ�õ������Իع��ȡ����
time_limit=2;      % if reach time>3sec, too slow, re-do the trial
filename=Subinfo{1};
slowlimit=300;
%% Define experimental process:   1.baseline (1) 2.rotation(2-4) 3.after(5) 4.washout(6) 5.relearning(7-9)
trialPerBlock=10;


base_trials = 5 .* Target_num;     % 80,1-80
tDCSbase_trials = 10 .* Target_num;     % 80,81-160
training_trials = 40 .* Target_num;       % ��80*4=320   161-480
nofeedback_trials=40.* Target_num;       % ��80*4=320   481-800
veridical_trials =10 .* Target_num;     % ��80*1=80 801-880
%

trials_index = [base_trials tDCSbase_trials training_trials nofeedback_trials veridical_trials];

session_iPerTrial = [ones(1,sum(trials_index(1))) 2*ones(1,sum(trials_index(2))) 3.*ones(1,sum(trials_index(3))) 4.*ones(1,sum(trials_index(4))) 5.*ones(1,sum(trials_index(5)))];   % �����ͬ�׶�
% numBlocks = 120;   % ʵ��9��block
block_iPerTrial = [ones(1,sum(trials_index(1))) 2*ones(1,sum(trials_index(2))) 3.*ones(1,sum(trials_index(3))) 4.*ones(1,sum(trials_index(4))) 5.*ones(1,sum(trials_index(5)))];    % to define block. Here, same as session
trialsNum = sum(trials_index);
trialsStartStep = NaN(1,trialsNum);    % �˶���ʼʱ���뿪center��������step
trialsEndStep = NaN(1,trialsNum);    % trials�жϽ���ʱ������step
trialsTotalStep = NaN(1,trialsNum);    % trials��step�����ֵ
Periods= NaN(1,trialsNum);    % ÿ��trialʱ�䣬���ڿ����ж�
endPoint=NaN(trialsNum,2);

%% Define test direction

for i=1:trialsNum/8
    temp(i,:)=randperm(Target_num);
end;

test_direction = temp';
test_direction = test_direction(:);

%% save parameters
stepsNum = 800;
savedData = NaN(trialsNum,stepsNum,5);  % 1-2:Marker����xy; 3:�˶�ʱ��; 4:ʵ���˶�����; 5:�ٶȣ���ʵ���˶�������㣩

%% Define Instruction
%up-left
text_MoveStop=text(0.5*rect(3),0.6*rect(4),'�ѵ���,�뷵��','LineWidth',5, 'FontSize', 24, 'HorizontalAlignment','center', 'visible','off','color',[1 1 1]);

text_AtStartPos=text(0.5*rect(3),0.6*rect(4),'������','LineWidth',5, 'FontSize', 24, 'HorizontalAlignment','center', 'visible','off','color',[1 1 1]);
text_MoveStart=text(0.5*rect(3),0.6*rect(4),'����Ŀ����˶�','LineWidth',5, 'FontSize', 24, 'HorizontalAlignment','center', 'visible','off','color',[1 1 1]);
%text at center screen (some feedback)
text_welcome_words=char('ʵ���1�׶ο�ʼ��ʹ��ɫ�����а�ɫĿ���','��2�׶Σ�û�й�꣬ʹ�ִ��а�ɫĿ���','��3�׶Σ����Թ�꣬ʹ�ִ��а�ɫĿ���','��4�׶Σ�û�й�꣬ʹ�ִ��а�ɫĿ���','���׶Σ�ʹ��ɫ�����а�ɫĿ���');
text_welcome_info=zeros(size(text_welcome_words,1),1);
for i=1:size(text_welcome_words,1)
    text_welcome_info(i)=text(0.5*rect(3),0.6*rect(4),text_welcome_words(i,:),'LineWidth',5, 'FontSize', 24, 'HorizontalAlignment', 'center','visible','off','color',[1 1 1]);
end

text_finish_words=char('��������߼�����','��������Ϣ','ʵ��ȫ������');
text_finish_info = zeros(size(text_finish_words,1),1);
for i=1:3
    text_finish_info(i)=text(0.5*rect(3),0.65*rect(4),text_finish_words(i,:),'LineWidth',5, 'FontSize', 24, 'HorizontalAlignment', 'center','visible','off','color',[1 1 1]);
end
%up-mid
text_score = text(0.5*rect(3),0.3*rect(4),'0', 'FontSize', 24, 'HorizontalAlignment', 'center','visible','off','color',[1 1 1]);
text_fast = text(0.5*rect(3),0.4*rect(4),'̫����', 'FontSize', 24, 'HorizontalAlignment', 'center','visible','off','color',[1 1 1]);
text_slow = text(0.5*rect(3),0.4*rect(4),'̫����', 'FontSize', 24, 'HorizontalAlignment', 'center','visible','off','color',[1 1 1]);

text_totalBonus=text(0.5*rect(3),0.75*rect(4),'����ʵ���ܵ÷�Ϊ:','LineWidth',5, 'FontSize', 24, 'HorizontalAlignment', 'center', 'visible','off','color',[1 1 1]);
instruction_totalBonus=text(0.5*rect(3),0.5*rect(4),'0','LineWidth',5, 'FontSize', 24, 'HorizontalAlignment', 'center', 'visible','off','color',[1 1 1]); % ��Ӧ����Ǯ��
textT = text(0.7*rect(3),0.85*rect(4),'');
set(textT,'Color',[1 1 1]);
set(textT,'FontSize',16);

%% define targets and startPoint on the screen
startingPos_scr = [rect(3)/2 rect(4)/2];
set(startPointH,'visible','on','XData',startingPos_scr(1),'YData',startingPos_scr(2));  hold on;% starting position

% Set Target points
targetPos=[cos(0),sin(0);cos(pi/4),sin(pi/4); cos(pi/2),sin(pi/2); cos(3*pi/4),sin(3*pi/4); cos(pi),sin(pi)...
    ; cos(5*pi/4),sin(5*pi/4); cos(3*pi/2),sin(3*pi/2); cos(7*pi/4),sin(7*pi/4)];
targetPos_scr = targetPos .* T2Sdist .*screen + repmat(startingPos_scr,Target_num,1);    % ����Ŀ�������

%  set(TargetPointH,'visible','on','XData',targetPos_scr(:,1),'YData',targetPos_scr(:,2));  % starting position
tab_coord=[5,5; 48763,5; 5,30475; 48763,30475];  % ���£����£����ϣ�����
startingPos_tab = [(tab_coord(1,1)+tab_coord(2,1))/2 (tab_coord(1,2)+tab_coord(3,2))/2];

targetPos_intos = targetPos .* T2Sdist .*intos + repmat(startingPos_tab,Target_num,1);

%% Experiments
input('���»س���ʵ����ʽ��ʼ');
%  HideCursor;
expStart=tic;
try
    
    for trial_i = 1:trialsNum
        clear trialBegin
        set(textT,'String',sprintf('Trials: %04i', trial_i));
        
        disp(trial_i);
        block_i = block_iPerTrial(trial_i);
        session_i = session_iPerTrial(trial_i);
        TargetPos_Scr = targetPos_scr(test_direction(trial_i),:);  % Set target direction
        
        %--- welcome info
        if trial_i==1 || trial_i==sum(trials_index(1))+1 || trial_i==sum(trials_index(1:2))+1 || trial_i==sum(trials_index(1:3))+1|| trial_i==sum(trials_index(1:4))+1;
            
            set(text_welcome_info(block_i),'visible','on');  % ��ϰ��ʼ����ʽ��ʼ����Ϣ��ʵ�����
            set(ReturnCircleH,'XData',startingPos_scr(1),'YData',startingPos_scr(2),'visible','off');  drawnow;
            pause(2);
            set(text_welcome_info(block_i),'visible','off');drawnow;
            %             pause(10);
        end
        trialBegin=tic;
        trialITI(trial_i)=toc(expStart); %  ��¼ÿ��trial��ʼ��ʱ��
        
        % ��ͬ����ı�־
        startingFlag = 0; % ��ʼ��ǰ�Դεı�־��0:�˶�û�н�����1:�˶��Ѿ������������ص���ʼ��λ�ã�����ʼ�㵽Ŀ����Լ���Ŀ��㷵�أ�
        getReadyFlag = 0; % ������ʼ��λ�ø����ı�־��0:��δ׼����ϣ�1:׼�����
        movementStartFlag = 0;% �˶���ʼ���뿪��ʼ�㣩�ı�־��0����δ�뿪��1���Ѿ��뿪
        arrivedFlag = 0; % ����Ŀ���ı�־��0:û�е��1:����Ŀ���
        returnFlag = 0; % ���صı�־��0:û�з��أ�1:��ʼ����
        failFlag = 0;
        tPrepare=0;
        % �˶����¼���ݳ�ʼ��
        iStep = 0;     % ��ʼ����¼��Ĳ���
        pktData =[];
        previousPosition = zeros(1,2);  % ��ʼ��ǰһ��λ��
        currentPosition = zeros(1,2);  % ��ʼ����ǰλ��
        soundPlayOnce = 1;
        cursorFinal=zeros(1,2);
        fast=0;slow=0;
        WinTabMex(2); 	% Start data acquisition.
        
        
        % ��ʽ�˶��׶Σ�����ʵ��ǰ׼���׶Σ��ص���ʼ��׶Σ��˶���Ŀ���׶Σ�����Ŀ���׶��Լ����ؽ׶Σ�
        while(startingFlag == 0)
            while 1
                pkt = WinTabMex(5);
                if ~isempty(pkt)
                    break
                end
            end
            pktData = [pktData pkt];
            currentTab =  pktData (:,end)';
            currentPosition = currentTab(1:2);
            current_screen = convert_reg(para,currentPosition);
            
            % �ص���ʼ��׶�
            if (getReadyFlag == 0)
                distanceFromStartPosition = norm((currentPosition-startingPos_tab)./intos);
                set(ReturnCircleH,'XData',startingPos_scr(1),'YData',startingPos_scr(2),'MarkerSize',distanceFromStartPosition.*screen,'visible','on');  drawnow;
                if(distanceFromStartPosition<5);
                    %                     now_feedback = current_screen;
                    %                     set(cursorH,'XData',now_feedback(1),'YData',now_feedback(2),'visible','on');  drawnow;
                    if  tPrepare==0;
                        clear tPrepareTic;
                        tPrepareTic = tic; % �趨׼���׶μ�ʱ
                        tPrepare=1;
                    end;
                    if  toc(tPrepareTic)>prepareTime %-0.5
                        set(ReturnCircleH,'XData',startingPos_scr(1),'YData',startingPos_scr(2),'MarkerSize',distanceFromStartPosition.*screen,'visible','off');  drawnow;
                        set(TargetPointH,'XData',TargetPos_Scr(1),'YData',TargetPos_Scr(2),'visible','on');         % ����Ŀ���
                        trialReadyTime(trial_i)=toc(expStart);
                        
                        disp('back to point already');
                        trialStartTime = tic;
                        if soundPlayOnce   % make sure the alarming sound only played once
                            wavplay(sound_ready.*5,100000,'async');
                            trialStartTime = tic;
                            soundPlayOnce=0;
                        end;
                        
                        %                         set(text_MoveStart,'visible','on');     % ��Ŀ����˶�
                        drawnow;
                        getReadyFlag = 1;
                        clear tStartTic;
                        tStartTic = tic;% �˶���ʼ��ʱ
                        
                    else
                        continue;  % ����δ����׼���õı�׼����������´�while(startingFlag==0)����ʼ
                    end;
                else
                    
                    tPrepare=0;
                    drawnow;
                    continue;  % ����δ����׼���õı�׼����������´�while(startingFlag==0)����ʼ
                end;   % end if(...&&...)else �ж��Ƿ�׼���ÿ�ʼ�˶������Ƿ�����ʼ��λ�ø���ͣ���㹻��ʱ��
            end;  % end if(getReadyFlag == 0) �ص���ʼ��λ���ж�
            
            % ʵʱ����
            if getReadyFlag == 1
                if  arrivedFlag == 0 && (session_i==1 || session_i==5) ;                     % veridical
                    rot_angle = 0;
                    tempV = current_screen-startingPos_scr;
                    tempL = sqrt(tempV(1)^2+tempV(2)^2);
                    tempA=atan(tempV(2)/tempV(1))*180/pi;    %(-90,90)
                    if tempV(1)<=0
                        angle_feedback =(180 + tempA + rot_angle)*pi/180;
                    elseif tempV(1)>=0 && tempV(2)>=0
                        angle_feedback =(tempA + rot_angle)*pi/180;
                    elseif tempV(1)>=0 && tempV(2)<=0
                        angle_feedback =(360 + tempA + rot_angle)*pi/180;
                    end;
                    now_feedback = [cos(angle_feedback) sin(angle_feedback)] * tempL + startingPos_scr;
                    if tempL>startSize+targetSize
                        set(cursorH,'XData',now_feedback(1),'YData',now_feedback(2),'visible','on');  drawnow;
                    else
                        set(cursorH,'XData',now_feedback(1),'YData',now_feedback(2),'visible','off');  drawnow;
                    end
                    %                     set(ReturnCircleH,'XData',startingPos_scr(1),'YData',startingPos_scr(2),'MarkerSize',tempL,'visible','off');  drawnow;
                    
                elseif arrivedFlag == 0 && (session_i==4 || session_i==2)        %no feedback
                    rot_angle = 0;
                    tempV = current_screen-startingPos_scr;
                    tempL = sqrt(tempV(1)^2+tempV(2)^2);
                    tempA=atan(tempV(2)/tempV(1))*180/pi;    %(-90,90)
                    if tempV(1)<=0
                        angle_feedback =(180 + tempA + rot_angle)*pi/180;
                    elseif tempV(1)>=0 && tempV(2)>=0
                        angle_feedback =(tempA + rot_angle)*pi/180;
                    elseif tempV(1)>=0 && tempV(2)<=0
                        angle_feedback =(360 + tempA + rot_angle)*pi/180;
                    end;
                    now_feedback = [cos(angle_feedback) sin(angle_feedback)] * tempL + startingPos_scr;
                    set(cursorH,'XData',now_feedback(1),'YData',now_feedback(2),'visible','off');  drawnow;
                    %                     set(ReturnCircleH,'XData',startingPos_scr(1),'YData',startingPos_scr(2),'MarkerSize',tempL,'visible','off');  drawnow;
                    
                    
                elseif arrivedFlag == 0 && (session_i==3);             %rotation
                    
                    rot_angle = 30;
                    rot_angleEC = 30;
                    tempV = current_screen-startingPos_scr;
                    tempL = sqrt(tempV(1)^2+tempV(2)^2);
                    tempA=atan(tempV(2)/tempV(1))*180/pi;
                    tempAEC=(test_direction(trial_i)-1)*45;
                    
                    angle_feedbackEC =(tempAEC + rot_angleEC)*pi/180;
                    
                    if tempV(1)<=0 && tempV(2)>=0
                        angle_feedback =(180 + tempA + rot_angle)*pi/180;
                        %                         angle_feedbackEC =(0 + tempAEC + rot_angleEC)*pi/180;
                    elseif tempV(1)<=0 && tempV(2)<=0
                        angle_feedback =(180 + tempA + rot_angle)*pi/180;
                        %                         angle_feedbackEC =(0 + tempAEC + rot_angleEC)*pi/180;
                    elseif tempV(1)>=0 && tempV(2)>=0
                        angle_feedback =(tempA + rot_angle)*pi/180;
                        %                         angle_feedbackEC =(tempAEC + rot_angleEC)*pi/180;
                    elseif tempV(1)>=0 && tempV(2)<=0
                        angle_feedback =(360 + tempA + rot_angle)*pi/180;
                        %                         angle_feedbackEC =(360 + tempAEC + rot_angleEC)*pi/180;
                    end;
                    now_feedback = [cos(angle_feedback) sin(angle_feedback)] * tempL + startingPos_scr;
                    if tempL>startSize+targetSize
                        set(cursorH,'XData',now_feedback(1),'YData',now_feedback(2),'visible','on');   drawnow;
                        
                    else
                        set(cursorH,'XData',now_feedback(1),'YData',now_feedback(2),'visible','off');   drawnow;
                    end
                end;
                
                
                % �뿪��ʼ�㣬��ʼ��¼����
                iStep = iStep+1;
                tMoveTime = toc(tStartTic);
                savedData(trial_i,iStep,1:2) = currentPosition;     % tab��x,y����
                savedData(trial_i,iStep,6:7) = current_screen;
                savedData(trial_i,iStep,3) = tMoveTime;       % �˶�ʱ��
                savedData(trial_i,iStep,4) = sqrt(((squeeze(savedData(trial_i,iStep,1))-startingPos_tab(1,1))./intos)^2+(((squeeze(savedData(trial_i,iStep,2))-startingPos_tab(1,2)))./intos)^2); % �˶�����mm������ǰtrial�ĵ�һ��step�ĵ���Ϊ��ʼ��
                savedData(trial_i,iStep,5) = Lfunc_linReg(numberLinReg,iStep,squeeze(savedData(trial_i,1:iStep,3))',squeeze(savedData(trial_i,1:iStep,4))');% �ٶ�
                if getReadyFlag == 1 && movementStartFlag == 0
                    if savedData(trial_i,iStep,4) >8
                        trialsStartStep(trial_i) = iStep;% mark movement begins
                        movementStartFlag=1;
                    end;
                end;
                % �жϵ���Ŀ���λ��
                if getReadyFlag == 1 && arrivedFlag == 0
                    if  savedData(trial_i,iStep,4) >=T2Sdist;
                        arrivedFlag = 1;
                        trialsEndStep(trial_i)
                        = iStep;
                        CusorAng=angle_feedback;
                        endPoint(trial_i,:)=[cos(CusorAng) sin(CusorAng)] * T2Sdist.*screen + startingPos_scr;  % ��Ļ���յ�
                        
                        %                     endPoint(trial_i,:)=now_feedback;
                        cursorFinal = endPoint(trial_i,:);
                        
                        if session_i==4 || session_i==2
                            set(cursorH,'XData',cursorFinal(1),'YData',cursorFinal(2),'MarkerSize',cursorSize,'visible','off');   drawnow;
                        elseif session_i==3
%                             doubleFinal = [cos(angle_feedbackEC) sin(angle_feedbackEC)] * T2Sdist.*screen + startingPos_scr;%error clamp cursor�յ�
%                             
%                             set(doubleH,'XData',doubleFinal(1),'YData',doubleFinal(2),'visible','on');  drawnow;
                            set(cursorH,'XData',cursorFinal(1),'YData',cursorFinal(2),'MarkerSize',cursorSize,'visible','on');  drawnow;
                        else
                            set(cursorH,'XData',cursorFinal(1),'YData',cursorFinal(2),'MarkerSize',cursorSize,'visible','on'); drawnow;
                        end;
                        
                        
                        %                         set(text_MoveStart,'visible','off');     % ��Ŀ����˶�
                        
                        returnFlag = 1;    % ��ʼ����
                        %                         beginIndex = find(savedData(trial_i,:,4)>4,1);
                        Periods(trial_i) = (savedData(trial_i,trialsEndStep(trial_i),3) - savedData(trial_i,trialsStartStep(trial_i),3))*1000;   %ms
                        
                        if Periods(trial_i)>=50 && Periods(trial_i)<=slowlimit
                            wavplay(sound_arrive.*20, 100000,'async');
                        elseif   Periods(trial_i)<150  % ����
                            fast=1;
                            wavplay(sound_wrong, 5000,'async');
                            set(text_fast,'string','̫����','visible','on','position',[TargetPos_Scr(1) TargetPos_Scr(2)-50],'color','y'); drawnow;
                        elseif    Periods(trial_i)>slowlimit   % ����
                            slow=1;
                            wavplay(sound_wrong, 30000,'async');
                            set(text_slow,'string','̫����','visible','on','position',[TargetPos_Scr(1) TargetPos_Scr(2)-50],'color','y'); drawnow;
                        end;
                        
                        
                        
                        
                        %                         if  slow==0 && sqrt((TargetPos_Scr(1)-cursorFinal(1))^2+(TargetPos_Scr(2)-cursorFinal(2))^2)<=targetSize
                        %
                        %
                        %                                 score=1;
                        %
                        %                                 set(SuccessH,'XData',TargetPos_Scr(1),'YData',TargetPos_Scr(2),'visible','on');         % ����Ŀ���
                        %
                        %                         else
                        %
                        %                             score=0;
                        %                         end;
                        %
                        
                        %                         totalBonus = totalBonus + score;   % �ܽ���
                        %
                        %                             set(text_score,'string',['�÷�:' num2str(score)],'visible','on','position',[TargetPos_Scr(1) TargetPos_Scr(2)+50]); drawnow; % ǰ���׶������Ͻ���ʾ�����÷�
                        
                        
                        
                        
                        
                        clear tReturn
                        tReturn = tic;    % ��ʼ��¼����ʱ��
                    elseif toc(trialStartTime)>time_limit && norm((currentPosition-startingPos_tab)./intos)<startMoveTolerance...
                            && erge_signal==0
                        erge_signal=1;
                        wavplay(sound_urge, 50000,'async');
                    end  % end if(...&&...&&...)
                end;  % if arrivedFlag
                
                
                if(arrivedFlag == 1 && toc(tReturn)>returnTime)
                    if fast==1
                        set(text_fast,'visible','off');drawnow
                    elseif slow==1
                        set(text_slow,'visible','off');drawnow
                    end;
                    set(TargetPointH,'visible','off');drawnow
                    set(cursorH,'visible','off');drawnow
                    set(doubleH,'visible','off');drawnow
                    if arrivedFlag == 1 && returnFlag == 1 %���ع�������ʾcircle
                        tempV = current_screen-startingPos_scr;
                        tempL = sqrt(tempV(1)^2+tempV(2)^2);
                        set(ReturnCircleH,'XData',startingPos_scr(1),'YData',startingPos_scr(2),'MarkerSize',tempL,'visible','on');  drawnow;
                        if(arrivedFlag == 1 && tempL<startSize)
                            %                             returnFlag=0;
                            %                             set(ReturnCircleH,'XData',startingPos_scr(1),'YData',startingPos_scr(2),'MarkerSize',tempL,'visible','off');  drawnow;
                            
                            %                         set(text_score,'visible','off');drawnow
                            %                         set(text_MoveStop,'visible','off');
                            startingFlag = 1;
                            clear tReturn
                        end;    % �жϷ��ؽ׶��Ƿ����
                    end;
                end;% end if(...&&toc...),�����ص�ʱ�䳬���趨ʱ��ʱ����ʼ��ʾԲ��
            end;
        end;        % end while(startingFlag == 0)
        
        
        %------for some trials, need to consider: end of a group, or at defined time of rest
        
        if trial_i==trialsNum;
            set(text_finish_info(3),'visible','on');
            set(ReturnCircleH,'XData',startingPos_scr(1),'YData',startingPos_scr(2),'visible','off');  drawnow;
            pause(2);
            set(text_finish_info(3),'visible','off');  % ȫ������
            
        elseif    trial_i==sum(trials_index(1))||trial_i==sum(trials_index(1:2))||trial_i==sum(trials_index(1:3))||trial_i==sum(trials_index(1:4))
            
            set(text_finish_info(2),'visible','on');
            set(ReturnCircleH,'XData',startingPos_scr(1),'YData',startingPos_scr(2),'MarkerSize',tempL,'visible','off');  drawnow;
            pause;
            set(text_finish_info(2),'visible','off');
        end
        %           wavplay(sound_goback, 50000,'async');   % music:go back
    end;   % end for trial_i = 1:trialsNum
    
    % ȫ��ʵ������������ܽ���
    
    set(cursorH,'visible','off');drawnow
    set(startPointH,'visible','off');drawnow
    %     set(text_totalBonus,'visible','on');
    %     set(instruction_totalBonus,'string',[num2str(totalBonus) ' ��'],'visible','on');
    drawnow
    expTime = toc(expStart);
    save([Subinfo{1} '_day2']);
    
catch
    ShowCursor;
    save([filename '_d2temp']);    % �����洢��ʱ�ļ�
    WinTabMex(3); 	% Stop/Pause data acquisition.
    WinTabMex(1); 	% Shutdown driver.
    y=lasterror;
    y.stack
    rethrow(lasterror);
end; % end try catch

%% close devices
WinTabMex(3); 	% Stop/Pause data acquisition.
WinTabMex(1); 	% Shutdown driver.
