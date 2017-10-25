%%
%% Evaluate policy values at each state 
% policy: #StateX#Action matrix that specifies conditional probabilities of
%         each action given each state
% gamma:  Decay rate
% S:      #States
% T:      #StateX#StateX#Action transition matrix
% R:      #StateX#State#Action  reward matrix
% returns value_vec: #StateX1 vector that contains values for each state under policy
function value_vec = PolicyValueFunction(policy, gamma, S, T, R)
    value_vec = zeros(S, 1);
    while 1
        delta = 0;
        for state = 1:S % for each state
            state_vec = zeros(S, 1);
            state_vec(state) = 1;
            % Get action vector for the state
            action_vec = transpose(policy) * state_vec;
            % Select which 7x7 transition matrix to apply based on action.
            % Reshape is needed to carry out tensor multiplication 7x7x2 x 2x1
            action_transition = reshape(reshape(T, [49, 2]) * action_vec, [7, 7]);
            % Select which 7x7 reward matrix to apply based on action.
            % Reshape is needed to carry out tensor multiplication 7x7x2 x 2x1
            action_reward = reshape(reshape(R, [49, 2]) * action_vec, [7, 7]);
            old_value = value_vec(state);
            value_vec(state) = transpose(action_transition * state_vec) * ...
                 (action_reward * state_vec + gamma * value_vec);
            delta = max(delta, abs(old_value - value_vec(state)));
        end
        if delta < 0.1
            break;
        end
    end