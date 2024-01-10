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


function [Archive_X, Archive_F, Archive_member_no] = UpdateArchiveUsingNSGAII(fronts, distances, Combined_X, Combined_F, ArchiveMaxSize)
    Archive_X = [];
    Archive_F = [];
    Archive_member_no = 0;
    for f = 1:length(fronts)
        front = fronts{f};
        [~, I] = sort(-distances(front));
        front = front(I);
        if length(front) + Archive_member_no <= ArchiveMaxSize
            Archive_X = [Archive_X; Combined_X(front, :)];
            Archive_F = [Archive_F; Combined_F(front, :)];
            Archive_member_no = Archive_member_no + length(front);
        else
            remaining = ArchiveMaxSize - Archive_member_no;
            Archive_X = [Archive_X; Combined_X(front(1:remaining), :)];
            Archive_F = [Archive_F; Combined_F(front(1:remaining), :)];
            Archive_member_no = ArchiveMaxSize;
            break;
        end
    end
end
