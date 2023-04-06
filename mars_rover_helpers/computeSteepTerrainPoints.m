function [terrain_points_obs,fx,fy]...
                        = computeSteepTerrainPoints(xg,yg,z_heights,maxSlopeAng)

% Function to compute all the terrain points above a threshold inclination angle.

% Copyright 2022-2023 The MathWorks, Inc

[Xg, Yg] = ndgrid(xg, yg);
terrain_points = [Xg(:) Yg(:) z_heights(:)];

[fx,fy] = gradient(z_heights,xg(2)-xg(1),yg(2)-yg(1));
fxnew = fx(:);
fynew = fy(:);

for i = 1:length(fxnew)
    N(i) = norm([fxnew(i),fynew(i)]);
end

idx = atand(N) > maxSlopeAng;

terrain_points_obs = [terrain_points(idx,1),...
                      terrain_points(idx,2),...
                      terrain_points(idx,3)];
end