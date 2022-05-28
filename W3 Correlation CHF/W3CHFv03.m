%W-3 correlation for CHF
clc; clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%           Reading input file               %%
%%---------------------------------------------%%
%opening the input file
file=fopen('inputCHf.txt');
%while condition --stops when file end
while ~feof(file)
    %reading first line
    line=fgetl(file);
    %conditions if line is relevant varible
    if (length(line)==9)&&strcmp(line,'Mass Flux')
       line=fgetl(file);
       G=str2double(line);
    elseif (length(line)==15)&&strcmp(line,'Heated Diameter')
        line=fgetl(file);
        D=str2double(line);
    elseif (length(line)==19)&&strcmp(line,'Temperature Profile')
        line=fgetl(file);
        temp_profile=str2num(line);
    elseif (length(line)==12)&&strcmp(line,'Shape factor')
        line=fgetl(file);
        shape_factor=str2num(line);
    end
end
%%%-----------------------------------------------------------%%



P=15; %MPa pressure

CHF=zeros(1,length(temp_profile));


%calculation of non-uniform CHF from uniform CHF using W-3 correlation
for i=1:length(temp_profile)
    %calculation of quality at temperature
    Xe=S_Enth(temp_profile(i),P);
    
    h_in=hf(temp_profile(i));  %inlet enthlpy
    %Saturation temperature at pressure(assuming constant pressure)
    T_sat=ts(P*10); %pressure in bar
    h_f=hf(T_sat);  %enthaly of saturated liquid
    %Uniform CHF calculation from W-3 correlation
    CHF_u=W3(P,Xe,G,D,h_in,h_f);
    %non uniform CHF from uniform CHF and shape factor
    CHF(i)=CHF_u/shape_factor(i);
end

%----------------------------------------------------------%
%                         Plot                             %
%----------------------------------------------------------%
plot(1:length(CHF),CHF)
xlabel('z (cm)'); ylabel('q" CHF ({W/cm^2})');
title('Non-Uniform Critical Heat Flux from W-3 Correlation')


%----------------------------------------------------------%
%                   Functions                              %
%----------------------------------------------------------%
%function for calculating quality 
function x=S_Enth(T,P)
h_in=hf(T);  %inlet enthlpy
%Saturation temperature at pressure(assuming constant pressure)
T_sat=ts(P*10); %pressure in bar

h_f=hf(T_sat);  %enthaly of saturated liquid

h_fg=hfg(T);

x=(h_in-h_f)/h_fg;

end

%function for calculation uniform CHF using W-3 correlation
function chf_u=W3(p,xe,G,Dh,h_in,h_f)
%Wesitinghouse_3 Correlation
%pressure p=5.5 to 16MPa
%mass flux G=1356 to 6800 kg/(m^2s)
%heated diameter Dh=0.015 to 0.018 m
%equilibrium qulaity xe=-0.15 to 0.15
%tube length L=0.254 to 3.70 m
%inlet enthalpy >930 kJ/kg
chf_u=((2.022-0.06238*p)+(0.1722-0.01427*p)*exp((18.177-0.5987*p)*xe))...
    *((0.1484-1.596*xe+0.1729*xe*abs(xe))*2.326*G+3271)*(1.157-0.869*xe)...
    *(0.2664+0.8357*exp(-124.1*Dh))*(0.8258+0.0003413*(h_f-h_in));
	
end

%yields the saturation temperature [celsius] at pressure P [bar]
function Ts=ts(P)

Tsat=[0:10:370,374.15];
 %saturation temperature in celsius

Psat=[0.006112,0.012271,0.023368,0.042418,0.073750,0.12335,0.19919,0.31161,0.47358,0.70109,1.01325,1.4327,1.9854,2.7011,3.6136,4.7597,6.1804,7.9202,10.027,12.553,15.550,19.080,23.202,27.979,33.480,39.776,46.941,55.052,64.191,74.449,85.917,98.694,112.89,128.64,146.08,165.37,186.74,210.53,221.2];
 %saturation pressure in bar

Ts=interp1(Psat,Tsat,P);
end

  %liquid enthalpy [kJ/kg] at T [celsius] 
function hf=hf(T) 
 
 Tsat=[0:10:370,374.15];
  %saturation temperature in celsius

 hliq=[0.000611,41.99,83.86,125.66,167.47,209.3,251.1,293.0,334.9,376.9,419.1,461.3,503.7,546.3,589.1,632.2,675.5,719.1,763.1,807.5,852.4,897.7,943.7,990.3,1037.6,1085.8,1135.0,1185.2,1236.8,1290,1345,1402,1462,1526,1596,1672,1762,1892,2095];
 %liquid saturation enthalpy in kJ/kg

hf=interp1(Tsat,hliq,T);
end

  %evaporation enthalpy [kJ/kg] at T [celsius] 
function hfg=hfg(T) 

 Tsat=[0:10:370,374.15];
  %saturation temperature in celsius

 hvap=[2501,2519,2538,2556,2574,2592,2609,2626,2643,2660,2676,2691,2706,2720,2734,2747,2758,2769,2778,2786,2793,2798,2802,2803,2803,2801,2796,2790,2780,2766,2749,2727,2700,2666,2623,2565,2481,2331,2095];
 %vapor saturation enthalpy in kJ/kg

 hliq=[0.000611,41.99,83.86,125.66,167.47,209.3,251.1,293.0,334.9,376.9,419.1,461.3,503.7,546.3,589.1,632.2,675.5,719.1,763.1,807.5,852.4,897.7,943.7,990.3,1037.6,1085.8,1135.0,1185.2,1236.8,1290,1345,1402,1462,1526,1596,1672,1762,1892,2095];
 %liquid saturation enthalpy in kJ/kg

deltah=hvap-hliq;

hfg=interp1(Tsat,deltah,T);
end


