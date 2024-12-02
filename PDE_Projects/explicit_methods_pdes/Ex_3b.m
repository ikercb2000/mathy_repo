% Parameters

lx = 2;
ly = 1;
hx = 0.01;
hy = 0.01;
ndx = lx / hx;
ndy = ly / hy;
t = 0.0;
ht = 0.0000001;
tf = 1;
nsteps = tf / ht;
n1 = round(nsteps / 3.0);
n2 = round(2 * nsteps / 3.0);
rho = ht / (hx * hy);
nx = ndx + 1;
ny = ndy + 1;
nix = ndx - 1;
niy = ndy - 1;
xmin = 0.0;
xmax = lx;
ymin = 0.0;
ymax = ly;

fprintf('nsteps, n1, n2 = %d, %d, %d\n', nsteps, n1, n2)

% Position of the nodes
x = linspace(xmin, xmax, nx);
y = linspace(ymin, ymax, ny);

% Initial and boundary conditions
u = zeros(ny, nx);
for i = 1:ny
    for j = 1:nx
        u(i, j) = uinit(x(j), y(i));
    end
end

for i = 1:ny
    u(i, 1) = ux0(y(i), t);
    u(i, nx) = uxmax(y(i), t);
end
for j = 1:nx
    u(1, j) = uy0(x(j), t);
end

% Initial 3D Surface Plot at t = 0
[X, Y] = meshgrid(x, y);
figure;
surf(X, Y, u, 'EdgeColor', 'none');
colormap('jet');
shading interp;
xlabel('x')
ylabel('y')
zlabel('Temperature')
title('3D Surface Plot of Initial Condition u(x, y, 0)')
colorbar;

% Finite differences schema
step = 0;

while (t <= tf)

    unew = zeros(ny, nx);

    for i = 2:niy
        for j = 2:nix
            unew(i, j) = (1 - 4 * rho) * u(i, j) + ...
                rho * (u(i-1, j) + u(i+1, j) + u(i, j-1) + u(i, j+1));
        end
    end

    t = t + ht;
    u = unew;
    
    for i = 1:ny
        u(i, 1) = ux0(y(i), t);
        u(i, nx) = uxmax(y(i), t);
    end
    for j = 1:nx
        u(1, j) = uy0(x(j), t);
        u(ny, j) = u(ny-1, j);
    end
    
    step = step + 1;

    % Compute and display error every 1000 iterations
    if mod(step, 1000) == 0
        analytical_solution = zeros(ny, nx);
        for i = 1:ny
            for j = 1:nx
                analytical_solution(i, j) = Temp(x(j), y(i), t); % Exact solution at time t
            end
        end
        
        error = abs(u - analytical_solution);
        max_error = max(max(error));

        % Select 20 evenly spaced indices across all grid points
        total_points = numel(u);
        selected_indices = round(linspace(1, total_points, 20));

        fprintf('\nIteration %d (t = %.4f)\n', step, t);
        fprintf('%-6s %-20s %-20s %-20s\n', 'Point', 'Estimated U(x,y,t)', 'Analytical U(x,y,t)', 'Error');
        fprintf('--------------------------------------------------------------\n');

        % Print the error for selected points in the grid
        for k = 1:length(selected_indices)
            idx = selected_indices(k);
            [i, j] = ind2sub(size(u), idx);
            fprintf('%-6d %-20.5f %-20.5f %-20.5f\n', idx, u(i, j), analytical_solution(i, j), error(i, j));
        end
        fprintf('Max error at iteration %d: %.5f\n\n', step, max_error);
    end

    % 3D Surface Plot at specific time steps
    if step == n1 || step == n2 || t >= tf
        figure;
        surf(X, Y, u, 'EdgeColor', 'none');
        colormap('jet');
        shading interp;
        xlabel('x')
        ylabel('y')
        zlabel('Temperature')
        title(['3D Surface Plot of u(x, y, t) at t = ', num2str(t)])
        colorbar;
    end
end

% Final 3D surface plot
figure;
surf(X, Y, u, 'EdgeColor', 'none');
colormap('jet');
shading interp;
xlabel('x')
ylabel('y')
zlabel('Temperature')
title(['Final 3D Surface Plot of u(x, y, t) at t = ', num2str(t)])
colorbar;

% Complementary functions

function s = uinit(~, ~)
    s = 100;
end

function s = uy0(~, ~)
    s = 0.0;
end

function s = ux0(~, ~)
    s = 0.0;
end

function s = uxmax(~, ~)
    s = 0.0;
end

function s = Temp(x, y, t)
    s = 100 * sin(pi * x / 2) * sin(pi * y) * exp(-((pi / 2)^2 + (pi)^2) * t);
end

