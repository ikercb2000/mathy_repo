% Parameters for the algorithm
Lx = 1;
Ly = 1;
dx = 0.05;
dy = 0.05;
Nx = round(Lx / dx) + 1;
Ny = round(Ly / dy) + 1;

fprintf('Nx = %.4f, Ny = %.4f\n', Nx, Ny);
fprintf('dx = %.4f, dy = %.4f\n', dx, dy);

% Position of nodes and u(x,y)
u = zeros(Ny, Nx);
x = linspace(0, Lx, Nx);
y = linspace(0, Ly, Ny);

% Boundary conditions
u(:, 1) = sin(3 * pi * x);   
u(:, end) = sin(pi * x);     
u(1, :) = 0;                 
u(end, :) = 0;              

% Parameters for Gauss-Seidel
maxIter = 100000;
tol = 1e-8;       

% Gauss-Seidel iteration with finite differences schema
for iter = 1:maxIter
    maxError = 0;
    
    for i = 2:Ny-1
        for j = 2:Nx-1
            old_u = u(i, j);
            u(i, j) = 0.25 * (u(i+1, j) + u(i-1, j) + u(i, j+1) + u(i, j-1));
            maxError = max(maxError, abs(u(i, j) - old_u));
        end
    end

    if maxError < tol
        fprintf('Convergence achieved at iteration %d with max error: %.8f\n', iter, maxError);
        break;
    end
    
    % Print error table every 100 iterations
    if mod(iter, 100) == 0
       
        analytical_solution = sin(3 * pi * x') * cos(pi * y);
        error = abs(u - analytical_solution);
        max_error = max(error(:));
        
        fprintf('\nIteration %d\n', iter);
        fprintf('%-6s %-20s %-20s %-20s\n', 'Point', 'Estimated U(x,y)', 'Analytical U(x,y)', 'Error');
        fprintf('--------------------------------------------------------------\n');
        
        total_points = numel(u);
        selected_indices = round(linspace(1, total_points, 20));

        % Print the error for selected points
        for k = 1:length(selected_indices)
            idx = selected_indices(k);
            [i, j] = ind2sub(size(u), idx);
            fprintf('%-6d %-20.5f %-20.5f %-20.5f\n', idx, u(i, j), analytical_solution(i, j), error(i, j));
        end
        fprintf('Max error at iteration %d: %.8f\n\n', iter, max_error);
    end
end

if iter == maxIter
    disp('Maximum number of iterations reached without convergence.');
end

% Plot the solution
[X, Y] = meshgrid(x, y);
figure;
surf(X, Y, u);
colormap('jet');
xlabel('x');
ylabel('y');
zlabel('Potential');
title('Solution of the Laplace Equation using Gauss-Seidel');
