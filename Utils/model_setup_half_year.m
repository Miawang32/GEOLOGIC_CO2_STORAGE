%% Basic 3D simulation of a two-phase water and gas system
% This example shows the creation of a simple 3D grid (not VE) in mrst from
% scratch and basic usage of the the TwoPhaseWaterGasModel for modelling a
% CO2-H2O system. CO2 is injected into an intially brine filled reservoir
% from an injection well at the bottom of the reservoir. We model two years
% of injection and two years post injection. CO2 properties are taken from 
% co2lab's tabulated co2props() function.

%% Load modules
mrstModule add co2lab ad-core ad-props ad-blackoil mrst-gui;

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

rock.poro = poro; % repmat(0.25, G.cells.num, 1);
rock.perm = perm; % repmat(250*milli*darcy, G.cells.num, 1);
rock.perm(:,2) = rock.perm(:,1);
rock.perm(:,3) = 0.1*rock.perm(:,1);

%% Initial state
gravity on; % tell MRST to turn on gravity
g = gravity; % get the gravity vector
rhow = 1000; % density of brine 
initState.pressure = rhow * g(3) * G.cells.centroids(:,3); % initial pressure
initState.s = repmat([1, 0], G.cells.num, 1); % initial saturations
initState.sGmax = initState.s(:,2); % initial max. gas saturation (hysteresis)

%% Fluid model
co2     = CO2props(); % load sampled tables of co2 fluid properties
p_ref   = 15 * mega * Pascal; % choose reference pressure
t_ref   = 70 + 273.15; % choose reference temperature, in Kelvin
rhoc    = co2.rho(p_ref, t_ref); % co2 density at ref. press/temp
cf_co2  = co2.rhoDP(p_ref, t_ref) / rhoc; % co2 compressibility
cf_wat  = 0; % brine compressibility (zero)
cf_rock = 4.35e-5 / barsa; % rock compressibility
muw     = 8e-4 * Pascal * second; % brine viscosity
muco2   = co2.mu(p_ref, t_ref) * Pascal * second; % co2 viscosity

mrstModule add ad-props; % The module where initSimpleADIFluid is found

% Use function 'initSimpleADIFluid' to make a simple fluid object
fluid = initSimpleADIFluid('phases', 'WG'           , ...
                           'mu'  , [muw, muco2]     , ...
                           'rho' , [rhow, rhoc]     , ...
                           'pRef', p_ref            , ...
                           'c'   , [cf_wat, cf_co2] , ...
                           'cR'  , cf_rock          , ...
                           'n'   , [2 2]);

% Change relperm curves
srw = 0.27;
src = 0.20;
fluid.krW = @(s) fluid.krW(max((s-srw)./(1-srw), 0));
fluid.krG = @(s) fluid.krG(max((s-src)./(1-src), 0));

% Add capillary pressure curve
pe = 5 * kilo * Pascal;
pcWG = @(sw) pe * sw.^(-1/2);
fluid.pcWG = @(sg) pcWG(max((1-sg-srw)./(1-srw), 1e-5)); %@@


%% Wells

% Well cell indices in 'global' grid: 48, 48, 6:10
% wc_global = false(G.cartDims);
% center_ix = ceil(l_res/2);

% wc_global(center_ix, center_ix, z_res) = true; % bottom center cell
% wc = find(wc_global(G.cells.indexMap));

% Start with empty set of wells
W = [];
wc = []; 

for Ii =1:numel(Inj_I)
    % Well cell indices
    wi = sub2ind([l_res, l_res, z_res], ...
        Inj_I(Ii), Inj_J(Ii), z_res);
    wc = [wc; wi];
    
    % Calculate the injection rate
    inj_rate = Inj_RATE(Ii) * mega * 1e3 / year / fluid.rhoGS;
    
    % Add a well to the set
    W = addWell(W, G, rock, wi, ...
                'refDepth', G.cells.centroids(wi, 3), ... % BHP reference depth
                'type', 'rate', ...  % inject at constant rate
                'val', inj_rate, ... % volumetric injection rate
                'comp_i', [0 1]);    % inject CO2, not water
end

% plot well cells
figure()
plotGrid(G, 'facecolor', 'none', 'edgealpha', 0.1);
plotGrid(G, wc, 'facecolor', 'red');


%% Boundary conditions

% Start with an empty set of boundary faces
bc = [];

% identify all vertical faces
vface_ind = (G.faces.normals(:,3) == 0);

% identify all boundary faces (having only one cell neighbor
bface_ind = (prod(G.faces.neighbors, 2) == 0);

% identify all lateral boundary faces
bc_face_ix = find(vface_ind & bface_ind);

% identify cells neighbouring lateral boundary baces
bc_cell_ix = sum(G.faces.neighbors(bc_face_ix,:), 2);

% lateral boundary face pressure equals pressure of corresponding cell
p_face_pressure = initState.pressure(bc_cell_ix); 

% Add hydrostatic pressure conditions to open boundary faces
bc = addBC(bc, bc_face_ix, 'pressure', p_face_pressure, 'sat', [1, 0]);

%% Schedule

% Setting up two copies of the well and boundary specifications. 
% Modifying the well in the second copy to have a zero flow rate.
schedule.control    = struct('W', W, 'bc', bc);
schedule.control(2) = struct('W', W, 'bc', bc);

for Ii = 1:numel(Inj_I) 
    schedule.control(2).W(Ii).val = 0;
end

dT = rampupTimesteps(4*year,year/12,2);  % two years injection with increasing timestep size

schedule.step.val = [dT; ... 
                    repmat(year/4, 8, 1)];     % two years post injection

% Specifying which control to use for each timestep.
schedule.step.control = [ones(numel(dT), 1); ones(8,1)*2];
steps = [];
days = schedule.step.val/3600/24; 

for Ii = 0:12                        
ind_step = find(cumsum(days)/180 >= Ii);
steps = [steps, ind_step(1)];
end

%% Model
model = TwoPhaseWaterGasModel(G, rock, fluid, 0, 0);

%%
% <html>
% <p><font size="-1">
% Copyright 2009-2022 SINTEF Digital, Mathematics & Cybernetics.
% </font></p>
% <p><font size="-1">
% This file is part of The MATLAB Reservoir Simulation Toolbox (MRST).
% </font></p>
% <p><font size="-1">
% MRST is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% </font></p>
% <p><font size="-1">
% MRST is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% </font></p>
% <p><font size="-1">
% You should have received a copy of the GNU General Public License
% along with MRST.  If not, see
% <a href="http://www.gnu.org/licenses/">http://www.gnu.org/licenses</a>.
% </font></p>
% </html>


