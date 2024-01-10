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


function [Archive_X_updated, Archive_F_updated, Archive_member_no]=UpdateArchive(Archive_X, Archive_F, Particles_X, Particles_F, Archive_member_no)
Archive_X_temp=[Archive_X ; Particles_X'];
Archive_F_temp=[Archive_F ; Particles_F];

o=zeros(1,size(Archive_F_temp,1));

for i=1:size(Archive_F_temp,1)
    o(i)=0;
    for j=1:i-1
        if any(Archive_F_temp(i,:) ~= Archive_F_temp(j,:))
            if dominates(Archive_F_temp(i,:),Archive_F_temp(j,:))
                o(j)=1;
            elseif dominates(Archive_F_temp(j,:),Archive_F_temp(i,:))
                o(i)=1;
                break;
            end
        else
            o(j)=1;
            o(i)=1;
        end
    end
end


Archive_member_no=0;
index=0;
for i=1:size(Archive_X_temp,1)
    if o(i)==0
        Archive_member_no=Archive_member_no+1;
        Archive_X_updated(Archive_member_no,:)=Archive_X_temp(i,:);
        Archive_F_updated(Archive_member_no,:)=Archive_F_temp(i,:);
    else
        index=index+1;
        %         dominated_X(index,:)=Archive_X_temp(i,:);
        %         dominated_F(index,:)=Archive_F_temp(i,:);
    end
end
end