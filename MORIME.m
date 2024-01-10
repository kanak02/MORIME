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

clc;
clear;
close all;
% Problem Configuration
ObjectiveFunction = @ZDT1; % Objective function handle
dim = 5; % Number of dimensions
ub = ones(1, dim); % Upper bounds (assuming 1 for all dimensions)
lb = zeros(1, dim); % Lower bounds (assuming 0 for all dimensions)
obj_no = 2; % Number of objectives
% Algorithm Parameters
max_iter = 50; % Maximum number of iterations
ArchiveMaxSize = 100; % Maximum size of the archive
Archive_X = zeros(ArchiveMaxSize, dim); % Initialize archive solutions
Archive_F = ones(ArchiveMaxSize, obj_no) * inf; % Initialize archive fitnesses
Archive_member_no = 0; % Number of members in the archive
Best_rime_rate = inf * ones(1, obj_no); % Best rate (fitness) initialization
Best_rime = zeros(dim, 1); % Best solution initialization
Rimepop = initialization(ArchiveMaxSize, dim, ub, lb); % Population initialization
W = 5; % Weight factor in RIME algorithm (specific to MORIME)
% Main loop for MORIME algorithm
for iter = 1:max_iter
    % RimeFactor calculation based on iteration number
    RimeFactor = (rand - 0.5) * 2 * cos((pi * iter / (max_iter / 10))) * (1 - round(iter * W / max_iter) / W);
    E = sqrt(iter / max_iter); % Exploration factor
    % Update Rimepop (population)
    for i = 1:ArchiveMaxSize
        Rime_rates(i, :) = ObjectiveFunction(Rimepop(i, :));
        for j = 1:dim
            r1 = rand();
            if r1 < E
                % Update position based on Rime strategy
                Rimepop(i, j) = Best_rime(j) + RimeFactor * ((ub(j) - lb(j)) * rand + lb(j));
            end
            normalized_rime_rates = normr(Rime_rates);
            r2 = rand();
            if r2 < normalized_rime_rates(i)
                Rimepop(i, j) = Best_rime(j); % Correctly update Rimepop based on Best_rime
            end
        end
        % Boundary Check to keep solutions within bounds
        Flag4ub = Rimepop(i, :) > ub;
        Flag4lb = Rimepop(i, :) < lb;
        Rimepop(i, :) = (Rimepop(i, :) .* (~(Flag4ub + Flag4lb))) + ub .* Flag4ub + lb .* Flag4lb;
    end

    % Calculate Fitness for each individual in Rimepop
    Rime_rates = zeros(ArchiveMaxSize, obj_no);
    for i = 1:ArchiveMaxSize
        Rime_rates(i, :) = ObjectiveFunction(Rimepop(i, :));
    end

    % Non-dominated Sorting and Crowding Distance Calculation
    Combined_X = [Rimepop; Archive_X(1:Archive_member_no, :)];
    Combined_F = [Rime_rates; Archive_F(1:Archive_member_no, :)];
    [fronts, ~] = NonDominatedSorting(Combined_F);
    crowdingDistances = CrowdingDistance(Combined_F, fronts);

    % Update Archive using NSGA-II strategies
    [Archive_X, Archive_F, Archive_member_no] = UpdateArchiveUsingNSGAII(fronts, crowdingDistances, Combined_X, Combined_F, ArchiveMaxSize);


    % Display iteration information
    disp(['At iteration ', num2str(iter), ', MORIME has ', num2str(Archive_member_no), ' non-dominated solutions in the archive']);
end

% Plotting the results
figure;
Draw_ZDT1(); % Function to draw the true Pareto Front (assuming it is defined)
hold on;
plot(Archive_F(:, 1), Archive_F(:, 2), 'ro', 'MarkerSize', 8, 'markerfacecolor', 'k');
legend('True PF', 'Obtained PF');
title('MORIME');
set(gcf, 'pos', [403 466 230 200]); % Setting the figure position and size
