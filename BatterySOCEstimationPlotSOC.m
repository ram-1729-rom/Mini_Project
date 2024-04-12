% Code to plot simulation results from BatterySOCEstimationExample
% The plot below shows the real and estimated battery state-of-charge.

% Generate simulation results if they don't exist
if ~exist('BatterySOCEstimationSimlog', 'var') || ...
        get_param('BatterySOCEstimation','RTWModifiedTimeStamp') == double(simscape.logging.timestamp(BatterySOCEstimationSimlog))        
    sim('BatterySOCEstimation')
    % Model StopFcn callback adds a timestamp to the Simscape simulation data log
end

% Reuse figure if it exists, else create new figure
if ~exist('h1_BatterySOCEstimation', 'var') || ...
        ~isgraphics(h1_BatterySOCEstimation, 'figure')
    h1_BatterySOCEstimation = figure('Name', 'BatterySOCEstimation');
end
figure(h1_BatterySOCEstimation)
clf(h1_BatterySOCEstimation)

% Get simulation results
simlog_SOC_real = BatterySOCEstimationLogsout.get('real_soc');
simlog_SOC_est = BatterySOCEstimationLogsout.get('est_soc');

% Plot results
plot(simlog_SOC_real.Values.Time/3600, simlog_SOC_real.Values.Data(:)*100, 'LineWidth', 1)
hold on
plot(simlog_SOC_est.Values.Time/3600, simlog_SOC_est.Values.Data(:)*100, 'LineWidth', 1)
hold off
grid on
title('State-of-charge')
ylabel('SOC (%)')
xlabel('Time (hours)')
legend({'Real','Estimated'},'Location','Best');

% Remove temporary variables
clear simlog_SOC_real simlog_SOC_est