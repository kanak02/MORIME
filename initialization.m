%_________________________________________________________________________________
%  Multi-objective RIME Algorithm (MORIME) source codes version 1.0
%  Author and programmer: Pradeep Jangir
%  Authors:- Sundaram B. Pandya,  Kanak Kalita, Jasgurpreet Singh Chohan, Laith Abualigah, Saurav Mallik11, Hong Qin
%         e-Mail: pkjmtech@gmail.com
%  
%  
%   MORIME Paper:
%   Pradeep Jangir, Sundaram B. Pandya,  Kanak Kalita, Jasgurpreet Singh Chohan, Laith Abualigah, Saurav Mallik11, Hong Qin
%   Multi-Objective RIME algorithm-based Techno Economic analysis for
%   security constraints load dispatch and power flow including uncertainties model of Hybrid Power Systems
%   Energy Reports (Under review)
%   
%  RIME main paper (Su, H., Zhao, D., Heidari, A. A., Liu, L., Zhang, X., Mafarja, M., & Chen, H. (2023). RIME: A physics-based optimization. Neurocomputing, 532, 183-214.)
%  Website and codes of RIME:http://www.aliasgharheidari.com/RIME.html
%____________________________________________________________________________________

function Positions = initialization(SearchAgents_no, dim, ub, lb)
    Boundary_no = size(ub, 2); % Number of boundaries

    % If the boundaries of all variables are equal and user enters a single
    % number for both ub and lb
    if Boundary_no == 1
        ub_new = ones(1, dim) * ub;
        lb_new = ones(1, dim) * lb;
    else
        ub_new = ub;
        lb_new = lb;   
    end

    % If each variable has a different lb and ub
    Positions = zeros(SearchAgents_no, dim);
    for i = 1:dim
        ub_i = ub_new(i);
        lb_i = lb_new(i);
        Positions(:, i) = rand(SearchAgents_no, 1) .* (ub_i - lb_i) + lb_i;
    end

    % Removed the transpose to ensure correct dimensions
end
