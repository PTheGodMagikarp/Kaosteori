function torsion_pendulum_simulation

    % Definition of parameters 
    beta = 92.93;   % mgd/I (gravitational torque coefficient/moment of inertia)
    alpha = 16.66;  % kappa/I (torsional stiffness/moment of inertia)
    delta = 0.58;   % b/I (damping coefficient/moment of inertia)
    gamma = 9.672;    % A/I (driving amplitude/moment of inertia)
    theta0 = 0;     % Initial angular offset
    omega_yf = 7.2; % Driving frequency (rad/s)

    % Time span for simulation (start and end time)
    tspan = [0 10];

    % Set ODE solver options for smaller step size (more points)
    options = odeset('MaxStep', 0.01, 'RelTol', 1e-6, 'AbsTol', 1e-6);

    % Define a grid of initial conditions for theta and omega
    theta_range = linspace(-2, 2, 2); % 2 values for theta
    omega_range = linspace(-2, 2, 2); % 2 values for omega
    [theta_init, omega_init] = meshgrid(theta_range, omega_range);
    initial_conditions = [theta_init(:), omega_init(:)];

    % Initialize 2D figure
    figure;
    set(gcf, 'Color', 'w');
    hold on;
    title('2D Phase Portrait of Torsion Pendulum', 'FontSize', 12);
    xlabel('\theta (rad)', 'FontSize', 12);
    ylabel('\omega (rad/s)', 'FontSize', 12);
    grid on;
    axis tight;

    % Initialize 3D figure
    figure;
    set(gcf, 'Color', 'w');
    hold on;
    title('3D Phase Portrait of Torsion Pendulum', 'FontSize', 12);
    xlabel('\theta (rad)', 'FontSize', 12);
    ylabel('\omega (rad/s)', 'FontSize', 12);
    zlabel('Time (s)', 'FontSize', 12);
    grid on;
    view(45, 30); % Set a better 3D view angle

    % Define colormap for trajectories
    colors = parula(size(initial_conditions, 1));

    % Loop over the initial conditions
    for i = 1:size(initial_conditions, 1)
        % Initial conditions: [theta; omega; t]
        x0 = [initial_conditions(i, 1); initial_conditions(i, 2); 0];

        % Solve the system of ODEs
        [t, y] = ode45(@(t, x) pendulum_ode(t, x, gamma, delta, alpha, theta0, beta, omega_yf), tspan, x0, options);

        % Extract theta, omega, and time for plotting
        theta = y(:, 1); % Angular displacement
        omega = y(:, 2); % Angular velocity

        % Plot 2D phase portrait
        figure(1);
        plot(theta, omega, 'Color', colors(i, :), 'LineWidth', 1.0);

        % Plot 3D phase portrait
        figure(2);
        plot3(theta, omega, t, 'Color', colors(i, :), 'LineWidth', 1.0);
    end
    hold off;
end

% Define the system of first-order ODEs
function dxdt = pendulum_ode(t, x, gamma, delta, alpha, theta0, beta, omega_yf)
    dxdt = zeros(3, 1);
    dxdt(1) = x(2); % d(theta)/dt = omega
    dxdt(2) = gamma * cos(omega_yf * x(3)) - delta * x(2) - alpha * x(1) - theta0 + beta * sin(x(1)); % d(omega)/dt
    dxdt(3) = 1; % dt/dt = 1
end
