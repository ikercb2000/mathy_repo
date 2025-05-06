% Parameters for the algorithm
L = 1;     
T = 0.1;    
k = 2;              
dx = 0.05;       
dt = dx^2/(2 * k); 
Nx = round(L/dx);
Nt = round(T/dt);

fprintf('Nx = %.4f, Nt = %.4f\n', Nx, Nt);
fprintf('dx = %.4f, dt = %.4f\n', dx, dt);

% Position of nodes and u(x,t) matrix
x = linspace(0, L, Nx);
t = linspace(0, T, Nt+1);
u = zeros(Nx, Nt+1);

% Initial and boundary conditions
u(:, 1) = -sin(3 * pi * x) + (1/4) * sin(6 * pi * x);
u(1, :) = 0;
u(end, :) = 0;

% Finite difference schema

for n = 1:Nt
    for i = 2:Nx-1
        u(i, n+1) = u(i, n) + k * dt / dx^2 * (u(i+1, n) - 2 * u(i, n) + u(i-1, n));
    end
    
    if mod(n, 40) == 0 % Prints the table every 40 iterations
        
        analytical_solution = -sin(3 * pi * x) * exp(-k * (3 * pi)^2 * t(n)) + ...
                              (1/4) * sin(6 * pi * x) * exp(-k * (6 * pi)^2 * t(n));
        
        error = abs(u(:, n) - analytical_solution');
        max_error = max(error);

        fprintf('\nIteration %d (t = %.4f)\n', n, t(n));
        fprintf('%-6s %-20s %-20s %-20s\n', 'Point', 'Estimated U(x,t)', 'Analytical U(x,t)', 'Error');
        fprintf('--------------------------------------------------------------\n');
        
        % Prints each row in the table
        for i = 1:Nx
            fprintf('%-6d %-20.5f %-20.5f %-20.5f\n', i, u(i, n), analytical_solution(i), error(i));
        end
    end
end

% Plots the solution surface
figure;
surf(x, t, u');
colormap('jet');
xlabel('Space');
ylabel('Time');
zlabel('Temperature');
title('Solution of the Heat Equation');
