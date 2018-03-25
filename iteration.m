%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the MATLAB implement of the tutorial arxiv.org/xxxxxxx
%
% An Iterative algorithm for Group L1 norm
%  
% definition of this interface:
% input:
%    - X is the original data matrix defined in the tutorial.
%    - Label is the class label of input data X.
%    - lambda_1 is the hyper-parameter to adjust the weight of Group L1 norm regularizer.
%    - d_1 denotes the end position of the feature from view 1
%    - d_2 denotes the end position of the feature from view 2
%    - d_3 denotes the end position of the feature from view 3
% output:
%    - W is the projection matrix W defined in the tutorial.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ W ] = iteration( X, Label, lambda_1, ite, d_1, d_2, d_3)
    tic;
    
    Y = SY2MY(Label);
    Y(find(Y == -1))=0;
    
    [dim, num] = size(X);
    [num, c] = size(Y);
    
    %%prepare for initialization
    I = eye(dim);
    
    %%set initial W as Eq.(8) in the tutorial
    W = (X * X' + 0.0000001 * I) \ (X * Y);
    
    
    %%  iteration
    for n = 1 : ite
        
        for i = 1 : c
            
            w_1 = W(1 : d_1, i);
            w_2 = W(d_1 + 1 : d_2, i);
            w_3 = W(d_2 + 1 : d_3, i);
           
            w_1 = w_1.^2;
            w_2 = w_2.^2;
            w_3 = w_3.^2;
            
            % 0.0000001 serves as small perturbation
            v_1 = 1./ (2.* sqrt(sum(w_1) + 0.0000001));
            v_2 = 1./ (2.* sqrt(sum(w_2) + 0.0000001));
            v_3 = 1./ (2.* sqrt(sum(w_3) + 0.0000001));
        
            
            v = [v_1 * ones(d_1, 1); v_2 * ones(d_2, 1); v_3 * ones(d_3, 1)];
            
            D = diag(v);
           
            
            W( : , i) = (X * X'+ lambda_1 * D) \ (X * Y( : , i));
        end;
   
        disp(n);
    end
    
    toc;
end

