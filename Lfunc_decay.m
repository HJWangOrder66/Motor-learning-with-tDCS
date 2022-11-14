function y = Lfunc_decay(params,x)
%LFUNC_DECAY describe passive decay of learning
%   params:1: a, retention factor, 2: y at step 1, aka y0
a = params(1);
y(1) = params(2);% y0
Expo = x-x(1);
y = y(1).*(a.^Expo);
end

