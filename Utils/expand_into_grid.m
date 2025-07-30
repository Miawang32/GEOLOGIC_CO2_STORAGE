function perm = expand_into_grid(perm_all, interval, nx, ny, nz)
% interval = 20;
zone_index_x = 0:interval(1):nx;
zone_index_y = 0:interval(2):ny;
zone_index_z = 0:interval(3):nz;

Nn = 1;
perm = ones(nx,ny,nz);
for Ii = zone_index_x(2:end)
    for Jj = zone_index_y(2:end)
        for Kk = zone_index_z(2:end)
            Ii_index = Ii-interval(1):Ii;
            Jj_index = Jj-interval(2):Jj;
            Kk_index = Kk-interval(3):Kk;
            perm(Ii_index(2:end), Jj_index(2:end), Kk_index(2:end)) = perm_all(Nn);
            Nn = Nn + 1;
        end
    end
end
perm = reshape(perm,nx*ny*nz, []);
perm(:,2) = perm(:,1);
perm(:,3) = perm(:,1)*0.1;
end