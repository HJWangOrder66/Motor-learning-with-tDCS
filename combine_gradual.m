%% put 2 sets of GR subjects together, since they have different washout
% notice: rawdata is not stored in combined data file due to lack of RAM
%% put anodal together
clear all;
endDataa=nan(12+15,1920,4);
IfOutliera=nan(12+15,1920);
MoveTimea=nan(12+15,1920);
peakDataa=nan(12+15,1920,6);
% rawDataa=nan(12+15,1920,800,7);
RTa=nan(12+15,1920);
TimePeaka=nan(12+15,1920);
trialInfoa=nan(12+15,1920,8);

load('GR_subj12_a.mat');
expInfo1=expInfo.subj_name;

endDataa(1:12,1:880,:)=endData(:,1:880,:);
IfOutliera(1:12,1:880)=IfOutlier(1:12,1:880);
MoveTimea(1:12,1:880)=MoveTime(1:12,1:880);
peakDataa(1:12,1:880,:)=peakData(1:12,1:880,:);
% rawDataa(1:12,1:880,:,:)=rawData(1:12,1:880,:,:);
RTa(1:12,1:880)=RT(1:12,1:880);
TimePeaka(1:12,1:880)=TimePeak(1:12,1:880);
trialInfoa(1:12,1:880,:)=trialInfo(1:12,1:880,:);

endDataa(1:12,961:1840,:)=endData(:,881:1760,:);
IfOutliera(1:12,961:1840)=IfOutlier(1:12,881:1760);
MoveTimea(1:12,961:1840)=MoveTime(1:12,881:1760);
peakDataa(1:12,961:1840,:)=peakData(1:12,881:1760,:);
% rawDataa(1:12,961:1840,:,:)=rawData(1:12,881:1760,:,:);
RTa(1:12,961:1840)=RT(1:12,881:1760);
TimePeaka(1:12,961:1840)=TimePeak(1:12,881:1760);
trialInfoa(1:12,961:1840,:)=trialInfo(1:12,881:1760,:);

load('GR_subj15_a.mat');
expInfo2=expInfo.subj_name;

endDataa(13:27,:,:)=endData(:,:,:);
IfOutliera(13:27,:)=IfOutlier(:,:);
MoveTimea(13:27,:)=MoveTime(:,:);
peakDataa(13:27,:,:)=peakData(:,:,:);
% rawDataa(13:27,:,:,:)=rawData(:,:,:,:);
RTa(13:27,:)=RT(:,:);
TimePeaka(13:27,:)=TimePeak(:,:);
trialInfoa(13:27,:,:)=trialInfo(:,:,:);

expInfo.subj_name=[expInfo1 expInfo2];
endData=endDataa;
IfOutlier=IfOutliera;
MoveTime=MoveTimea;
peakData=peakDataa;
% rawData=rawDataa;
RT=RTa;
TimePeak=TimePeaka;
trialInfo=trialInfoa;

save GR_Anodal_all_27 IfOutlier peakData endData trialInfo expInfo MoveTime RT TimePeak

%% put sham together
clear all;
endDataa=nan(13+17,1920,4);
IfOutliera=nan(13+17,1920);
MoveTimea=nan(13+17,1920);
peakDataa=nan(13+17,1920,6);
% rawDataa=nan(13+17,1920,800,7);
RTa=nan(13+17,1920);
TimePeaka=nan(13+17,1920);
trialInfoa=nan(13+17,1920,8);

load('GR_subj13_s');
expInfo1=expInfo.subj_name;
endDataa(1:13,1:880,:)=endData(:,1:880,:);
IfOutliera(1:13,1:880)=IfOutlier(1:13,1:880);
MoveTimea(1:13,1:880)=MoveTime(1:13,1:880);
peakDataa(1:13,1:880,:)=peakData(1:13,1:880,:);
% rawDataa(1:13,1:880,:,:)=rawData(1:13,1:880,:,:);
RTa(1:13,1:880)=RT(1:13,1:880);
TimePeaka(1:13,1:880)=TimePeak(1:13,1:880);
trialInfoa(1:13,1:880,:)=trialInfo(1:13,1:880,:);

endDataa(1:13,961:1840,:)=endData(:,881:1760,:);
IfOutliera(1:13,961:1840)=IfOutlier(1:13,881:1760);
MoveTimea(1:13,961:1840)=MoveTime(1:13,881:1760);
peakDataa(1:13,961:1840,:)=peakData(1:13,881:1760,:);
% rawDataa(1:13,961:1840,:,:)=rawData(1:13,881:1760,:,:);
RTa(1:13,961:1840)=RT(1:13,881:1760);
TimePeaka(1:13,961:1840)=TimePeak(1:13,881:1760);
trialInfoa(1:13,961:1840,:)=trialInfo(1:13,881:1760,:);

load('GR_subj17_s');
expInfo2=expInfo.subj_name;
endDataa(14:end,:,:)=endData(:,:,:);
IfOutliera(14:end,:)=IfOutlier(:,:);
MoveTimea(14:end,:)=MoveTime(:,:);
peakDataa(14:end,:,:)=peakData(:,:,:);
% rawDataa(14:end,:,:)=rawData(:,:,:);
RTa(14:end,:)=RT(:,:);
TimePeaka(14:end,:)=TimePeak(:,:);
trialInfoa(14:end,:,:)=trialInfo(:,:,:);

expInfo.subj_name=[expInfo1 expInfo2];
endData=endDataa;
IfOutlier=IfOutliera;
MoveTime=MoveTimea;
peakData=peakDataa;
% rawData=rawDataa;
RT=RTa;
TimePeak=TimePeaka;
trialInfo=trialInfoa;


save GR_Sham_all_30 IfOutlier peakData endData trialInfo expInfo MoveTime RT TimePeak

