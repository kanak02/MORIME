%_________________________________________________________________________________
%  Multi-objective RIME Algorithm (MORIME) source codes version 1.0 (NDS+CD)
%  Author and programmer: Kanak Kalita, Pradeep Jangir
%  Authors:- Sundaram B. Pandya,  Kanak Kalita, Jasgurpreet Singh Chohan, Laith Abualigah, Saurav Mallik11, Hong Qin
%         e-Mail: kanakkalita02@gmail.com, pkjmtech@gmail.com
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

function distances = CrowdingDistance(F, fronts)
    % Initialize the distances array
    distances = zeros(size(F, 1), 1);

    % Calculate crowding distance for each front
    for f = 1:length(fronts)
        front = fronts{f};
        frontSize = length(front);

        % Set the boundary points' distances to infinity
        if frontSize > 2
            distances(front) = 0;
            for m = 1:size(F, 2) % Iterate over each objective
                [sortedValues, sortOrder] = sort(F(front, m));
                sortedFront = front(sortOrder);

                % Distance for boundary points
                distances(sortedFront(1)) = inf;
                distances(sortedFront(end)) = inf;

                % Distance for intermediate points
                for i = 2:(frontSize - 1)
                    distances(sortedFront(i)) = distances(sortedFront(i)) + ...
                        (F(sortedFront(i + 1), m) - F(sortedFront(i - 1), m)) / ...
                        (max(F(:, m)) - min(F(:, m)));
                end
            end
        else
            distances(front) = inf;
        end
    end
end
