%% Grid and rock
depth = 1500; % depth of aquifer top surface
H = 100;      % full thickness of aquifer
L = 3100;     % horizontal extent 

zcoord = linspace(0, 1, z_res+1).^1.5 * 100; % thinner cells towards the top
dL = linspace(0, 1, ceil(l_res/2)+1).^1.5; % narrower cells towards well
lcoord = [-fliplr(dL(2:end)), dL(2:end)] * L;

G = tensorGrid(lcoord, lcoord, zcoord, ...
               'depthz', repmat(depth, 1, (l_res+1) * (l_res+1)));
G = computeGeometry(G);