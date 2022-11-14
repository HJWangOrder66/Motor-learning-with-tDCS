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
end
colorArray={'b','c','g','k','b','k','b','r','k','b'};
Slow=0.3;

load('EC_Sham_all_41.mat');
Svalid_end=peakData(:,:,7);
Svalid_end = -Svalid_end;
Svalid_end(endData(:,:,6)==1|peakData(:,:,8)==1)=NaN;
IfValid=isnan(IfTFail);
SRT=newRTD;
SRT(~IfValid)=nan;

for subj_i = 1:41
    direction_temp = squeeze(trialInfo(subj_i,:,1));
    for dir_i=1:8
        valid_end_temp=squeeze(Svalid_end(subj_i,find(direction_temp==dir_i)));
        Sbaseline_d1s1(subj_i,dir_i)=nanmean(valid_end_temp(1:5));
        Sbaseline_d1s2(subj_i,dir_i)=nanmean(valid_end_temp(11:15));
        Sbaseline_d2s1(subj_i,dir_i)=nanmean(valid_end_temp(95+1:95+5));
        Sbaseline_d2s2(subj_i,dir_i)=nanmean(valid_end_temp(95+11:95+15));
    end;
end;
% different baseline
for subj_i = 1:41
    direction_temp = squeeze(trialInfo(subj_i,:,1));
    for trial_i=1:size(Svalid_end,2)
        if ~isnan(direction_temp(trial_i))
            % day1 baseline
            Sdeba_end(1,subj_i,trial_i)=Svalid_end(subj_i,trial_i)-Sbaseline_d1s2(subj_i,direction_temp(trial_i));
            % day2 no feedback baseline
            Sdeba_end(2,subj_i,trial_i)=Svalid_end(subj_i,trial_i)-Sbaseline_d2s1(subj_i,direction_temp(trial_i));
            % day2 with feedback baseline
            Sdeba_end(3,subj_i,trial_i)=Svalid_end(subj_i,trial_i)-Sbaseline_d2s2(subj_i,direction_temp(trial_i));
            
        end;
    end;
end;
for subj_i=1:41
    
    for cycle_i=1:size(Svalid_end,2)/trialNum
        Sham_cycle_orig(subj_i,cycle_i)=nanmean(Svalid_end(subj_i,cycle_i*8-7:cycle_i*8));
        Sham_cycle_RT(subj_i,cycle_i)=nanmean(SRT(subj_i,cycle_i*8-7:cycle_i*8));
        for baseline_i=1:3
            Sham_cycle_deba(baseline_i,subj_i,cycle_i)=nanmean(squeeze(Sdeba_end(baseline_i,subj_i,cycle_i*8-7:cycle_i*8)));
        end;
    end;
end;
% save('EC_Sham_all_41.mat','Sham_cycle_deba','Sham_cycle_orig','-append');

load('EC_Anodal_all_41.mat');
Avalid_end=peakData(:,:,7);
Avalid_end = -Avalid_end;
Avalid_end(endData(:,:,6)==1|peakData(:,:,8)==1)=NaN;
IfValid=isnan(IfTFail);
ART=newRTD;
ART(~IfValid)=nan;

for subj_i = 1:41
    direction_temp = squeeze(trialInfo(subj_i,:,1));
    target_angle = (direction_temp - 1).*45;
    for dir_i=1:8
        valid_end_temp=squeeze(Avalid_end(subj_i,find(direction_temp==dir_i)));
        Abaseline_d1s1(subj_i,dir_i)=nanmean(valid_end_temp(1:5));
        Abaseline_d1s2(subj_i,dir_i)=nanmean(valid_end_temp(11:15));
        Abaseline_d2s1(subj_i,dir_i)=nanmean(valid_end_temp(95+1:95+5));
        Abaseline_d2s2(subj_i,dir_i)=nanmean(valid_end_temp(95+11:95+15));
    end;
end;
% different baseline
for subj_i = 1:41
    direction_temp = squeeze(trialInfo(subj_i,:,1));
    for trial_i=1:size(Avalid_end,2)
        if ~isnan(direction_temp(trial_i))
            %day1 baseline
            Adeba_end(1,subj_i,trial_i)=Avalid_end(subj_i,trial_i)-Abaseline_d1s2(subj_i,direction_temp(trial_i));
            % day2 no feedback
            Adeba_end(2,subj_i,trial_i)=Avalid_end(subj_i,trial_i)-Abaseline_d2s1(subj_i,direction_temp(trial_i));
            %day2 with feedback
            Adeba_end(3,subj_i,trial_i)=Avalid_end(subj_i,trial_i)-Abaseline_d2s2(subj_i,direction_temp(trial_i));
            
        end
    end
end

% cycle
% load baseTrialAve;
for subj_i=1:41
    for cycle_i=1:size(Avalid_end,2)/trialNum
        Anodal_cycle_orig(subj_i,cycle_i)=nanmean(Avalid_end(subj_i,cycle_i*8-7:cycle_i*8));
        Anodal_cycle_RT(subj_i,cycle_i)=nanmean(ART(subj_i,cycle_i*8-7:cycle_i*8));

        
        for baseline_i=1:3
            Anodal_cycle_deba(baseline_i,subj_i,cycle_i)=nanmean(squeeze(Adeba_end(baseline_i,subj_i,cycle_i*8-7:cycle_i*8)));
        end
    end
end
% save('EC_Anodal_all_41.mat','Anodal_cycle_deba','Anodal_cycle_orig','-append');
% %% individual figure, trial by trial
% figure;
% for subj_i = 1:41
%     subplot(6,7,subj_i);
%     tempData = Avalid_end(subj_i,1:760);
%     plot(tempData);
%     %     plot(tempData(~isoutlier(tempData)));
%     anodal_outrate(subj_i) = sum(isoutlier(tempData)/760);
% end
% figure;
% for subj_i = 1:41
%     subplot(6,7,subj_i);
%     tempData = Svalid_end(subj_i,1:760);
%     plot(tempData);
%     %     plot(tempData(~isoutlier(tempData)));
%     sham_outrate(subj_i) = sum(isoutlier(tempData)/760);
% end
%% average subjects plot
sessionNum=[5 10 40 40 5 10 40 40];

figure('Position',[1 1 960 540]);
hold on;
LabelSize = 20;
TickSize = 16;
h3=fill([10 55 55 10],[0 0 35 35],[1 0.9 0.9],'LineStyle','none');%tDCS
h4=plot([5 15],[0 0],'k','LineWidth',1,'LineStyle',':');%veridical/rotation
h4=plot([0 5],[0 0],'k','LineWidth',1);%veridical/rotation
h5=plot([15 15 55 55],[0 30 30 0],'k','LineWidth',1,'LineStyle','-.');%veridical/rotation
h6=plot([55 95],[0 0],'k','LineWidth',1,'LineStyle',':');%no feedback
plot([95 100],[0 0],'k','LineWidth',1);
plot([100 110],[0 0],'k','LineWidth',1,'LineWidth',1,'LineStyle',':');
% plot([110 120]+10,[0 0],'k','LineWidth',1,'LineStyle',':');
plot([110 110 150 150],[0 30 30 0],'k','LineWidth',1);%veridical/rotation
plot([150 190],[0 0],'k','LineWidth',1,'LineStyle',':');%no feedback
plot([95 95],[0 35],'k','LineWidth',0.7,'LineStyle',':');
text(13,33,'tDCS','FontSize',LabelSize,'color',[0 0 0],'FontName','Times New Roman');
set(gca,'XTick',0:20:180,'YLim',[-5 35],'XLim',[0 200],'YTick',-0:10:30,'fontsize',TickSize,'LineWidth',1.5,'FontName','Times New Roman');
ylabel('Angle(deg)','fontsize',LabelSize);
xlabel('Cycle','fontsize',LabelSize);
box off;
ShamSubj=1:41;
AnodalSubj=1:41;
text(98,33,'After 24h','FontSize',LabelSize,'color',[0 0 0],'FontName','Times New Roman');

for session_i=1:8
    if session_i < 5
        base_i=1;
    else
        base_i=3;
    end
    if session_i==1
        x=1;
    else
        x=1+ sum(sessionNum(1:session_i-1));
    end
    
    Sham_sem=nanstd(squeeze(Sham_cycle_deba(base_i,ShamSubj,x:x+sessionNum(session_i)-1)))/(length(ShamSubj)^0.5);
    Anodal_sem=nanstd(squeeze(Anodal_cycle_deba(base_i,AnodalSubj,x:x+sessionNum(session_i)-1)))/(length(AnodalSubj)^0.5);
    Sham_mean=squeeze(mean(Sham_cycle_deba(base_i,ShamSubj,x:x+sessionNum(session_i)-1),2))';
    Anodal_mean=squeeze(mean(Anodal_cycle_deba(base_i,AnodalSubj,x:x+sessionNum(session_i)-1),2))';
    
    
    hshadow=fill([x:x+sessionNum(session_i)-1 flip(x:x+sessionNum(session_i)-1)],...
        [Sham_mean+Sham_sem flip(Sham_mean-Sham_sem)],...
        [0.5 0.5 0.5],'LineStyle','none');
    alpha(hshadow,0.4);
    h1=plot(x:x+sessionNum(session_i)-1,Sham_mean,'k','LineWidth',2);
    hshadow=fill([x:x+sessionNum(session_i)-1 flip(x:x+sessionNum(session_i)-1)],...
        [Anodal_mean+Anodal_sem flip(Anodal_mean-Anodal_sem)],...
        'r','LineStyle','none');
    alpha(hshadow,0.4);
    h2=plot(x:x+sessionNum(session_i)-1,Anodal_mean,'r','LineWidth',2);
end
%     box off;

plot([16 24],[-1 -1],'k','LineWidth',5);
text(18,-2.5,'1','fontsize',LabelSize-2,'FontName','Times New Roman');
plot([46 55],[-1 -1],'k','LineWidth',5);
text(48,-2.5,'2','fontsize',LabelSize-2,'FontName','Times New Roman');
plot([86 95],[-1 -1],'k','LineWidth',5);
text(88,-2.5,'3','fontsize',LabelSize-2,'FontName','Times New Roman');
plot([111 119],[-1 -1],'k','LineWidth',5);
text(113,-2.5,'4','fontsize',LabelSize-2,'FontName','Times New Roman');
plot([141 150],[-1 -1],'k','LineWidth',5);
text(143,-2.5,'5','fontsize',LabelSize-2,'FontName','Times New Roman');
plot([181 190],[-1 -1],'k','LineWidth',5);
text(183,-2.5,'6','fontsize',LabelSize-2,'FontName','Times New Roman');

legend([h2,h1],{'Anodal','Sham'},'fontsize',20,'Location','northeast');
legend boxoff;
%% stats
ShamSubj = 1:41;
AnodalSubj = 1:41;
longSession = [3 4 5 7 8];
for session_i = 5%longSession
    if session_i==1
        x=1;
    else
        x=1+ sum(sessionNum(1:session_i-1));
    end
    if session_i>5
        base_i  = 3;
    else
        base_i = 1;
    end
    if session_i ~= 5
        tempSData1 = mean(Sham_cycle_deba(base_i,ShamSubj,x:x+8),3);
        tempAData1 = mean(Anodal_cycle_deba(base_i,AnodalSubj,x:x+8),3);
        tempSData2 = mean(Sham_cycle_deba(base_i,ShamSubj,x+sessionNum(session_i)-10:x+sessionNum(session_i)-1),3);
        tempAData2 = mean(Anodal_cycle_deba(base_i,AnodalSubj,x+sessionNum(session_i)-10:x+sessionNum(session_i)-1),3);
    else
        tempSData1 = squeeze(Sham_cycle_deba(base_i,ShamSubj,x));
        tempAData1 = squeeze(Anodal_cycle_deba(base_i,AnodalSubj,x));
    end
    Sham_char(session_i,1) = nanmean(tempSData1);
    Sham_char(session_i,2) = nanstd(tempSData1);
    Anodal_char(session_i,1) = nanmean(tempAData1);
    Anodal_char(session_i,2) = nanstd(tempAData1);
    [h(session_i,1),p(session_i,1),~,stats(session_i,1)] = ttest2(tempSData1,tempAData1);
    [bfresult(session_i,1),pbf(session_i,1)] = bf.ttest2(tempSData1,tempAData1);
    if session_i ~= 5
        Sham_char(session_i,3) = nanmean(tempSData2);
        Sham_char(session_i,4) = nanstd(tempSData2);
        Anodal_char(session_i,3) = nanmean(tempAData2);
        Anodal_char(session_i,4) = nanstd(tempAData2);
        [h(session_i,2),p(session_i,2),~,stats(session_i,2)] = ttest2(tempSData2,tempAData2);
        [bfresult(session_i,2),pbf(session_i,2)] = bf.ttest2(tempSData2,tempAData2);
    end
end

%% cycle compare: with subject
ShamSubj = 1:41;
AnodalSubj = 1:41;
base_i = 3;
Sham_curve = squeeze(Sham_cycle_deba(base_i,ShamSubj,:));
Anodal_curve = squeeze(Anodal_cycle_deba(base_i,AnodalSubj,:));

for cycle_i = 1:40
    Sham_ifrotplateau(cycle_i) = ttest(Sham_curve(:,110+cycle_i),Sham_curve(:,110+cycle_i+1));
    Anodal_ifrotplateau(cycle_i) = ttest(Anodal_curve(:,110+cycle_i),Anodal_curve(:,110+cycle_i+1));
end


%% decay rate: bootstrap
options = optimset('MaxIter',100);
for session_i = [4 8]
    for strp_i=1:1000
        subj_re = randsample(1:41,20);
        tempData = squeeze(nanmean(Sham_cycle_deba(1,subj_re,xv(session_i):xv(session_i)+sessionNum(session_i)-1),2));
        %     plot(Rete_re,'k');hold on;
        initi_params = [0.9 tempData(1)/2];
        [paramsEach,resnorm,resid] = lsqcurvefit(@Lfunc_decay,initi_params,find(~isnan(tempData)),tempData(~isnan(tempData)),[],[],options);
        ShamR2_temp=corrcoef(tempData,Lfunc_decay(paramsEach,1:40));
        ShamR2(strp_i)=ShamR2_temp(1,2).^2;
        Sham_decayparam(strp_i,:) = paramsEach(1);
    end
    Sham_decaypam_sort = sort(Sham_decayparam);
    CI_Sham(session_i,:) = [Sham_decaypam_sort(25) Sham_decaypam_sort(975)];
    for strp_i=1:1000
        subj_re = randsample(1:41,20);
        tempData = squeeze(nanmean(Anodal_cycle_deba(1,subj_re,xv(session_i):xv(session_i)+sessionNum(session_i)-1),2));
        initi_params = [0.9 tempData(1)/2];
        options = optimset('MaxIter',100);
        [paramsEach,resnorm,resid] = lsqcurvefit(@Lfunc_decay,initi_params,find(~isnan(tempData)),tempData(~isnan(tempData)),[],[],options);
        AnodalR2_temp=corrcoef(tempData,Lfunc_decay(paramsEach,1:40));
        AnodalR2(strp_i)=AnodalR2_temp(1,2).^2;
        Anodal_decayparam(strp_i,:)=paramsEach(1);
    end;
    Anodal_decaypam_sort = sort(Anodal_decayparam);
    CI_Anodal(session_i,:) = [Anodal_decaypam_sort(25) Anodal_decaypam_sort(975)];
end
bf.ttest2(Anodal_decayparam,Sham_decayparam)
histogram(Sham_decayparam,'BinWidth',0.001);hold on
histogram(Anodal_decayparam,'BinWidth',0.001);hold on
%% reaction time figure

Svector = Sham_cycle_RT(1:41,:);
Avector = Anodal_cycle_RT(1:41,:);
x_plot={'initial learning','decay','relearning','decay2'};
y_plot='Reaction time';
Svector(Svector>2) = nan;
Avector(Avector>2) = nan;
ShamSubj=1:41;
AnodalSubj=1:41;

nanmean(nanmean(Avector(:,96:end),2))
nanstd(nanmean(Avector(:,96:end),2))
nanmean(nanmean(Svector(:,96:end),2))
nanstd(nanmean(Svector(:,96:end),2))
[h p ci stats] = ttest2(nanmean(Avector(:,96:end),2),nanmean(Svector(:,96:end),2))
bf.ttest2(nanmean(Svector(:,96:end),2),nanmean(Avector(:,96:end),2))

nanmean(nanmean(Avector(:,111:119),2)-nanmean(Avector(:,106:110),2))
nanstd(nanmean(Avector(:,111:119),2)-nanmean(Avector(:,106:110),2))
nanmean(nanmean(Svector(:,111:119),2)-nanmean(Svector(:,106:110),2))
nanstd(nanmean(Svector(:,111:119),2)-nanmean(Svector(:,106:110),2))
[h p ci stats] = ttest2(nanmean(Avector(:,111:119),2)-nanmean(Avector(:,101:110),2),nanmean(Svector(:,111:119),2)-nanmean(Svector(:,101:110),2))
bf.ttest2(nanmean(Avector(:,111:119),2)-nanmean(Avector(:,101:110),2),nanmean(Svector(:,111:119),2)-nanmean(Svector(:,101:110),2))

figure('Position',[1 1 400 270]);
LabelSize = 14;
TickSize = 12;
hold on;% yyaxis left
for session_i = 5:8
    if session_i==1
        x=1;
    else
        x=1+ sum(sessionNum(1:session_i-1));
        
    end
    Sham_sem = nanstd(Svector(:,xv(session_i):xv(session_i)+sessionNum(session_i)-1),1)/(length(ShamSubj)^0.5);
    Anodal_sem = nanstd(Avector(:,xv(session_i):xv(session_i)+sessionNum(session_i)-1),1)/(length(AnodalSubj)^0.5);
    Sham_mean = nanmean(Svector(:,xv(session_i):xv(session_i)+sessionNum(session_i)-1),1);
    Anodal_mean = nanmean(Avector(:,xv(session_i):xv(session_i)+sessionNum(session_i)-1),1);
    
    hshadow = fill([x:x+sessionNum(session_i)-1 flip(x:x+sessionNum(session_i)-1)],...
        [Sham_mean+Sham_sem flip(Sham_mean-Sham_sem)],...
        [0.5 0.5 0.5],'LineStyle','none');
    alpha(hshadow,0.4);
    h1=plot(x:x+sessionNum(session_i)-1,Sham_mean,'k','LineWidth',2);
    hshadow=fill([x:x+sessionNum(session_i)-1 flip(x:x+sessionNum(session_i)-1)],...
        [Anodal_mean+Anodal_sem flip(Anodal_mean-Anodal_sem)],...
        'r','LineStyle','none');
    alpha(hshadow,0.4);
    h2=plot(x:x+sessionNum(session_i)-1,Anodal_mean,'r','LineWidth',2);
    
end

set(gca,'fontsize',TickSize,'LineWidth',1,'FontName','Times New Roman');
ylabel('Reaction Time (s)','fontsize',LabelSize);
xlabel('Cycle','fontsize',LabelSize);
box off;
legend([h2,h1],{'Anodal','Sham'},'fontsize',LabelSize,'Location','best');
legend boxoff;
figure('Position',[1 1 400 270]);
hold on;
% yyaxis left
for session_i = 5:8
    if session_i==1
        x=1;
    else
        x=1+ sum(sessionNum(1:session_i-1));
        
    end
    Sham_sem = nanstd(Svector(:,xv(session_i):xv(session_i)+sessionNum(session_i)-1),1)/(length(ShamSubj)^0.5);
    Anodal_sem = nanstd(Avector(:,xv(session_i):xv(session_i)+sessionNum(session_i)-1),1)/(length(AnodalSubj)^0.5);
    Sham_mean = nanmean(Svector(:,xv(session_i):xv(session_i)+sessionNum(session_i)-1),1)-nanmean(Svector(:,101:110),'All');
    Anodal_mean = nanmean(Avector(:,xv(session_i):xv(session_i)+sessionNum(session_i)-1),1)-nanmean(Avector(:,101:110),'All');
    
    hshadow = fill([x:x+sessionNum(session_i)-1 flip(x:x+sessionNum(session_i)-1)],...
        [Sham_mean+Sham_sem flip(Sham_mean-Sham_sem)],...
        [0.5 0.5 0.5],'LineStyle','none');
    alpha(hshadow,0.4);
    h1=plot(x:x+sessionNum(session_i)-1,Sham_mean,'k','LineWidth',2);
    hshadow=fill([x:x+sessionNum(session_i)-1 flip(x:x+sessionNum(session_i)-1)],...
        [Anodal_mean+Anodal_sem flip(Anodal_mean-Anodal_sem)],...
        'r','LineStyle','none');
    alpha(hshadow,0.4);
    h2=plot(x:x+sessionNum(session_i)-1,Anodal_mean,'r','LineWidth',2);
    
end

set(gca ,'fontsize',TickSize,'LineWidth',1,'FontName','Times New Roman');
ylabel('¦¤Reaction Time (s)','fontsize',LabelSize);
xlabel('Cycle','fontsize',LabelSize);
box off;
legend([h2,h1],{'Anodal','Sham'},'fontsize',LabelSize,'Location','best');
legend boxoff;
