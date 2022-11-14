%% average subjects plot
% clear all;
load('EC_subj10_s_4');
load('EC_subj14_a_4');
load('EC_subj14_c_4');
targetDeg = [45 135 225 315];
blockNum=[30 10 80 80];
sessionNum=[30 10 80 80];

trialNum=4;
for session_i=1:length(sessionNum)
    if session_i==1
        xv(session_i)=1;
    else
        xv(session_i)=1+ sum(sessionNum(1:session_i-1));
    end
end
% set(gcf,'outerposition',get(0,'screensize'));
colorArray={'b','c','g','k','b','k','b','r','k','b'};
Slow=0.3;
        figure('Position',[1 1 960 540]);
        hold on;
LabelSize = 20;
TickSize = 16;
% load baseTrialAve;
hold on;
h4=fill([30 120 120 30],[-10 -10 35 35],[0.9 0.9 0.9],'LineStyle','none');%tDCS
h5=plot([0 30],[0 0],'k','LineWidth',1);%veridical/rotation
h6=plot([40 40 120 120],[0 4 4 0],'k','LineWidth',1,'LineStyle',':');%veridical/rotation
h7=plot([120 200],[0 0],'k','LineWidth',1,'LineStyle',':');%no feedback

text(33,33,'tDCS','FontSize',LabelSize,'color',[0 0 0],'FontName','Times New Roman');
set(gca,'XTick',0:20:200,'YLim',[-10 35],'XLim',[0 240],'YTick',-0:10:30,'fontsize',TickSize,'LineWidth',1,'FontName','Times New Roman');
ylabel('Angle(deg)','fontsize',LabelSize);
xlabel('Cycle','fontsize',LabelSize);
box off;
Svector = squeeze(Sham_cycle_deba(2,:,:));
Avector = squeeze(Anodal_cycle_deba(2,:,:));
Cvector = squeeze(Cathodal_cycle_deba(2,:,:));

for session_i=1:4
    figure(1);
    if session_i==1
        x=1;
    else
        x=1+ sum(sessionNum(1:session_i-1));
    end;
    Sham_sem=nanstd(Svector(:,x:x+sessionNum(session_i)-1),1)/(size(Svector,1)^0.5);
    hshadow=fill([x:x+sessionNum(session_i)-1 flip(x:x+sessionNum(session_i)-1)],...
        [nanmean(Svector(:,x:x+sessionNum(session_i)-1),1)+Sham_sem flip(nanmean(Svector(:,x:x+sessionNum(session_i)-1),1)-Sham_sem)],...
        [0.5 0.5 0.5],'LineStyle','none');
    alpha(hshadow,0.4);
    h1=plot(x:x+sessionNum(session_i)-1,nanmean(Svector(:,x:x+sessionNum(session_i)-1),1),'k','LineWidth',2);
    hold on;
    Anodal_sem=nanstd(Avector(:,x:x+sessionNum(session_i)-1),1)/(14^0.5);
    hshadow=fill([x:x+sessionNum(session_i)-1 flip(x:x+sessionNum(session_i)-1)],...
        [nanmean(Avector(:,x:x+sessionNum(session_i)-1),1)+Anodal_sem flip(nanmean(Avector(:,x:x+sessionNum(session_i)-1),1)-Anodal_sem)],...
        'r','LineStyle','none');
    alpha(hshadow,0.4);
    h2=plot(x:x+sessionNum(session_i)-1,nanmean(Avector(:,x:x+sessionNum(session_i)-1),1),'r','LineWidth',2);
    %
    Cathodal_sem=nanstd(Cvector(:,x:x+sessionNum(session_i)-1),1)/(14^0.5);
    hshadow=fill([x:x+sessionNum(session_i)-1 flip(x:x+sessionNum(session_i)-1)],...
        [nanmean(Cvector(:,x:x+sessionNum(session_i)-1),1)+Anodal_sem flip(nanmean(Cvector(:,x:x+sessionNum(session_i)-1),1)-Cathodal_sem)],...
        'b','LineStyle','none');
    alpha(hshadow,0.4);
    h3=plot(x:x+sessionNum(session_i)-1,nanmean(Cvector(:,x:x+sessionNum(session_i)-1),1),'b','LineWidth',2);
    
end;
% title(ECtitle,'FontSize',20);
box off;
plot([41 49],[-4 -4],'k','LineWidth',5);
text(44,-6,'1','fontsize',LabelSize-2,'FontName','Times New Roman');
plot([111 120],[-4 -4],'k','LineWidth',5);
text(114,-6,'2','fontsize',LabelSize-2,'FontName','Times New Roman');
plot([191 200],[-4 -4],'k','LineWidth',5);
text(194,-6,'3','fontsize',LabelSize-2,'FontName','Times New Roman');
legend([h2,h3,h1],{'Anodal','Cathodal','Sham'},'fontsize',LabelSize);
legend boxoff;

%% stats: anova
for session_i = 3%[3 4]
    if session_i==1
        x=1;
    else
        x=1+ sum(sessionNum(1:session_i-1));
    end
    
    tempSData1 = mean(Sham_cycle_deba(2,:,x:x+8),3);
    tempAData1 = mean(Anodal_cycle_deba(2,:,x:x+8),3);
    tempCData1 = mean(Cathodal_cycle_deba(2,:,x:x+8),3);
    tempSData2 = mean(Sham_cycle_deba(2,:,x+sessionNum(session_i)-10:x+sessionNum(session_i)-1),3);
    tempAData2 = mean(Anodal_cycle_deba(2,:,x+sessionNum(session_i)-10:x+sessionNum(session_i)-1),3);
    tempCData2 = mean(Cathodal_cycle_deba(2,:,x+sessionNum(session_i)-10:x+sessionNum(session_i)-1),3);
    
    Sham_char(session_i,1) = nanmean(tempSData1);
    Sham_char(session_i,2) = nanstd(tempSData1);
    Sham_char(session_i,3) = nanmean(tempSData2);
    Sham_char(session_i,4) = nanstd(tempSData2);
    Anodal_char(session_i,1) = nanmean(tempAData1);
    Anodal_char(session_i,2) = nanstd(tempAData1);
    Anodal_char(session_i,3) = nanmean(tempAData2);
    Anodal_char(session_i,4) = nanstd(tempAData2);
    Cathodal_char(session_i,1) = nanmean(tempCData1);
    Cathodal_char(session_i,2) = nanstd(tempCData1);
    Cathodal_char(session_i,3) = nanmean(tempCData2);
    Cathodal_char(session_i,4) = nanstd(tempCData2);
    %                 [h(session_i,1),p(session_i,1),~,stats(session_i,1)] = ttest2(tempSData1,tempAData1);
    %                 [h(session_i,2),p(session_i,2),~,stats(session_i,2)] = ttest2(tempSData2,tempAData2);
    [tempp1, temptbl1, stats] = anova1([tempSData1 tempAData1 tempCData1],[ones(size(tempSData1)) 2*ones(size(tempAData1)) 3*ones(size(tempCData1))]);
    [tempp2, temptbl2, stats] = anova1([tempSData2 tempAData2 tempCData2],[ones(size(tempSData2)) 2*ones(size(tempAData2)) 3*ones(size(tempCData2))]);
group = [ones(size(tempSData1)) 2*ones(size(tempAData1)) 3*ones(size(tempCData1))]';
subj = (1:length(group))';
% modelFull = fitlme(datatbl,'data~group')
    data1 = [tempSData1 tempAData1 tempCData1]';
datatbl1 = table(data1,group,subj);
    data2 = [tempSData2 tempAData2 tempCData2]';
datatbl2 = table(data2,group,subj);
bfactor(session_i,1) = bf.anova(datatbl1,'data1~group');
bfactor(session_i,2) = bf.anova(datatbl2,'data2~group');

    p_char(session_i,1) = tempp1;
    p_char(session_i,2) = tempp2;
    f_char(session_i,1) = temptbl1{2,5};
    f_char(session_i,2) = temptbl2{2,5};
end
% data = [tempSData1 tempAData1 tempCData1]';
% group = [ones(size(tempSData1)) 2*ones(size(tempAData1)) 3*ones(size(tempCData1))]';
% subj = (1:length(data))';
% modelFull = fitlme(datatbl,'data~group')
% datatbl = table(data,group,subj);
% bf.anova(datatbl,'data~group')
%% decay bootstrap
for session_i = 4
    for group_i = 1:3
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
        CI_small = [decayparam_strp_sort(:,25) decayparam_strp_sort(:,975)];
    end
end

