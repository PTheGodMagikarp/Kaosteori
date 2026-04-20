function Kaos
    % Definition of parameters
    beta = 47.73;    % mgd/I
    alpha = 7.971;   % kappa/I
    delta = 0.56;     % b/I
    gamma = 18.92;   % A/I
    theta0 = 0;      % Initial angular offset
    omega_yf = 6.053;  % Driving frequency (rad/s)

    % Time span for simulation
    tspan = [0 18000]; 

    % Set ODE solver options
    options = odeset('MaxStep', 0.01, 'RelTol', 1e-6, 'AbsTol', 1e-6);

    % Define initial condition for theta and omega
    initial_condition = [0.1, 0]; % Initial condition: [theta, omega]

    % Solve the system of ODEs
    x0 = [initial_condition(1); initial_condition(2); 0];
    [t, y] = ode45(@(t, x) pendulum_ode(t, x, gamma, delta, alpha, theta0, beta, omega_yf), tspan, x0, options);

    % Extract theta and omega 
    theta = y(:, 1); % Angular displacement
    omega = y(:, 2); % Angular velocity 

    % Calculate the driving force for the z-axis
    Z = gamma * cos(omega_yf * t);

    % 2D figure
    figure;
    set(gcf, 'Color', 'w');
    hold on;
    title('2D Phase Portrait of Torsion Pendulum', 'FontSize', 12);
    xlabel('\theta (rad)', 'FontSize', 12);
    ylabel('\omega (rad/s)', 'FontSize', 12);
    grid on;
    plot(theta, omega, 'b-', 'LineWidth', 1);
    hold off;

    % 3D figure
    figure;
    set(gcf, 'Color', 'w');
    hold on;
    title('3D Phase Portrait of Torsion Pendulum', 'FontSize', 12);
    xlabel('X (\theta)', 'FontSize', 12);
    ylabel('Y (\omega)', 'FontSize', 12);
    zlabel('Z (\gamma cos(\omega_{yf} t))', 'FontSize', 12);
    grid on;
    view(30, 45);
    plot3(theta, omega, Z, 'b-', 'LineWidth', 1);
    hold off;

    % Plotting angular frequency (omega) as a function of time
    figure;
    set(gcf, 'Color', 'w');
    hold on;
    title('Angular Frequency vs. Time', 'FontSize', 12);
    xlabel('Time (s)', 'FontSize', 12);
    ylabel('\omega (rad/s)', 'FontSize', 12);
    grid on;
    plot(t, omega, 'r-', 'LineWidth', 0.5);
    hold off;

    % Poincaré plot
    T = 2*pi/omega_yf; % Period of the driving force
    % Find indices where t is a multiple of T
    poincare_indices = find(mod(t, T) < 0.001| mod(t, T) > T-0.001);
  
    % Plot Poincaré section
    figure;
    set(gcf, 'Color', 'w');
    hold on;
    title('Poincaré Section of Torsion Pendulum', 'FontSize', 12);
    xlabel('\theta (rad)', 'FontSize', 12);
    ylabel('\omega (rad/s)', 'FontSize', 12);
    grid on;
    plot(theta(poincare_indices), omega(poincare_indices), 'ko', 'MarkerSize', 0.5, 'MarkerFaceColor', 'r');
    hold off;

    %% Power Spectral Density 

    % Define sampling frequency
    fs = 20; % (Hz)

    % Remove transient
    steady_idx = t >= 100 * T;
    uniform_dt = 1/fs; % Time step
    uniform_t = min(t(steady_idx)):uniform_dt:max(t(steady_idx));
    uniform_theta = interp1(t(steady_idx), theta(steady_idx), uniform_t, 'linear'); % Resample

    % Compute PSD
    window = hamming(128);        % Window size
    noverlap = 64;                % Overlap
    nfft = 1024;                  % FFT points
    [pxx, f] = pwelch(uniform_theta, window, noverlap, nfft, fs);

    % Plotting Power Spectral Density of theta
    figure;  
    set(gcf, 'Color', 'w');
    hold on;
    title('Power Spectral Density (Numerical)', 'FontSize', 12);
    xlabel('Frequency (Hz)', 'FontSize', 12);
    ylabel('Power/Frequency(dB/Hz)', 'FontSize', 12);
    grid on;
    plot(f, 10*log10(pxx), 'b-', 'LineWidth', 1);
    xlim([0 10]);                % Limit to 10 Hz
    xline(omega_yf/(2*pi), '--r', 'LineWidth', 1);
    hold off;
end

% Define the system of first-order ODEs
function dxdt = pendulum_ode(t, x, gamma, delta, alpha, theta0, beta, omega_yf)
    dxdt = zeros(3, 1);
    dxdt(1) = x(2); % d(theta)/dt = omega
    dxdt(2) = gamma * cos(omega_yf * t) - delta * x(2) - alpha * x(1) - theta0 + beta * sin(x(1));
    dxdt(3) = 1; % dt/dt = 1
end
