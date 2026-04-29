function Kaos
    
 % Definition of parameters
 beta = 47.73;    % mgd/I
 alpha = 7.971;   % kappa/I
 delta = 0.56;     % b/I
 gamma = 18.92;   % A/I
 theta0 = 0;      % Initial angular offset
 omega_yf = 6.053;  % Driving frequency (rad/s)

 % Time span
 tspan = [0 20000]; 

 % Set ODE solver options
 options = odeset('MaxStep', 0.01, 'RelTol', 1e-6, 'AbsTol', 1e-6);

 % Define initial condition
 initial_condition = [0.1, 0]; % [theta, omega]

 % Solve the system of ODEs
 x0 = [initial_condition(1); initial_condition(2); 0];
 [t, y] = ode45(@(t, x) pendulum_ode(t, x, gamma, delta, alpha, theta0, beta, omega_yf), tspan, x0, options);

 % Extract theta and omega 
 theta = y(:, 1); % Angular displacement
 omega = y(:, 2); % Angular velocity 

 % Calculate the driving force
 Z = gamma * cos(omega_yf * t);

 % Define steady-state
 T = 2*pi/omega_yf; % Period of the driving force
 steady = t >= 500 * T; 

 % Extract steady-state data
 time_s = t(steady);
 theta_s = theta(steady);
 omega_s = omega(steady);
 Zs = Z(steady);

%% Plots

 % 2D figure
 figure;
 set(gcf, 'Color', 'w');
 hold on;
 title('2D Phase Portrait of Torsion Pendulum', 'FontSize', 12);
 xlabel('\theta (rad)', 'FontSize', 12);
 ylabel('\omega (rad/s)', 'FontSize', 12);
 grid on;
 plot(theta_s, omega_s, 'b-', 'LineWidth', 1);
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
 plot3(theta_s, omega_s, Zs, 'b-', 'LineWidth', 1);
 hold off;

 % Angular frequency as a function of time
 figure;
 set(gcf, 'Color', 'w');
 hold on;
 title('Angular Frequency vs. Time', 'FontSize', 12);
 xlabel('Time (s)', 'FontSize', 12);
 ylabel('\omega (rad/s)', 'FontSize', 12);
 grid on;
 plot(time_s, omega_s, 'r-', 'LineWidth', 0.5);
 hold off;

 % Poincaré plot
 poincare_i = find(mod(time_s, T) < 0.001| mod(time_s, T) > T-0.001);
  
 % Plot Poincaré section
 figure;
 set(gcf, 'Color', 'w');
 hold on;
 title('Poincaré Section of Torsion Pendulum', 'FontSize', 12);
 xlabel('\theta (rad)', 'FontSize', 12);
 ylabel('\omega (rad/s)', 'FontSize', 12);
 grid on;
 plot(theta_s(poincare_i), omega_s(poincare_i), 'ko', 'MarkerSize', 0.5, 'MarkerFaceColor', 'r');
 hold off;

%% Power Spectral Density 

 % Define sampling frequency
 fs = 20; % (Hz)
 uniform_dt = 1/fs;
 uniform_t = min(time_s):uniform_dt:max(time_s);
 uniform_theta = interp1(time_s, theta_s, uniform_t, 'linear'); % Resample

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
 xlim([0 10]); % Limit to 10 Hz
 xline(omega_yf/(2*pi), '--r', 'LineWidth', 1);
 hold off;

 %% Box counting

 % Normalize theta and omega
 theta_n = (theta_s - min(theta_s)) / (max(theta_s) - min(theta_s));
 omega_n = (omega_s - min(omega_s)) / (max(omega_s) - min(omega_s));
 space = [theta_n, omega_n];

 % Define range of box sizes
 boxsizes = linspace(0.001, 0.2, 30);
 counts = zeros(size(boxsizes));

 for i = 1:length(boxsizes)
     box_size = boxsizes(i);
     box_indices = floor(space / box_size) + 1;
     point_boxes = unique(box_indices, 'rows');
     counts(i) = size(point_boxes, 1);
 end

 % Fit log(counts) vs. log(box_sizes)
 linfit = polyfit(log(boxsizes), log(counts), 1);
 fractal_dim = -linfit(1);
 disp(['Fractal Dimension: ', num2str(fractal_dim)]);

 % Plot log
 figure;
 loglog(boxsizes, counts, '.');
 hold on;
 loglog(boxsizes, exp(polyval(lin_fit, log(box_sizes))), 'r-');
 xlabel('Box size');
 ylabel('Number of boxes');
 title('Box-Counting for Fractal Dimension');
 legend('Data', 'Fit');
 grid on;

end

% Define the system of first-order ODEs
function dxdt = pendulum_ode(t, x, gamma, delta, alpha, theta0, beta, omega_yf)
    dxdt = zeros(3, 1);
    dxdt(1) = x(2); % d(theta)/dt = omega
    dxdt(2) = gamma * cos(omega_yf * t) - delta * x(2) - alpha * x(1) - theta0 + beta * sin(x(1));
    dxdt(3) = 1; % dt/dt = 1
end
