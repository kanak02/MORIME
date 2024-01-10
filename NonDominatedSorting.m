%_________________________________________________________________________________
%  Multi-objective RIME Algorithm (MORIME) source codes version 1.0 (NDS+CD)
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

function [fronts, maxFront] = NonDominatedSorting(F)
    % Initialize
    [S, n, frontNumbers] = deal(cell(size(F, 1), 1));
    [rank, distances] = deal(zeros(size(F, 1), 1));
    front = 1;
    maxFront = 0;

    % Calculate domination
    for i = 1:size(F, 1)
        S{i} = [];
        n{i} = 0;
        for j = 1:size(F, 1)
            if dominates(F(i, :), F(j, :))
                S{i} = [S{i}, j];
            elseif dominates(F(j, :), F(i, :))
                n{i} = n{i} + 1;
            end
        end
        if n{i} == 0
            rank(i) = 1;
            if isempty(frontNumbers{front})
                frontNumbers{front} = i;
            else
                frontNumbers{front} = [frontNumbers{front}, i];
            end
        end
    end

    % Assign fronts
    while ~isempty(frontNumbers{front})
        Q = [];
        for i = frontNumbers{front}
            for j = S{i}
                n{j} = n{j} - 1;
                if n{j} == 0
                    rank(j) = front + 1;
                    Q = [Q, j];
                end
            end
        end
        front = front + 1;
        frontNumbers{front} = Q;
    end
    maxFront = front - 1;

    % Organize fronts
    fronts = cell(maxFront, 1);
    for i = 1:maxFront
        fronts{i} = frontNumbers{i};
    end
end
