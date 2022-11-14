# Motor-learning-with-tDCS
Experiment code: Gradual/ErrorClamp_tDCS_day1/2.m

SubjProcess.m: put subjects together

RelAngle.m: calculate angle relative to target, any anglar difference larger than 90° marked as outlier

Analyze: All_Analysis_GR/EC.m

Combined data file: GR_Anodal_All_27, GR_Sham_All_27, EC_Anodal_All_41, EC_Sham_All_41, EC_subj10_s_4, EC_subj14_a_4, EC_subj14_c_4

Notice: raw data is not saved in these files due to INSUFFICIENT MEMORY. 

Other functions (called in experiment code): 

Lfunc_learningCurve: exponential function;
Lfunc_linReg: linear regression, here to calculate speed;
convert_reg, Lfunc_screenSet: convert screen display and tablet readings.
Lfunc_decay: expen
