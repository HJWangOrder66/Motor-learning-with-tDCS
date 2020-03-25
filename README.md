# Motor-learning-with-tDCS
Experiment code: Gradual/ErrorClamp_tDCS_day1/2.m

SubjProcess.m: put subjects together

(For gradual: combine_gradual.m, for 2 groups of gradual have different washout length)

RelAngle.m: calculate angle relative to target, any anglar difference larger than 90° marked as outlier

Analyze: All_Analysis_GR/EC.m

Combined data file: GR_Anodal_All_27, GR_Sham_All_30, EC_Anodal_All_42, EC_Sham_All_41

Notice: raw data is not saved in these files due to INSUFFICIENT MEMORY. For gradual groups, raw data can be found in subsets of data: GR_subj12_a, GR_subj15_a, GR_subj13_s, GR_subj17_s. 

Notice: first 10 in EC sham & first 11 in EC anodal have experiment in 1 day, thus not included in ananlysis.

Other functions (called in experiment code): 

Lfunc_learningCurve: exponential function;
Lfunc_linReg: linear regression, here to calculate speed;
convert_reg, Lfunc_screenSet: convert screen display and tablet readings.
