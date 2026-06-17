% Import data
a = importdata("Endlig data med state", ',', 1);

% Extract columns
steadystart = 501;       %Skip first 500 points
time = a.data(steadystart:end, 1);      % Time (s)
angle = a.data(steadystart:end, 2);     % Angle (rad)
omega = a.data(steadystart:end, 3);     % Angular velocity (rad/s)
state = a.data(steadystart:end, 4);     % State (0 or 1)

% Find indices where state is 0
idx = (state == 0);

% Find valid indices
valid_angle = ~isnan(angle);
valid_omega = ~isnan(omega);

% Interpolate angle_exp 
if any(valid_angle)
    angle(idx) = interp1(time(valid_angle), angle(valid_angle), time(idx), 'linear', 'extrap');
end

% Interpolate omega_exp 
if any(valid_omega)
    omega(idx) = interp1(time(valid_omega), omega(valid_omega), time(idx), 'linear', 'extrap');
end

% Plot Poincaré plot
figure;
set(gcf, 'Color', 'w');
hold on;
title('Poincaré plot of Torsion Pendulum', 'FontSize', 12);
xlabel('\theta (rad)', 'FontSize', 12);
ylabel('\omega (rad/s)', 'FontSize', 12);
grid on;
builtin('plot',angle(idx), omega(idx), 'ko', 'MarkerSize', 0.5, 'MarkerFaceColor', 'r');
hold off;