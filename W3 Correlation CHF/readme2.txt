------------------Code description--------------------

                       Input
code reads input from file 'inputCHF.txt' which has the structure as described below
-Firt line is just header line
-Enter Mass Flux in 3rd line
-Enter Heated Diameter in 5th line
-Temperature profile input on 7th line 
-Shape factor input on 9th line
NOTE: Don't change the text written e.g., 'Mass Flux' as program mathed the whole 
word to acquire the input and save it to the relevant variable.

                       Output
Program diplays the plot of Non-Uniform Critical heat flux verses length of the channel

                       Program
Non uniform CHF calculation using shape factor and uniform CHF from W3 correlation

line 4-27
reading the input file 
file must be present in the working directory and must be called
with the exact name

while loop with the condition ~feof reads file until the end of file
file is read line by line and each line is checked by if condition
if met then next line value is read and assigned to the corresponding variable.
Reads Mass Flux, Heated diameter, Temperature profile and Shape factor

line 32
Pressure variable as given, set to 15MPa
line 34
CHF vector is initialized to save the values at each iteration

line 37-50
for loop which runs for number of values in temperature profile
flow quality is determined at given temperature and pressure by S_Enth function

inlet enthalpy is calculated at given temperature using hf function
saturation temperature is calculated at given pressure to calculate 
enthalpy of saturated liquid.

CHF_u fucntion calculates the uniform CHF using W3 correlation.
calculated CHF_u is divided by shape factor to calculate the
non uniform CHF.

line 55-57
non uniform CHF is plotted against the length of the channel

line 64-75
fucntion that calculates the flow quality at given temperature and pressure
As flow quality= x = (hi - hf)/hfg 
all the parameters are calculated from corresponding fucntions
all these function are acquired from the source refered in the project description.

line 78-89
function that calculates the uniform CHF from W3 correlation.

below are the fucntion resources found from the link mentioned in the project description.
These include 
-Saturation temperature at given pressure
-Liuid enthalpy at given tempertaure
-Evaporation enthalpy at given temperature