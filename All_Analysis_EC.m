%% baseline calculation
clear all;
sessionNum=[5 10 40 40 5 10 40 40];
targetDeg = [0 45 90 135 180 225 270 315];
trialNum=8;
for session_i=1:length(sessionNum)
        if session_i==1
            xv(session_i)=1;
        else
            xv(session_i)=1+ sum(sessionNum(1:session_i-1));
        end
end;
% set(gcf,'outerposition',get(0,'screensize'));
colorArray={'b','c','g','k','b','k','b','r','k','b'};
Slow=0.3;
load('EC_Sham_all_41.mat');
Svalid_end=peakData(:,:,7);
% Svalid_end(endData(:,:,6)==1|peakData(:,:,8)==1)=NaN;
SRT=RT;
SMT=MoveTime;
SPT=TimePeak;

SPV=peakData(:,:,5);
for subj_i = 1:length(expInfo.subj_name)-10
    direction_temp = squeeze(trialInfo(subj_i+10,:,1));
    target_angle = (direction_temp - 1).*45;
    for dir_i=1:8
        valid_end_temp=squeeze(Svalid_end(subj_i+10,find(direction_temp==dir_i)));
        Sbaseline_d1s1(subj_i,dir_i)=nanmean(valid_end_temp(1:5));
        Sbaseline_d1s2(subj_i,dir_i)=nanmean(valid_end_temp(11:15));
            Sbaseline_d2s1(subj_i,dir_i)=nanmean(valid_end_temp(95+1:95+5));
            Sbaseline_d2s2(subj_i,dir_i)=nanmean(valid_end_temp(95+11:95+15));
    end;
end;
% different baseline

for subj_i = 1:length(expInfo.subj_name)-10
    direction_temp = squeeze(trialInfo(subj_i+10,:,1));
    for trial_i=1:size(Svalid_end,2)
        if ~isnan(direction_temp(trial_i))
            % day1 baseline
            Sdeba_end(1,subj_i,trial_i)=Svalid_end(subj_i+10,trial_i)-Sbaseline_d1s2(subj_i,direction_temp(trial_i));
            % day2 no feedback baseline
            Sdeba_end(2,subj_i,trial_i)=Svalid_end(subj_i+10,trial_i)-Sbaseline_d2s1(subj_i,direction_temp(trial_i));
            % day2 with feedback baseline
            Sdeba_end(3,subj_i,trial_i)=Svalid_end(subj_i+10,trial_i)-Sbaseline_d2s2(subj_i,direction_temp(trial_i));
            
        end;
    end;
end;


load('EC_Anodal_all_42.mat');
Avalid_end=peakData(:,:,7);
% Avalid_end(endData(:,:,6)==1|peakData(:,:,8)==1)=NaN;
ART=RT;
AMT=MoveTime;
APT=TimePeak;
APV=peakData(:,:,5);

for subj_i = 1:length(expInfo.subj_name)-11
    direction_temp = squeeze(trialInfo(subj_i+11,:,1));
    target_angle = (direction_temp - 1).*45;
    for dir_i=1:8
        valid_end_temp=squeeze(Avalid_end(subj_i+11,find(direction_temp==dir_i)));
        Abaseline_d1s1(subj_i,dir_i)=nanmean(valid_end_temp(1:5));
        Abaseline_d1s2(subj_i,dir_i)=nanmean(valid_end_temp(11:15));
            Abaseline_d2s1(subj_i,dir_i)=nanmean(valid_end_temp(95+1:95+5));
            Abaseline_d2s2(subj_i,dir_i)=nanmean(valid_end_temp(95+11:95+15));
    end;
end;
% different baseline
for subj_i = 1:length(expInfo.subj_name)-11
    direction_temp = squeeze(trialInfo(subj_i+11,:,1));
    for trial_i=1:size(Avalid_end,2)
        if ~isnan(direction_temp(trial_i))
            %day1 baseline
            Adeba_end(1,subj_i,trial_i)=Avalid_end(subj_i+11,trial_i)-Abaseline_d1s2(subj_i,direction_temp(trial_i));
            % day2 no feedback
            Adeba_end(2,subj_i,trial_i)=Avalid_end(subj_i+11,trial_i)-Abaseline_d2s1(subj_i,direction_temp(trial_i));
            %day2 with feedback
            Adeba_end(3,subj_i,trial_i)=Avalid_end(subj_i+11,trial_i)-Abaseline_d2s2(subj_i,direction_temp(trial_i));
            
        end;
    end;
end;

% cycle
% load baseTrialAve;
for subj_i=1:31%length(expInfo.subj_name)
    
    for cycle_i=1:size(Avalid_end,2)/trialNum
        Sham_cycle_orig(subj_i,cycle_i)=nanmean(Svalid_end(subj_i,cycle_i*8-7:cycle_i*8));
        Sham_cycle_RT(subj_i,cycle_i)=nanmean(SRT(subj_i,cycle_i*8-7:cycle_i*8));
        Sham_cycle_MT(subj_i,cycle_i)=nanmean(SMT(subj_i,cycle_i*8-7:cycle_i*8));
        Sham_cycle_PT(subj_i,cycle_i)=nanmean(SPT(subj_i,cycle_i*8-7:cycle_i*8));
                Sham_cycle_PV(subj_i,cycle_i)=nanmean(SPV(subj_i,cycle_i*8-7:cycle_i*8));

        Anodal_cycle_orig(subj_i,cycle_i)=nanmean(Avalid_end(subj_i,cycle_i*8-7:cycle_i*8));
        Anodal_cycle_RT(subj_i,cycle_i)=nanmean(ART(subj_i,cycle_i*8-7:cycle_i*8));
        Anodal_cycle_MT(subj_i,cycle_i)=nanmean(AMT(subj_i,cycle_i*8-7:cycle_i*8));
        Anodal_cycle_PT(subj_i,cycle_i)=nanmean(APT(subj_i,cycle_i*8-7:cycle_i*8));
                        Anodal_cycle_PV(subj_i,cycle_i)=nanmean(APV(subj_i,cycle_i*8-7:cycle_i*8));

        for baseline_i=1:3
            
            Sham_cycle_deba(baseline_i,subj_i,cycle_i)=nanmean(squeeze(Sdeba_end(baseline_i,subj_i,cycle_i*8-7:cycle_i*8)));
            
            Anodal_cycle_deba(baseline_i,subj_i,cycle_i)=nanmean(squeeze(Adeba_end(baseline_i,subj_i,cycle_i*8-7:cycle_i*8)));
        end;
    end;
end;
Sepe_Cl_Sham=mean(Sham_cycle_deba(1,:,54:55),3)>median(mean(Sham_cycle_deba(1,:,54:55),3));
Sepe_Cl_Anodal=mean(Anodal_cycle_deba(1,:,54:55),3)>median(mean(Anodal_cycle_deba(1,:,54:55),3));

%% average subjects
for session_i=1:8
    figure(4);
    if session_i==1
        x=1;
        plot(x:x+sessionNum(session_i)-1,squeeze(mean(Sham_cycle_deba(1,:,x:x+sessionNum(session_i)-1),2)),'k');
        hold on;
        plot(x:x+sessionNum(session_i)-1,squeeze(mean(Anodal_cycle_deba(1,:,x:x+sessionNum(session_i)-1),2)),'r');
        % plot(x:x+sessionNum(session_i)-1,squeeze(mean(baseTrialAve(:,1,:),1)),'b');
    elseif session_i<5
        x=1+ sum(sessionNum(1:session_i-1));
        plot(x:x+sessionNum(session_i)-1,squeeze(mean(Sham_cycle_deba(1,:,x:x+sessionNum(session_i)-1),2)),'k');
        hold on;
        plot(x:x+sessionNum(session_i)-1,squeeze(mean(Anodal_cycle_deba(1,:,x:x+sessionNum(session_i)-1),2)),'r');
        
    else
        x=1+ sum(sessionNum(1:session_i-1));
        plot(x:x+sessionNum(session_i)-1,mean(Sham_cycle_orig(:,x:x+sessionNum(session_i)-1),1),'k');
        hold on;
        plot(x:x+sessionNum(session_i)-1,mean(Anodal_cycle_orig(:,x:x+sessionNum(session_i)-1),1),'r');
        
    end
    
%     if session_i==1
%         plot(1:20,squeeze(mean(baseTrialAve(:,1,1:20),1)),'b');
%     elseif session_i==3
%         plot(x:x+sessionNum(session_i)-1,squeeze(mean(baseTrialAve(:,2,1:40),1)),'b');
%     elseif session_i==4
%         plot(x:x+10-1,squeeze(mean(baseTrialAve(:,3,1:10),1)),'b');
%         plot(x+10:x+30-1,squeeze(mean(baseTrialAve(:,4,1:20),1)),'g');
%         Sham_cycle_afe=squeeze(mean(Sham_cycle_deba(1,:,x:x+sessionNum(session_i)-1),2));
%         Anodal_cycle_afe=squeeze(mean(Anodal_cycle_deba(1,:,x:x+sessionNum(session_i)-1),2));
%     elseif session_i==8
%         plot(x:x+sessionNum(session_i)-1,squeeze(mean(baseTrialAve(:,5,1:40),1)),'b');
%         
%         %             Sham_cycle_sav=squeeze(mean(Sham_cycle_orig(:,x:x+sessionNum(session_i)-1),2));
%         %     Anodal_cycle_sav=squeeze(mean(Anodal_cycle_orig(:,x:x+sessionNum(session_i)-1),2));
%         %
%         %     [h,p]=ttest2(Sham_cycle_sav(2:8),Anodal_cycle_sav(2:8));
%         %     text(x-20,27,['p=' num2str(p)]);
%     end;
    
    grid on;
    legend('Sham','Anodal');
    title('Only day1 baseline')
end;

%% reaction time compare, sham vs anodal
%
figure(199);
x_plot={'initial learning','decay','relearning'};
Svector=Sham_cycle_RT;
Avector=Anodal_cycle_RT;
for plot_i=1:3
subplot(3,1,plot_i);
if plot_i==1
    session_i=3;
elseif plot_i==2
    session_i=4;
elseif plot_i==3
    session_i=7;
end;

plot((1:40)-0.1,Svector(:,xv(session_i):xv(session_i)+40-1),'ok');hold on;
plot((1:40)+0.1,Avector(:,xv(session_i):xv(session_i)+40-1),'or');hold on;
xlabel(x_plot{plot_i});
ylabel('reaction time');
title('Clamp');
end;

figure(198);% t test

for plot_i=1:3
subplot(3,1,plot_i);
if plot_i==1
    session_i=3;
elseif plot_i==2
    session_i=4;
elseif plot_i==3
    session_i=7;
end;

plot(1:40,mean(Svector(:,xv(session_i):xv(session_i)+40-1),1),'-k');hold on;
errorbar(1:40,mean(Svector(:,xv(session_i):xv(session_i)+40-1),1),std(Svector(:,xv(session_i):xv(session_i)+40-1))./(31^0.5),'Color',[0 0 0]);hold on;
plot(1:40,mean(Avector(:,xv(session_i):xv(session_i)+40-1),1),'-r');hold on;
errorbar(1:40,mean(Avector(:,xv(session_i):xv(session_i)+40-1),1),std(Avector(:,xv(session_i):xv(session_i)+40-1))./(31^0.5),'Color',[1 0 0]);hold on;
for cycle_i=1:40
    [hRT(plot_i,cycle_i) pRT(plot_i,cycle_i)]=ttest2(Svector(:,xv(session_i)+cycle_i-1),Avector(:,xv(session_i)+cycle_i-1));
    if pRT(plot_i,cycle_i)<0.001
        text(cycle_i,0.4,'***');
    elseif pRT(plot_i,cycle_i)<0.01
        text(cycle_i,0.4,'**');
    elseif pRT(plot_i,cycle_i)<0.05
        text(cycle_i,0.4,'*');
%     else
%         text(cycle_i,0.1,'-');
    end
end;

xlabel(x_plot{plot_i});
ylabel('reaction time');
title('Clamp');
end;
%% Movement time compare, sham vs anodal
%
figure(197);
x_plot={'initial learning','decay','relearning'};

Svector=Sham_cycle_MT;
Avector=Anodal_cycle_MT;
y_plot='Movement time';
for plot_i=1:3
subplot(3,1,plot_i);
if plot_i==1
    session_i=3;
elseif plot_i==2
    session_i=4;
elseif plot_i==3
    session_i=7;
end;

plot((1:40)-0.1,Svector(:,xv(session_i):xv(session_i)+40-1),'ok');hold on;
plot((1:40)+0.1,Avector(:,xv(session_i):xv(session_i)+40-1),'or');hold on;
xlabel(x_plot{plot_i});
ylabel(y_plot);
title('Clamp');
end;

figure(196);% t test
x_plot={'initial learning','decay','relearning'};
for plot_i=1:3
subplot(3,1,plot_i);
if plot_i==1
    session_i=3;
elseif plot_i==2
    session_i=4;
elseif plot_i==3
    session_i=7;
end;

plot(1:40,mean(Svector(:,xv(session_i):xv(session_i)+40-1),1),'-k');hold on;
errorbar(1:40,mean(Svector(:,xv(session_i):xv(session_i)+40-1),1),std(Svector(:,xv(session_i):xv(session_i)+40-1))./(31^0.5),'Color',[0 0 0]);hold on;
plot(1:40,mean(Avector(:,xv(session_i):xv(session_i)+40-1),1),'-r');hold on;
errorbar(1:40,mean(Avector(:,xv(session_i):xv(session_i)+40-1),1),std(Avector(:,xv(session_i):xv(session_i)+40-1))./(31^0.5),'Color',[1 0 0]);hold on;
for cycle_i=1:40
    [hMT(plot_i,cycle_i) pMT(plot_i,cycle_i)]=ttest2(Svector(:,xv(session_i)+cycle_i-1),Avector(:,xv(session_i)+cycle_i-1));
    if pMT(plot_i,cycle_i)<0.001
        text(cycle_i,0.2,'***');
    elseif pMT(plot_i,cycle_i)<0.01
        text(cycle_i,0.2,'**');
    elseif pMT(plot_i,cycle_i)<0.05
        text(cycle_i,0.2,'*');
%     else
%         text(cycle_i,0.1,'-');
    end
end;

xlabel(x_plot{plot_i});
ylabel(y_plot);
title('Clamp');
end;
%% peak time compare, sham vs anodal
%
figure(195);
x_plot={'initial learning','decay','relearning'};

Svector=Sham_cycle_PT;
Avector=Anodal_cycle_PT;
y_plot='peak time';
for plot_i=1:3
subplot(3,1,plot_i);
if plot_i==1
    session_i=3;
elseif plot_i==2
    session_i=4;
elseif plot_i==3
    session_i=7;
end;

plot((1:40)-0.2,Svector(:,xv(session_i):xv(session_i)+40-1),'ok');hold on;
plot((1:40)+0.2,Avector(:,xv(session_i):xv(session_i)+40-1),'or');hold on;
xlabel(x_plot{plot_i});
ylabel(y_plot);
title('Clamp');
end;

figure(194);% t test
x_plot={'initial learning','decay','relearning'};
for plot_i=1:3
subplot(3,1,plot_i);
if plot_i==1
    session_i=3;
elseif plot_i==2
    session_i=4;
elseif plot_i==3
    session_i=7;
end;

plot(1:40,mean(Svector(:,xv(session_i):xv(session_i)+40-1),1),'-k');hold on;
errorbar(1:40,mean(Svector(:,xv(session_i):xv(session_i)+40-1),1),std(Svector(:,xv(session_i):xv(session_i)+40-1))./(31^0.5),'Color',[0 0 0]);hold on;
plot(1:40,mean(Avector(:,xv(session_i):xv(session_i)+40-1),1),'-r');hold on;
errorbar(1:40,mean(Avector(:,xv(session_i):xv(session_i)+40-1),1),std(Avector(:,xv(session_i):xv(session_i)+40-1))./(31^0.5),'Color',[1 0 0]);hold on;
for cycle_i=1:40
    [hPT(plot_i,cycle_i) pPT(plot_i,cycle_i)]=ttest2(Svector(:,xv(session_i)+cycle_i-1),Avector(:,xv(session_i)+cycle_i-1));
    if pPT(plot_i,cycle_i)<0.001
        text(cycle_i,0.15,'***');
    elseif pPT(plot_i,cycle_i)<0.01
        text(cycle_i,0.15,'**');
    elseif pPT(plot_i,cycle_i)<0.05
        text(cycle_i,0.15,'*');
%     else
%         text(cycle_i,0.1,'-');
    end
end;

xlabel(x_plot{plot_i});
ylabel(y_plot);
title('Clamp');
end;
%% peak time portion, sham vs anodal
%
figure(193);
x_plot={'initial learning','decay','relearning'};

Svector=Sham_cycle_PT./Sham_cycle_MT;
Svector(Svector<0)=nan;
Avector=Anodal_cycle_PT./Anodal_cycle_MT;
Avector(Avector<0)=nan;
y_plot='peak time/movement time';
x_plot={'initial learning','decay','relearning'};
for plot_i=1:3
subplot(3,1,plot_i);
if plot_i==1
    session_i=3;
elseif plot_i==2
    session_i=4;
elseif plot_i==3
    session_i=7;
end;

plot((1:40)-0.2,Svector(:,xv(session_i):xv(session_i)+40-1),'ok');hold on;
plot((1:40)+0.2,Avector(:,xv(session_i):xv(session_i)+40-1),'or');hold on;
xlabel(x_plot{plot_i});
ylabel(y_plot);
title('Clamp');
end;

figure(192);% t test

for plot_i=1:3
subplot(3,1,plot_i);
if plot_i==1
    session_i=3;
elseif plot_i==2
    session_i=4;
elseif plot_i==3
    session_i=7;
end;

plot(1:40,mean(Svector(:,xv(session_i):xv(session_i)+40-1),1),'-k');hold on;
errorbar(1:40,mean(Svector(:,xv(session_i):xv(session_i)+40-1),1),std(Svector(:,xv(session_i):xv(session_i)+40-1))./(31^0.5),'Color',[0 0 0]);hold on;
plot(1:40,mean(Avector(:,xv(session_i):xv(session_i)+40-1),1),'-r');hold on;
errorbar(1:40,mean(Avector(:,xv(session_i):xv(session_i)+40-1),1),std(Avector(:,xv(session_i):xv(session_i)+40-1))./(31^0.5),'Color',[1 0 0]);hold on;
for cycle_i=1:40
    [hPTP(plot_i,cycle_i) pPTP(plot_i,cycle_i)]=ttest2(Svector(:,xv(session_i)+cycle_i-1),Avector(:,xv(session_i)+cycle_i-1));
    if pPTP(plot_i,cycle_i)<0.001
        text(cycle_i,0.75,'***');
    elseif pPTP(plot_i,cycle_i)<0.01
        text(cycle_i,0.75,'**');
    elseif pPTP(plot_i,cycle_i)<0.05
        text(cycle_i,0.75,'*');
%     else
%         text(cycle_i,0.1,'-');
    end
end;

xlabel(x_plot{plot_i});
ylabel(y_plot);
title('Clamp');
end;
%% peak velocity
figure(191);
x_plot={'initial learning','decay','relearning'};

Svector=Sham_cycle_PV;
Avector=Anodal_cycle_PV;
y_plot='peak velocity';
for plot_i=1:3
subplot(3,1,plot_i);
if plot_i==1
    session_i=3;
elseif plot_i==2
    session_i=4;
elseif plot_i==3
    session_i=7;
end;

plot((1:40)-0.2,Svector(:,xv(session_i):xv(session_i)+40-1),'ok');hold on;
plot((1:40)+0.2,Avector(:,xv(session_i):xv(session_i)+40-1),'or');hold on;
xlabel(x_plot{plot_i});
ylabel(y_plot);
title('Clamp');
end;

figure(190);% t test
x_plot={'initial learning','decay','relearning'};
for plot_i=1:3
subplot(3,1,plot_i);
if plot_i==1
    session_i=3;
elseif plot_i==2
    session_i=4;
elseif plot_i==3
    session_i=7;
end;

plot(1:40,mean(Svector(:,xv(session_i):xv(session_i)+40-1),1),'-k');hold on;
errorbar(1:40,mean(Svector(:,xv(session_i):xv(session_i)+40-1),1),std(Svector(:,xv(session_i):xv(session_i)+40-1))./(31^0.5),'Color',[0 0 0]);hold on;
plot(1:40,mean(Avector(:,xv(session_i):xv(session_i)+40-1),1),'-r');hold on;
errorbar(1:40,mean(Avector(:,xv(session_i):xv(session_i)+40-1),1),std(Avector(:,xv(session_i):xv(session_i)+40-1))./(31^0.5),'Color',[1 0 0]);hold on;
for cycle_i=1:40
    [hPV(plot_i,cycle_i) pPV(plot_i,cycle_i)]=ttest2(Svector(:,xv(session_i)+cycle_i-1),Avector(:,xv(session_i)+cycle_i-1));
    if pPV(plot_i,cycle_i)<0.001
        text(cycle_i,350,'***');
    elseif pPV(plot_i,cycle_i)<0.01
        text(cycle_i,350,'**');
    elseif pPV(plot_i,cycle_i)<0.05
        text(cycle_i,350,'*');
%     else
%         text(cycle_i,0.1,'-');
    end
end;

xlabel(x_plot{plot_i});
ylabel(y_plot);
title('Clamp');
end;
%% reaction time, fast
figure(189);
x_plot={'initial learning','decay','relearning'};

Svector=Sham_cycle_RT(Sepe_Cl_Sham,:);
Avector=Anodal_cycle_RT(Sepe_Cl_Anodal,:);
for plot_i=1:3
subplot(3,1,plot_i);
if plot_i==1
    session_i=3;
elseif plot_i==2
    session_i=4;
elseif plot_i==3
    session_i=7;
end;

plot((1:40)-0.1,Svector(:,xv(session_i):xv(session_i)+40-1),'ok');hold on;
plot((1:40)+0.1,Avector(:,xv(session_i):xv(session_i)+40-1),'or');hold on;
xlabel(x_plot{plot_i});
ylabel('reaction time');
title('Clamp, fast');
end;

figure(188);% t test
x_plot={'initial learning','decay','relearning'};
for plot_i=1:3
subplot(3,1,plot_i);
if plot_i==1
    session_i=3;
elseif plot_i==2
    session_i=4;
elseif plot_i==3
    session_i=7;
end;

plot(1:40,mean(Svector(:,xv(session_i):xv(session_i)+40-1),1),'-k');hold on;
errorbar(1:40,mean(Svector(:,xv(session_i):xv(session_i)+40-1),1),std(Svector(:,xv(session_i):xv(session_i)+40-1))./(sum(Sepe_Cl_Sham)^0.5),'Color',[0 0 0]);hold on;
plot(1:40,mean(Avector(:,xv(session_i):xv(session_i)+40-1),1),'-r');hold on;
errorbar(1:40,mean(Avector(:,xv(session_i):xv(session_i)+40-1),1),std(Avector(:,xv(session_i):xv(session_i)+40-1))./(sum(Sepe_Cl_Anodal)^0.5),'Color',[1 0 0]);hold on;
for cycle_i=1:40
    [hRT(plot_i,cycle_i) pRT(plot_i,cycle_i)]=ttest2(Svector(:,xv(session_i)+cycle_i-1),Avector(:,xv(session_i)+cycle_i-1));
    if pRT(plot_i,cycle_i)<0.001
        text(cycle_i,0.15,'***');
    elseif pRT(plot_i,cycle_i)<0.01
        text(cycle_i,0.15,'**');
    elseif pRT(plot_i,cycle_i)<0.05
        text(cycle_i,0.15,'*');
%     else
%         text(cycle_i,0.1,'-');
    end
end;

xlabel(x_plot{plot_i});
ylabel('reaction time');
title('Clamp, fast');
end;

%% 
for cycle_i=1:40
    
    [hc(cycle_i) pc(cycle_i)]=ttest2(Anodal_cycle_RT(Sepe_Cl_Anodal,xv(3)+cycle_i-1),Anodal_cycle_RT(~Sepe_Cl_Anodal,xv(3)+cycle_i-1));
    Astd(cycle_i)=std(Anodal_cycle_RT(:,xv(3)+cycle_i-1));
    Sstd(cycle_i)=std(Sham_cycle_RT(:,xv(3)+cycle_i-1));
end;
AMFast=mean(Anodal_cycle_RT(Sepe_Cl_Anodal,xv(3):xv(3)+40-1),1);
AMSlow=mean(Anodal_cycle_RT(~Sepe_Cl_Anodal,xv(3):xv(3)+40-1),1);
SMFast=mean(Sham_cycle_RT(Sepe_Cl_Sham,xv(3):xv(3)+40-1),1);
SMSlow=mean(Sham_cycle_RT(~Sepe_Cl_Sham,xv(3):xv(3)+40-1),1);
[h p]=ttest2(SMFast, SMSlow)
[h p]=ttest2(AMFast, AMSlow)
[h p]=ttest2(Astd,Sstd)

[r p]=corrcoef(mean(Sham_cycle_RT(:,xv(3):xv(3)+40-1),2),squeeze(mean(Sham_cycle_deba(1,:,54:55),3)));
[r p]=corrcoef(mean(Anodal_cycle_RT(:,xv(3):xv(3)+40-1),2),squeeze(mean(Anodal_cycle_deba(1,:,54:55),3)));

%% baseline compare
% load baseTrialAve;
% Ctr_sav=squeeze(mean(baseTrialAve(:,5,:),1));
% Ctr_afe=squeeze(mean(baseTrialAve(:,3,1:10),1));
figure(2);
baseline_title={'d1 ', 'd2 noFB ', 'd2 withFB '};

for session_i=1:10
    for baseline_i=1:3
        %         session_i=8;
        if session_i==1
            x=1;
        elseif session_i<6
            x=1+ sum(sessionNum(1:session_i-1));
        else
            x=1+ sum(sessionNum(1:session_i-1))+10;
        end
        subplot(2,3,baseline_i);
        plot(x:x+sessionNum(session_i)-1,squeeze(mean(Sham_cycle_deba(baseline_i,:,x:x+sessionNum(session_i)-1),2)),'k');
        hold on;
        plot(x:x+sessionNum(session_i)-1,squeeze(mean(Anodal_cycle_deba(baseline_i,:,x:x+sessionNum(session_i)-1),2)),'r');
        if session_i==8
            Sham_cycle_sav=squeeze(mean(Sham_cycle_deba(baseline_i,:,x:x+sessionNum(session_i)-1),2));
            Anodal_cycle_sav=squeeze(mean(Anodal_cycle_deba(baseline_i,:,x:x+sessionNum(session_i)-1),2));
            
            [h,p]=ttest2(Sham_cycle_sav(2:8),Anodal_cycle_sav(2:8));
            text(x-20,27,['p=' num2str(p)]);
        end;
        grid on;
        legend('Sham','Anodal');
        title(baseline_title{baseline_i});
        subplot(2,3,baseline_i+3);
        plot(x:x+sessionNum(session_i)-1,squeeze(mean(Sham_cycle_deba(baseline_i,:,x:x+sessionNum(session_i)-1),2)),'k');
        hold on;
        if session_i==8
            Sham_cycle_sav=squeeze(mean(Sham_cycle_deba(baseline_i,:,x:x+sessionNum(session_i)-1),2));
            
            plot(x:x+sessionNum(session_i)-1,Ctr_sav,'b');
            [h,p]=ttest2(Sham_cycle_sav(2:8),Ctr_sav(2:8));
            text(x-20,27,['p=' num2str(p)]);
        end
        grid on;
        legend('Sham','one day');
        
        title([baseline_title{baseline_i} 'vs 1 day']);
    end
end

%% initial learning speed
Sepe_Cl_Sham=mean(Sham_cycle_deba(1,:,54:55),3)>median(mean(Sham_cycle_deba(1,:,54:55),3));
Sepe_Cl_Anodal=mean(Anodal_cycle_deba(1,:,54:55),3)>median(mean(Anodal_cycle_deba(1,:,54:55),3));

for session_i=1:8
    subplot(1,2,1);
    if session_i==1
        x=1;
        plot(x:x+sessionNum(session_i)-1,squeeze(mean(Sham_cycle_deba(1,Sepe_Cl_Sham,x:x+sessionNum(session_i)-1),2)),'k');
        hold on;
        plot(x:x+sessionNum(session_i)-1,squeeze(mean(Sham_cycle_deba(1,~Sepe_Cl_Sham,x:x+sessionNum(session_i)-1),2)),'b');
        
    elseif session_i<5
        x=1+ sum(sessionNum(1:session_i-1));
        plot(x:x+sessionNum(session_i)-1,squeeze(mean(Sham_cycle_deba(1,Sepe_Cl_Sham,x:x+sessionNum(session_i)-1),2)),'k');
        hold on;
        plot(x:x+sessionNum(session_i)-1,squeeze(mean(Sham_cycle_deba(1,~Sepe_Cl_Sham,x:x+sessionNum(session_i)-1),2)),'b');
        
    else
        x=1+ sum(sessionNum(1:session_i-1));
        plot(x:x+sessionNum(session_i)-1,mean(Sham_cycle_orig(Sepe_Cl_Sham,x:x+sessionNum(session_i)-1),1),'k');
        hold on;
        plot(x:x+sessionNum(session_i)-1,mean(Sham_cycle_orig(~Sepe_Cl_Sham,x:x+sessionNum(session_i)-1),1),'b');
        
    end
    legend('faster','slower');
    title('Sham');
    text(40,mean(mean(Sham_cycle_deba(1,Sepe_Cl_Sham,54:55),3)),num2str(mean(mean(Sham_cycle_deba(1,Sepe_Cl_Sham,54:55),3))),'Color','k');
    text(40,mean(mean(Sham_cycle_deba(1,~Sepe_Cl_Sham,54:55),3)),num2str(mean(mean(Sham_cycle_deba(1,~Sepe_Cl_Sham,54:55),3))),'Color','b');
    text(40,mean(mean(Sham_cycle_deba(1,:,54:55),3)),'p<.001');
    text(55,mean(mean(Sham_cycle_deba(1,Sepe_Cl_Sham,56:57),3)),num2str(mean(mean(Sham_cycle_deba(1,Sepe_Cl_Sham,56:57),3))),'Color','k');
    text(55,mean(mean(Sham_cycle_deba(1,~Sepe_Cl_Sham,56:57),3)),num2str(mean(mean(Sham_cycle_deba(1,~Sepe_Cl_Sham,56:57),3))),'Color','b');
    
    text(80,mean(mean(Sham_cycle_deba(1,Sepe_Cl_Sham,86:95),3)),num2str(mean(mean(Sham_cycle_deba(1,Sepe_Cl_Sham,86:95),3))),'Color','k');
    text(80,mean(mean(Sham_cycle_deba(1,~Sepe_Cl_Sham,86:95),3)),num2str(mean(mean(Sham_cycle_deba(1,~Sepe_Cl_Sham,86:95),3))),'Color','b');
    text(110,mean(mean(Sham_cycle_orig(Sepe_Cl_Sham,112:118))),num2str(mean(mean(Sham_cycle_orig(Sepe_Cl_Sham,112:118)))),'Color','k');
    text(110,mean(mean(Sham_cycle_orig(~Sepe_Cl_Sham,112:118))),num2str(mean(mean(Sham_cycle_orig(~Sepe_Cl_Sham,112:118)))),'Color','b');
    
        text(140,mean(mean(Sham_cycle_orig(Sepe_Cl_Sham,151:152))),num2str(mean(mean(Sham_cycle_orig(Sepe_Cl_Sham,151:152)))),'Color','k');
    text(140,mean(mean(Sham_cycle_orig(~Sepe_Cl_Sham,151:152))),num2str(mean(mean(Sham_cycle_orig(~Sepe_Cl_Sham,151:152)))),'Color','b');

            text(190,mean(mean(Sham_cycle_orig(Sepe_Cl_Sham,181:190))),num2str(mean(mean(Sham_cycle_orig(Sepe_Cl_Sham,181:190)))),'Color','k');
    text(190,mean(mean(Sham_cycle_orig(~Sepe_Cl_Sham,181:190))),num2str(mean(mean(Sham_cycle_orig(~Sepe_Cl_Sham,181:190)))),'Color','b');

    ylim([-5 30]);
    subplot(1,2,2);
    if session_i==1
        x=1;
        plot(x:x+sessionNum(session_i)-1,squeeze(mean(Anodal_cycle_deba(1,Sepe_Cl_Anodal,x:x+sessionNum(session_i)-1),2)),'k');
        hold on;
        plot(x:x+sessionNum(session_i)-1,squeeze(mean(Anodal_cycle_deba(1,~Sepe_Cl_Anodal,x:x+sessionNum(session_i)-1),2)),'b');
        
    elseif session_i<5
        x=1+ sum(sessionNum(1:session_i-1));
        plot(x:x+sessionNum(session_i)-1,squeeze(mean(Anodal_cycle_deba(1,Sepe_Cl_Anodal,x:x+sessionNum(session_i)-1),2)),'k');
        hold on;
        plot(x:x+sessionNum(session_i)-1,squeeze(mean(Anodal_cycle_deba(1,~Sepe_Cl_Anodal,x:x+sessionNum(session_i)-1),2)),'b');
        
    else
        x=1+ sum(sessionNum(1:session_i-1));
        plot(x:x+sessionNum(session_i)-1,mean(Anodal_cycle_orig(Sepe_Cl_Anodal,x:x+sessionNum(session_i)-1),1),'k');
        hold on;
        plot(x:x+sessionNum(session_i)-1,mean(Anodal_cycle_orig(~Sepe_Cl_Anodal,x:x+sessionNum(session_i)-1),1),'b');
        
    end
    text(40,mean(mean(Anodal_cycle_deba(1,Sepe_Cl_Anodal,54:55),3)),num2str(mean(mean(Anodal_cycle_deba(1,Sepe_Cl_Anodal,54:55),3))),'Color','k');
    text(40,mean(mean(Anodal_cycle_deba(1,~Sepe_Cl_Anodal,54:55),3)),num2str(mean(mean(Anodal_cycle_deba(1,~Sepe_Cl_Anodal,54:55),3))),'Color','b');
    text(40,mean(mean(Anodal_cycle_deba(1,:,54:55),3)),'p<.001');
    text(55,mean(mean(Anodal_cycle_deba(1,Sepe_Cl_Anodal,56:57),3)),num2str(mean(mean(Anodal_cycle_deba(1,Sepe_Cl_Anodal,56:57),3))),'Color','k');
    text(55,mean(mean(Anodal_cycle_deba(1,~Sepe_Cl_Anodal,56:57),3)),num2str(mean(mean(Anodal_cycle_deba(1,~Sepe_Cl_Anodal,56:57),3))),'Color','b');
    
    text(80,mean(mean(Anodal_cycle_deba(1,Sepe_Cl_Anodal,86:95),3)),num2str(mean(mean(Anodal_cycle_deba(1,Sepe_Cl_Anodal,86:95),3))),'Color','k');
    text(80,mean(mean(Anodal_cycle_deba(1,~Sepe_Cl_Anodal,86:95),3)),num2str(mean(mean(Anodal_cycle_deba(1,~Sepe_Cl_Anodal,86:95),3))),'Color','b');
    text(110,mean(mean(Anodal_cycle_orig(Sepe_Cl_Anodal,112:118))),num2str(mean(mean(Anodal_cycle_orig(Sepe_Cl_Anodal,112:118)))),'Color','k');
    text(110,mean(mean(Anodal_cycle_orig(~Sepe_Cl_Anodal,112:118))),num2str(mean(mean(Anodal_cycle_orig(~Sepe_Cl_Anodal,112:118)))),'Color','b');
        text(140,mean(mean(Anodal_cycle_orig(Sepe_Cl_Anodal,151:152))),num2str(mean(mean(Anodal_cycle_orig(Sepe_Cl_Anodal,151:152)))),'Color','k');
    text(140,mean(mean(Anodal_cycle_orig(~Sepe_Cl_Anodal,151:152))),num2str(mean(mean(Anodal_cycle_orig(~Sepe_Cl_Anodal,151:152)))),'Color','b');
    text(190,mean(mean(Anodal_cycle_orig(Sepe_Cl_Anodal,181:190))),num2str(mean(mean(Anodal_cycle_orig(Sepe_Cl_Anodal,181:190)))),'Color','k');
    text(190,mean(mean(Anodal_cycle_orig(~Sepe_Cl_Anodal,181:190))),num2str(mean(mean(Anodal_cycle_orig(~Sepe_Cl_Anodal,181:190)))),'Color','b');

    
    ylim([-5 30]);
    title('Anodal');
    legend('faster','slower');
end;
%% clamp learning, decay & relearning speed
Sp_Color={'b','k'};
y=1:30;
for subj_i = 1:31
    figure(130+Sepe_Cl_Sham(subj_i));% Sham
    subplot(4,4,find(y(Sepe_Cl_Sham==Sepe_Cl_Sham(subj_i))==subj_i));
    
    for session_i=1:8
        if session_i<5
            plot(xv(session_i):xv(session_i)+sessionNum(session_i)-1,squeeze(Sham_cycle_deba(1,subj_i,xv(session_i):xv(session_i)+sessionNum(session_i)-1)),'Color',Sp_Color{Sepe_Cl_Sham(subj_i)+1});
            hold on;
        else
            plot(xv(session_i):xv(session_i)+sessionNum(session_i)-1,Sham_cycle_orig(subj_i,xv(session_i):xv(session_i)+sessionNum(session_i)-1),'Color',Sp_Color{Sepe_Cl_Sham(subj_i)+1});
            hold on;
        end;
        if session_i==3
            Clam=squeeze(Sham_cycle_deba(1,subj_i,xv(session_i):xv(session_i)+sessionNum(session_i)-1));
            initi_params = [Clam(1)./2 5 nanmean(Clam(end-2:end))];% ---a,b,c
            options = optimset('MaxIter',100);
            
            [paramsEach,resnorm,resid] = lsqcurvefit(@Lfunc_learningCurve,initi_params,1:sessionNum(session_i),Clam',[],[],options);
            plot(xv(session_i):xv(session_i)+sessionNum(session_i)-1,Lfunc_learningCurve(paramsEach,1:sessionNum(session_i)),'color','g','LineWidth',1.5);
            Sham_Clam(subj_i)=paramsEach(2);
        elseif session_i==4
            Rete=squeeze(Sham_cycle_deba(1,subj_i,xv(session_i):xv(session_i)+sessionNum(session_i)-1));
            initi_params = [Rete(1)./2 20 nanmean(Rete(end-2:end))];% ---a,b,c
            options = optimset('MaxIter',100);
            
            [paramsEach,resnorm,resid] = lsqcurvefit(@Lfunc_learningCurve,initi_params,1:sessionNum(session_i),Rete',[],[],options);
            plot(xv(session_i):xv(session_i)+sessionNum(session_i)-1,Lfunc_learningCurve(paramsEach,1:sessionNum(session_i)),'color','g','LineWidth',1.5);
            Sham_decay(subj_i)=paramsEach(2);
        elseif session_i==7
            Saving=Sham_cycle_orig(subj_i,xv(session_i):xv(session_i)+sessionNum(session_i)-1);
            initi_params = [Saving(1)./2 5 nanmean(Saving(end-2:end))];% ---a,b,c
            options = optimset('MaxIter',100);
            
            [paramsEach,resnorm,resid] = lsqcurvefit(@Lfunc_learningCurve,initi_params,1:sessionNum(session_i),Saving,[],[],options);
            plot(xv(session_i):xv(session_i)+sessionNum(session_i)-1,Lfunc_learningCurve(paramsEach,1:sessionNum(session_i)),'color','g','LineWidth',1.5);
            Sham_sav(subj_i)=paramsEach(2);
        end;
    end;
    title(['Sham, ' num2str(subj_i)]);
    text(50,20,['b=' num2str(Sham_decay(subj_i))]);
    text(120,0,['b=' num2str(Sham_sav(subj_i))]);
        text(20,-10,['b=' num2str(Sham_Clam(subj_i))]);

end;
%% clamp learning, decay & relearning speed
Sp_Color={'b','k'};
y=1:31;
for subj_i = 1:31
    figure(132+Sepe_Cl_Anodal(subj_i));% Anodal
    subplot(4,4,find(y(Sepe_Cl_Anodal==Sepe_Cl_Anodal(subj_i))==subj_i));
    
    for session_i=1:8
        if session_i<5
            plot(xv(session_i):xv(session_i)+sessionNum(session_i)-1,squeeze(Anodal_cycle_deba(1,subj_i,xv(session_i):xv(session_i)+sessionNum(session_i)-1)),'Color',Sp_Color{Sepe_Cl_Anodal(subj_i)+1});
            hold on;
        else
            plot(xv(session_i):xv(session_i)+sessionNum(session_i)-1,Anodal_cycle_orig(subj_i,xv(session_i):xv(session_i)+sessionNum(session_i)-1),'Color',Sp_Color{Sepe_Cl_Anodal(subj_i)+1});
            hold on;
        end;
        if session_i==3
            Clam=squeeze(Anodal_cycle_deba(1,subj_i,xv(session_i):xv(session_i)+sessionNum(session_i)-1));
            initi_params = [Clam(1)./2 5 nanmean(Clam(end-2:end))];% ---a,b,c
            options = optimset('MaxIter',100);
            
            [paramsEach,resnorm,resid] = lsqcurvefit(@Lfunc_learningCurve,initi_params,1:sessionNum(session_i),Clam',[],[],options);
            plot(xv(session_i):xv(session_i)+sessionNum(session_i)-1,Lfunc_learningCurve(paramsEach,1:sessionNum(session_i)),'color','g','LineWidth',1.5);
            Anodal_Clam(subj_i)=paramsEach(2);
        elseif session_i==4
            Rete=squeeze(Anodal_cycle_deba(1,subj_i,xv(session_i):xv(session_i)+sessionNum(session_i)-1));
            initi_params = [Rete(1)./2 5 nanmean(Rete(end-2:end))];% ---a,b,c
            options = optimset('MaxIter',100);
            
            [paramsEach,resnorm,resid] = lsqcurvefit(@Lfunc_learningCurve,initi_params,1:sessionNum(session_i),Rete',[],[],options);
            plot(xv(session_i):xv(session_i)+sessionNum(session_i)-1,Lfunc_learningCurve(paramsEach,1:sessionNum(session_i)),'color','g','LineWidth',1.5);
            Anodal_decay(subj_i)=paramsEach(2);
        elseif session_i==7
            Saving=Anodal_cycle_orig(subj_i,xv(session_i):xv(session_i)+sessionNum(session_i)-1);
            initi_params = [Saving(1)./2 20 nanmean(Saving(end-2:end))];% ---a,b,c
            options = optimset('MaxIter',100);
            
            [paramsEach,resnorm,resid] = lsqcurvefit(@Lfunc_learningCurve,initi_params,1:sessionNum(session_i),Saving,[],[],options);
            plot(xv(session_i):xv(session_i)+sessionNum(session_i)-1,Lfunc_learningCurve(paramsEach,1:sessionNum(session_i)),'color','g','LineWidth',1.5);
            Anodal_sav(subj_i)=paramsEach(2);
        end;
    end;
    title(['Anodal, ' num2str(subj_i)]);
    text(50,30,['b=' num2str(Anodal_decay(subj_i))]);
    text(120,0,['b=' num2str(Anodal_sav(subj_i))]);
        text(20,-10,['b=' num2str(Anodal_Clam(subj_i))]);

end;
%% intial learning 
y=1:31;
figure(20);
subplot(2,2,1);
for strp_i=1:500
    subj_re=randsample(1:31,27);
    Clam_re=squeeze(mean(Sham_cycle_deba(1,subj_re,xv(3):xv(3)+sessionNum(3)-1),2));
    plot(Clam_re,'k');hold on;
    initi_params = [Clam_re(1)./2 5 nanmean(Clam_re(end-2:end))];% ---a,b,c
    options = optimset('MaxIter',100);
    
    [paramsEach,resnorm,resid] = lsqcurvefit(@Lfunc_learningCurve,initi_params,1:sessionNum(3),Clam_re',[],[],options);
    ShamR2_temp=corrcoef(Clam_re,Lfunc_learningCurve(paramsEach,1:sessionNum(3)));
    ShamR2Init(strp_i)=ShamR2_temp(1,2).^2;
    
    Sham_Init_re(strp_i,:)=paramsEach;
end;

for strp_i=1:500
    subj_re=randsample(1:31,27);
    Clam_re=squeeze(mean(Anodal_cycle_deba(1,subj_re,xv(3):xv(3)+sessionNum(3)-1),2));
    plot(Clam_re,'r');hold on;
    
    initi_params = [Clam_re(1)./2 5 nanmean(Clam_re(end-2:end))];% ---a,b,c
    options = optimset('MaxIter',100);
    
    [paramsEach,resnorm,resid] = lsqcurvefit(@Lfunc_learningCurve,initi_params,1:sessionNum(3),Clam_re',[],[],options);
    AnodalR2_temp=corrcoef(Clam_re,Lfunc_learningCurve(paramsEach,1:sessionNum(3)));
    AnodalR2Init(strp_i)=AnodalR2_temp(1,2).^2;
    Anodal_Init_re(strp_i,:)=paramsEach;
end;
[h,p]=ttest2(Sham_Init_re(:,2),Anodal_Init_re(:,2))
subplot(2,2,2);
plot(Sham_Init_re(:,2),'ok');hold on;
plot(Anodal_Init_re(:,2),'or');hold on;
title('Init rate');
subplot(2,2,3);
plot(ShamR2Init,'ok');hold on;
plot(AnodalR2Init,'or');hold on;
title('r^2');
subplot(2,2,4);
plot(Sham_Init_re(:,3),'ok');hold on;
plot(Anodal_Init_re(:,3),'or');hold on;
title('plateau');
%% decay bootstrap all
figure(21);
subplot(2,2,1);
for strp_i=1:500
    subj_re=randsample(1:31,27);
    Rete_re=squeeze(mean(Sham_cycle_deba(1,subj_re,xv(4):xv(4)+sessionNum(4)-1),2));
    plot(Rete_re,'k');hold on;
    initi_params = [Rete_re(1)./2 5 nanmean(Rete_re(end-2:end))];% ---a,b,c
    options = optimset('MaxIter',100);
    
    [paramsEach,resnorm,resid] = lsqcurvefit(@Lfunc_learningCurve,initi_params,1:sessionNum(4),Rete_re',[],[],options);
    ShamR2_temp=corrcoef(Rete_re,Lfunc_learningCurve(paramsEach,1:sessionNum(4)));
    ShamR2(strp_i)=ShamR2_temp(1,2).^2;
    
    Sham_decay_re(strp_i,:)=paramsEach;
end;

for strp_i=1:500
    subj_re=randsample(1:31,27);
    Rete_re=squeeze(mean(Anodal_cycle_deba(1,subj_re,xv(4):xv(4)+sessionNum(4)-1),2));
    plot(Rete_re,'r');hold on;
    
    initi_params = [Rete_re(1)./2 5 nanmean(Rete_re(end-2:end))];% ---a,b,c
    options = optimset('MaxIter',100);
    
    [paramsEach,resnorm,resid] = lsqcurvefit(@Lfunc_learningCurve,initi_params,1:sessionNum(4),Rete_re',[],[],options);
    AnodalR2_temp=corrcoef(Rete_re,Lfunc_learningCurve(paramsEach,1:sessionNum(4)));
    AnodalR2(strp_i)=AnodalR2_temp(1,2).^2;
    Anodal_decay_re(strp_i,:)=paramsEach;
end;
[h,p]=ttest2(Sham_decay_re(:,2),Anodal_decay_re(:,2))
subplot(2,2,2);
plot(Sham_decay_re(:,2),'ok');hold on;
plot(Anodal_decay_re(:,2),'or');hold on;
title('decay rate');
subplot(2,2,3);
plot(ShamR2,'ok');hold on;
plot(AnodalR2,'or');hold on;
title('r^2');
subplot(2,2,4);
plot(Sham_decay_re(:,3),'ok');hold on;
plot(Anodal_decay_re(:,3),'or');hold on;
title('plateau');
%% decay bootstrap fast/slow
figure(22);
subplot(2,2,1);
y=1:31;
reSample=500;
for strp_i=1:reSample
    subj_re=randsample(y(Sepe_Cl_Sham),12);
    Rete_Fast=squeeze(mean(Sham_cycle_deba(1,subj_re,xv(4):xv(4)+sessionNum(4)-1),2));
    plot(Rete_Fast,'k');hold on;
    initi_params = [Rete_Fast(1)./2 5 nanmean(Rete_Fast(end-2:end))];% ---a,b,c
    options = optimset('MaxIter',100);
    
    [paramsEach,resnorm,resid] = lsqcurvefit(@Lfunc_learningCurve,initi_params,1:sessionNum(4),Rete_Fast',[],[],options);
    ShamR2_temp=corrcoef(Rete_Fast,Lfunc_learningCurve(paramsEach,1:sessionNum(4)));
    ShamR2Fast(strp_i)=ShamR2_temp(1,2).^2;
    
    Sham_decay_Fast(strp_i,:)=paramsEach;
end;
for strp_i=1:reSample
    subj_re=randsample(y(~Sepe_Cl_Sham),12);
    Rete_Slow=squeeze(mean(Sham_cycle_deba(1,subj_re,xv(4):xv(4)+sessionNum(4)-1),2));
    plot(Rete_Slow,'b');hold on;
    initi_params = [Rete_Slow(1)./2 5 nanmean(Rete_Slow(end-2:end))];% ---a,b,c
    options = optimset('MaxIter',100);
    
    [paramsEach,resnorm,resid] = lsqcurvefit(@Lfunc_learningCurve,initi_params,1:sessionNum(4),Rete_Slow',[],[],options);
    ShamR2_temp=corrcoef(Rete_Fast,Lfunc_learningCurve(paramsEach,1:sessionNum(4)));
    ShamR2Slow(strp_i)=ShamR2_temp(1,2).^2;
    
    Sham_decay_Slow(strp_i,:)=paramsEach;
end;
title('Sham, fast & slow');
[h,p]=ttest2(Sham_decay_Fast(:,2),Sham_decay_Slow(:,2))
subplot(2,2,2);
plot(Sham_decay_Fast(:,2),'ok');hold on;
plot([1 reSample],[mean(Sham_decay_Fast(:,2)) mean(Sham_decay_Fast(:,2))],'k');
text(reSample,mean(Sham_decay_Fast(:,2)),num2str(mean(Sham_decay_Fast(:,2))),'Color','k');
plot(Sham_decay_Slow(:,2),'ob');hold on;
plot([1 reSample],[mean(Sham_decay_Slow(:,2)) mean(Sham_decay_Slow(:,2))],'k');
text(reSample,mean(Sham_decay_Slow(:,2)),num2str(mean(Sham_decay_Slow(:,2))),'Color','k');
title('decay rate(b)');
subplot(2,2,3);
plot(ShamR2Fast,'ok');hold on;
plot([1 reSample],[mean(ShamR2Fast) mean(ShamR2Fast)],'k');
text(reSample,mean(ShamR2Fast),num2str(mean(ShamR2Fast)),'Color','k');

plot(ShamR2Slow,'ob');hold on;
plot([1 reSample],[mean(ShamR2Slow) mean(ShamR2Slow)],'k');
text(reSample,mean(ShamR2Slow),num2str(mean(ShamR2Slow)),'Color','k');

title('r^2');
subplot(2,2,4);
plot(Sham_decay_Fast(:,3),'ok');hold on;
plot([1 reSample],[mean(Sham_decay_Fast(:,3)) mean(Sham_decay_Fast(:,3))],'k');
text(reSample,mean(Sham_decay_Fast(:,3)),num2str(mean(Sham_decay_Fast(:,3))),'Color','k');
plot(Sham_decay_Slow(:,3),'ob');hold on;
plot([1 reSample],[mean(Sham_decay_Slow(:,3)) mean(Sham_decay_Slow(:,3))],'k');
text(reSample,mean(Sham_decay_Slow(:,3)),num2str(mean(Sham_decay_Slow(:,3))),'Color','k');
title('plateau(c)');
%% Anodal
figure(23);
subplot(2,2,1);
y=1:31;
reSample=500;
for strp_i=1:reSample
    subj_re=randsample(y(Sepe_Cl_Anodal),12);
    Rete_Fast=squeeze(mean(Anodal_cycle_deba(1,subj_re,xv(4):xv(4)+sessionNum(4)-1),2));
    plot(Rete_Fast,'k');hold on;
    initi_params = [Rete_Fast(1)./2 5 nanmean(Rete_Fast(end-2:end))];% ---a,b,c
    options = optimset('MaxIter',100);
    
    [paramsEach,resnorm,resid] = lsqcurvefit(@Lfunc_learningCurve,initi_params,1:sessionNum(4),Rete_Fast',[],[],options);
    AnodalR2_temp=corrcoef(Rete_Fast,Lfunc_learningCurve(paramsEach,1:sessionNum(4)));
    AnodalR2Fast(strp_i)=AnodalR2_temp(1,2).^2;
    
    Anodal_decay_Fast(strp_i,:)=paramsEach;
end;
for strp_i=1:reSample
    subj_re=randsample(y(~Sepe_Cl_Anodal),12);
    Rete_Slow=squeeze(mean(Anodal_cycle_deba(1,subj_re,xv(4):xv(4)+sessionNum(4)-1),2));
    plot(Rete_Slow,'b');hold on;
    initi_params = [Rete_Slow(1)./2 5 nanmean(Rete_Slow(end-2:end))];% ---a,b,c
    options = optimset('MaxIter',100);
    
    [paramsEach,resnorm,resid] = lsqcurvefit(@Lfunc_learningCurve,initi_params,1:sessionNum(4),Rete_Slow',[],[],options);
    AnodalR2_temp=corrcoef(Rete_Fast,Lfunc_learningCurve(paramsEach,1:sessionNum(4)));
    AnodalR2Slow(strp_i)=AnodalR2_temp(1,2).^2;
    
    Anodal_decay_Slow(strp_i,:)=paramsEach;
end;
title('Anodal, decay, fast & slow');
[h,p]=ttest2(Anodal_decay_Fast(:,2),Anodal_decay_Slow(:,2))
subplot(2,2,2);
plot(Anodal_decay_Fast(:,2),'ok');hold on;
plot([1 reSample],[mean(Anodal_decay_Fast(:,2)) mean(Anodal_decay_Fast(:,2))],'k');
text(reSample,mean(Anodal_decay_Fast(:,2)),num2str(mean(Anodal_decay_Fast(:,2))),'Color','k');
plot(Anodal_decay_Slow(:,2),'ob');hold on;
plot([1 reSample],[mean(Anodal_decay_Slow(:,2)) mean(Anodal_decay_Slow(:,2))],'k');
text(reSample,mean(Anodal_decay_Slow(:,2)),num2str(mean(Anodal_decay_Slow(:,2))),'Color','k');
title('decay rate(b)');
subplot(2,2,3);
plot(AnodalR2Fast,'ok');hold on;
plot([1 reSample],[mean(AnodalR2Fast) mean(AnodalR2Fast)],'k');
text(reSample,mean(AnodalR2Fast),num2str(mean(AnodalR2Fast)),'Color','k');

plot(AnodalR2Slow,'ob');hold on;
plot([1 reSample],[mean(AnodalR2Slow) mean(AnodalR2Slow)],'k');
text(reSample,mean(AnodalR2Slow),num2str(mean(AnodalR2Slow)),'Color','k');

title('r^2');
subplot(2,2,4);
plot(Anodal_decay_Fast(:,3),'ok');hold on;
plot([1 reSample],[mean(Anodal_decay_Fast(:,3)) mean(Anodal_decay_Fast(:,3))],'k');
text(reSample,mean(Anodal_decay_Fast(:,3)),num2str(mean(Anodal_decay_Fast(:,3))),'Color','k');
plot(Anodal_decay_Slow(:,3),'ob');hold on;
plot([1 reSample],[mean(Anodal_decay_Slow(:,3)) mean(Anodal_decay_Slow(:,3))],'k');
text(reSample,mean(Anodal_decay_Slow(:,3)),num2str(mean(Anodal_decay_Slow(:,3))),'Color','k');
title('plateau(c)');
%% savings rate compare bootstrap
figure(24);
subplot(2,2,1);
y=1:31;
reSample=500;
for strp_i=1:reSample
    subj_re=randsample(1:31,27);
    Sav_re=squeeze(mean(Sham_cycle_orig(subj_re,xv(7):xv(7)+sessionNum(7)-1),1));
    initi_params = [Sav_re(1)./2 5 nanmean(Sav_re(end-2:end))];% ---a,b,c
    options = optimset('MaxIter',100);
    plot(Sav_re,'k');hold on;
    
    [paramsEach,resnorm,resid] = lsqcurvefit(@Lfunc_learningCurve,initi_params,1:sessionNum(7),Sav_re,[],[],options);
    ShamR2_temp=corrcoef(Sav_re,Lfunc_learningCurve(paramsEach,1:sessionNum(7)));
    ShamR2(strp_i)=ShamR2_temp(1,2).^2;
    
    Sham_sav_re(strp_i,:)=paramsEach;
end;

for strp_i=1:reSample
    subj_re=randsample(1:31,27);
    Sav_re=squeeze(mean(Anodal_cycle_orig(subj_re,xv(7):xv(7)+sessionNum(7)-1),1));
    initi_params = [Sav_re(1)./2 5 nanmean(Sav_re(end-2:end))];% ---a,b,c
    options = optimset('MaxIter',100);
    plot(Sav_re,'r');hold on;
    
    [paramsEach,resnorm,resid] = lsqcurvefit(@Lfunc_learningCurve,initi_params,1:sessionNum(7),Sav_re,[],[],options);
    AnodalR2_temp=corrcoef(Sav_re,Lfunc_learningCurve(paramsEach,1:sessionNum(7)));
    AnodalR2(strp_i)=AnodalR2_temp(1,2).^2;
    Anodal_sav_re(strp_i,:)=paramsEach;
end;
[h,p]=ttest2(Sham_sav_re(:,2),Anodal_sav_re(:,2))
subplot(2,2,2);
plot(Sham_sav_re(:,2),'ok');hold on;
plot(Anodal_sav_re(:,2),'or');hold on;
subplot(2,2,3);
plot(ShamR2,'ok');hold on;
plot(AnodalR2,'or');hold on;

subplot(2,2,4);
plot(Sham_sav_re(:,3),'ok');hold on;
plot(Anodal_sav_re(:,3),'or');hold on;
%% saving compare bootstrap fast vs slow
figure(26);
subplot(2,2,1);
reSample=500;
for strp_i=1:reSample
    subj_re=randsample(y(Sepe_Cl_Sham),12);
    Sav_Fast=squeeze(mean(Sham_cycle_orig(subj_re,xv(7):xv(7)+sessionNum(7)-1),1));
    initi_params = [Sav_Fast(1)./2 10 nanmean(Sav_Fast(end-2:end))];% ---a,b,c
    options = optimset('MaxIter',100);
    plot(Sav_Fast,'k');hold on;
    
    [paramsEach,resnorm,resid] = lsqcurvefit(@Lfunc_learningCurve,initi_params,1:sessionNum(7),Sav_Fast,[],[],options);
    ShamR2_temp=corrcoef(Sav_Fast,Lfunc_learningCurve(paramsEach,1:sessionNum(7)));
    ShamR2Fast(strp_i)=ShamR2_temp(1,2).^2;
    
    Sham_Sav_Fast(strp_i,:)=paramsEach;
end;
for strp_i=1:reSample
    subj_re=randsample(y(~Sepe_Cl_Sham),12);
    Sav_Slow=squeeze(mean(Sham_cycle_orig(subj_re,xv(7):xv(7)+sessionNum(7)-1),1));
    initi_params = [Sav_Slow(1)./2 10 nanmean(Sav_Slow(end-2:end))];% ---a,b,c
    options = optimset('MaxIter',100);
    plot(Sav_Slow,'b');hold on;
    
    [paramsEach,resnorm,resid] = lsqcurvefit(@Lfunc_learningCurve,initi_params,1:sessionNum(7),Sav_Slow,[],[],options);
    ShamR2_temp=corrcoef(Sav_Fast,Lfunc_learningCurve(paramsEach,1:sessionNum(7)));
    ShamR2Slow(strp_i)=ShamR2_temp(1,2).^2;
    
    Sham_Sav_Slow(strp_i,:)=paramsEach;
end;
title('Clamp, Savings, Sham, fast & slow');
[h,p]=ttest2(Sham_Sav_Fast(:,2),Sham_Sav_Slow(:,2))
subplot(2,2,2);
plot(Sham_Sav_Fast(:,2),'ok');hold on;
plot([1 reSample],[mean(Sham_Sav_Fast(:,2)) mean(Sham_Sav_Fast(:,2))],'k');
text(reSample,mean(Sham_Sav_Fast(:,2)),num2str(mean(Sham_Sav_Fast(:,2))),'Color','k');
plot(Sham_Sav_Slow(:,2),'ob');hold on;
plot([1 reSample],[mean(Sham_Sav_Slow(:,2)) mean(Sham_Sav_Slow(:,2))],'b');
text(reSample,mean(Sham_Sav_Slow(:,2)),num2str(mean(Sham_Sav_Slow(:,2))),'Color','b');
title('Sav rate(b)');
subplot(2,2,3);
plot(ShamR2Fast,'ok');hold on;
plot([1 reSample],[mean(ShamR2Fast) mean(ShamR2Fast)],'k');
text(reSample,mean(ShamR2Fast),num2str(mean(ShamR2Fast)),'Color','k');

plot(ShamR2Slow,'ob');hold on;
plot([1 reSample],[mean(ShamR2Slow) mean(ShamR2Slow)],'b');
text(reSample,mean(ShamR2Slow),num2str(mean(ShamR2Slow)),'Color','b');

title('r^2');
subplot(2,2,4);
plot(Sham_Sav_Fast(:,3),'ok');hold on;
plot([1 reSample],[mean(Sham_Sav_Fast(:,3)) mean(Sham_Sav_Fast(:,3))],'k');
text(reSample,mean(Sham_Sav_Fast(:,3)),num2str(mean(Sham_Sav_Fast(:,3))),'Color','k');
plot(Sham_Sav_Slow(:,3),'ob');hold on;
plot([1 reSample],[mean(Sham_Sav_Slow(:,3)) mean(Sham_Sav_Slow(:,3))],'b');
text(reSample,mean(Sham_Sav_Slow(:,3)),num2str(mean(Sham_Sav_Slow(:,3))),'Color','b');
title('plateau(c)');
%% 
figure(27);
subplot(2,2,1);
for strp_i=1:reSample
    subj_re=randsample(y(Sepe_Cl_Anodal),10);
    Sav_Fast=squeeze(mean(Anodal_cycle_orig(subj_re,xv(7):xv(7)+sessionNum(7)-1),1));
    initi_params = [Sav_Fast(1)./2 10 nanmean(Sav_Fast(end-2:end))];% ---a,b,c
    options = optimset('MaxIter',100);
    plot(Sav_Fast,'k');hold on;
    
    [paramsEach,resnorm,resid] = lsqcurvefit(@Lfunc_learningCurve,initi_params,1:sessionNum(7),Sav_Fast,[],[],options);
    AnodalR2_temp=corrcoef(Sav_Fast,Lfunc_learningCurve(paramsEach,1:sessionNum(7)));
    AnodalR2Fast(strp_i)=AnodalR2_temp(1,2).^2;
    Anodal_Sav_Fast(strp_i,:)=paramsEach;
end;
for strp_i=1:reSample
    subj_re=randsample(y(~Sepe_Cl_Anodal),10);
    Sav_Slow=squeeze(mean(Anodal_cycle_orig(subj_re,xv(7):xv(7)+sessionNum(7)-1),1));
    initi_params = [Sav_Slow(1)./2 10 nanmean(Sav_Slow(end-2:end))];% ---a,b,c
    options = optimset('MaxIter',100);
    plot(Sav_Slow,'b');hold on;
    
    [paramsEach,resnorm,resid] = lsqcurvefit(@Lfunc_learningCurve,initi_params,1:sessionNum(7),Sav_Slow,[],[],options);
    AnodalR2_temp=corrcoef(Sav_Fast,Lfunc_learningCurve(paramsEach,1:sessionNum(7)));
    AnodalR2Slow(strp_i)=AnodalR2_temp(1,2).^2;
    Anodal_Sav_Slow(strp_i,:)=paramsEach;
end;
title('Clamp, Savings, Anodal, fast & slow');
[h,p]=ttest2(Anodal_Sav_Fast(:,2),Anodal_Sav_Slow(:,2))
subplot(2,2,2);
plot(Anodal_Sav_Fast(:,2),'ok');hold on;
plot([1 reSample],[mean(Anodal_Sav_Fast(:,2)) mean(Anodal_Sav_Fast(:,2))],'k');
text(reSample,mean(Anodal_Sav_Fast(:,2)),num2str(mean(Anodal_Sav_Fast(:,2))),'Color','k');
plot(Anodal_Sav_Slow(:,2),'ob');hold on;
plot([1 reSample],[mean(Anodal_Sav_Slow(:,2)) mean(Anodal_Sav_Slow(:,2))],'b');
text(reSample,mean(Anodal_Sav_Slow(:,2)),num2str(mean(Anodal_Sav_Slow(:,2))),'Color','b');
title('Sav rate(b)');
subplot(2,2,3);
plot(AnodalR2Fast,'ok');hold on;
plot([1 reSample],[mean(AnodalR2Fast) mean(AnodalR2Fast)],'k');
text(reSample,mean(AnodalR2Fast),num2str(mean(AnodalR2Fast)),'Color','k');

plot(AnodalR2Slow,'ob');hold on;
plot([1 reSample],[mean(AnodalR2Slow) mean(AnodalR2Slow)],'b');
text(reSample,mean(AnodalR2Slow),num2str(mean(AnodalR2Slow)),'Color','b');

title('r^2');
subplot(2,2,4);
plot(Anodal_Sav_Fast(:,3),'ok');hold on;
plot([1 reSample],[mean(Anodal_Sav_Fast(:,3)) mean(Anodal_Sav_Fast(:,3))],'k');
text(reSample,mean(Anodal_Sav_Fast(:,3)),num2str(mean(Anodal_Sav_Fast(:,3))),'Color','k');
plot(Anodal_Sav_Slow(:,3),'ob');hold on;
plot([1 reSample],[mean(Anodal_Sav_Slow(:,3)) mean(Anodal_Sav_Slow(:,3))],'b');
text(reSample,mean(Anodal_Sav_Slow(:,3)),num2str(mean(Anodal_Sav_Slow(:,3))),'Color','b');
title('plateau(c)');

%% correlation
figure(3);
for i=1:6
subplot(2,3,i);
if i==1
    xAll=squeeze(mean(Sham_cycle_deba(1,:,54:55),3));
    yAll=squeeze(mean(Sham_cycle_deba(1,:,86:95),3));
    xFast=squeeze(mean(Sham_cycle_deba(1,Sepe_Cl_Sham,54:55),3));
    yFast=squeeze(mean(Sham_cycle_deba(1,Sepe_Cl_Sham,86:95),3));
        xSlow=squeeze(mean(Sham_cycle_deba(1,~Sepe_Cl_Sham,54:55),3));
    ySlow=squeeze(mean(Sham_cycle_deba(1,~Sepe_Cl_Sham,86:95),3));
    Title='Sham, initial x aftereffct';
%     YRange=[-4 14];
elseif i==2
        xAll=squeeze(mean(Sham_cycle_deba(1,:,54:55),3));
    yAll=squeeze(mean(Sham_cycle_orig(:,112:118),2))';
    xFast=squeeze(mean(Sham_cycle_deba(1,Sepe_Cl_Sham,54:55),3));
    yFast=squeeze(mean(Sham_cycle_orig(Sepe_Cl_Sham,112:118),2))';
        xSlow=squeeze(mean(Sham_cycle_deba(1,~Sepe_Cl_Sham,54:55),3));
    ySlow=squeeze(mean(Sham_cycle_orig(~Sepe_Cl_Sham,112:118),2))';
    Title='Sham, initial x savings';
    elseif i==3
        xAll=squeeze(mean(Sham_cycle_deba(1,:,56:57),3))-squeeze(mean(Sham_cycle_deba(1,:,54:55),3));
    yAll=squeeze(mean(Sham_cycle_orig(:,112:118),2))';
    xFast=squeeze(mean(Sham_cycle_deba(1,Sepe_Cl_Sham,56:57),3))-squeeze(mean(Sham_cycle_deba(1,Sepe_Cl_Sham,54:55),3));
    yFast=squeeze(mean(Sham_cycle_orig(Sepe_Cl_Sham,112:118),2))';
        xSlow=squeeze(mean(Sham_cycle_deba(1,~Sepe_Cl_Sham,56:57),3))-squeeze(mean(Sham_cycle_deba(1,~Sepe_Cl_Sham,54:55),3));
    ySlow=squeeze(mean(Sham_cycle_orig(~Sepe_Cl_Sham,112:118),2))';
    Title='Sham, initial gapx savings';

%     YRange=[5 25];
elseif i==4
        xAll=squeeze(mean(Anodal_cycle_deba(1,:,54:55),3));
    yAll=squeeze(mean(Anodal_cycle_deba(1,:,86:95),3));
    xFast=squeeze(mean(Anodal_cycle_deba(1,Sepe_Cl_Anodal,54:55),3));
    yFast=squeeze(mean(Anodal_cycle_deba(1,Sepe_Cl_Anodal,86:95),3));
        xSlow=squeeze(mean(Anodal_cycle_deba(1,~Sepe_Cl_Anodal,54:55),3));
    ySlow=squeeze(mean(Anodal_cycle_deba(1,~Sepe_Cl_Anodal,86:95),3));
    Title='Anodal, initial x aftereffct';
%     YRange=[-4 14];
elseif i==5
            xAll=squeeze(mean(Anodal_cycle_deba(1,:,54:55),3));
    yAll=squeeze(mean(Anodal_cycle_orig(:,112:118),2))';
    xFast=squeeze(mean(Anodal_cycle_deba(1,Sepe_Cl_Anodal,54:55),3));
    yFast=squeeze(mean(Anodal_cycle_orig(Sepe_Cl_Anodal,112:118),2))';
        xSlow=squeeze(mean(Anodal_cycle_deba(1,~Sepe_Cl_Anodal,54:55),3));
    ySlow=squeeze(mean(Anodal_cycle_orig(~Sepe_Cl_Anodal,112:118),2))';
    Title='Anodal, initial x savings';
elseif i==6
            xAll=squeeze(mean(Anodal_cycle_deba(1,:,56:57),3))-squeeze(mean(Anodal_cycle_deba(1,:,54:55),3));
    yAll=squeeze(mean(Anodal_cycle_orig(:,112:118),2))';
    xFast=squeeze(mean(Anodal_cycle_deba(1,Sepe_Cl_Anodal,56:57),3))-squeeze(mean(Anodal_cycle_deba(1,Sepe_Cl_Anodal,54:55),3));
    yFast=squeeze(mean(Anodal_cycle_orig(Sepe_Cl_Anodal,112:118),2))';
        xSlow=squeeze(mean(Anodal_cycle_deba(1,~Sepe_Cl_Anodal,56:57),3))-squeeze(mean(Anodal_cycle_deba(1,~Sepe_Cl_Anodal,54:55),3));
    ySlow=squeeze(mean(Anodal_cycle_orig(~Sepe_Cl_Anodal,112:118),2))';
    Title='Anodal, initial gapx savings';
%     YRange=[5 25];
end;
plot(xFast,yFast,'ok');
hold on;
plot(xSlow,ySlow,'ob');
title(Title);
% xlim([13 30]);
[r,p]=corrcoef(xAll,yAll);
[rF,pF]=corrcoef(xFast,yFast);
[rS,pS]=corrcoef(xSlow,ySlow);
polyAll=polyfit(xAll,yAll,1);
polyFast=polyfit(xFast,yFast,1);
polySlow=polyfit(xSlow,ySlow,1);

plot([min(xAll) max(xAll)],polyval(polyAll,[min(xAll) max(xAll)]),'Color',[0.5 0.5 0.5]);
plot([min(xFast) max(xFast)],polyval(polyFast,[min(xFast) max(xFast)]),'k');
plot([min(xSlow) max(xSlow)],polyval(polySlow,[min(xSlow) max(xSlow)]),'b');
text(max(xFast),polyval(polyFast,max(xFast)),['p=' num2str(pF(1,2))],'Color','k');
text(min(xSlow),polyval(polySlow,min(xSlow)),['p=' num2str(pS(1,2))],'Color','b');
text(max(xAll),polyval(polyAll,max(xAll)),['p=' num2str(p(1,2))],'Color',[0.5 0.5 0.5]);
legend('faster','slower');
end;
%% static analyze
[h,p,ci,stat]=ttest2(squeeze(mean(Sham_cycle_deba(1,:,51:60),2)),squeeze(mean(Anodal_cycle_deba(1,:,51:60),2)))
text(40,25,'ns');
[h,p]=ttest2(mean(Sham_cycle_orig(:,86:95),2),mean(Anodal_cycle_orig(:,86:95),2))
for i=1:40
    [h1(i) p1(i)]=ttest2(squeeze(Sham_cycle_deba(1,:,60+i)),squeeze(Anodal_cycle_deba(1,:,60+i)));
end;
[h,p]=ttest2(squeeze(mean(Sham_cycle_deba(1,:,56:57),2)),squeeze(mean(Anodal_cycle_deba(1,:,56:57),2)))

[h,p]=ttest2(squeeze(mean(Sham_cycle_deba(1,:,62:70),2)),squeeze(mean(Anodal_cycle_deba(1,:,62:70),2)))

[h,p]=ttest2(squeeze(mean(Sham_cycle_deba(1,:,86:95),3)),squeeze(mean(Anodal_cycle_deba(1,:,86:95),3)))
text(80,10,'p<.001');
[h,p]=ttest2(squeeze(mean(Sham_cycle_deba(1,:,111:120),2)),squeeze(mean(Anodal_cycle_deba(1,:,111:120),2)))
[h,p]=ttest2(Sham_cycle_orig(:,101),Anodal_cycle_orig(:,101))
[h,p]=ttest2(mean(Sham_cycle_orig(:,56:57),2),mean(Anodal_cycle_orig(:,56:57),2))

[h,p]=ttest2(mean(Sham_cycle_orig(:,101:102),2),mean(Anodal_cycle_orig(:,101:102),2))

[h,p]=ttest2(mean(Sham_cycle_orig(:,121:130),2),mean(Anodal_cycle_orig(:,121:130),2))
[h,p]=ttest2(mean(Sham_cycle_orig(:,131:140),2),mean(Anodal_cycle_orig(:,131:140),2))
text(121,3,'ns');text(131,3,'ns');
[h,p]=ttest2(mean(Sham_cycle_orig(:,142:150),2),mean(Anodal_cycle_orig(:,142:150),2))

text(141,25,'2-8: p=0.064');
[h,p]=ttest2(mean(Sham_cycle_orig(:,211:220),2),mean(Anodal_cycle_orig(:,211:220),2))

[h,p]=ttest2(mean(Abaseline_d2s2-Abaseline_d2s1,2),mean(Sbaseline_d2s2-Sbaseline_d2s1,2))


%%
[h,p]=ttest2(mean(Sham_cycle_deba(1,Sepe_Cl_Sham,54:55),3),mean(Sham_cycle_deba(1,~Sepe_Cl_Sham,54:55),3))
[h,p]=ttest2(mean(Anodal_cycle_deba(1,Sepe_Cl_Anodal,54:55),3),mean(Anodal_cycle_deba(1,~Sepe_Cl_Anodal,54:55),3))
[h,p]=ttest2(mean(Sham_cycle_deba(1,Sepe_Cl_Sham,56:57),3),mean(Sham_cycle_deba(1,~Sepe_Cl_Sham,56:57),3))
[h,p]=ttest2(mean(Anodal_cycle_deba(1,Sepe_Cl_Anodal,56:57),3),mean(Anodal_cycle_deba(1,~Sepe_Cl_Anodal,56:57),3))

[h,p]=ttest2(mean(Sham_cycle_deba(1,Sepe_Cl_Sham,54:55),3),mean(Anodal_cycle_deba(1,Sepe_Cl_Anodal,54:55),3))
[h,p]=ttest2(mean(Sham_cycle_deba(1,~Sepe_Cl_Sham,54:55),3),mean(Anodal_cycle_deba(1,~Sepe_Cl_Anodal,54:55),3))
[h,p]=ttest2(mean(Sham_cycle_deba(1,Sepe_Cl_Sham,56:57),3),mean(Anodal_cycle_deba(1,Sepe_Cl_Anodal,56:57),3))
[h,p]=ttest2(mean(Sham_cycle_deba(1,~Sepe_Cl_Sham,56:57),3),mean(Anodal_cycle_deba(1,~Sepe_Cl_Anodal,56:57),3))



[h,p]=ttest2(mean(Sham_cycle_deba(1,Sepe_Cl_Sham,86:95),3),mean(Sham_cycle_deba(1,~Sepe_Cl_Sham,86:95),3))
[h,p]=ttest2(mean(Anodal_cycle_deba(1,Sepe_Cl_Anodal,86:95),3),mean(Anodal_cycle_deba(1,~Sepe_Cl_Anodal,86:95),3))

[h,p]=ttest2(mean(Sham_cycle_deba(1,Sepe_Cl_Sham,86:95),3),mean(Anodal_cycle_deba(1,Sepe_Cl_Anodal,86:95),3))
[h,p]=ttest2(mean(Sham_cycle_deba(1,~Sepe_Cl_Sham,86:95),3),mean(Anodal_cycle_deba(1,~Sepe_Cl_Anodal,86:95),3))

[h,p]=ttest2(mean(Sham_cycle_orig(Sepe_Cl_Sham,112:118),2),mean(Sham_cycle_orig(~Sepe_Cl_Sham,112:118),2))
[h,p]=ttest2(mean(Anodal_cycle_orig(Sepe_Cl_Anodal,112:118),2),mean(Anodal_cycle_orig(~Sepe_Cl_Anodal,112:118),2))

[h,p]=ttest2(mean(Sham_cycle_orig(Sepe_Cl_Sham,151:152),2),mean(Sham_cycle_orig(~Sepe_Cl_Sham,151:152),2))
[h,p]=ttest2(mean(Sham_cycle_orig(Sepe_Cl_Sham,181:190),2),mean(Sham_cycle_orig(~Sepe_Cl_Sham,181:190),2))
[h,p]=ttest2(mean(Anodal_cycle_orig(Sepe_Cl_Anodal,151:152),2),mean(Anodal_cycle_orig(~Sepe_Cl_Anodal,151:152),2))
[h,p]=ttest2(mean(Anodal_cycle_orig(Sepe_Cl_Anodal,181:190),2),mean(Anodal_cycle_orig(~Sepe_Cl_Anodal,181:190),2))



[h,p]=ttest2(mean(Sham_cycle_orig(Sepe_Cl_Sham,112:118),2),mean(Anodal_cycle_orig(Sepe_Cl_Anodal,112:118),2))
[h,p]=ttest2(mean(Sham_cycle_orig(~Sepe_Cl_Sham,112:120),2),mean(Anodal_cycle_orig(~Sepe_Cl_Anodal,112:120),2))

