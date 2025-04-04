clc; clear; close all;
t=readtable("ajm.xlsx");
p=t.p;
r=t.r;
% p = 200; % Strength of workpiece (Pa) 
% r = 3.4; % Density of abrasive (kg/m³)

% Input material type
material = input("Enter material type (ductile/brittle): ", 's');

% Input 1D arrays for velocity and mass flow rate
V = input("Enter set of velocities [ ] in m/s: "); % Example: [10, 20, 30, 40]
ma = input("Enter set of mass flow rates [ ] in gm/s: "); % Example: [5, 10, 15, 20]

% Convert mass flow rate from gm/s to kg/s
ma = ma / 1000;
p=p*10^6;
% Initialize MRR array
mrr = zeros(length(V), length(ma));

% Compute MRR based on material type
if strcmp(material, "ductile")
    for i = 1:length(ma)
        mrr(:, i) = (V.^2 .* ma(i)) ./ (2 * p(1,1));  % Element-wise calculation
    end
elseif strcmp(material, "brittle")
    for i = 1:length(ma)
        mrr(:, i) = ((4 / (6^1.5)) * (V.^1.5 .* ma(i))) ./ (p(2,1)^0.75 * r(2,1)^0.25);
    end
else
    disp("Invalid material type! Please enter 'ductile' or 'brittle'.");
    return;
end

% Convert MRR matrix into a table format
mrr_table = array2table(mrr, 'VariableNames', compose("ma=%.3fkg/s", ma), 'RowNames', compose("V=%.1fm/s", V));

% Display the table in the command window
disp("Material Removal Rate (MRR) Table:");
disp(mrr_table);

% Plot MRR vs Velocity for different mass flow rates
figure;
hold on;
for i = 1:length(ma)
    plot(V, mrr(:, i), 'o-', 'DisplayName', sprintf('ma = %.3f kg/s', ma(i)));
end
hold off;
xlabel('Velocity (m/s)');
ylabel('Material Removal Rate (MRR)');
title('MRR vs Velocity');
legend;
grid on;

% Plot MRR vs Mass Flow Rate for different velocities
figure;
hold on;
for i = 1:length(V)
    plot(ma, mrr(i, :), 's-', 'DisplayName', sprintf('V = %.1f m/s', V(i)));
end
hold off;
xlabel('Mass Flow Rate (kg/s)');
ylabel('Material Removal Rate (MRR)');
title('MRR vs Mass Flow Rate');
legend;
grid on;