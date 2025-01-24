% Define functions and parameters
f1 = @(x) 1 + 2*x;
f2 = @(x) x.^3 .* (x - 1) .* (1 - 2*x);
f3_eps1 = @(x) atan((x - 0.5) / 0.1);
f3_eps2 = @(x) atan((x - 0.5) / 0.01);

interval = [-1, 1];
n_values = [25,100];

% Combinations

for n = n_values
    fprintf('-------------------------------------------------------------\n')
    L2Projector1D(f1, interval, n, 'f1');
    L2Projector1D(f2, interval, n, 'f2');
    L2Projector1D(f3_eps1, interval, n, 'f3_eps1');
    L2Projector1D(f3_eps2, interval, n, 'f3_eps2');
end
fprintf('-------------------------------------------------------------\n')

% Definition of functions

function M = MassAssembler1D(x)
    n = length(x)-1;
    M = zeros(n+1,n+1);
    for i = 1:n
        h = x(i+1) - x(i);
        M(i,i) = M(i,i) + h/3;
        M(i,i+1) = M(i,i+1) + h/6;
        M(i+1,i) = M(i+1,i) + h/6;
        M(i+1,i+1) = M(i+1,i+1) + h/3;
    end
end

function b = LoadAssembler1D(x,f)
    n = length(x)-1;
    b = zeros(n+1,1);
    for i = 1:n
        h = x(i+1) - x(i);
        b(i) = b(i) + f(x(i))*h/2;
        b(i+1) = b(i+1) + f(x(i+1))*h/2;
    end
end

function L2Projector1D(f,interval,n, func_name)
    h = 1/n;
    x = interval(1):h:interval(2);
    M = MassAssembler1D(x);
    b = LoadAssembler1D(x,f);
    Pf = M\b;
    % plot L2 projection and real function
    figure; 
    plot(x, Pf, '--', 'LineWidth', 2, 'DisplayName', 'L^2 Projection');
    hold on;
    f_values = arrayfun(f, x);
    plot(x, f_values, '-', 'Color', [0.6 0.6 0.6], 'LineWidth', 1, 'DisplayName', 'Real Function');
    legend();
    title(sprintf('L^2 Projection with n = %d', n));
    xlabel('x');
    ylabel('Value');
    grid on;
    hold off;
    f_values = arrayfun(f, x);
    error_estimate = sqrt(sum((Pf - f_values').^2));
    fprintf('Error estimate for %s with %d subintervals: %e\n', func_name, n, error_estimate);
end