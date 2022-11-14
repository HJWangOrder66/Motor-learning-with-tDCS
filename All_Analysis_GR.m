%% average subjects plot
load('GR_Anodal_all_27');
load('GR_Sham_all_27');
figure('Position',[1 1 960 540]);
hold on;
LabelSize = 20;
TickSize = 16;
ShamSubj=1:27;
AnodalSubj=1:27;
sessionNum = [10 10 40 40 10 10 40 40];
for session_i=1:length(sessionNum)
    if session_i==1
        xv(session_i)=1;
    else
        xv(session_i)=1+ sum(sessionNum(1:session_i-1));
    end;
end;
% load baseTrialAve;
hold on;
h3=fill([10 60 60 10],[-10 -10 35 35],[1 0.9 0.9],'LineStyle','none');%tDCS
h4=plot([0 20 60 60],[0 0 30 0],'k','LineWidth',1);%veridical/rotation
h5=plot([60 100],[0 0],'k','LineWidth',1,'LineStyle',':');%no feedback
plot([100 120],[0 0],'k','LineWidth',1);
plot([120 120 160 160],[0 30 30 0],'k','LineWidth',1);%veridical/rotation
plot([160 200],[0 0],'k','LineWidth',1,'LineStyle',':');%no feedback

plot([100 100],[0 35],'k','LineWidth',0.7,'LineStyle',':');
text(103,33,'After 24h','FontSize',LabelSize,'color',[0 0 0],'FontName','Times New Roman');
text(13,33,'tDCS','FontSize',LabelSize,'color',[0 0 0],'FontName','Times New Roman');
set(gca,'XTick',0:20:200,'YLim',[-10 35],'XLim',[0 240],'YTick',-10:10:30,'fontsize',TickSize,'LineWidth',1.5,'FontName','Times New Roman');
ylabel('Angle(deg)','fontsize',LabelSize);
xlabel('Cycle','fontsize',LabelSize);
box off;
for session_i= 1:8
    if session_i==1
        x=1;
    else
        x=1+ sum(sessionNum(1:session_i-1));
        
    end
    if session_i < 5
        base_i = 2;
    else
        base_i = 4;
    end
    
    Sham_sem=nanstd(squeeze(Sham_cycle_deba(base_i,ShamSubj,x:x+sessionNum(session_i)-1)))/(length(ShamSubj)^0.5);
    Anodal_sem=nanstd(squeeze(Anodal_cycle_deba(base_i,AnodalSubj,x:x+sessionNum(session_i)-1)))/(length(AnodalSubj)^0.5);
    Sham_mean=squeeze(-mean(Sham_cycle_deba(base_i,ShamSubj,x:x+sessionNum(session_i)-1),2))';
    Anodal_mean=squeeze(-mean(Anodal_cycle_deba(base_i,AnodalSubj,x:x+sessionNum(session_i)-1),2))';
    
    tempx = x:x+sessionNum(session_i)-1;
    
    hshadow=fill([tempx flip(tempx)],...
        [Sham_mean+Sham_sem flip(Sham_mean-Sham_sem)],...
        [0.5 0.5 0.5],'LineStyle','none');
    alpha(hshadow,0.4);
    h1=plot(tempx,Sham_mean,'k','LineWidth',2);
    hshadow=fill([tempx flip(tempx)],...
        [Anodal_mean+Anodal_sem flip(Anodal_mean-Anodal_sem)],...
        'r','LineStyle','none');
    alpha(hshadow,0.4);
    h2=plot(tempx,Anodal_mean,'r','LineWidth',2);
    
end

plot([51 60],[-2 -2],'k','LineWidth',5);
text(53,-4,'1','fontsize',LabelSize-2,'FontName','Times New Roman');
plot([91 100],[-2 -2],'k','LineWidth',5);
text(93,-4,'2','fontsize',LabelSize-2,'FontName','Times New Roman');
plot([121 129],[-2 -2],'k','LineWidth',5);
text(123,-4,'3','fontsize',LabelSize-2,'FontName','Times New Roman');
plot([151 160],[-2 -2],'k','LineWidth',5);
text(153,-4,'4','fontsize',LabelSize-2,'FontName','Times New Roman');
plot([191 200],[-2 -2],'k','LineWidth',5);
text(193,-4,'5','fontsize',LabelSize-2,'FontName','Times New Roman');
legend([h2,h1],{'Anodal','Sham'},'fontsize',LabelSize,'Location','northeast');
legend boxoff;

%% stats
ShamSubj=1:27;
AnodalSubj=1:27;
longSession = [3 4 7 8];
for session_i = 8%longSession
    if session_i==1
        x=1;
    else
        x=1+ sum(sessionNum(1:session_i-1));
    end
    if session_i <= 5
        base_i = 2;
    else
        base_i = 4;
    end
    if session_i ~= 5 && session_i ~= 4 %%% cycle1
        tempSData1 = mean(Sham_cycle_deba(base_i,ShamSubj,x:x+8),3);
        tempAData1 = mean(Anodal_cycle_deba(base_i,AnodalSubj,x:x+8),3);
    else
        tempSData1 = squeeze(Sham_cycle_deba(base_i,ShamSubj,x));
        tempAData1 = squeeze(Anodal_cycle_deba(base_i,AnodalSubj,x));
    end
    if session_i ~= 5
        tempSData2 = mean(Sham_cycle_deba(base_i,ShamSubj,x+sessionNum(session_i)-10:x+sessionNum(session_i)-1),3);
        tempAData2 = mean(Anodal_cycle_deba(base_i,AnodalSubj,x+sessionNum(session_i)-10:x+sessionNum(session_i)-1),3);
        
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
%% decay rate, bootstrap
for session_i = [4 8]
    for group_i = 1:2
        if group_i == 1
            tempDataAll = squeeze(Sham_cycle_deba(2,:,xv(session_i):xv(session_i)+sessionNum(session_i)-1));
        elseif group_i == 2
            tempDataAll = squeeze(Anodal_cycle_deba(2,:,xv(session_i):xv(session_i)+sessionNum(session_i)-1));
        else
            tempDataAll = squeeze(Cathodal_cycle_deba(2,:,xv(session_i):xv(session_i)+sessionNum(session_i)-1));
        end
        for strp_i = 1:1000
            subj_re = randsample(1:size(tempDataAll,1),round(size(tempDataAll,1)/2));
            tempData = nanmean(tempDataAll(subj_re,:));
            %     plot(Rete_re,'k');hold on;
            initi_params = [0.9 tempData(1)/2];
            options = optimset('MaxIter',100);
            [paramsEach,resnorm,resid] = lsqcurvefit(@Lfunc_decay,initi_params,find(~isnan(tempData)),tempData(~isnan(tempData)),[],[],options);
            decayparam_strp(group_i,strp_i) = paramsEach(1);
        end
        %         histogram(decayparam_strp);
        decayparam_strp_sort = sort(decayparam_strp,2);
        CI_GR{session_i} = [decayparam_strp_sort(:,25) decayparam_strp_sort(:,975)];
    end
    
end
bf.ttest2(decayparam_strp(1,:),decayparam_strp(2,:))
histogram(decayparam_strp(1,:)); hold on;
histogram(decayparam_strp(2,:)); hold on;

%% learning rate: trial by trial
for group_i = 1:2
    figure(group_i);
    if group_i ==1
        tempCurve = -squeeze(Anodal_cycle_deba(1,:,:));
    else
        tempCurve = -squeeze(Sham_cycle_deba(1,:,:));
    end
    for learning_i = 1
        if learning_i == 1
            tempLearningtrial = 21:60;
            
            tempPertur = 0.75:0.75:30;
        end
        for subj_i = 1:27
            %             tempDecayData = tempCurve(subj_i,tempDecaytrial);
            tempLearningData = tempCurve(subj_i, tempLearningtrial);
            subplot(4,7,subj_i);
            
            yyaxis left;
            plot(diff(tempLearningData));
            yyaxis right
            plot(tempPertur(1:end-1)-tempLearningData(1:end-1));
            title(mean(diff(tempLearningData))/mean(tempPertur(1:end-1)-tempLearningData(1:end-1)));
            LR(group_i,subj_i) = mean(diff(tempLearningData))/mean(tempPertur(1:end-1)-tempLearningData(1:end-1));
        end
    end
end
LR(LR<0) = nan;
nanmean(LR,2)
nanstd(LR,0,2)
[h p ci stats] = ttest2(LR(1,:),LR(2,:))
bf.ttest2(LR(1,:),LR(2,:))
%% reaction time compare, sham vs anodal
ShamSubj=1:27;
AnodalSubj=1:27;

Svector = Sham_cycle_RT;
Avector = Anodal_cycle_RT;
x_plot={'initial learning','decay','relearning','decay2'};
y_plot='Reaction time';
Svector(Svector>2) = nan;
Avector(Avector>2) = nan;
%%% day1 RT
nanmean(nanmean(Avector(:,1:100),2))
nanstd(nanmean(Avector(:,1:100),2))
nanmean(nanmean(Svector(:,1:100),2))
nanstd(nanmean(Svector(:,1:100),2))
[h p ci stats] = ttest2(nanmean(Avector(:,1:100),2),nanmean(Svector(:,1:100),2))
bf.ttest2(nanmean(Svector(:,1:100),2),nanmean(Avector(:,1:100),2))
%%% day2 RT
nanmean(nanmean(Avector(:,121:end),2))
nanstd(nanmean(Avector(:,121:end),2))
nanmean(nanmean(Svector(:,121:end),2))
nanstd(nanmean(Svector(:,121:end),2))
[h p ci stats] = ttest2(nanmean(Avector(:,121:end),2),nanmean(Svector(:,121:end),2))
bf.ttest2(nanmean(Svector(:,121:end),2),nanmean(Avector(:,121:end),2));

tempSDeltaRT = nanmean(Svector(ShamSubj,121:129),2)-nanmean(Svector(ShamSubj,116:120),2);
tempADeltaRT = nanmean(Avector(ShamSubj,121:129),2)-nanmean(Avector(ShamSubj,116:120),2);
nanmean(tempSDeltaRT)
nanstd(tempSDeltaRT)
nanmean(tempADeltaRT)
nanstd(tempADeltaRT)

[h p ci stats] = ttest2(nanmean(Svector(ShamSubj,121:129),2)-nanmean(Svector(ShamSubj,116:120),2),nanmean(Avector(ShamSubj,121:129),2)-nanmean(Avector(ShamSubj,116:120),2))
bf.ttest2(nanmean(Svector(ShamSubj,121:129),2)-nanmean(Svector(ShamSubj,116:120),2),nanmean(Avector(ShamSubj,121:129),2)-nanmean(Avector(ShamSubj,116:120),2))
figure('Position',[1 1 400 270]);
LabelSize = 14;
TickSize = 12;
hold on;% yyaxis left
% yyaxis left
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

set(gca, 'fontsize',TickSize,'LineWidth',1,'FontName','Times New Roman');
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
    Sham_mean = nanmean(Svector(:,xv(session_i):xv(session_i)+sessionNum(session_i)-1),1)-nanmean(Svector(:,116:120),'All');
    Anodal_mean = nanmean(Avector(:,xv(session_i):xv(session_i)+sessionNum(session_i)-1),1)-nanmean(Avector(:,116:120),'All');
    
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
ylabel('¦¤Reaction Time (s)','fontsize',LabelSize);
xlabel('Cycle','fontsize',LabelSize);
box off;
legend([h2,h1],{'Anodal','Sham'},'fontsize',LabelSize,'Location','best');
legend boxoff;


