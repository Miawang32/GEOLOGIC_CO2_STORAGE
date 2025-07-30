function [pmap, smap] = collect_states(states, steps)
pmap = [];
smap = [];
for step = steps
    pmap = [pmap, states{step}.pressure];
    smap = [smap, states{step}.s(:,2)];
end
end

