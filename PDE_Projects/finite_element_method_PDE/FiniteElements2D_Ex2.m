% Geometry Definition and Parameters

g = [2 2 2 2 2 2 2 2
    -0.5 0.5 0.5 -0.5 -2.5 2.5 2.5 -2.5
    0.5 0.5 -0.5 -0.5 2.5 2.5 -2.5 -2.5
    1 1 2 2 0 0 3 3
    1 2 2 1 0 3 3 0 
    1 1 1 1 1 1 1 1
    0 0 0 0 0 0 0 0];

rho = 1.0;
resolutions = [0.05,0.1,0.2];

for h = resolutions
    [p,e,t] = initmesh(g,'Hmax',h);
    A = StiffnessAssembler2D(p,t,inline('1','x','y'));
    [R,r] = RobinAssembler2D(p,e,@Kappa1,@gD1,@gN1);
    phi = (A+R)\r;

    [phix,phiy] = pdegrad(p,t,phi);
    neg_grad = [-phix' -phiy'];
    v_mag = -sqrt(neg_grad(:,1).^2 + neg_grad(:,2).^2);
    P = max(v_mag(:)).^2 / 2 * rho - (1/2) * rho * v_mag.^2;

    plot_mesh(p, e, t, h);
    
    vel_pot_plot(g,p,t,phi,h);
    
    vel_field_plot(g,neg_grad,p,e,t,h);
    
    bern_press_plot(g,p,t,P,h);
end

% Initial and Boundary Conditions

function z = Kappa1(x,y)
    z=0;
end

function z = gD1(x,y)
    z=0;
end

function z = gN1(x,y) % modified to respect directions in problem
    z=0;
    if (x<-2.49)
        z=1; 
    end
   if (x>2.49)
        z=-1; 
    end
end

% Finite Element Method Functions

function A = StiffnessAssembler2D(p,t,a)
    np = size(p,2);
    nt = size(t,2);
    A = sparse(np,np);
    for K = 1:nt
        loc2glb = t(1:3,K);
        x = p(1,loc2glb); 
        y = p(2,loc2glb);
        [area,b,c] = HatGradients(x,y);
        xc = mean(x); yc = mean(y); 
        abar = a(xc,yc); 
        AK = abar*(b*b'+c*c')*area; 
        A(loc2glb,loc2glb) = A(loc2glb,loc2glb)+ AK; 
    end
end

function R = RobinMassMatrix2D(p,e,kappa)
    np = size(p,2);
    ne = size(e,2);
    R = sparse(np,np);
    for E = 1:ne
        loc2glb = e(1:2,E);
        x = p(1,loc2glb);
        y = p(2,loc2glb);
        len= sqrt((x(1)-x(2))^2+(y(1)-y(2))^2);
        xc = mean(x); 
        yc = mean(y);
        k = kappa(xc,yc);
        RE = k/6*[2 1; 1 2]*len;
        R(loc2glb,loc2glb) = R(loc2glb,loc2glb) + RE;
    end
end

function r = RobinLoadVector2D(p,e,kappa,gD,gN)
    np = size(p,2);
    ne = size(e,2);
    r = zeros(np,1);
    for E = 1:ne
        loc2glb = e(1:2,E);
        x = p(1,loc2glb);
        y = p(2,loc2glb);
        len = sqrt((x(1)-x(2))^2+(y(1)-y(2))^2);
        xc = mean(x); yc = mean(y);
        tmp = kappa(xc,yc)*gD(xc,yc)+gN(xc,yc);
        rE = tmp*[1; 1]*len/2;
        r(loc2glb) = r(loc2glb) + rE;
    end
end

function [R,r] = RobinAssembler2D(p,e,kappa,gD,gN)
    R = RobinMassMatrix2D(p,e,kappa);
    r = RobinLoadVector2D(p,e,kappa,gD,gN);
end

function [area,b,c] = HatGradients(x,y)
    area=polyarea(x,y);
    b=[y(2)-y(3); y(3)-y(1); y(1)-y(2)]/2/area;
    c=[x(3)-x(2); x(1)-x(3); x(2)-x(1)]/2/area;
end

% Plot functions

function vel_pot_plot(g,p,t,phi,h)
    figure;
    hold on;
    pdegplot(g, 'EdgeLabels', 'off');
    pdecont(p,t,phi,40);
    colorbar;
    caxis([min(phi), max(phi)]);
    xlabel('x', Fontsize = 15);
    ylabel('y', Fontsize = 15);
    title(sprintf("Velocity Potential with h_K = %.2f",h));
    hold off;
end

function vel_field_plot(g,vector,p,e,t,h)
    figure;
    hold on;
    pdegplot(g, 'EdgeLabels', 'off');
    pdeplot(p,e,t,'flowdata',vector);
    xlabel('x', Fontsize = 15);
    ylabel('y', Fontsize = 15);
    title(sprintf("Velocity Field with h_K = %.2f",h));
    hold off;
end

function bern_press_plot(g,p,t,P,h)
    figure;
    hold on;
    pdegplot(g, 'EdgeLabels', 'off');
    pdecont(p, t, P, 20);
    colorbar;
    caxis([min(P), max(P)]);
    xlabel('x', 'FontSize', 15);
    ylabel('y', 'FontSize', 15);
    title(sprintf("Bernoulli Pressure Isocontours with h_K = %.2f",h));
    hold off;
end

function plot_mesh(p, e, t, h)
    figure;
    pdemesh(p, e, t);
    xlabel('x', 'FontSize', 15);
    ylabel('y', 'FontSize', 15);
    title(sprintf('Mesh with h_K = %.2f', h), 'FontSize', 15);
end