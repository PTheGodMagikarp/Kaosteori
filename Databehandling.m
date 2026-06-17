% Load data
a = importdata("Endlig data uden state", ',', 1);
time = a.data(:, 1);      % Time (s)
theta = a.data(:, 2);     % Angle (rad)
omega = a.data(:, 3);     % Angular velocity (rad/s)

% Definition of parameters
gamma = 18.92;   % A/I
omega_yf = 6.1;  % Driving frequency (rad/s)
fs = 20;         % Sampling frequency (Hz)

% Calculate the driving force
Z = gamma * cos(omega_yf * time);

% Remove transient from experimental data
T = 2*pi/omega_yf; % Period of driving force
transient_cutoff = 500 * T; % Remove the first 100 
steadystate = time >= transient_cutoff;

% Define steady-state data
time_s = time(steadystate);
theta_s = theta(steadystate);
omega_s = omega(steadystate);
Zs = Z(steadystate);

% 2D figure
figure;
set(gcf, 'Color', 'w');
hold on;
title('2D Phase Portrait of Torsion Pendulum', 'FontSize', 12);
xlabel('\theta (rad)', 'FontSize', 12);
ylabel('\omega (rad/s)', 'FontSize', 12);
builtin('plot',theta_s(1:15000), omega_s(1:15000), 'b-', 'LineWidth', 1);
grid on;
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
builtin('plot3',theta_s(1:15000), omega_s(1:15000), Zs(1:15000), 'b-', 'LineWidth', 1);
hold off;

% Plot angular frequency as a function of time
figure;
set(gcf, 'Color', 'w');
hold on;
title('Angular Frequency vs. Time', 'FontSize', 12);
xlabel('Time (s)', 'FontSize', 12);
ylabel('\omega (rad/s)', 'FontSize', 12);
grid on;
builtin('plot',time_s(1:100000), omega_s(1:100000), 'b-', 'LineWidth', 1);
hold off;

% Plot Power Spectral Density
figure;
set(gcf, 'Color', 'w');
hold on;
title('Power Spectral Density', 'FontSize', 12);
xlabel('Frequency (Hz)', 'FontSize', 12);
ylabel('Power/Frequency (dB/Hz)', 'FontSize', 12);
grid on;

window = hamming(128);        % Window size
noverlap = 64;                % Overlap
nfft = 1024;                  % FFT points
[pxx_theta, f_theta] = pwelch(theta_s, window, noverlap, nfft, fs);
builtin('plot',f_theta, 10*log10(pxx_theta), 'b-', 'LineWidth', 1);
xline(omega_yf/(2*pi), '--r', 'LineWidth', 1);
hold off;

%% Box counting

% Normalize theta and omega
theta_n = (theta_s - min(theta_s)) / (max(theta_s) - min(theta_s));
omega_n = (omega_s - min(omega_s)) / (max(omega_s) - min(omega_s));
space = [theta_n, omega_n];

% Define range of box sizes
box_sizes = linspace(0.001, 0.2, 30); 
counts = zeros(size(box_sizes));

for i = 1:length(box_sizes)
    box_size = box_sizes(i);
    box_indices = floor(space / box_size) + 1;
    point_boxes = unique(box_indices, 'rows');
    counts(i) = size(point_boxes, 1);
end

% Fit log(counts) vs. log(box_sizes)
linfit = polyfit(log(box_sizes), log(counts), 1);
fractal_dim = -linfit(1);
disp(['Fractal Dimension: ', num2str(fractal_dim)]);

% Plot log
figure;
loglog(box_sizes, counts, '.');
hold on;
loglog(box_sizes, exp(polyval(lin_fit, log(box_sizes))), 'r-');
xlabel('Box size');
ylabel('Number of boxes');
title('Box-Counting for Fractal Dimension');
legend('Data', 'Fit');
grid on;