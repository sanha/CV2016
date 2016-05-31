function [cost, grad] = softmaxCost(theta, numClasses, inputSize, lambda, data, labels)

% numClasses - the number of classes 
% inputSize - the size N of the input vector
% lambda - weight decay parameter
% data - the N x M input matrix, where each column data(:, i) corresponds to
%        a single test set
% labels - an M x 1 matrix containing the labels corresponding for the input data
%

% Unroll the parameters from theta
theta = reshape(theta, numClasses, inputSize);
numCases = size(data, 2);

groundTruth = full(sparse(labels, 1:numCases, 1));
%cost = 0;

%thetagrad = zeros(numClasses, inputSize);

%% ---------- YOUR CODE HERE --------------------------------------
%  Instructions: Compute the cost and gradient for softmax regression.
%                You need to compute thetagrad and cost.
%                The groundTruth matrix might come in handy.


% size(groundTruth) % 10 100
% size(theta)       % 10 8
% size(labels)      % 100 1
% size(data)        % 8 10
% size (thetagrad)  % 10 8  
% h                 % 10 10


% note that if we subtract off after taking the exponent, as in the
% text, we get NaN

hyp = exp(theta * data);
sum_hyp = sum(hyp);
p = zeros(numClasses, numCases);
cost_cases = zeros(1, numCases);
for i=1:numCases
    p(:, i) = hyp(:, i) / sum_hyp(i);
    cost_cases(i) = log(p(labels(i), i));
end
cost = -(sum(cost_cases) / numCases) + lambda * sum(sum(theta .^ 2)) / 2;

thetagrad = -((groundTruth - p) * data' / numCases) + lambda * theta;

% ------------------------------------------------------------------
% Unroll the gradient matrices into a vector for minFunc
grad = [thetagrad(:)];
end

