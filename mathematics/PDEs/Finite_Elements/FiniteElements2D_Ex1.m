% Parameters

H_geom = [2 2 2 2 2 2 2 2 2 2 2 2
    0 0 0 1 1 2 2 3 2 2 1 1
    1 0 1 1 2 2 3 3 3 2 2 1
    0 0 3 2 2 2 3 0 0 0 1 0
    0 3 3 3 2 3 3 3 0 1 1 1
    1 1 1 1 1 1 1 1 1 1 1 1
    0 0 0 0 0 0 0 0 0 0 0 0
    ];

resolutions = [0.075, 0.1, 0.25, 0.5];

% Mesh printing and Projection

for i = resolutions
    [p, e, t] = initmesh(H_geom, 'hmax', i);
    figure;
    pdemesh(p, e, t);
    title(sprintf('Mesh with h_K = %.2f', i));
    L2Projector2D(p,t,i);
end

% Function to project

function res = Func(x,y)
    res = sin(x*y);
end

% Functions for projections

function M = MassAssembler2D(p,t)
    np = size(p,2);
    nt = size(t,2);
    M = sparse(np,np);
    for K = 1:nt
        loc2glb = t(1:3,K);
        x = p(1,loc2glb);
        y = p(2,loc2glb);
        area = polyarea(x,y);
        MK = [2 1 1;
        1 2 1;
        1 1 2]/12*area;
        M(loc2glb,loc2glb) = M(loc2glb,loc2glb) ... 
            + MK;
    end
end

function b = LoadAssembler2D(p,t,f)
    np = size(p,2);
    nt = size(t,2);
    b = zeros(np,1);
    for K = 1:nt
        loc2glb = t(1:3,K);
        x = p(1,loc2glb);
        y = p(2,loc2glb);
        area = polyarea(x,y);
        bK = [f(x(1),y(1));
        f(x(2),y(2));
        f(x(3),y(3))]/3*area;
        b(loc2glb) = b(loc2glb) ...
        + bK;
    end
end

function L2Projector2D(p,t,h)
    M = MassAssembler2D(p,t);
    b = LoadAssembler2D(p,t,@Func);
    Pf = M\b;

    % Function surface
    figure;
    trisurf(t(1:3, :)', p(1, :)', p(2, :)', Pf, 'EdgeColor', 'k', 'FaceColor', 'interp');
    colormap(jet);
    colorbar;
    xlabel('x');
    ylabel('y');
    zlabel('Pf(x,y)');
    title(sprintf('L_2 Projection with h_K = %.2f', h));

    % Error surface
    f_values = arrayfun(@Func, p(1, :), p(2, :));
    error = abs(f_values - Pf');                 
    figure;
    trisurf(t(1:3, :)', p(1, :)', p(2, :)', error, 'EdgeColor', 'k', 'FaceColor', 'interp');
    colormap(jet);
    colorbar;
    xlabel('x');
    ylabel('y');
    zlabel('|f(x,y)-Pf(x,y)|');
    title(sprintf('L_2 Projection Error with h_K = %.2f', h));
end