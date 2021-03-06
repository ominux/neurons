function [best_thresh, best_pol, best_err] = optimal_feature_params(F1, L, W)

[Fs inds] = sort(F1);   % sorted feature responses
Ls = L(inds);           % sorted class labels
Ws = W(inds);           % sorted weights

err = zeros(size(Fs));  
pol = zeros(size(Fs));

% efficient way to find optimal threshold from page 6 of [Viola-Jones IJCV 2004]
TPOS = sum( (Ls == 1) .* Ws);                  % Total sum of class 1 example weights
TNEG = sum( (Ls == -1) .* Ws);                 % Total sum of class -1 example weights
SPOS = 0;                                       % Running sum of class 1 example weights
SNEG = 0;                                       % Running sum of class -1 example weights

%% loop through the sorted list, updating SPOS and SNEG, and computing the ERROR
for q=1:length(Fs)
    
    % if your feature has the same value for many examples in the training
    % set, this can cause a problem when selecting a threshold if you keep 
    % accumulating the error (within a block of repeated values).  For a
    % given feature response, there should be only 1 error value!
    if (q>1) && (Fs(q) == Fs(q-1))
        err(q) = err(q-1); pol(q) = pol(q-1);
    else
        % accumulate error for positive polarity and negative polarity.
        % errors come in the form of false positives (fp) and false
        % negatives (fn)
        % positive polarity => + class < thresh < - class
        % negative polarity => - class < thresh < + class
        
        fp_error_pos_pol = TPOS - SPOS;                             % fp >= q
        %fp_error_neg_pol = SPOS + Ls(q)*Ws(q);                      % fp <= q
        fn_error_pos_pol = SNEG;                                    % fn < q
        %fn_error_neg_pol = TNEG - SNEG - ~Ls(q)*Ws(q);              % fn > q

        % total error for +/- polarity
        %last_err = pos_pol_error;
        pos_pol_error = fp_error_pos_pol + fn_error_pos_pol;
        %neg_pol_error = fp_error_neg_pol + fn_error_neg_pol;
        
%         % set the final error and polarity
%         if pos_pol_error <= neg_pol_error
%             err(q) = pos_pol_error; pol(q) = 1;
%         else
%             err(q) = neg_pol_error; pol(q) = -1;
%         end
        
        % set the final error and polarity
        if pos_pol_error <=.5
            err(q) = pos_pol_error; pol(q) = 1;
        else
            err(q) = 1-pos_pol_error; pol(q) = -1;
        end
    end
    
    % update SPOS and SNEG for the next iteration
    if Ls(q) == 1
        SPOS = SPOS + Ws(q);
    else
        SNEG = SNEG + Ws(q);
    end
    
end

%bar(err);
%keyboard;

%% find 'q' that gives the minimum error and correspoinding polarity
[best_err, q_ind]  = min(err);
best_thresh          = Fs(q_ind);
best_pol             = pol(q_ind);



% if (best_err > 1) || (best_err < 0)
%     plot(err);
%     hold on;
%     plot(pol, 'r-');
%     keyboard;
% end
