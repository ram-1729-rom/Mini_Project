% xk+1 = sqrt(5+xk)+wk
% yk = xk^3 + vk

SigmaW = 1; % process noise covariance 
SigmaV = 2; % sensor noise covariance
maxIter = 40;

xtrue = 2 + randn(1); % true sys initial state
xhat = 2; % KF initial estimate 
SigmaX = 1; % KF covariance
u = 0; % initial driving i/p

% storage for true state, estimated state and covariance of estimated state 
xstore = zeros(maxIter + 1, length(xtrue)); xstore(1,:) = xtrue;
xhatstore = zeros(maxIter, length(xhat));
SigmaXstore = zeros(maxIter, length(xhat)^2);

for k = 1:maxIter

    Ahat = 0.5/sqrt(5 + xhat); Bhat = 1;

    % state estimate time update
    xhat = sqrt(5+xhat);

    % error covariance time update
    SigmaX = Ahat*SigmaX*Ahat' + Bhat*SigmaW*Bhat';

    % i/p signal u and o/p signal y
    w = chol(SigmaW)'*randn(1);
    v = chol(SigmaV)'*randn(1);
    ytrue = xtrue^3 + v; % y based on present x and u
    xtrue = sqrt(5+xtrue) + w;% future x based on present u

    % estimate sys o/p
    Chat = 3*xhat^2; Dhat = 1;
    yhat = xhat^3;

    % find kalman filter gain matrix
    SigmaY = Chat*SigmaX*Chat' + Dhat*SigmaV*Dhat';
    L = SigmaX*Chat'/SigmaY;

    % state estimate measurement update
    xhat = xhat + L*(ytrue - yhat);
    xhat = max(-5, xhat); % to stop xhat taking -ve value

    % error covariance measurement update
    SigmaX = SigmaX - L*SigmaY*L';
    [~, S, V] = svd(SigmaX);
    HH = V*S*V';
    SigmaX = (SigmaX + SigmaX' + HH + HH')/4;
    
    xstore(k+1, :) = xtrue; xhatstore(k,:) = xhat;
    SigmaXstore(k,:) = (SigmaX(:))';
end

figure(1); clf; t = 0:maxIter - 1;
plot(t, xstore(1:maxIter), 'k-', t, xhatstore, 'b--', ...
    t,xhatstore+3*sqrt(SigmaXstore), 'm-.', ...
    t, xhatstore-3*sqrt(SigmaXstore), 'm-.'); grid;
legend('true', 'estimate', 'bounds');
xlabel('Iteration'); ylabel('State');
title('Extended Kalman Filter in action');