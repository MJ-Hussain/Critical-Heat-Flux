%CHF
clc; clear;
%Load CHF table data
load('CHF Table.mat');
%Input section
P_input=1000;
G_input=5000;
X_input=0.1;

%Igore repeated values
P_vec=unique(Pressure);
G_vec=unique(MassFlux);

%If required value is in between given values
%nearest known values will be considered
if ismember(P_input,P_vec)
    P_values=[P_input];
else
    [ minval, indx ] = min( abs( P_input-P_vec ) );
    if P_input>P_vec(indx)
        P_values=[P_vec(indx) P_vec(indx+1)];
    elseif P_input<P_vec(indx)
        P_values=[P_vec(indx-1) P_vec(indx)];
    end
end


if ismember(G_input,G_vec)
    G_values=[G_input];
else
    [ minval, indx ] = min( abs( G_input-G_vec ) );
    if G_input>G_vec(indx)
        G_values=[G_vec(indx) G_vec(indx+1)];
    elseif G_input<G_vec(indx)
        G_values=[G_vec(indx-1) G_vec(indx)];
    end
end

%Index of required quality value
X_index=find(X_vec==X_input);


%If values are in between known data the finding CHF 
%for known values and interpolating
for m=1:length(P_values)
    
    for n=1:length(G_values)
        flag=0;
        id_p=find(Pressure==P_values(m));
        id_g=find(MassFlux==G_values(n));
        for p_x=1:length(id_p)
            for p_g=1:length(id_g)
             if id_p(p_x)==id_g(p_g)
                index=id_p(p_x);
                flag=1;
                break;
                
             end
            end
            if flag==1
                break;
            end
        end 
        
       CHF_g(n)=Quality(index,X_index); 
    end
    if length(G_values)>1
       
       CHF_p(m) = interp1(G_values,CHF_g,G_input,'linear');
    else
        CHF_p(m)=CHF_g;
    end
    if length(P_values)>1
       
       CHF_f = interp1(P_values,CHF_p,P_input,'linear');
    else
       CHF_f=CHF_p;
    end
end
%Printing final solution
fprintf('At given Pressure %8.2f \n Mass Flux %6.2f \n and Quality of %3.2f \n CHF value is %8.2f \n',P_input,G_input,X_input,CHF_f)


