function [P_well, Qs_well, Qr_well] = collect_welldata(wellSols, steps)
p   = getWellOutput(wellSols, 'bhp');
qs  = getWellOutput(wellSols, 'qGs');
qr  = getWellOutput(wellSols, 'qGr');

P_well = p(steps,:);
Qs_well = abs(qs(steps,:));
Qr_well = abs(qr(steps,:));

end

