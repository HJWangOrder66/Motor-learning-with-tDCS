function y = Lfunc_learningCurve(params,x)
a = params(1);
b = params(2);
c = params(3);
y =a*exp(-(x)./b)+c;

% --- the learning curve
