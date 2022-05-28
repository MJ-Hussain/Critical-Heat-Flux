
clc; clear;
%_____________________________________%
%            Input section            %
%-------------------------------------%

P_in=1000;
G_in=5000;
X_in=0.1;
%------------------------------------%
X_q=[-0.50 -0.40 -0.30 -0.20 -0.15 -0.10 -0.05 0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.60 0.70 0.80 0.90 1.0];

if (P_in<100 || P_in>21000) || (G_in<0 || G_in>8000)
    disp('Pressure and Flow rate values out of range')
    return
end
if ( ~ ismember(X_in,X_q))
   disp('Please input from given Quality values') 
   disp(num2str(X_q))
   return
end
%------------------------------------%
%Reading data from excel file
%data ranges in excel file
R={'A5:Y40';'A44:Y80';'A84:Y120';'A124:Y160';
    'A164:Y200';'A204:Y240';'A244:Y280';'A284:Y320';
    'A324:Y360';'A364:Y400';'A404:Y440';'A444:Y480';'A484:Y520';
    'A524:Y547'};

 lR=length(R);
 P=[]; G=[]; X=[];
 k1=0; k2=0;
 
for i=1:lR
   M = xlsread('CHF Table.xlsx',char(R(i)));
   l_vec=length(M(:,1));
   k1=k2+1;
   k2=k2+l_vec;
  
   P(k1:k2)=M(:,1);
   G(k1:k2)=M(:,2);
   X(k1:k2,:)=M(:,3:25);
   
end


P_vec=unique(P);
G_vec=unique(G);

P_mat=check(P_in,P_vec);
G_mat=check(G_in,G_vec);
id_q=find(X_q==X_in);



for m=1:length(P_mat)
    
    for n=1:length(G_mat)
        
        %-------------------------------------%
        done=0;
        idx1=find(P==P_mat(m));
        idx2=find(G==G_mat(n));
        for id=1:length(idx1)
            for id2=1:length(idx2)
             if idx1(id)==idx2(id2)
                index=idx1(id);
                done=1;
                break;
                
             end
            end
            if done==1
                break;
            end
        end 
        %------------------------------------%
       chf_g(n)=X(index,id_q); 
    end
    if length(G_mat)>1
       chf_p(m)= interpolate(G_mat,chf_g,G_in);
    else
        chf_p(m)=chf_g;
    end
    if length(P_mat)>1
       chf_f=interpolate(P_mat,chf_p,P_in);
    else
       chf_f=chf_p;
    end
end




fprintf('For given Mass Flux %6.2f, Pressure %8.2f and Quality %3.2f, value of CHF is %8.2f \n',G_in,P_in,X_in,chf_f)

%_____________________________________%
%             Functions               %
%-------------------------------------%
%Function to find nearest values for demanded value
function value=check(x,x_vec)
if ismember(x,x_vec)
    value=[x];
else
    [ d, ix ] = min( abs( x-x_vec ) );
    if x>x_vec(ix)
        value=[x_vec(ix) x_vec(ix+1)];
    elseif x<vec(ix)
        value=[x_vec(ix-1) x_vec(ix)];
    end
end

end

%Function for interpolation
function int_value=interpolate(x,v,xq)
int_value = interp1(x,v,xq,'linear');
end
