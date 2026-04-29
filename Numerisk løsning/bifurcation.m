
function bifurcation

 % Defining the parameters
 beta = 67.73;    % mgd/I
 alpha = 5.971;   % kappa/I
 delta = 0.36;     % b/I
 gamma = 18.92;   % A/I
 theta0 = 0;      % Initial angular offset

 % Range for driving frequency
 omega_yf_min = 2.5;
 omega_yf_max = 9.0;
 omega_yf_step = 0.05;
 omega_yf_values = omega_yf_min:omega_yf_step:omega_yf_max;

 % Define timespan
 tspan = [0 1000];

 % ODE solver 
 options = odeset('MaxStep', 0.01, 'RelTol', 1e-6, 'AbsTol', 1e-6);

 % Initial condition
 initial_condition = [0.1; 0];

 % Store Poincaré points
 poincare_points = cell(length(omega_yf_values), 1);

 % Loop over omega_yf values
 for i = 1:length(omega_yf_values)
     omega_yf = omega_yf_values(i);

 % Solve the system of ODEs
 x0 = [initial_condition(1); initial_condition(2); 0];
 [t, y] = ode45(@(t, x) pendulum_ode(t, x, gamma, delta, alpha, theta0, beta, omega_yf), tspan, x0, options);
 
 % Extract theta and omega
 theta = y(:, 1);
 omega = y(:, 2);

 % Discard transient
 T = 2*pi/omega_yf;
 steady = t >= 500 * T;

 % Extract steady-state data
 t_s = t(steady);
 theta_s = theta(steady);
 omega_s = omega(steady);

 % Calculate Poincaré points for steady-state data
 poincare_indices = find(mod(t_s, T) < 0.001 | mod(t_s, T) > T-0.001);
 poincare_points{i} = [theta_s(poincare_indices), omega_s(poincare_indices)];

 % New initial condition
 initial_condition = [theta_s(end); omega_s(end)];
 end

 % Plot bifurcation
 figure;
 set(gcf, 'Color', 'w');
 hold on;
 title('Bifurcation Diagram for Torsion Pendulum', 'FontSize', 12);
 xlabel('\omega_{yf} (rad/s)', 'FontSize', 12);
 ylabel('\omega (rad/s)', 'FontSize', 12);
 grid on;

 % Plot Poincaré points for each omega_yf
 for i = 1:length(omega_yf_values)
     if ~isempty(poincare_points{i})
         builtin('plot',omega_yf_values(i) * ones(size(poincare_points{i}, 1), 1), ...
              poincare_points{i}(:, 1), 'k.', 'MarkerSize', 2);
     end
 end
 hold off;

end

% Define the system of first-order ODEs
function dxdt = pendulum_ode(t, x, gamma, delta, alpha, theta0, beta, omega_yf)
    dxdt = zeros(3, 1);
    dxdt(1) = x(2); % d(theta)/dt = omega
    dxdt(2) = gamma * cos(omega_yf * t) - delta * x(2) - alpha * x(1) - theta0 + beta * sin(x(1));
    dxdt(3) = 1; % dt/dt = 1
end
