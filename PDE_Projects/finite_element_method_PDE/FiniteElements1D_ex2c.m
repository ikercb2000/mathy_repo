% Parameter selection

h = 0.001;
interval = [0,1];
kappa = [1.e6, 0];
gd = [0, 0];
gn = [0, -1];
AnltcSol = false;
PoissonSolver1D(h,interval,kappa,gn,gd,AnltcSol);

% Functions of the problem

function val = a(x)
    val = 1.;
end

function val = b(x)
    val = 1.;
end

function val = c(x)
    val = -2.;
end

function val = f(x)
    val = -x;
end

% Complementary functions for the solver

function A = StiffnessAssembler1D(x,a,b,c,kappa)
    n = length(x)-1;
    A = zeros(n+1,n+1);
    for i = 1:n
        h = x(i+1) - x(i);
        xmid = (x(i+1) + x(i))/2;
        amid = a(xmid);
        bmid = b(xmid);
        cmid = c(xmid);
        A(i,i) = A(i,i) + amid/h + bmid/2 + (cmid*h)/4;
        A(i,i+1) = A(i,i+1) - amid/h - bmid/2 - (cmid*h)/4;
        A(i+1,i) = A(i+1,i) - amid/h - bmid/2 - (cmid*h)/4;
        A(i+1,i+1) = A(i+1,i+1) + amid/h + bmid/2 + (cmid*h)/4;
    end
    A(1,1) = A(1,1) + kappa(1);
    A(n+1,n+1) = A(n+1,n+1) + kappa(2);
end

function b = LoadAssembler1D(x,f)
    n = length(x)-1;
    b = zeros(n+1,1);
    for i = 1:n
        h = x(i+1) - x(i);
        xmid = (x(i+1) + x(i))/2;
        fmid = f(xmid);
        b(i) = b(i) + (fmid*h)/ 2;
        b(i+1) = b(i+1) + (fmid*h)/ 2;
    end
end

function b = SourceAssembler1D(x,f,kappa,gd, gn)
    b = LoadAssembler1D(x,f);
    b(1) = b(1) + kappa(1)*gd(1) - gn(1);
    b(end) = b(end) + kappa(2)*gd(2) - gn(2);
end

% Numerical solver for the problem

function PoissonSolver1D(h,interval,kappa,gn,gd,AnltcSol)
    x = interval(1):h:interval(2);
    A = StiffnessAssembler1D(x, @a,@b,@c, kappa);
    b = SourceAssembler1D(x, @f, kappa, gd, gn);
    u = A\b;

    if AnltcSol
        u_exact = ExactSolution(x);
        error = max(abs(u - u_exact'));
        fprintf('Maximum error: %.6e\n', error);
    end

    % Plot the numerical and exact solutions
    figure;
    plot(x, u, '-', 'DisplayName', 'Numerical Solution');
    hold on;
    if AnltcSol
        plot(x, u_exact, '--', 'DisplayName', 'Exact Solution');
    end
    xlabel('x');
    ylabel('u(x)');
    title('Numerical vs Exact Solution');
    legend('show');
    grid on;
end
